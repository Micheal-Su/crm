<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
	<meta charset="UTF-8">
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript">

		//页面加载完毕
		$(function(){

			//导航中所有文本颜色为白色
			$(".liClass > a").css("color" , "aqua");

			//默认选中导航菜单中的第一个菜单项
			$(".liClass:first").addClass("active");

			//第一个菜单项的文字变成黑色
			$(".liClass:first > a").css("color" , "black");

			//给所有的菜单项注册鼠标单击事件
			$(".liClass").click(function(){
				//移除所有菜单项的激活状态
				$(".liClass").removeClass("active");
				//导航中所有文本颜色为黑色
				$(".liClass > a").css("color" , "aqua");
				//当前项目被选中
				$(this).addClass("active");
				//当前项目颜色变成黑色
				$(this).children("a").css("color","black");
			});

			window.open("workbench/home/index.html","workareaFrame");

		});

	</script>

	<style>
		.nav nav-pills nav-stacked .liClass:hover{
			background-color: #5e5e5e;

		}
	</style>

</head>
<body>

<!-- 我的资料 -->
<div style="color: #a6e1ec" class="modal fade" id="myInformation" role="dialog">
	<div class="modal-dialog" role="document" style="width: 30%;">
		<div style="background-color: #333333" class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">我的资料</h4>
			</div>
			<div class="modal-body">
				<div style="position: relative; left: 40px;">
					姓名：<b>${user.name}</b><br><br>
					登录帐号：<b>${user.loginAct}</b><br><br>
					部门编号：<b>${user.deptno}</b><br><br>
					邮箱：<b>${user.email}</b><br><br>
					失效时间：<b>${user.expireTime}</b><br><br>
					允许访问IP：<b>${user.allowIps}</b>
				</div>
			</div>
			<div class="modal-footer">
				<button style="background-color: #333333;color: #a6e1ec" type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
			</div>
		</div>
	</div>
</div>

<!-- 修改密码的模态窗口 -->
<div class="modal fade" id="editPwdModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 70%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">修改密码</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form">
					<div class="form-group">
						<label for="oldPwd" class="col-sm-2 control-label">原密码</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="oldPwd" style="width: 200%;">
						</div>
					</div>

					<div class="form-group">
						<label for="newPwd" class="col-sm-2 control-label">新密码</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="newPwd" style="width: 200%;">
						</div>
					</div>

					<div class="form-group">
						<label for="confirmPwd" class="col-sm-2 control-label">确认密码</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="confirmPwd" style="width: 200%;">
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
				<button type="button" class="btn btn-primary" data-dismiss="modal" onclick="window.location.href='login.jsp';">更新</button>
			</div>
		</div>
	</div>
</div>

<!-- 退出系统的模态窗口 -->
<div class="modal fade" id="exitModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 30%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">离开</h4>
			</div>
			<div class="modal-body">
				<p>您确定要退出系统吗？</p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
				<button type="button" class="btn btn-primary" data-dismiss="modal" onclick="window.location.href='login.jsp';">确定</button>
			</div>
		</div>
	</div>
</div>

<!-- 顶部 -->
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
	<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">2021 苏俊彬</span></div>
	<div style="position: absolute; top: 15px; right: 30px;">
		<ul >
			<li class="dropdown user-dropdown">
				<a href="javascript:void(0)" style="text-decoration: none; color: white;" class="dropdown-toggle" data-toggle="dropdown">
					<span class="glyphicon glyphicon-user"></span> ${user.name} <span class="caret"></span>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				</a>
				<ul class="dropdown-menu">
					<li><a href="settings/index.html"><span class="glyphicon glyphicon-wrench"></span> 系统设置</a></li>
					<li><a href="javascript:void(0)" data-toggle="modal" data-target="#myInformation"><span class="glyphicon glyphicon-file"></span> 我的资料</a></li>
					<li><a href="javascript:void(0)" data-toggle="modal" data-target="#editPwdModal"><span class="glyphicon glyphicon-edit"></span> 修改密码</a></li>
					<li><a href="javascript:void(0);" data-toggle="modal" data-target="#exitModal"><span class="glyphicon glyphicon-off"></span> 退出</a></li>
				</ul>
			</li>
		</ul>
	</div>
</div>

<!-- 中间 -->
<div id="center" style="position: absolute;top: 50px; bottom: 30px; left: 0px; right: 0px;">

	<!-- 导航 -->
	<div id="navigation" style="background-color: #222222; left: 0px; width: 18%; position: relative; height: 100%; overflow:auto;">
		<ul id="no1" class="nav nav-pills nav-stacked">
			<li style="font-size: 20px;" class="liClass"><a href="workbench/home/index.html" target="workareaFrame"><span class="glyphicon glyphicon-home"></span> 工作台</a></li>
			<li style="font-size: 20px;" class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-tag"></span> 动态</a></li>
			<li style="font-size: 20px;" class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-time"></span> 审批</a></li>
			<li style="font-size: 20px;" class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-user"></span> 客户公海</a></li>
			<li style="font-size: 20px;" class="liClass"><a href="workbench/activity/index.jsp" target="workareaFrame"><span class="glyphicon glyphicon-play-circle"></span> 市场活动</a></li>
			<li style="font-size: 20px;" class="liClass"><a href="workbench/clue/index.jsp" target="workareaFrame"><span class="glyphicon glyphicon-search"></span> 线索（潜在客户）</a></li>
			<li style="font-size: 20px;" class="liClass"><a href="workbench/customer/index.jsp" target="workareaFrame"><span class="glyphicon glyphicon-user"></span> 客户</a></li>
			<li style="font-size: 20px;" class="liClass"><a href="workbench/contacts/index.jsp" target="workareaFrame"><span class="glyphicon glyphicon-earphone"></span> 联系人</a></li>
			<li style="font-size: 20px;" class="liClass"><a href="workbench/transaction/index.jsp" target="workareaFrame"><span class="glyphicon glyphicon-usd"></span> 交易（商机）</a></li>
			<li style="font-size: 20px;" class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-phone-alt"></span> 售后回访</a></li>
			<li style="font-size: 20px;" class="liClass">
				<a href="#no2" class="collapsed" data-toggle="collapse"><span class="glyphicon glyphicon-stats"></span> 统计图表</a>
				<ul id="no2" class="nav nav-pills nav-stacked collapse">
					<li style="font-size: 17px; background-color: #222222" class="liClass"><a href="javascript:void(0);" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> 市场活动统计图表</a></li>
					<li style="font-size: 17px; background-color: #222222" class="liClass"><a href="javascript:void(0);" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> 线索统计图表</a></li>
					<li style="font-size: 17px; background-color: #222222" class="liClass"><a href="javascript:void(0);" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> 客户和联系人统计图表</a></li>
					<li style="font-size: 17px; background-color: #222222" class="liClass"><a href="javascript:void(0);" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> 交易统计图表</a></li>
				</ul>
			</li>
			<li style="font-size: 20px;" class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-file"></span> 报表</a></li>
			<li style="font-size: 20px;" class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-shopping-cart"></span> 销售订单</a></li>
			<li style="font-size: 20px;" class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-send"></span> 发货单</a></li>
			<li style="font-size: 20px;" class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-earphone"></span> 跟进</a></li>
			<li style="font-size: 20px;" class="liClass"><a href="workbench/product/index.jsp" target="workareaFrame"><span class="glyphicon glyphicon-leaf"></span> 产品</a></li>
			<li style="font-size: 20px;" class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-usd"></span> 报价</a></li>
		</ul>

		<!-- 分割线 -->
		<div id="divider1" style="position: absolute; top : 0px; right: 0px; width: 0px; height: 100% ; background-color: #B3B3B3;"></div>
	</div>
	<!-- 工作区 -->
	<div id="workarea" style="position: absolute; top : 0px; left: 18%; width: 82%; height: 100%;">
		<iframe style="border-width: 0px; width: 100%; height: 100%;" name="workareaFrame"></iframe>
	</div>
</div>

<div id="divider2" style="height: 1px; width: 100%; position: absolute;bottom: 30px; background-color: #B3B3B3;"></div>

<!-- 底部 -->
<div id="down" style="height: 30px; width: 100%; position: absolute;bottom: 0px;"></div>

</body>
</html>