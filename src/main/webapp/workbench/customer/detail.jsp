<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

    <script type="text/javascript">

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

            $("#create-customerName").typeahead({
                source: function (query, process) {
                    $.post(
                        "workbench/customer/getCustomerName.do",
                        {"name": query},
                        function (data) {
                            process(data);
                        },
                        "json"
                    );
                },
                delay: 150
            });

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
            showRemarkList();
            showTranList();
            showContactsList()
            $("#remarkBody").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            });
            $("#remarkBody").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            });

            $("#updateBtn").click(function () {
                if ($("#edit-name").val() == "") {
                    alert("名称不能为空");
                    return false;
                }
                $.ajax({
                    url: "workbench/customer/update.do",
                    data: {
                        "id": "${c.id}",
                        "owner": $.trim($("#edit-owner").val()),
                        "name": $.trim($("#edit-name").val()),
                        "phone": $.trim($("#edit-phone").val()),
                        "email": $.trim($("#edit-email").val()),
                        "website": $.trim($("#edit-website").val()),
                        "description": $.trim($("#edit-description").val()),
                        "address": $.trim($("#edit-address").val()),
                        "nextContactTime": $.trim($("#edit-nextContactTime").val()),
                        "contactSummary": $.trim($("#edit-contactSummary").val())
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {

                        if (data.success) {
                            alert("更新成功");
                            $("#editContactsModal").modal("hide");
                            window.location.reload();
                        } else {
                            alert("修改客户失败");
                        }
                    }
                })
            })

            $("#deleteBtn").click(function (){
                if(confirm("确定要删除该客户吗？")){

                    $.ajax({
                        url:"workbench/customer/deleteInDetail.do",
                        data: {
                            "customerId":"${c.id}",
                        },
                        type:"post",
                        dataType:"json",
                        success:function (data){
                            if (data.success){
                                window.location.href="workbench/customer/index.jsp";
                            }else {
                                alert("删除客户失败")
                            }
                        }
                    })
                }
            })


            //为保存按钮绑定事件
            $("#saveRemarkBtn").on("click", function () {
                $.ajax({
                    url: "workbench/customer/saveRemark.do",
                    data: {
                        "noteContent": $.trim($("#remark").val()),
                        "customerId": "${c.id}"
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
                            html += '<div id="' + data.cr.id + '" class="remarkDiv" style="height: 60px;">';
                            html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                            html += '<div style="position: relative; top: -40px; left: 40px;" >';
                            html += '<h5 style="color: aquamarine" id="e' + data.cr.id + '">' + data.cr.noteContent + '</h5>';
                            html += '<font color="aqua">客户</font> <font color="aqua">-</font> <b>${c.name}</b> <small style="color: aqua;"> ' + (data.cr.createTime) + ' 由' + (data.cr.createBy) + '</small>';
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
                    url: "workbench/customer/updateRemark.do",
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
                                html += '<td>'+n.mphone+'</td>'
                                html += '</tr>'
                            })
                            $("#contactsSearchBody").html(html);

                        }
                    })
                    //展现完列表后，禁用模态窗口默认的回车后刷新整个窗口行为
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
                        $("#createTran-contactsId").val(data.id);
                        $("#createTran-contactsName").val(data.fullname);

                    }
                })
            })

            $("#bundTranBtn").click(function (){
                if ($("#create-name").val() == "") {
                    alert("名称不能为空");
                    return false;
                }
               if ($("#createTran-stage").val() == "") {
                    alert("交易阶段不能为空");
                    return false;
                }
                $.ajax({
                    url: "workbench/customer/bundTran.do",
                    data: {
                        "customerId":"${c.id}",
                        "customerName":"${c.name}",
                        "owner":$.trim($("#createTran-owner").val()),
                        "name":$.trim($("#createTran-name").val()),
                        "money":$.trim($("#createTran-money").val()),
                        "expectedDate":$.trim($("#createTran-expectedDate").val()),
                        "source":$.trim($("#createTran-source").val()),
                        "stage":$.trim($("#createTran-stage").val()),
                        "activityId":$.trim($("#createTran-activityId").val()),
                        "contactsName":$.trim($("#createTran-contactsName").val()),
                        "contactsId":$.trim($("#createTran-contactsId").val()),
                        "type":$.trim($("#createTran-type").val()),
                        "description":$.trim($("#createTran-description").val()),
                        "nextContactTime":$.trim($("#createTran-nextContactTime").val()),
                        "contactSummary":$.trim($("#createTran-contactSummary").val())
                    },
                    type: "post",
                    dataType: "json",
                    success:function (data){

                        if (data.success){
                            showTranList();
                            $("#createTransactionModal").modal("hide");

                        }else{
                            alert("新建交易失败");
                        }
                    }
                })
            })

            $("#addContactsBtn").click(function () {
                //存在则直接关联，不存在则创建新的联系人后再与公司（客户）关联
                $.ajax({
                    url: "workbench/customer/addContacts.do",
                    data: {
                        "customerId": "${c.id}",
                        "customerName": "${c.name}",
                        "owner": $.trim($("#create-owner").val()),
                        "fullname": $.trim($("#create-fullname").val()),
                        "source": $.trim($("#create-source").val()),
                        "mphone": $.trim($("#create-mphone").val()),
                        "job": $.trim($("#create-job").val()),
                        "description": $.trim($("#create-description").val()),
                        "appelation": $.trim($("#create-appellation").val()),
                        "email": $.trim($("#create-email").val()),
                        "birth": $.trim($("#create-birth").val()),
                        "contactSummary": $.trim($("#create-contactSummary").val()),
                        "nextContactTime": $.trim($("#create-nextContactTime").val()),
                        "address": $.trim($("#create-address").val())
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            //关联成功，刷新列表
                            showContactsList();
                            //关闭模态窗口
                            $("#createContactsModal").modal("hide");
                        } else {
                            alert("关联事件失败")
                        }
                    }

                })
            })

        });

        function showRemarkList() {
            $.ajax({
                url: "workbench/customer/getRemarkListByCid.do",
                data: {
                    "customerId": "${c.id}"
                },
                type: "get",
                dataType: "json",
                success: function (data) {
                    var html = "";
                    $.each(data, function (i, n) {
                        html += '<div id="' + n.id + '" class="remarkDiv" style="height: 60px;">';
                        html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                        html += '<div style="position: relative; top: -40px; left: 40px;" >';
                        html += '<h5 style="color: aquamarine" id="e' + n.id + '">' + n.noteContent + '</h5>';
                        html += '<font color="aqua">客户</font> <font color="aqua">-</font> <b>${c.name}</b> <small style="color: aqua;"id="s' + n.id + '"> ' + (n.editFlag == 0 ? n.createTime : n.editTime) + ' 由' + (n.editFlag == 0 ? n.createBy : n.editBy) + '</small>';
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

        function showTranList(){
            $.ajax({
                url:"workbench/customer/getTranListByCustomerId.do",
                //每条线索有多个关联活动
                data:{
                    "customerId":"${c.id}"
                },
                type:"get",
                dataType:"json",
                success:function (data){

                    var html = "";
                    $.each(data,function (i,n){
                        html += '<tr class="table-tr" >';
                        html += '<td><a style="color: aquamarine; text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/detail.do?id=' + n.id + '\';">' + n.name + '</a></td>';
                        html += '<td>'+n.money+'</td>';
                        html += '<td>'+n.stage+'</td>';
                        //可以在控制层遍历tranList，给每一个根据stage赋予possibility，在前端就不会显得突兀了
                        html += '<td>'+n.possibility+'</td>';
                        html += '<td>'+n.expectedDate+'</td>';
                        html += '<td>'+n.type+'</td>';
                        html += '<td><a href="javascript:void(0);" onclick="deleteTransaction(\''+n.id+'\')" style="color: red;text-decoration: none;"><span style="color: red" class="glyphicon glyphicon-remove"></span>删除</a></td>';
                        html += '</tr>';
                    })
                    $("#tranBody").html(html);
                }
            })
        }

        function deleteTransaction(transactionId) {
            if (confirm("确定删除该交易吗")) {
                $.ajax({
                    url: "workbench/customer/deleteTran.do",
                    data: {
                        "transactionId": transactionId
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {

                            showTranList();
                        } else {
                            alert("删除失败")
                        }
                    }
                })
            }
        };

        function showContactsList() {
            $.ajax({
                url: "workbench/customer/getContactsListByCid.do",
                data: {
                    "customerId": "${c.id}"
                },
                type: "get",
                dataType: "json",
                success: function (data) {
                    var html = "";
                    $.each(data, function (i, n) {
                        html += '<tr class="table-tr">';
                        html += '<td><a style="color: aquamarine;text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/contacts/detail.do?id=' + n.id + '\';">' + n.fullname + '</a></td>';
                        html += '<td>' + n.email + '</td>';
                        html += '<td>' + n.mphone + '</td>';
                        html += '<td><a href="javascript:void(0);" onclick="deleteContacts(\'' + n.id + '\')" style="color: red;text-decoration: none;"><span style="color: red" class="glyphicon glyphicon-remove"></span>删除</a></td>';
                        html += '</tr>';
                    })
                    $("#contactsBody").html(html);
                }
            })
        }

        function deleteContacts(contactsId) {
            if (confirm("确定要删除所选的联系人吗？")) {
                $.ajax({
                    url: "workbench/customer/deleteContacts.do",
                    data: {
                        "customerId": "${c.id}",
                        "contactsId": contactsId
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {

                            showContactsList();
                        } else {
                            alert("解除关联失败")
                        }
                    }
                })
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
                url: "workbench/customer/deleteRemark.do",
                data: {
                    "id": id
                },
                type: "post",
                dataType: "json",
                success: function (data) {

                    if (data.success) {
                        $("#" + id).remove()
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
    </style>

</head>
<body style="background-color: #222222">

<!-- 修改备注的模态窗口 -->
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

<!-- 删除联系人的模态窗口 -->
<div class="modal fade" id="removeContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div style="background-color: rgba(41, 45, 62, .8);color: aqua" class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span style="color: aquamarine" aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">删除联系人</h4>
            </div>
            <div class="modal-body">
                <p>您确定要删除该联系人吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-danger" data-dismiss="modal">删除</button>
            </div>
        </div>
    </div>
</div>

<!-- 删除交易的模态窗口 -->
<div class="modal fade" id="removeTransactionModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div style="background-color: rgba(41, 45, 62, .8);color: aqua" class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" onclick="$('#removeTransactionModal').modal('hide');">
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

<!-- 创建交易的模态窗口 -->
<div class="modal fade" id="createTransactionModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div style="background-color: rgba(41, 45, 62, .8);color: aqua" class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" onclick="$('#createTransactionModal').modal('hide');">
                    <span style="color: aquamarine" aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">创建交易</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="createTran-owner">
                                <c:forEach items="${customerUserList}" var="u">
                                    <option style="background-color: #333333;color:aquamarine" value="${u.id}" ${c.owner eq u.name ? "selected" : ""}>${u.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="createTran-money" class="col-sm-2 control-label">金额</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="createTran-money">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="createTran-name">
                        </div>
                        <label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time1" readonly id="createTran-expectedDate">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-transactionType" class="col-sm-2 control-label">类型</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="createTran-type">
                                <option style="background-color: #333333;color:aquamarine"></option>
                                <c:forEach items="${transactionTypeList}" var="t">
                                    <option style="background-color: #333333;color:aquamarine" value="${t.value}">${t.text}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="createTran-stage">
                                <option style="background-color: #333333;color:aquamarine"></option>
                                <c:forEach items="${stageList}" var="s">
                                    <option style="background-color: #333333;color:aquamarine" value="${s.value}">${s.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-clueSource" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="createTran-source">
                                <option style="background-color: #333333;color:aquamarine"></option>
                                <c:forEach items="${sourceList}" var="s">
                                    <option style="background-color: #333333;color:aquamarine" value="${s.value}">${s.text}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <label for="create-possibility" class="col-sm-2 control-label">可能性</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="createTran-possibility">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="createTran-contactsName">
                            <input type="hidden" id="createTran-contactsId">
                        </div>

                        <label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findMarketActivity"><span class="glyphicon glyphicon-search"></span></a></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" name="createTran-activitySrc" id="createTran-activitySrc">
                            <input type="hidden" id="createTran-activityId" name="createTran-activityId">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 70%;">
                            <textarea class="form-control" rows="3" id="createTran-description"></textarea>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                        <div class="col-sm-10" style="width: 70%;">
                            <textarea class="form-control" rows="3" id="createTran-contactSummary"></textarea>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time2" readonly id="createTran-nextContactTime">
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

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span style="color: aquamarine" aria-hidden="true">×</span>
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
                <table id="contactsTable" class="table" style="width: 900px; position: relative;top: 10px;">
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

<!-- 创建联系人的模态窗口 -->
<div class="modal fade" id="createContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div style="background-color: rgba(41, 45, 62, .8);color: aqua" class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
                    <span style="color: aquamarine" aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">创建联系人</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                                <option style="background-color: #333333;color:aquamarine"></option>
                                <c:forEach items="${customerUserList}" var="u">
                                    <option style="background-color: #333333;color:aquamarine" value="${u.id}" ${user.id eq u.id ? "selected" : ""}>${u.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-customerSource" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
                                <option style="background-color: #333333;color:aquamarine"></option>
                                <c:forEach items="${sourceList}" var="s">
                                    <option style="background-color: #333333;color:aquamarine" value="${s.value}">${s.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-fullname">
                        </div>
                        <label for="create-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-appellation">
                                <option style="background-color: #333333;color:aquamarine"></option>
                                <c:forEach items="${appellationList}" var="a">
                                    <option style="background-color: #333333;color:aquamarine" value="${a.value}" }>${a.text}</option>
                                </c:forEach>
                            </select>
                        </div>

                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                        <label for="create-birth" class="col-sm-2 control-label">生日</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" readonly class="form-control time1" id="create-birth">
                        </div>
                    </div>


                    <div class="form-group" style="position: relative;">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time2" id="create-nextContactTime" readonly>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" id="addContactsBtn" class="btn btn-primary">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改客户的模态窗口 -->
<div class="modal fade" id="editCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div style="background-color: rgba(41, 45, 62, .8);color: aqua" class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span style="color: aquamarine" aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <c:forEach items="${customerUserList}" var="u">
                                    <option style="background-color: #333333;color:aquamarine" value="${u.id}" ${user.id eq u.id ? "selected" : ""}>${u.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-name" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name" value="${c.name}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website" value="${c.website}">
                        </div>
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" value="${c.phone}">
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
                            <label for="edit-nextContactTime2" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" readonly class="form-control time" id="edit-nextContactTime"
                                       value="${c.nextContactTime}">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
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

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.location.href='workbench/customer/index.jsp';">
        <span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div style="color: whitesmoke" class="page-header">
        <h3>${c.name} <small><a href="${c.website}" target="_blank">${c.website}</a></small></h3>
    </div>
    <div style="background-color: #222222;position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editCustomerModal"><span
                class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>

<!-- 详细信息 -->
<div style="color: aquamarine ;position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: aqua;">所有者</div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; bottom: -1px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; left: 450px"></div>
        <div style="width: 300px;position: relative; left: 450px; top: -20px; color: aqua;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -40px;"><b>${c.owner}</b></div>
        <div style="width: 300px;position: absolute; left: 650px; top: 0px;"><b>${c.name}</b></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: aqua;">公司网站</div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; bottom: -1px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; left: 450px"></div>
        <div style="width: 300px;position: relative; left: 450px; top: -20px; color: aqua;">公司座机</div>
        <div style="width: 300px;position: relative; left: 200px; top: -40px;"><b>${c.website}</b></div>
        <div style="width: 300px;position: absolute; left: 650px; top: 0px;"><b>${c.phone}</b></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: aqua;">创建者</div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; bottom: 1px;"></div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${c.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: whitesmoke;">${c.createTime}</small></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: aqua;">修改者</div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; bottom: 1px;"></div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${c.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: whitesmoke;">${c.editTime}</small></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: aqua;">联系纪要</div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; bottom: 1px;"></div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${c.contactSummary}
            </b>
        </div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: aqua;">下次联系时间</div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; bottom: 1px;"></div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.nextContactTime}</b></div>
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
<div id="remarkBody" style="color: aqua;position: relative; top: 40px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <div id="remarkDiv" style="background-color: #5e5e5e; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="background-color: #9d9d9d;color: #c8e5bc;width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button id="saveRemarkBtn" type="button"  class="btn btn-primary">保存</button>
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
            <table id="activityTable2" class="table" style="width: 900px;">
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

<!-- 联系人 -->
<div>
    <div style="color: aqua;position: relative; top: 20px; left: 40px;">
        <div class="page-header">
            <h4>联系人</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable" class="table" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>邮箱</td>
                    <td>手机</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="contactsBody">

                </tbody>
            </table>
        </div>

        <div>
            <a href="javascript:void(0);" data-toggle="modal" data-target="#createContactsModal"
               style="color: #a20fff; text-decoration: none;"><span style="color: #a20fff" class="glyphicon glyphicon-plus"></span>新建联系人</a>
        </div>
    </div>
</div>

<div style="height: 200px;"></div>
</body>
</html>