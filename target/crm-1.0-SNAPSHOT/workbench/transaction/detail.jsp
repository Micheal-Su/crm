<%@ page import="java.util.List" %>
<%@ page import="com.bjpowernode.crm.settings.domain.DicValue" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page import="com.bjpowernode.crm.workbench.domain.Tran" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    //准备字典类型为stage的字典值列表
    List<DicValue> dvList = (List<DicValue>) application.getAttribute("stageList");

    //准备阶段和可能性之间的对应关系
    Map<String, String> pMap = (Map<String, String>) application.getAttribute("pMap");

    //根据pMap 准备pMap中的key集合
    Set<String> set = pMap.keySet();

    //准备：前面正常阶段和后面丢失阶段的分界点下标
    int point = 0;
    for (int i = 0; i < dvList.size(); i++) {
        //取得每一个字典值
        DicValue dv = dvList.get(i);
        //从dv中获取value值
        String stage = dv.getValue();
        //根据stage获取possibility
        String possibility = pMap.get(stage);
        //如果可能性为0，说明找到了前面正常阶段和后面丢失阶段的分界点
        if ("0".equals(possibility)) {
            point = i;
            break;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>

    <style type="text/css">
        .mystage {
            font-size: 20px;
            vertical-align: middle;
            cursor: pointer;
        }

        .closingDate {
            font-size: 15px;
            cursor: pointer;
            vertical-align: middle;
        }
    </style>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

    <script type="text/javascript">

        var json = {
            <%
                for (String key:set){
                    String value = pMap.get(key);
            %>
            "<%=key%>":<%=value%>,
            <%
                }
            %>
        };

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {
            $(".time1").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });
            $(".time2").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "top-left"
            });

            $("#edit-stage").change(function () {
                //取得选中的阶段
                var stage = $("#edit-stage").val();
                var possibility = json[stage];
                $("#edit-possibility").val(possibility);
            })

            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });
            showRemarkList();
            showHistoryList();

            $(".remarkDiv").mouseover(function () {
                $(this).children("div").children("div").show();
            });

            $(".remarkDiv").mouseout(function () {
                $(this).children("div").children("div").hide();
            });

            $(".myHref").mouseover(function () {
                $(this).children("span").css("color", "red");
            });

            $(".myHref").mouseout(function () {
                $(this).children("span").css("color", "#E6E6E6");
            });

            $("#remarkBody").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            });
            $("#remarkBody").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            });


            //阶段提示框
            $(".mystage").popover({
                trigger: 'manual',
                placement: 'bottom',
                html: 'true',
                animation: false
            }).on("mouseenter", function () {
                var _this = this;
                $(this).popover("show");
                $(this).siblings(".popover").on("mouseleave", function () {
                    $(_this).popover('hide');
                });
            }).on("mouseleave", function () {
                var _this = this;
                setTimeout(function () {
                    if (!$(".popover:hover").length) {
                        $(_this).popover("hide")
                    }
                }, 100);
            });




            $("#updateBtn").click(function () {

                $.ajax({
                    url: "workbench/transaction/updateByModal.do",
                    data: {
                        "id": "${t.id}",
                        "owner": $.trim($("#edit-owner").val()),
                        "name": $.trim($("#edit-name").val()),
                        "money": $.trim($("#edit-money").val()),
                        "expectedDate": $.trim($("#edit-expectedDate").val()),
                        "customerName": $.trim($("#edit-customerName").val()),
                        "source": $.trim($("#edit-source").val()),
                        "stage": $.trim($("#edit-stage").val()),
                        "activityId": $.trim($("#edit-activityId").val()),
                        "contactsId": $.trim($("#edit-contactsId").val()),
                        "type": $.trim($("#edit-type").val()),
                        "description": $.trim($("#edit-description").val()),
                        "nextContactTime": $.trim($("#edit-nextContactTime").val()),
                        "contactSummary": $.trim($("#edit-contactSummary").val())
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {

                        if (data.success) {
                            alert("更新成功");
                            $("#editActivityModal").modal("hide");
                            window.location.reload();
                        } else {
                            alert("修改市场活动失败");
                        }
                    }
                })
            })

            //为保存按钮绑定事件
            $("#saveRemarkBtn").on("click", function () {
                $.ajax({
                    url: "workbench/transaction/saveRemark.do",
                    data: {
                        "noteContent": $.trim($("#remark").val()),
                        "tranId": "${t.id}"
                        //	在detail.do中已经将c保存在请求域中了
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {

                        if (data.success) {
                            //将textarea中内容清空
                            $("#remark").val("");
                            // alert("添加备注成功");
                            //在textarea文本域上方新增一个div
                            var html = "";
                            html += '<div id="' + data.tr.id + '" class="remarkDiv" style="height: 60px;">';
                            html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                            html += '<div style="position: relative; top: -40px; left: 40px;" >';
                            html += '<h5 id="e' + data.tr.id + '">' + data.tr.noteContent + '</h5>';
                            html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${t.customerName}-${t.name}</b> <small style="color: gray;"> ' + (data.tr.createTime) + ' 由' + (data.tr.createBy) + '</small>';
                            html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\'' + data.tr.id + '\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
                            html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\'' + data.tr.id + '\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                            html += '</div>';
                            html += '</div>';
                            html += '</div>';
                            $("#remarkDiv").before(html);

                        } else {
                            alert("添加备注失败");
                        }
                    }
                })
            })

            $("#updateRemarkBtn").on("click", function () {
                var id = $("#remarkId").val();
                $.ajax({
                    url: "workbench/transaction/updateRemark.do",
                    data: {
                        "id": id,
                        "noteContent": $.trim($("#noteContent").val())
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {

                        if (data.success) {
                            //更新div中相应的信息，需要更新的内容有 noteContent editTime editBy
                            $("#e" + id).html(data.tr.noteContent);
                            $("#s" + id).html(data.tr.editTime + " 由" + data.tr.editBy);
                            //更新内容之后，关闭模态窗口
                            $("#editRemarkModal").modal("hide");

                        } else {
                            alert("更新备注失败")
                        }

                    }
                })
            })

            $("#cname").keydown(function (event){
                if (event.keyCode==13){
                    $.ajax({
                        //线索本身已经存在的关联活动就不再查询出来了，不可重复关联
                        url:"workbench/transaction/getContactsListByName.do",
                        data:{
                            "cname":$.trim($("#cname").val())
                        },
                        type:"get",
                        dataType:"json",
                        success:function (data){
                            var html = "";
                            $.each(data,function (i,n){
                                html += '<tr>'
                                html += '<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>'
                                html += '<td>'+n.fullname+'</td>'
                                html += '<td>'+n.email+'</td>'
                                html += '<td>'+n.phone+'</td>'
                                html += '</tr>'
                            })
                            $("#contactsSearchBody").html(html);

                        }
                    })
                    return false;
                }
            })
            $("#chooseBtn").click(function (){
                var $xz = $("input[name=xz]:checked");
                if ($xz.length==0){
                    alert("请选择联系人")
                }else if ($xz.length>1){
                    alert("只能选择一个联系人")
                }else {
                    var contactsId = $($xz[0]).val();
                }

                $.ajax({
                    url:"workbench/contacts/getById.do",
                    data:{
                        "contactsId":contactsId
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data){

                        $("#findContacts").modal("hide");
                        $("#edit-contactsId").val(data.id);
                        $("#edit-contactsName").val(data.fullname);

                    }
                })
            })

        });

        function showRemarkList() {
            $.ajax({
                url: "workbench/transaction/getRemarkListByTid.do",
                data: {
                    "tranId": "${t.id}"
                },
                type: "get",
                dataType: "json",
                success: function (data) {
                    var html = "";
                    $.each(data, function (i, n) {
                        html += '<div id="' + n.id + '" class="remarkDiv" style="height: 60px;">';
                        html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                        html += '<div style="position: relative; top: -40px; left: 40px;" >';
                        html += '<h5 id="e' + n.id + '">' + n.noteContent + '</h5>';
                        html += '<font color="gray">交易</font> <font color="gray">-</font> <b>${t.customerName}-${t.name}</b> <small style="color: gray;"id="s' + n.id + '"> ' + (n.editFlag == 0 ? n.createTime : n.editTime) + ' 由' + (n.editFlag == 0 ? n.createBy : n.editBy) + '</small>';
                        html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                        html += '<a class="myHref" href="javascript:void(0);"onclick="editRemark(\'' + n.id + '\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
                        html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                        html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\'' + n.id + '\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                        html += '</div>';
                        html += '</div>';
                        html += '</div>';
                    })
                    //在添加备注的文本框头上插入
                    $("#remarkDiv").before(html);
                }
            })
        }


        function showHistoryList() {
            $.ajax({
                url: "workbench/transaction/getTranHistoryByTranId.do",
                data: {
                    "tranId": "${t.id}"
                },
                type: "get",
                dataType: "json",
                success: function (data) {
                    var html = "";
                    $.each(data, function (i, n) {
                        html += '<tr>';
                        html += '<td>' + n.stage + '</td>';
                        html += '<td>' + n.money + '</td>';
                        html += '<td>' + n.possibility + '</td>';
                        html += '<td>' + n.expectedDate + '</td>';
                        html += '<td>' + n.createTime + '</td>';
                        html += '<td>' + n.createBy + '</td>';
                        html += '</tr>';
                    })
                    $("#tranHistoryBody").html(html);
                }
            })
        };
        /*
            方法：改变交易阶段
            参数：
                stage:需要改变的阶段
                i:需要改变阶段对应的下标
         */
        function changeStage(stage, i) {
            // alert(stage);
            // alert(i);
            $.ajax({
                url: "workbench/transaction/changeStage.do",
                data: {
                    "id": "${t.id}",
                    "stage": stage,
                    "money": "${t.money}",	//生成交易历史用
                    "expectedDate": "${t.expectedDate}"	//生成交易历史用
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        //改变成功，局部刷新数据
                        $("#stage").html(data.t.stage);
                        $("#possibility").html(data.t.possibility);
                        $("#editBy").html(data.t.editBy);
                        $("#editTime").html(data.t.editTime);
                        //刷新图标。
                        changeIcon(stage, i);

                    } else {
                        alert("改变阶段失败")
                    }
                }
            })
        }

        function changeIcon(stage, index1) {
            //当前阶段
            var currentStage = stage;
            //当前阶段可能性
            var currentPossibility = $("#possibility").html();
            //当前阶段的下标
            var index = index1;
            //前面正常阶段和后面丢失阶段的分界点下标
            var point = "<%=point%>";
            // alert(currentStage);
            // alert(currentPossibility);
            // alert(index);
            // alert(point);

            //如果当前阶段可能性为0
            if (currentPossibility == "0") {

                //遍历前7个
                for (var i = 0; i < point; i++) {
                    //黑圈
                    //移除掉原有样式
                    $("#" + i).removeClass();
                    //添加新样式
                    $("#" + i).addClass("glyphicon glyphicon-record mystage")
                    //为新样式赋予颜色
                    $("#" + i).css("color", "#000000");
                }
                for (var i = point; i <<%=dvList.size()%>; i++) {
                    //如果是当前阶段
                    if (i == index) {
                        //红叉
                        //移除掉原有样式
                        $("#" + i).removeClass();
                        //添加新样式
                        $("#" + i).addClass("glyphicon glyphicon-remove mystage")
                        //为新样式赋予颜色
                        $("#" + i).css("color", "#FF0000");
                    } else {
                        //黑叉
                        //移除掉原有样式
                        $("#" + i).removeClass();
                        //添加新样式
                        $("#" + i).addClass("glyphicon glyphicon-remove mystage")
                        //为新样式赋予颜色
                        $("#" + i).css("color", "#000000");

                    }
                }


                //如果当前阶段可能性不为0
            } else {
                //遍历前7个
                for (var i = 0; i < point; i++) {
                    if (i == index) {
                        //绿标
                        //移除掉原有样式
                        $("#" + i).removeClass();
                        //添加新样式
                        $("#" + i).addClass("glyphicon glyphicon-map-marker mystage")
                        //为新样式赋予颜色
                        $("#" + i).css("color", "#90F790");


                        //如果小于当前阶段
                    } else if (i < index) {
                        //绿勾
                        //移除掉原有样式
                        $("#" + i).removeClass();
                        //添加新样式
                        $("#" + i).addClass("glyphicon glyphicon-ok-circle mystage")
                        //为新样式赋予颜色
                        $("#" + i).css("color", "#90F790");


                        //如果大于当前阶段
                    } else if (i > index) {
                        //黑圈
                        //移除掉原有样式
                        $("#" + i).removeClass();
                        //添加新样式
                        $("#" + i).addClass("glyphicon glyphicon-record mystage")
                        //为新样式赋予颜色
                        $("#" + i).css("color", "#000000");

                    }
                }
                for (var i = point; i <<%=dvList.size()%>; i++) {
                    //黑叉
                    //移除掉原有样式
                    $("#" + i).removeClass();
                    //添加新样式
                    $("#" + i).addClass("glyphicon glyphicon-record mystage")
                    //为新样式赋予颜色
                    $("#" + i).css("color", "#000000");

                }

            }
        }

        function editRemark(id) {

            $("#remarkId").val(id);

            var noteContent = $("#e" + id).html();

            $("#noteContent").val(noteContent);

            $("#editRemarkModal").modal("show");

        }

        function deleteRemark(id) {
            $.ajax({
                url: "workbench/transaction/deleteRemark.do",
                data: {
                    "id": id
                },
                type: "post",
                dataType: "json",
                success: function (data) {

                    if (data.success) {
                        $("#" + id).remove();

                    } else {
                        alert("删除备注失败")
                    }
                }
            })
        }


    </script>

</head>
<body>
<!-- 修改交易的模态窗口 -->
<div class="modal fade" id="editTranModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改交易信息</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-transactionOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <c:forEach items="${tranUserList}" var="u">
                                    <option value="${u.id}" ${user.id eq u.id ? "selected" : ""}>${u.name}</option>
                                </c:forEach>

                            </select>
                            <input type="hidden" name="id" value="${t.id}"/>
                        </div>
                        <label for="edit-amountOfMoney" class="col-sm-2 control-label">金额</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-money" value="${t.money}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-transactionName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" id="edit-name" class="form-control"
                                   value="${t.name}">
                        </div>
                        <label for="edit-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time1" readonly
                                   id="edit-expectedDate" value="${t.expectedDate}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-accountName" class="col-sm-2 control-label">客户名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-customerName" name="customerName"
                                   value="${t.customerName}" placeholder="支持自动补全，输入客户不存在则新建"/>
                        </div>
                        <label for="edit-transactionStage" class="col-sm-2 control-label">阶段<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-stage">
                                <option></option>
                                <c:forEach items="${stageList}" var="s">
                                    <option value="${s.value}" ${t.stage eq s.value ? "selected" : ""}>${s.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-transactionType" class="col-sm-2 control-label">类型</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-type">
                                <option></option>
                                <c:forEach items="${transactionTypeList}" var="tran">
                                    <option value="${tran.value}" ${t.type eq tran.value ? "selected" : ""}>${tran.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-possibility" class="col-sm-2 control-label">可能性</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-possibility"
                                   value="${t.possibility}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <option></option>
                                <c:forEach items="${sourceList}" var="s">
                                    <option value="${s.value}" ${t.source eq s.value ? "selected" : ""}>${s.text}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <label for="edit-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a
                                href="javascript:void(0);" data-toggle="modal" data-target="#findMarketActivity"><span
                                class="glyphicon glyphicon-search"></span></a></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <!--提交的是id,不提交name-->
                            <input type="text" class="form-control" value="${activityName}">
                            <!--选到看到的是name，本质提交的是id-->
                            <input type="hidden" id="edit-activityId" value="${t.activityId}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a
                                href="javascript:void(0);" data-toggle="modal"
                                data-target="#findContacts"><span
                                class="glyphicon glyphicon-search"></span></a></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-contactsName" value="${t.contactsName}">
                            <input type="hidden" id="edit-contactsId" value="${t.contactsId}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 70%;">
                            <textarea class="form-control" rows="3" id="edit-description">${t.description}</textarea>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                        <div class="col-sm-10" style="width: 70%;">
                            <textarea class="form-control" rows="3"
                                      id="edit-contactSummary">${t.contactSummary}</textarea>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time2" readonly id="edit-nextContactTime"
                                   value="${t.nextContactTime}">
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="updateBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="findContacts" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找联系人</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" id="cname" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="contactsTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input type="checkbox"/></td>
                        <td>名称</td>
                        <td>邮箱</td>
                        <td>手机</td>
                    </tr>
                    </thead>
                    <tbody id="contactsSearchBody">

                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary"  id="chooseBtn">选中</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改线索备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>${t.name}-${t.customerName} <small>-${t.money}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editTranModal"><span
                class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>

<!-- 阶段状态 -->
<div style="position: relative; left: 40px; top: -50px;">
    阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <%
        //准备当前阶段
        Tran t = (Tran) request.getAttribute("t");
        String currentStage = t.getStage();
        //准备当前阶段的可能性
        String currentPossibility = pMap.get(currentStage);

        //判断当前阶段
        //如果当前阶段可能性为0,则前7个一定是黑圈，后两个不一定，一红叉一黑叉
        if ("0".equals(currentPossibility)) {

            for (int i = 0; i < dvList.size(); i++) {

                //取出来遍历出来的每一个阶段，根据阶段取得其可能性
                DicValue dv = dvList.get(i);
                String listStage = dv.getValue();
                String listPossibility = pMap.get(listStage);


                //如果遍历出来的阶段可能性为0,则说明是后面2个
                if ("0".equals(listPossibility)) {

                    //如果是当前阶段
                    if (listStage.equals(currentStage)) {
                        //红叉---------------------

    %>


    <span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
          class="glyphicon glyphicon-remove mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dv.getText()%>" style="color: #FF0000;"></span>
    ----------


    <%

    } else {
        //黑叉-------------------
    %>


    <span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
          class="glyphicon glyphicon-remove mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dv.getText()%>" style="color: #000000;"></span>
    ----------


    <%

        }

        //如果遍历出来的阶段可能性不为0，说明前7个一定是黑圈
    } else {
        //黑圈

    %>


    <span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
          class="glyphicon glyphicon-record mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dv.getText()%>" style="color: #000000;"></span>
    ----------


    <%

            }
        }


        //如果当前阶段可能性不为0，则前7个可能是绿圈、绿色标记、黑圈，后两个一定是黑叉
    } else {
        //准备当前阶段的下标
        int index = 0;
        for (int i = 0; i < dvList.size(); i++) {

            DicValue dv = dvList.get(i);
            String stage = dv.getValue();

            if (stage.equals(currentStage)) {
                index = i;
                break;
            }
        }
        for (int i = 0; i < dvList.size(); i++) {

            //取出来遍历出来的每一个阶段，根据阶段取得其可能性
            DicValue dv = dvList.get(i);
            String listStage = dv.getValue();
            String listPossibility = pMap.get(listStage);
            if ("0".equals(listPossibility)) {
                //黑叉

    %>


    <span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
          class="glyphicon glyphicon-remove mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dv.getText()%>" style="color: #000000;"></span>
    ----------


    <%
    } else {
        if (i == index) {
            //绿色正在标
    %>

    <span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
          class="glyphicon glyphicon-map-marker mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dv.getText()%>" style="color: #90F790;"></span>
    ----------

    <%

    } else if (i < index) {
        //绿勾
    %>

    <span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
          class="glyphicon glyphicon-ok-circle mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dv.getText()%>" style="color: #90F790;"></span>
    ----------


    <%
    } else if (i > index) {
        //黑圈
    %>


    <span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
          class="glyphicon glyphicon-record mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dv.getText()%>" style="color: #000000;"></span>
    ----------


    <%
                    }
                }


            }


        }
    %>

    <span class="closingDate">${t.expectedDate}</span>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: 0px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; bottom: -1px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; left: 450px"></div>
        <div style="width: 300px;position: relative; left: 450px; top: -20px; color: gray;">金额</div>
        <div style="width: 300px;position: relative; left: 200px; top: -40px;"><b>${t.owner}</b></div>
        <div style="width: 300px;position: absolute; left: 650px; top: 0px;"><b>${t.money}</b></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; bottom: -1px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; left: 450px"></div>
        <div style="width: 300px;position: relative; left: 450px; top: -20px; color: gray;">预计成交日期</div>
        <div style="width: 300px;position: relative; left: 200px; top: -40px;"><b>${t.name}</b></div>
        <div style="width: 300px;position: absolute; left: 650px; top: 0px;"><b>${t.expectedDate}</b></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">客户名称</div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; bottom: -1px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; left: 450px"></div>
        <div style="width: 300px;position: relative; left: 450px; top: -20px; color: gray;">阶段</div>
        <div style="width: 300px;position: relative; left: 200px; top: -40px;"><b>${t.customerName}</b></div>
        <div style="width: 300px;position: absolute; left: 650px; top: 0px;"><b id="stage">${t.stage}</b></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">类型</div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; bottom: -1px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; left: 450px"></div>
        <div style="width: 300px;position: relative; left: 450px; top: -20px; color: gray;">可能性</div>
        <div style="width: 300px;position: relative; left: 200px; top: -40px;"><b>${t.type}</b></div>
        <div style="width: 300px;position: absolute; left: 650px; top: 0px;"><b id="possibility">${t.possibility}</b>
        </div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">来源</div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; bottom: -1px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; left: 450px"></div>
        <div style="width: 300px;position: relative; left: 450px; top: -20px; color: gray;">市场活动源</div>
        <div style="width: 300px;position: relative; left: 200px; top: -40px;"><b>${t.source}&nbsp;&nbsp;</b></div>
        <div style="width: 300px;position: absolute; left: 650px; top: 0px;"><b>${t.activityName}&nbsp;&nbsp;</b></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">联系人名称</div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; bottom: 1px;"></div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${t.contactsName}</b></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; bottom: 1px;"></div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${t.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${t.createTime}</small></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; bottom: 1px;"></div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b
                id="editBy">${t.editBy}&nbsp;&nbsp;</b><small id="editTime"
                                                              style="font-size: 10px; color: gray;">${t.editTime}</small>
        </div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; bottom: 1px;"></div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${t.description}
            </b>
        </div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; bottom: 1px;"></div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                &nbsp;${t.contactSummary}
            </b>
        </div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; bottom: 1px;"></div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${t.nextContactTime}</b></div>
    </div>
</div>

<!-- 备注 -->
<div id="remarkBody" style="position: relative; top: 100px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button id="saveRemarkBtn" type="button" class="btn btn-primary">保存</button>
            </p>
        </form>
    </div>
</div>


<!-- 阶段历史 -->
<div>
    <div style="position: relative; top: 100px; left: 40px;">
        <div class="page-header">
            <h4>阶段历史</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>阶段</td>
                    <td>金额</td>
                    <td>可能性</td>
                    <td>预计成交日期</td>
                    <td>创建时间</td>
                    <td>创建人</td>
                </tr>
                </thead>
                <tbody id="tranHistoryBody">

                </tbody>
            </table>
        </div>

    </div>
</div>

<div style="height: 200px;"></div>

</body>
</html>