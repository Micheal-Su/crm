<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

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

        $(function () {
            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "top-left"
            });
            $(".time1").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            $("#edit-customerName").typeahead({
                source: function (query, process) {
                    $.post(
                        "workbench/transaction/getCustomerName.do",
                        { "name" : query },
                        function (data) {
                            process(data);
                        },
                        "json"
                    );
                },
                delay: 150
            });

            $("#edit-stage").change(function (){
                //?????????????????????
                var stage = $("#edit-stage").val();
                var possibility = json[stage];
                $("#edit-possibility").val(possibility);
            })

            //??????????????????????????????????????????????????????
            $("#updateBtn").click(function (){
                if($("#edit-transactionName").val() == ""){
                    alert("??????????????????");
                    return false;
                }

                if($("#edit-contactsName").val() == ""){
                    alert("???????????????????????????");
                    return false;
                }
                if($("#edit-expectedDate").val() == ""){
                    alert("???????????????????????????");
                    return false;
                }
                if($("#edit-stage").val() == ""){
                    alert("?????????????????????");
                    return false;
                }
                //?????????????????????????????????
                $("#editForm").submit();

            })

            $("#aname").keydown(function (event){
                if (event.keyCode==13){
                    $.ajax({
                        //????????????????????????????????????????????????????????????????????????????????????
                        url:"workbench/transaction/getActivityListByName.do",
                        data:{
                            "aname":$.trim($("#aname").val()),
                        },
                        type:"get",
                        dataType:"json",
                        success:function (data){

                            var html = "";
                            $.each(data,function (i,n){
                                html += '<tr class="table-tr">'
                                html += '<td><input type="checkbox" name="axz" value="'+n.id+'"/></td>'
                                html += '<td>'+n.name+'</td>'
                                html += '<td>'+n.startDate+'</td>'
                                html += '<td>'+n.endDate+'</td>'
                                html += '<td>'+n.owner+'</td>'
                                html += '</tr>'
                            })
                            $("#activitySearchBody").html(html);

                        }
                    })
                    //?????????????????????????????????????????????????????????????????????????????????
                    return false;
                }
            })

            $("#chooseActivityBtn").click(function (){
                var $axz = $("input[name=axz]:checked");
                if ($axz.length==0){
                    alert("????????????????????????")
                }else if ($axz.length>1){
                    alert("??????????????????????????????")
                }
                else {
                    var activityId = $($axz[0]).val();

                    $.ajax({
                        url:"workbench/activity/getById.do",
                        data: {
                            "activityId" : activityId
                        },
                        type:"post",
                        dataType:"json",
                        success:function (data){

                                $("#findMarketActivity").modal("hide");
                                $("#edit-activityId").val(data.id);
                                $("#edit-activitySrc").val(data.name);
                        }
                    })
                }
            })

            $("#cname").keydown(function (event){
                if (event.keyCode==13){
                    $.ajax({
                        //????????????????????????????????????????????????????????????????????????????????????
                        url:"workbench/transaction/getContactsListByName.do",
                        data:{
                            "cname":$.trim($("#cname").val())
                        },
                        type:"get",
                        dataType:"json",
                        success:function (data){
                            var html = "";
                            $.each(data,function (i,n){
                                html += '<tr class="table-tr">'
                                html += '<td><input type="checkbox" name="cxz" value="'+n.id+'"/></td>'
                                html += '<td>'+n.fullname+'</td>'
                                html += '<td>'+n.email+'</td>'
                                html += '<td>'+n.mphone+'</td>'
                                html += '</tr>'
                            })
                            $("#contactsSearchBody").html(html);

                        }
                    })
                    //?????????????????????????????????????????????????????????????????????????????????
                    return false;
                }
            })
            $("#chooseBtn").click(function (){
                var $cxz = $("input[name=cxz]:checked");
                if ($cxz.length==0){
                    alert("??????????????????")
                }else if ($cxz.length>1){
                    alert("???????????????????????????")
                }else {
                    var contactsId = $($cxz[0]).val();
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
        })
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

<!-- ?????????????????? -->
<div class="modal fade" id="findMarketActivity" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div style="background-color: rgba(41, 45, 62, .8);color: aqua" class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">??</span>
                </button>
                <h4 class="modal-title">??????????????????</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" id="aname" style="width: 300px;" placeholder="????????????????????????????????????????????????">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable3" class="table" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>??????</td>
                        <td>????????????</td>
                        <td>????????????</td>
                        <td>?????????</td>
                    </tr>
                    </thead>
                    <tbody id="activitySearchBody">

                    </tbody>
                </table>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
                    <button type="button" class="btn btn-primary"  id="chooseActivityBtn">??????</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ??????????????? -->
<div class="modal fade" id="findContacts" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div style="background-color: rgba(41, 45, 62, .8);color: aqua" class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">??</span>
                </button>
                <h4 class="modal-title">???????????????</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" id="cname" style="width: 300px;" placeholder="?????????????????????????????????????????????">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="contactsTable" class="table" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>??????</td>
                        <td>??????</td>
                        <td>??????</td>
                    </tr>
                    </thead>
                    <tbody id="contactsSearchBody">

                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
                <button type="button" class="btn btn-primary"  id="chooseBtn">??????</button>
            </div>
        </div>
    </div>
</div>

<div style="background-color: #222222;position:  relative; left: 30px;">
    <h3 style="color: aqua">????????????</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button type="button" class="btn btn-primary" id="updateBtn">??????</button>
        <button type="button" onclick="window.history.back();" class="btn btn-default">??????</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>


<%--??????????????????--%>
<form id="editForm" action="workbench/transaction/updateByRedirect.do" class="form-horizontal" role="form"
      style="color: aqua;background-color: #222222;position: relative; top: -30px;">
    <div class="form-group">

        <label for="edit-transactionOwner" class="col-sm-2 control-label">?????????<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" name="owner">
                <c:forEach items="${tranUserList}" var="u">
                    <option style="background-color: #333333;color:aquamarine" value="${u.id}" ${user.id eq u.id ? "selected" : ""}>${u.name}</option>
                </c:forEach>

            </select>
            <input type="hidden" name="id" value="${t.id}"/>
            <input type="hidden" name="customerId" value="${t.customerId}"/>
        </div>
        <label for="edit-amountOfMoney" class="col-sm-2 control-label">??????</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" name="money" value="${t.money}">
        </div>
    </div>

    <div class="form-group">
        <label for="edit-transactionName" class="col-sm-2 control-label">??????<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" id="edit-transactionName" class="form-control" name="name" value="${t.name}">
        </div>
        <label for="edit-expectedClosingDate" class="col-sm-2 control-label">??????????????????<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input style="background-color: #5e5e5e" type="text" class="form-control time1" readonly name="expectedDate" value="${t.expectedDate}">
        </div>
    </div>

    <div class="form-group">
        <label for="edit-contactsName" class="col-sm-2 control-label">???????????????<span style="font-size: 15px; color: red;">*</span>&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-contactsName" name="contactsName" value="${t.contactsName}">
            <input type="hidden" id="edit-contactsId" name="contactsId">
        </div>
        <label for="edit-transactionStage" class="col-sm-2 control-label">??????<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" name="stage" id="edit-stage">
                <option style="background-color: #333333;color:aquamarine"></option>
                <c:forEach items="${stageList}" var="s">
                    <option style="background-color: #333333;color:aquamarine" value="${s.value}" ${t.stage eq s.value ? "selected" : ""}>${s.text}</option>
                </c:forEach>
            </select>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-transactionType" class="col-sm-2 control-label">??????</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" name="type">
                <option style="background-color: #333333;color:aquamarine"></option>
                <c:forEach items="${transactionTypeList}" var="tran">
                    <option style="background-color: #333333;color:aquamarine"value="${tran.value}" ${t.type eq tran.value ? "selected" : ""}>${tran.text}</option>
                </c:forEach>
            </select>
        </div>
        <label for="edit-possibility" class="col-sm-2 control-label">?????????</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" name="possibility" id="edit-possibility">
        </div>
    </div>

    <div class="form-group">
        <label for="edit-clueSource" class="col-sm-2 control-label">??????</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" name="source">
                <option style="background-color: #333333;color:aquamarine"></option>
                <c:forEach items="${sourceList}" var="s">
                    <option style="background-color: #333333;color:aquamarine" value="${s.value}" ${t.source eq s.value ? "selected" : ""}>${s.text}</option>
                </c:forEach>
            </select>
        </div>

        <label for="edit-activitySrc" class="col-sm-2 control-label">???????????????&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findMarketActivity"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input style="background-color: #5e5e5e" type="text" class="form-control" readonly id="edit-activitySrc" name="activitySource" value="${t.activityName}">
            <!--??????????????????activityName?????????????????????activityId-->
            <input type="hidden" id="edit-activityId" name="activityId" value="${t.activityId}">
        </div>
    </div>

    <div class="form-group">

    </div>

    <div class="form-group">
        <label for="edit-describe" class="col-sm-2 control-label">??????</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" name="description">${t.description}</textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-contactSummary" class="col-sm-2 control-label">????????????</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" name="contactSummary">${t.contactSummary}</textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-nextContactTime" class="col-sm-2 control-label">??????????????????</label>
        <div class="col-sm-10" style="width: 300px;">
            <input style="background-color: #5e5e5e" type="text" class="form-control time" readonly name="nextContactTime" value="${t.nextContactTime}">
        </div>
    </div>

</form>
</body>
</html>