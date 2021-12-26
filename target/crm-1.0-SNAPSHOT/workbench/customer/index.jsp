<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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

	<script type="text/javascript">

		$(function(){
			$(".time").datetimepicker({
				minView: "month",
				language: 'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "top-left"
			});

			$("#addBtn").click(function (){

				$.ajax({
					url:"workbench/customer/getUserList.do",
					type:"get",
					dataType:"json",
					success:function (data){

						var html;
						$.each(data,function (i,n){
							html+="<option style='background-color: #333333;color: aquamarine' value='"+n.id+"'>"+n.name+"</option>";
						})

						$("#create-owner").html(html);
						//将当前登录的用户，设置为下拉框的默认选项
						//取得当前登录用户的id（利用el表达式取session中的值，注意要套用在字符串中，也就是加在“”中）
						var id = "${user.id}";
						$("#create-owner").val(id);

						//当所有者下拉框处理完毕后，展现模态窗口
						$("#createCustomerModal").modal("show");

					}
				})
			})

			$("#saveBtn").click(function(){
				if($("#create-name").val() == ""){
					alert("名称不能为空");
					return false;
				}

				$.ajax({
					url: "workbench/customer/save.do",
					data:{
						"owner":$.trim($("#create-owner").val()),
						"name":$.trim($("#create-name").val()),
						"phone":$.trim($("#create-phone").val()),
						"website":$.trim($("#create-website").val()),
						"contactSummary":$.trim($("#create-contactSummary").val()),
						"nextContactTime":$.trim($("#create-nextContactTime").val()),
						"address":$.trim($("#create-address").val()),
						"description":$.trim($("#create-description").val())
					},
					type: "post",
					dataType: "json",
					success:function (data){

						if (data.success){
							alert("添加成功");
							pageList(1,$("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
							//不在模态中保存上次刚输入的交易信息
							$("#customerAddForm")[0].reset();
							$("#createCustomerModal").modal("hide");

						}else{
							alert("添加客户失败");
						}
					}
				})
			})

			pageList(1,4);

			$("#searchBtn").click(function (){
				$("#hidden-website").val($.trim($("#search-website").val()));
				$("#hidden-phone").val($.trim($("#search-phone").val()));
				$("#hidden-owner").val($.trim($("#search-owner").val()));
				$("#hidden-name").val($.trim($("#search-name").val()));

				pageList(1,$("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
			})
			//定制字段
			$("#definedColumns > li").click(function(e) {
				//防止下拉菜单消失
				e.stopPropagation();
			})

			$("#qx").on("click",function (){
				$("input[name=xz]").prop("checked",this.checked);
			})

			$("#customerBody").on("click",$("input[name=xz]"),function (){
				$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
			})
			$("#editBtn").click(function (){

				var $xz = $("input[name=xz]:checked");
				if ($xz.length==0){
					alert("请选择需要修改的记录")
				}else if ($xz.length>1){
					alert("对不起，一次只能同时修改一个记录，请重新选择")
				}else if ($xz.length==1){
					var id = $xz.val();
					$.ajax({
						url:"workbench/customer/getUserListAndCustomer.do",
						data:{
							"id":id
						},
						type:"get",
						dataType:"json",
						success:function (data){
							var html;
							$.each(data.customerUserList,function (i,n){
								html += "<option style='background-color: #333333;color: aquamarine' value='"+n.id+"'>"+n.name+"</option>"
							})
							$("#edit-owner").html(html);
							$("#edit-id").val(data.c.id);
							$("#edit-name").val(data.c.name);
							$("#edit-owner").val(data.c.owner);
							$("#edit-phone").val(data.c.phone);
							$("#edit-description").val(data.c.description);
							$("#edit-website").val(data.c.website);
							$("#edit-nextContactTime").val(data.c.nextContactTime);
							$("#edit-contactSummary").val(data.c.contactSummary);
							$("#edit-address").val(data.c.address);

							//所有的值都填写好之后，打开修改操作的模态窗口
							$("#editCustomerModal").modal("show");
						}
					})
				}
			})

			$("#updateBtn").click(function (){
				if($("#edit-name").val() == "") {
					alert("名称不能为空");
					return false;
				}
				$.ajax({
					url: "workbench/customer/update.do",
					data:{
						"id":$.trim($("#edit-id").val()),
						"owner":$.trim($("#edit-owner").val()),
						"name":$.trim($("#edit-name").val()),
						"phone":$.trim($("#edit-phone").val()),
						"email":$.trim($("#edit-email").val()),
						"website":$.trim($("#edit-website").val()),
						"description":$.trim($("#edit-description").val()),
						"address":$.trim($("#edit-address").val()),
						"nextContactTime":$.trim($("#edit-nextContactTime").val()),
						"contactSummary":$.trim($("#edit-contactSummary").val())
					},
					type: "post",
					dataType: "json",
					success:function (data){

						if (data.success){

							alert("修改成功")
							//关闭修改操作的模态窗口
							$("#editActivityModal").modal("hide");
							pageList($("#customerPage").bs_pagination('getOption', 'currentPage')
									,$("#customerPage").bs_pagination('getOption', 'rowsPerPage'));

						}else{
							alert("修改市场活动失败");
						}
					}
				})
			})

			$("#deleteBtn").click(function (){
				//找到复选框中所有挑√的复选框的jquery对象
				var $xz = $("input[name=xz]:checked");
				if ($xz.length==0){
					alert("请选择要删除的记录")
				}else{
					if(confirm("确定要删除所选的记录吗？")){
						var param = "";
						//将$xz中的每一个dom对象遍历出来，取其value值相当于取得了需要删除记录的id
						for (var i=0;i<$xz.length;i++){
							param += "id="+ $($xz[i]).val();
							if (i<$xz.length-1){
								param += "&";
							}
						}
						$.ajax({
							url:"workbench/customer/delete.do",
							data:param,
							type:"post",
							dataType:"json",
							success:function (data){
								if (data.success){
									pageList(1,4);
								}else {
									alert("删除客户失败");
								}
							}
						})
					}

				}
			})

		});

		//分页函数已经兼备了查询的功能
		function pageList(pageNo,pageSize){
			$("#qx").prop("checked",false);
			$("#search-name").val($.trim($("#hidden-name").val()));
			$("#search-owner").val($.trim($("#hidden-owner").val()));
			$("#search-phone").val($.trim($("#hidden-phone").val()));
			$("#search-website").val($.trim($("#hidden-website").val()));

			$.ajax({
				url:"workbench/customer/pageList.do",
				data:{
					"pageNo":pageNo,
					"pageSize":pageSize,
					"name":$.trim($("#search-name").val()),
					"owner":$.trim($("#search-owner").val()),
					"phone":$.trim($("#search-phone").val()),
					"website":$.trim($("#search-website").val())
				},
				type:"get",
				dataType:"json",
				success:function (data){
					var html = "";
					$.each(data.dataList,function (i,n){
						html += '<tr class="active">';
						html += '<td style="background-color: #5e5e5e;color: whitesmoke"><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
						html += '<td style="background-color: #5e5e5e;"><a style="color: aquamarine;text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/customer/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
						html += '<td style="background-color: #5e5e5e;color: whitesmoke">'+n.owner+'</td>';
						html += '<td style="background-color: #5e5e5e;color: whitesmoke">'+n.phone+'</td>';
						html += '<td style="background-color: #5e5e5e;color: whitesmoke">'+n.website+'</td>';
						html += '</tr>';

					})
					$("#customerBody").html(html);

					//计算总页数
					var totalPages =
							Math.ceil(data.total/pageSize);

					$("#customerPage").bs_pagination({
						currentPage: pageNo, // 页码
						rowsPerPage: pageSize, // 每页显示的记录条数
						maxRowsPerPage: 20, // 每页最多显示的记录条数
						totalPages: totalPages, // 总页数
						totalRows: data.total, // 总记录条数

						visiblePageLinks: 5, // 显示几个卡片

						showGoToPage: true,
						showRowsPerPage: true,
						showRowsInfo: true,
						showRowsDefaultInfo: true,

						onChangePage : function(event, data){
							pageList(data.currentPage , data.rowsPerPage);
						}
					})

				}
			})
		}
	</script>
</head>
<body style="background-color: #222222;">

<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-phone">
<input type="hidden" id="hidden-website">

<!-- 创建客户的模态窗口 -->
<div class="modal fade" id="createCustomerModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 85%;">
		<div style="background-color: rgba(41, 45, 62, .8);color: aqua" class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span style="color: #0af4ff" aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form" id="customerAddForm">

					<div class="form-group">
						<label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="create-owner">

							</select>
						</div>
						<label for="create-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="create-name">
						</div>
					</div>

					<div class="form-group">
						<label for="create-website" class="col-sm-2 control-label">公司网站</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="create-website">
						</div>
						<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="create-phone">
						</div>
					</div>
					<div class="form-group">
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
								<input type="text" class="form-control time" readonly id="create-nextContactTime">
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
				<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
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
					<span style="color: #0af4ff" aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">修改客户</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form">
					<input type="hidden" id="edit-id">

					<div class="form-group">
						<label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-owner">

							</select>
						</div>
						<label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-name">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-website">
						</div>
						<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-phone">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-describe" class="col-sm-2 control-label">描述</label>
						<div class="col-sm-10" style="width: 81%;">
							<textarea class="form-control" rows="3" id="edit-description"></textarea>
						</div>
					</div>

					<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

					<div style="position: relative;top: 15px;">
						<div class="form-group">
							<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
							</div>
						</div>
						<div class="form-group">
							<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" readonly id="edit-nextContactTime">
							</div>
						</div>
					</div>

					<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

					<div style="position: relative;top: 20px;">
						<div class="form-group">
							<label for="edit-address" class="col-sm-2 control-label">详细地址</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="1" id="edit-address">北京大兴大族企业湾</textarea>
							</div>
						</div>
					</div>
				</form>

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary"  data-dismiss="modal" id="updateBtn">更新</button>
			</div>
		</div>
	</div>
</div>




<div>
	<div style="color: whitesmoke;position: relative; left: 10px; top: -10px;">
		<div class="page-header">
			<h3>客户列表</h3>
		</div>
	</div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

	<div style="width: 100%; position: absolute;top: 5px; left: 10px;">


		<div class="btn-toolbar" role="toolbar" style="height: 80px;">
			<%--	查询表单  --%>
			<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

				<div class="form-group">
					<div class="input-group">
						<div style="color: whitesmoke;background-color: #222222" class="input-group-addon">名称</div>
						<input style="color: whitesmoke;background-color: #222222" class="form-control" type="text" id="search-name">
					</div>
				</div>

				<div class="form-group">
					<div class="input-group">
						<div style="color: whitesmoke;background-color: #222222" class="input-group-addon">所有者</div>
						<input style="color: whitesmoke;background-color: #222222" class="form-control" type="text" id="search-owner">
					</div>
				</div>

				<div class="form-group">
					<div class="input-group">
						<div style="color: whitesmoke;background-color: #222222" class="input-group-addon">公司座机</div>
						<input style="color: whitesmoke;background-color: #222222" class="form-control" type="text" id="search-phone">
					</div>
				</div>

				<div class="form-group">
					<div class="input-group">
						<div style="color: whitesmoke;background-color: #222222" class="input-group-addon">公司网站</div>
						<input style="color: whitesmoke;background-color: #222222" class="form-control" type="text" id="search-website">
					</div>
				</div>

				<button style="color: whitesmoke;background-color: #222222" type="button" id="searchBtn" class="btn btn-default">查询</button>

			</form>
		</div>
		<div class="btn-toolbar" role="toolbar" style="background-color: #222222; height: 50px; position: relative;top: 5px;">
			<div class="btn-group" style="position: relative; top: 18%;">
				<button style="color: aqua;background-color: #222222" type="button" class="btn btn-primary" id="addBtn"><span style="color: aqua;" class="glyphicon glyphicon-plus"></span> 创建</button>
				<button style="color: whitesmoke;background-color: #222222" type="button" class="btn btn-default" id="editBtn"><span style="color: whitesmoke" class="glyphicon glyphicon-pencil"></span> 修改</button>
				<button style="color: #ff0966;background-color: #222222" type="button" class="btn btn-danger" id="deleteBtn"><span style="color:#ff0966" class="glyphicon glyphicon-minus"></span> 删除</button>
			</div>

		</div>
		<div style="position: relative;top: 10px;">
			<table class="table table-hover">
				<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="qx"/></td>
					<td>名称</td>
					<td>所有者</td>
					<td>公司座机</td>
					<td>公司网站</td>
				</tr>
				</thead>
				<tbody id="customerBody">

				</tbody>
			</table>
		</div>



		<div style="height: 50px; position: relative;top: 30px;">
			<div id="customerPage" style="background-color: #222222;color: whitesmoke"></div>

		</div>

	</div>

</div>
</body>
</html>