<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="http://at.alicdn.com/t/font_1786038_m62pqneyrzf.css">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <link rel="shortcut icon" href="#"/>
    <style>
        * {
            margin: 0;
            padding: 0;
        }

        html {
            height: 100%;
        }

        body {
            height: 100%;
            font-family: JetBrains Mono Medium;
            display: flex;
            align-items: center;
            justify-content: center;
            /* background-color: #0e92b3; */
            background: url('image/jianzhu.jpg') no-repeat;
            background-size: 100% 100%;
        }

        .form-wrapper {
            width: 300px;
            background-color: rgba(41, 45, 62, .8);
            color: #fff;
            border-radius: 2px;
            padding: 50px;
        }

        .form-wrapper .header {
            text-align: center;
            font-size: 35px;
            text-transform: uppercase;
            line-height: 100px;
        }

        .form-wrapper .input-wrapper input {
            background-color: rgb(41, 45, 62);
            border: 0;
            width: 100%;
            text-align: center;
            font-size: 15px;
            color: #fff;
            outline: none;
        }

        .form-wrapper .input-wrapper input::placeholder {
            text-transform: uppercase;
        }

        .form-wrapper .input-wrapper .border-wrapper {
            background-image: linear-gradient(to right, #e8198b, #0eb4dd);
            width: 100%;
            height: 50px;
            margin-bottom: 20px;
            border-radius: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .form-wrapper .input-wrapper .border-wrapper .border-item {
            height: calc(100% - 4px);
            width: calc(100% - 4px);
            border-radius: 30px;
        }

        .form-wrapper .action {
            display: flex;
            justify-content: center;
        }

        .form-wrapper .action .btn {
            width: 60%;
            text-transform: uppercase;
            border: 2px solid #0e92b3;
            text-align: center;
            line-height: 50px;
            border-radius: 30px;
            cursor: pointer;
        }

        .form-wrapper .action .btn:hover {
            background-image: linear-gradient(120deg, #84fab0 0%, #8fd3f4 100%);
        }

        .form-wrapper .icon-wrapper {
            text-align: center;
            width: 60%;
            margin: 0 auto;
            margin-top: 20px;
            border-top: 1px dashed rgb(146, 146, 146);
            padding: 20px;
        }

        .form-wrapper .icon-wrapper i {
            font-size: 20px;
            color: rgb(187, 187, 187);
            cursor: pointer;
            border: 1px solid #fff;
            padding: 5px;
            border-radius: 20px;
        }

        .form-wrapper .icon-wrapper i:hover {
            background-color: #0e92b3;
        }
    </style>
    <script>
        //启动执行函数
        $(function () {

            if (window.top != window) {
                window.top.location = window.location;
            }

            //页面加载（刷新）完毕后，将用户文本框中的内容清空
            $("#loginAct").val("");
            //页面加载完毕后，让用户的文本框自动获得焦点
            $("#loginAct").focus();

            //为了好看，不使用表单提交了
            //为登录按钮绑定事件，执行登录操作-点击按钮
            // $("#submitBtn").on("click",function (){
            // 	login();
            // })

            //为登录按钮绑定事件，执行登录操作-回车提交
            //window为当前页面直接敲回车
            $(window).on("keydown", function (event) {
                if (event.keyCode == 13) {
                    login();
                }
            })
        })

        //登录账号验证
        function login() {
            //获取账号和密码
            $("#msg").html("");
            var loginAct = $.trim($("#loginAct").val());
            var loginPwd = $.trim($("#loginPwd").val());
            if (loginAct == "" || loginPwd == "") {
                $("#msg").html("账号或密码不能为空");
                return false;
            }
            $.ajax({

                //将要请求的地址告诉后端
                url: "settings/user/login.do",
                data: {
                    //后端使用request.getParameter()获取参数
                    "loginAct": loginAct,
                    "loginPwd": loginPwd
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        window.location.href = "workbench/index.jsp";
                    } else {
                        $("#msg").html(data.msg);
                    }
                }

            })

        }

    </script>
</head>
<body>

<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
    CRM &nbsp;<span style="font-size: 12px;">2021 苏俊彬</span></div>

<div class="form-wrapper">
    <div class="header">
        login
    </div>
    <div class="input-wrapper">
        <div class="border-wrapper">
            <input type="text" id="loginAct" placeholder="username" class="border-item" autocomplete="off">
        </div>
        <div class="border-wrapper">
            <input type="password" id="loginPwd" placeholder="password" class="border-item" autocomplete="off">
        </div>
    </div>
    <div class="checkbox" style="position: relative;top: 0px; left: 38px;">
        <span id="msg" style="color:red; text-align: center"></span>

    </div>
    <div class="action">
        <div class="btn" onclick="login()">login</div>
    </div>
    <%--写成form表单，并自己写一个button类的登录键，则不会“变形”	--%>

</div>
</body>
</html>