<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    Map<String,String> pMap =(Map<String,String>) application.getAttribute("pMap");
    Set<String> set = pMap.keySet();
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

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

            //客户名称补全
            $("#edit-customerName").typeahead({
                source: function (query, process) {
                    $.post(
                        "workbench/contacts/getCustomerName.do",
                        { "name" : query },
                        function (data) {
                            process(data);
                        },
                        "json"
                    );
                },
                delay: 150
            });
            $("#create-customerName").typeahead({
                source: function (query, process) {
                    $.post(
                        "workbench/contacts/getCustomerName.do",
                        { "name" : query },
                        function (data) {
                            process(data);
                        },
                        "json"
                    );
                },
                delay: 150
            });

            $("#create-stage").change(function (){
                //取得选中的阶段
                var stage = $("#create-stage").val();
                var possibility = json[stage];
                $("#create-possibility").val(possibility);
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

            showRemarkList();
            showTranList();
            showActivityList();

            $("#updateBtn").click(function (){
                if ($("#edit-fullname").val() == "") {
                    alert("姓名不能为空");
                    return false;
                }
                $.ajax({
                    url: "workbench/contacts/update.do",
                    data: {
                        "id": "${c.id}",
                        "owner": $.trim($("#edit-owner").val()),
                        "source": $.trim($("#edit-source").val()),
                        "customerName": $.trim($("#edit-customerName").val()),
                        "fullname": $.trim($("#edit-fullname").val()),
                        "appellation": $.trim($("#edit-appellation").val()),
                        "email": $.trim($("#edit-email").val()),
                        "mphone": $.trim($("#edit-mphone").val()),
                        "job": $.trim($("#edit-job").val()),
                        "birth": $.trim($("#edit-birth").val()),
                        "description": $.trim($("#edit-description").val()),
                        "contactSummary": $.trim($("#edit-contactSummary").val()),
                        "nextContactTime": $.trim($("#edit-nextContactTime").val()),
                        "address": $.trim($("#edit-address").val())
                    },
                    type: "post",
                    dataType: "json",
                    success:function (data){

                        if (data.success){
                            alert("更新成功");
                            $("#editContactsModal").modal("hide");
                            window.location.reload();
                        }else{
                            alert("修改联系人失败");
                        }
                    }
                })
            })

            $("#deleteBtn").click(function (){
                if(confirm("确定要删除该联系人吗？")){

                    $.ajax({
                        url:"workbench/contacts/deleteInDetail.do",
                        data: {
                            "contactsId":"${c.id}",
                        },
                        type:"post",
                        dataType:"json",
                        success:function (data){
                            if (data.success){
                                window.location.href="workbench/contacts/index.jsp";
                            }else {
                                alert("删除联系人失败")
                            }
                        }
                    })
                }
            })

            //为保存按钮绑定事件
            $("#saveRemarkBtn").on("click", function () {
                $.ajax({
                    url: "workbench/contacts/saveRemark.do",
                    data: {
                        "noteContent": $.trim($("#remark").val()),
                        "contactsId": "${c.id}"
                        //	在detail.do中已经将c保存在请求域中了
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {

                        if (data.success) {
                            //将textarea中内容清空
                            $("#remark").val("");
                            //在textarea文本域上方新增一个div
                            var html = "";
                            html += '<div id="' + data.cr.id + '" class="remarkDiv" style="height: 60px;">';
                            html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                            html += '<div style="position: relative; top: -40px; left: 40px;" >';
                            html += '<h5 id="e' + data.cr.id + '">' + data.cr.noteContent + '</h5>';
                            html += '<font color="aqua">联系人</font> <font color="aqua">-</font> <b>${c.fullname}-${c.customerName}</b> <small style="color: aqua;"> ' + (data.cr.createTime) + ' 由' + (data.cr.createBy) + '</small>';
                            html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\'' + data.cr.id + '\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
                            html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\'' + data.cr.id + '\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
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
                    url: "workbench/contacts/updateRemark.do",
                    data: {
                        "id": id,
                        "noteContent": $.trim($("#noteContent").val())
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {

                        if (data.success) {
                            //更新div中相应的信息，需要更新的内容有 noteContent editTime editBy
                            $("#e" + id).html(data.cr.noteContent);
                            $("#s" + id).html(data.cr.editTime + " 由" + data.cr.editBy);
                            //更新内容之后，关闭模态窗口
                            $("#editRemarkModal").modal("hide");

                        } else {
                            alert("更新备注失败")
                        }

                    }
                })
            })

            $("#aname").keydown(function (event){
                if (event.keyCode==13){
                    $.ajax({
                        //线索本身已经存在的关联活动就不再查询出来了，不可重复关联
                        url:"workbench/contacts/getActivityListByContactsNameButNotId.do",
                        data:{
                            "aname":$.trim($("#aname").val()),
                            "contactsId":"${c.id}"
                        },
                        type:"get",
                        dataType:"json",
                        success:function (data){

                            var html = "";
                            $.each(data,function (i,n){
                                html += '<tr>'
                                html += '<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>'
                                html += '<td ><a style="color: #a20fff;text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id=' + n.id + '\';">' + n.name + '</a></td>';
                                html += '<td>'+n.startDate+'</td>'
                                html += '<td>'+n.endDate+'</td>'
                                html += '<td>'+n.owner+'</td>'
                                html += '</tr>'
                            })
                            $("#activitySearchBody").html(html);

                        }
                    })
                    //展现完列表后，禁用模态窗口默认的回车后刷新整个窗口行为
                    return false;
                }
            })

            $("#bundBtn").click(function (){
                var $xz = $("input[name=xz]:checked");
                if ($xz.length==0){
                    alert("请选择需要关联的事件")
                }else {
                    var param = "cid=${c.id}&";
                    for(var i=0;i<$xz.length;i++){
                        param += "aid="+$($xz[i]).val();
                        if (i<$xz.length-1){
                            param +='&';
                        }
                    }
                    $.ajax({
                        url:"workbench/contacts/bundActivity.do",
                        data:param,
                        type:"post",
                        dataType:"json",
                        success:function (data){

                            if (data.success){
                                showActivityList();
                                $("#aname").val("");
                                $("#activitySearchBody").html("");
                                $("#bundModal").modal("hide");
                            }else{
                                alert("关联事件失败")
                            }
                        }
                    })
                }
            })

            $("#bundTranBtn").click(function (){
                if ($("#create-name").val() == "") {
                    alert("名称不能为空");
                    return false;
                }
                $.ajax({
                    url: "workbench/contacts/bundTran.do",
                    data: {
                        "contactsId":"${c.id}",
                        "owner":$.trim($("#create-owner").val()),
                        "name":$.trim($("#create-name").val()),
                        "money":$.trim($("#create-money").val()),
                        "expectedDate":$.trim($("#create-expectedDate").val()),
                        "customerName":$.trim($("#create-customerName").val()),
                        "source":$.trim($("#create-source").val()),
                        "stage":$.trim($("#create-stage").val()),
                        "activityId":$.trim($("#create-activityId").val()),
                        "type":$.trim($("#create-type").val()),
                        "description":$.trim($("#create-description").val()),
                        "nextContactTime":$.trim($("#create-nextContactTime").val()),
                        "contactSummary":$.trim($("#create-contactSummary").val())
                    },
                    type: "post",
                    dataType: "json",
                    success:function (data){

                        if (data.success){
                            $("#createTransactionModal").modal("hide");
                            window.location.reload();
                        }else{
                            alert("新建交易失败");
                        }
                    }
                })
            })
        });

        function showTranList(){

            $.ajax({

                url:"workbench/contacts/getTranListByContactsId.do",
                //每条线索有多个关联活动
                data:{
                    "contactsId":"${c.id}"
                },
                type:"get",
                dataType:"json",
                success:function (data){

                    var html = "";
                    $.each(data,function (i,n){
                        html += '<tr class="table-tr">';
                        html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/detail.do?id=' + n.id + '\';">' + n.name + '</a></td>';
                        html += '<td>'+n.money+'</td>';
                        html += '<td>'+n.stage+'</td>';
                        html += '<td>'+json[n.stage]+'</td>';
                        html += '<td>'+n.expectedDate+'</td>';
                        html += '<td>'+n.type+'</td>';
                        html += '<td><a href="javascript:void(0);" onclick="deleteTransaction(\''+n.id+'\')" style="color: red;text-decoration: none;"><span style="color: red" class="glyphicon glyphicon-remove"></span>删除</a></td>';
                        html += '</tr>';
                    })
                    $("#tranBody").html(html);
                }
            })
        }

        function deleteTransaction(transactionId){

            $.ajax({
                url:"workbench/contacts/deleteTran.do",
                data:{
                    "contactsId":"${c.id}",
                    "transactionId":transactionId
                },
                type: "post",
                dataType: "json",
                success:function (data){
                    if (data.success){

                        showTranList();
                    }else{
                        alert("删除失败")
                    }
                }
            })
        };

        function showRemarkList() {
            $.ajax({
                url: "workbench/contacts/getRemarkListByCid.do",
                data: {
                    "contactsId": "${c.id}"
                },
                type: "get",
                dataType: "json",
                success: function (data) {
                    var html = "";
                    $.each(data, function (i, n) {
                        html += '<div id="' + n.id + '" class="remarkDiv" style="height: 60px;">';
                        html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                        html += '<div style="position: relative; top: -40px; left: 40px;" >';
                        html += '<h5 style="color:aquamarine;" id="e' + n.id + '">' + n.noteContent + '</h5>';
                        html += '<font color="aqua">联系人</font> <font color="aqua">-</font> <b>${c.fullname}-${c.customerName}</b> <small style="color: aqua;"id="s' + n.id + '"> ' + (n.editFlag == 0 ? n.createTime : n.editTime) + ' 由' + (n.editFlag == 0 ? n.createBy : n.editBy) + '</small>';
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
        function showActivityList(){

            $.ajax({

                url:"workbench/contacts/getActivityListByContactsId.do",
                //每条线索有多个关联活动
                data:{
                    "contactsId":"${c.id}"
                },
                type:"get",
                dataType:"json",
                success:function (data){

                    var html = "";
                    $.each(data,function (i,n){
                        html += '<tr class="table-tr">';
                        html += '<td ><a style="color: aquamarine;text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id=' + n.id + '\';">' + n.name + '</a></td>';
                        html += '<td>'+n.startDate+'</td>';
                        html += '<td>'+n.endDate+'</td>';
                        html += '<td><a href="javascript:void(0);" onclick="unbundActivity(\''+n.carId+'\')" style="color: red;text-decoration: none;"><span style="color: red" class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
                        html += '</tr>';
                    })
                    $("#activityBody").html(html);
                }
            })
        };

        function unbundActivity(id){
            $.ajax({
                url:"workbench/contacts/unbundActivity.do",
                data:{
                    "id":id
                },
                type: "post",
                dataType: "json",
                success:function (data){
                    if (data.success){
                        showActivityList();
                    }else{
                        alert("解除关联失败")
                    }
                }
            })
        }

        function editRemark(id) {

            $("#remarkId").val(id);

            var noteContent = $("#e" + id).html();

            $("#noteContent").val(noteContent);

            $("#editRemarkModal").modal("show");

        }

        function deleteRemark(id) {
            $.ajax({
                url: "workbench/contacts/deleteRemark.do",
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
    <style>

        .table-tr:hover{
            background-color: #5e5e5e;
        }

        .form-control{
            background-color: #5e5e5e;
            color: #e8ff2f;
        }
    </style>

</head>
<body style="background-color: #222222">

<!-- 创建交易的模态窗口 -->
<div class="modal fade" id="createTransactionModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div style="background-color: rgba(41, 45, 62, .8);color: aqua" class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" >
                    <span style="color: aquamarine" aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">创建交易</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-transactionOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                                <option style="background-color: #333333;color:aquamarine"></option>
                                <c:forEach items="${contactsUserList}" var="u">
                                    <option style="background-color: #333333;color:aquamarine" value="${u.id}" ${c.owner eq u.name ? "selected" : ""}>${u.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-money">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                        <label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input style="background-color: #5e5e5e" type="text" class="form-control time1" readonly id="create-expectedDate">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input style="background-color: #5e5e5e" type="text" class="form-control" id="create-customerName"
                                   placeholder="支持自动补全，输入客户不存在则新建" readonly value="${c.customerName}">
                        </div>

                        <label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-stage">
                                <option style="background-color: #333333;color:aquamarine"></option>
                                <c:forEach items="${stageList}" var="s">
                                    <option style="background-color: #333333;color:aquamarine" value="${s.value}">${s.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-transactionType" class="col-sm-2 control-label">类型</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-type">
                                <option style="background-color: #333333;color:aquamarine"></option>
                                <c:forEach items="${transactionTypeList}" var="t">
                                    <option style="background-color: #333333;color:aquamarine" value="${t.value}">${t.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-possibility" class="col-sm-2 control-label">可能性</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-possibility">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-clueSource" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
                                <option style="background-color: #333333;color:aquamarine"></option>
                                <c:forEach items="${sourceList}" var="s">
                                    <option style="background-color: #333333;color:aquamarine" value="${s.value}">${s.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findMarketActivity"><span class="glyphicon glyphicon-search"></span></a></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-activitySrc">
                            <input type="hidden" id="create-activityId">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 70%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                        <div class="col-sm-10" style="width: 70%;">
                            <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input style="background-color: #5e5e5e" type="text" class="form-control time2" readonly id="create-nextContactTime">
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="bundTranBtn">创建</button>
            </div>
        </div>
    </div>
</div>

<!-- 删除交易的模态窗口 -->
<div class="modal fade" id="removeTransactionModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div style="background-color: rgba(41, 45, 62, .8);color: aqua" class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span style="color: aquamarine" aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">删除交易</h4>
            </div>
            <div class="modal-body">
                <p>您确定要删除该交易吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-danger" data-dismiss="modal">删除</button>
            </div>
        </div>
    </div>
</div>

<!-- 关联市场活动的模态窗口 -->
<div class="modal fade" id="bundModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div style="background-color: rgba(41, 45, 62, .8);color: aqua" class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span style="color: aquamarine" aria-hidden="true">×</span>
                </button>
                <h4 style="color: #a20fff" class="modal-title">关联市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" id="aname" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input type="checkbox"/></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="activitySearchBody">

                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="bundBtn">关联</button>
            </div>
        </div>
    </div>
</div>


<!-- 修改联系人的模态窗口 -->
<div class="modal fade" id="editContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div style="background-color: rgba(41, 45, 62, .8);color: aqua" class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span style="color: aquamarine" aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改联系人</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-contactsOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <c:forEach items="${contactsUserList}" var="u">
                                    <option style="background-color: #333333;color:aquamarine" value="${u.id}" ${c.owner eq u.name ? "selected" : ""}>${u.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <option style="background-color: #333333;color:aquamarine"></option>
                                <c:forEach items="${sourceList}" var="s">
                                    <option style="background-color: #333333;color:aquamarine" value="${s.value}" ${c.source eq s.value ? "selected" : ""}>${s.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-fullname" value="${c.fullname}">
                        </div>
                        <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-appellation">
                                <option style="background-color: #333333;color:aquamarine"></option>
                                <c:forEach items="${appellationList}" var="a">
                                    <option style="background-color: #333333;color:aquamarine" value="${a.value}" ${c.appellation eq a.value ? "selected" : ""}>${a.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" value="${c.job}">
                        </div>
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" value="${c.mphone}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email" value="${c.email}">
                        </div>
                        <label for="edit-birth" class="col-sm-2 control-label">生日</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input style="background-color: #5e5e5e" type="text" class="form-control time1" id="edit-birth" value="${c.birth}" readonly>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-customerName"
                                   placeholder="支持自动补全，输入客户不存在则新建" value="${c.customerName}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description">${c.description}</textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3"
                                          id="edit-contactSummary">${c.contactSummary}</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input style="background-color: #5e5e5e" type="text" class="form-control time2" id="edit-nextContactTime"
                                       value="${c.nextContactTime}" readonly>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address1" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address">${c.address}</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<!-- 修改线索备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div style="background-color: rgba(41, 45, 62, .8);color: aqua" class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span style="color: aquamarine" aria-hidden="true">×</span>
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
    <a href="javascript:void(0);" onclick="window.location.href='workbench/contacts/index.jsp';">
        <span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3 style="color: whitesmoke">${c.fullname}${c.appellation}<small> - ${c.customerName}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editContactsModal"><span
                class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>

<!-- 详细信息 -->
<div style="color: aquamarine;position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: aqua;">所有者</div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; bottom: -1px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; left: 450px"></div>
        <div style="width: 300px;position: relative; left: 450px; top: -20px; color: aqua;">来源</div>
        <div style="width: 300px;position: relative; left: 200px; top: -40px;"><b>${c.owner}</b></div>
        <div style="width: 300px;position: absolute; left: 650px; top: 0px;"><b>${c.source}</b></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: aqua;">客户名称</div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; bottom: -1px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; left: 450px"></div>
        <div style="width: 300px;position: relative; left: 450px; top: -20px; color: aqua;">姓名</div>
        <div style="width: 300px;position: relative; left: 200px; top: -40px;"><b>${c.customerName}</b></div>
        <div style="width: 300px;position: absolute; left: 650px; top: 0px;"><b>${c.fullname}</b></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: aqua;">邮箱</div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; bottom: -1px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; left: 450px"></div>
        <div style="width: 300px;position: relative; left: 450px; top: -20px; color: aqua;">手机</div>
        <div style="width: 300px;position: relative; left: 200px; top: -40px;"><b>${c.email}</b></div>
        <div style="width: 300px;position: absolute; left: 650px; top: 0px;"><b>${c.mphone}</b></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: aqua;">职位</div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; bottom: -1px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; left: 450px"></div>
        <div style="width: 300px;position: relative; left: 450px; top: -20px; color: aqua;">生日</div>
        <div style="width: 300px;position: relative; left: 200px; top: -40px;"><b>${c.job}</b></div>
        <div style="width: 300px;position: absolute; left: 650px; top: 0px;"><b>${c.birth}</b></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: aqua;">创建者</div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; bottom: 1px;"></div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${c.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: whitesmoke;">${c.createTime}</small></div>
    </div>

    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: aqua;">修改者</div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; bottom: 1px;"></div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${c.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: whitesmoke;">${c.editTime}</small></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: aqua;">描述</div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; bottom: 1px;"></div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${c.description}
            </b>
        </div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: aqua;">联系纪要</div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; bottom: 1px;"></div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${c.contactSummary}
            </b>
        </div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: aqua;">下次联系时间</div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; bottom: 1px;"></div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.nextContactTime}</b></div>

    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: aqua;">详细地址</div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; bottom: 1px;"></div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${c.address}
            </b>
        </div>
    </div>
</div>
<!-- 备注 -->
<div id="remarkBody" style="color: aqua;position: relative; top: 20px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <div id="remarkDiv" style="background-color: #5e5e5e; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="background-color: #9d9d9d;color: #c8e5bc;width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button id="saveRemarkBtn" type="button" class="btn btn-primary">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 交易 -->
<div>
    <div style="color: aqua;position: relative; top: 20px; left: 40px;">
        <div class="page-header">
            <h4>交易</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable3" class="table" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>金额</td>
                    <td>阶段</td>
                    <td>可能性</td>
                    <td>预计成交日期</td>
                    <td>类型</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="tranBody">

                </tbody>
            </table>
        </div>

        <div>
            <a href="javascript:void(0);" data-toggle="modal" data-target="#createTransactionModal" style="color: #a20fff;text-decoration: none;"><span style="color: #a20fff" class="glyphicon glyphicon-plus"></span>新建交易</a>
        </div>
    </div>
</div>

<!-- 市场活动 -->
<div>
    <div style="color: aqua;position: relative; top: 60px; left: 40px;">
        <div class="page-header">
            <h4>市场活动</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table class="table" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>所有者</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="activityBody">

                </tbody>
            </table>
        </div>

        <div>
            <a href="javascript:void(0);" data-toggle="modal" data-target="#bundModal" style="color: #a20fff;text-decoration: none;"><span style="color: #a20fff" class="glyphicon glyphicon-plus"></span>关联市场活动</a>
        </div>
    </div>
</div>



<div style="height: 200px;"></div>
</body>
</html>