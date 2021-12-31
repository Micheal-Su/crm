<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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

		<%--	提供possibility  --%>
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

		$(function (){
			$(".time1").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});
			$(".time2").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "top-left"
			});
			$("#create-customerName").typeahead({
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

			$("#create-stage").change(function (){
				//取得选中的阶段
				var stage = $("#create-stage").val();
				var possibility = json[stage];
				$("#create-possibility").val(possibility);
			})

			//为保存按钮绑定事件，执行交易添加操作
			$("#saveBtn").click(function (){
				//发出传统请求，提交表单
				if($("#create-transactionName").val() == ""){
					alert("名称不能为空");
					return false;
				}
				if($("#create-customerName").val() == ""){
					alert("客户名称不能为空");
					return false;
				}
				if($("#create-contactsName").val() == ""){
					alert("联系人名称不能为空");
					return false;
				}
				if($("#create-expectedDate").val() == ""){
					alert("请选择预计成交日期");
					return false;
				}
				if($("#create-stage").val() == ""){
					alert("请选择交易阶段");
					return false;
				}
				$("#tranForm").submit();

			})
			$("#aname").keydown(function (event){
				if (event.keyCode==13){
					$.ajax({
						//线索本身已经存在的关联活动就不再查询出来了，不可重复关联
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
					//展现完列表后，禁用模态窗口默认的回车后刷新整个窗口行为
					return false;
				}
			})

			$("#chooseActivityBtn").click(function (){
				var $axz = $("input[name=axz]:checked");
				if ($axz.length==0){
					alert("请选择市场活动源")
				}else if ($axz.length>1){
					alert("只能选择一个市场活动")
				}
				else {
					var activityId = $($axz[0]).val();
					$.ajax({
						url:"workbench/activity/getById.do",
						data: {
							"activityId":activityId
						},
						type:"post",
						dataType:"json",
						success:function (data){


							$("#findMarketActivity").modal("hide");
							$("#create-activityId").val(data.id);
							$("#create-activitySrc").val(data.name);

						}
					})
				}
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
					//展现完列表后，禁用模态窗口默认的回车后刷新整个窗口行为
					return false;
				}
			})
			$("#chooseBtn").click(function (){
				var $cxz = $("input[name=cxz]:checked");
				if ($cxz.length==0){
					alert("请选择联系人")
				}else if ($cxz.length>1){
					alert("只能选择一个联系人")
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
						$("#create-contactsId").val(data.id);
						$("#create-contactsName").val(data.fullname);

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

<!-- 查找市场活动 -->
<div class="modal fade" id="findMarketActivity" role="dialog">
	<div class="modal-dialog" role="document" style="width: 80%;">
		<div style="background-color: rgba(41, 45, 62, .8);color: aqua" class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">查找市场活动</h4>
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
				<table id="activityTable3" class="table" style="width: 900px; position: relative;top: 10px;">
					<thead>
					<tr style="color: #B3B3B3;">
						<td></td>
						<td>名称</td>
						<td>开始日期</td>
						<td>结束日期</td>
						<td>所有者</td>
					</tr>
					</thead>
					<tbody id="activitySearchBody">

					</tbody>
				</table>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary"  id="chooseActivityBtn">选中</button>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog">
	<div class="modal-dialog" role="document" style="width: 80%;">
		<div style="background-color: rgba(41, 45, 62, .8);color: aqua" class="modal-content">
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
				<table id="contactsTable" class="table" style="width: 900px; position: relative;top: 10px;">
					<thead>
					<tr style="color: #B3B3B3;">
						<td></td>
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

<div style="background-color: #222222;position:  relative; left: 30px;">
	<h3 style="color: aqua">创建交易</h3>
	<div style="position: relative; top: -40px; left: 70%;">
		<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
		<button type="button" class="btn btn-default" onclick="window.history.back()">取消</button>
	</div>
	<hr style="position: relative; top: -40px;">
</div>
<form action="workbench/transaction/save.do" id="tranForm" method="post" class="form-horizontal" role="form"  style="color: aqua;background-color: #222222;position: relative; top: -30px;">
	<div class="form-group">
		<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<select class="form-control" id="create-transactionOwner" name="create-owner">
				<c:forEach items="${uList}" var="u">
					<option style="background-color: #333333;color:aquamarine" value="${u.id}" ${user.id eq u.id ? "selected" : ""}>${u.name}</option>
				</c:forEach>
			</select>
		</div>
		<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control" id="create-amountOfMoney" name="create-money">
		</div>
	</div>

	<div class="form-group">
		<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control" id="create-transactionName" name="create-name">
		</div>
		<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<input style="background-color: #5e5e5e" type="text" class="form-control time1" readonly id="create-expectedDate" name="create-expectedDate">
		</div>
	</div>

	<div class="form-group">
		<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control" id="create-customerName" name="create-customerName"
				   placeholder="支持自动补全，输入客户不存在则新建">
		</div>

		<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<select class="form-control" id="create-stage" name="create-stage">
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
			<select class="form-control" id="create-transactionType" name="create-type">
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
			<select class="form-control" id="create-clueSource" name="create-source">
				<option></option>
				<c:forEach items="${sourceList}" var="s">
					<option style="background-color: #333333;color:aquamarine" value="${s.value}">${s.text}</option>
				</c:forEach>
			</select>
		</div>
		<label for="create-activitySrc" class="col-sm-2 control-label" >市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findMarketActivity"><span class="glyphicon glyphicon-search"></span></a></label>
		<div class="col-sm-10" style="width: 300px;">
			<input style="background-color: #5e5e5e" type="text" class="form-control" readonly name="create-activitySrc" id="create-activitySrc">
			<input type="hidden" id="create-activityId" name="create-activityId">
		</div>
	</div>

	<div class="form-group">
		<label for="create-contactsName" class="col-sm-2 control-label">联系人名称<span style="font-size: 15px; color: red;">*</span>&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control" name="create-contactsName" id="create-contactsName">
			<input type="hidden" id="create-contactsId" name="create-contactsId">
		</div>
	</div>

	<div class="form-group">
		<label for="create-describe" class="col-sm-2 control-label">描述</label>
		<div class="col-sm-10" style="width: 70%;">
			<textarea class="form-control" rows="3" id="create-describe" name="create-description"></textarea>
		</div>
	</div>

	<div class="form-group">
		<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
		<div class="col-sm-10" style="width: 70%;">
			<textarea class="form-control" rows="3" id="create-contactSummary"name="contactSummary"></textarea>
		</div>
	</div>

	<div class="form-group">
		<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
		<div class="col-sm-10" style="width: 300px;">
			<input style="background-color: #5e5e5e" type="text" class="form-control time2" readonly id="create-nextContactTime" name="create-nextContactTime">
		</div>
	</div>

</form>
</body>
</html>