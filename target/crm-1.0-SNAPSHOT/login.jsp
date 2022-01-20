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
        /*通配符，所有标签都实验这些属性（覆盖默认的）*/
        /** {*/
        /*    margin: 0; !*外边距，在border外侧添加空白*!*/
        /*    padding: 0;!*内边距* 在border内侧添加空白!*/
        /*}*/


        html {
            height: 100%;
        }

        body {
            height: 100%;
            font-family: JetBrains Mono Medium; /*字体*/
            display: flex;
            align-items: center;
            justify-content: center;
            /* background-color: #0e92b3; */
            background: url('image/jianzhu.jpg') no-repeat;

            background-size: 100% 100%;
        }

        /*自定义的一个class wrapper（包装器）*/
        .form-wrapper {
            width: 300px;
            background-color: rgba(41, 45, 62, .8); /*.8表示透明度，前三为红绿蓝三原色*/
            color: #fff;
            border-radius: 20px; /*实现圆角边框*/
            padding: 50px;
            /*float: left;*/
            left: 20%;
            top: 5%;
            position: relative;
            align-content: center;
        }

        .form-wrapper .header {
            text-align: center;
            font-size: 20px;
            text-transform: uppercase; /*转换为大写*/
            line-height: 100px;
        }

        /*输入框*/
        .form-wrapper .input-wrapper input {
            background-color: rgb(41, 45, 62);
            border: 0;
            width: 100%;
            text-align: center;
            font-size: 15px;
            color: #fff;
            outline: none;
        }

        .form-wrapper .input-wrapper input::placeholder { /*提示信息*/
            text-transform: uppercase;
        }

        /*input标签的border ，linear-gradient：渐变属性：偏向角度，起始点颜色，终止点颜色 */
        /*display: flex ---> 子元素的float、clear、vertical-align属性失效*/
        .form-wrapper .input-wrapper .border-wrapper {
            background-image: linear-gradient(to right, #e8198b, #0eb4dd);
            width: 100%;
            height: 50px;
            margin-bottom: 20px;
            border-radius: 30px;
            display: flex; /*有六个属性*/
            /*flex-direction flex-wrap flex-flow justify-content align-items align-content*/
            align-items: center;
            justify-content: center;
        }

        .form-wrapper .input-wrapper .border-wrapper .border-item {
            height: calc(100% - 4px); /*动态计算长度值*/
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
            border: 2px solid #0e92b3; /*2px 实心  颜色*/
            text-align: center;
            line-height: 50px;
            border-radius: 30px;
            cursor: pointer; /*手型光标*/
        }

        .form-wrapper .action .btn:hover {
            background-image: linear-gradient(120deg, #84fab0 0%, #8fd3f4 100%);
        }


        .float-wrapper {
            position: absolute;
            height: 100%;
            width: 50%;
            background-color: rgba(41, 45, 62, .8);
            float: left;
        }

        .father-wrapper:hover .float-wrapper {
            width: 30%;
            transition: all 3s;
        }


        .three-wrapper:hover .float-wrapper {
            width: 70%;
            transition: all 3s;
        }

        .three-wrapper:hover ~ .right-wrapper {
            width: 30%;
            transition: all 3s;
        }

        .right-wrapper:hover {
            /*background-color: #5e5e5e;*/
            width: 70%;
            transition: all 3s;
        }


        .float-wrapper:hover .ddd {
            transform: translateX(100px);
            transition: all 3s;
        }

        .footer {
            background-color: rgba(41, 45, 61, .8);
            position: absolute;
            bottom: 0px;
            height: 30px;
            width: 100%;
        }

        .footer_table {
            border-spacing: 50px 10px;
        }


    </style>
    <script type="text/javascript">
        //启动执行函数 相当于 $(document).ready(function(){});
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
            // $("#msg").html("");
            var loginAct = $.trim($("#loginAct").val());
            var loginPwd = $.trim($("#loginPwd").val());
            if (loginAct == "" || loginPwd == "") {
                $("#msg").html("账号或密码不能为空");
                return false;
            } else {
                if (loginAct.length < 6 || loginAct.length > 16) {
                    $("#msg").html("用户名长度必须为6-16个字符");
                    return false;
                } else {
                    var regExp = /^[A-Za-z0-9]+$/;
                    var ok = regExp.test(loginAct);
                    if (ok) {

                    } else {
                        $("#msg").html("用户名只能由字母和数字组成");
                        return false;
                    }
                }
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
                        $("#loginAct").val("");
                        $("#loginPwd").val("");
                        window.location.href = "workbench/index.jsp";
                    } else {
                        $("#msg").html(data.msg);
                    }
                }

            })

        }

        function showProducter() {
            $("#myInformation").modal("show");
        }

    </script>
</head>
<body>

<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
    CRM &nbsp;<span style="font-size: 12px;">2021 苏俊彬</span></div>

<div class="form-wrapper" style="position: relative;">
    <div class="header">
        LOGIN
    </div>
    <div class="input-wrapper">
        <div class="border-wrapper">
            <input type="text" id="loginAct" placeholder="username" class="border-item" autocomplete="off">
        </div>
        <div class="border-wrapper">
            <input type="password" id="loginPwd" placeholder="password" class="border-item" autocomplete="off">
        </div>
    </div>
    <div class="checkbox" style="height: 20px;text-align: center;position: relative;top: 0px;">
        <span id="msg" style="color:red;"></span>
        <%--        white-space:pre 使浏览器不忽略空白--%>
    </div>
    <div class="action">
        <div class="btn" onclick="login()">login</div>
    </div>
    <%--写成form表单，并自己写一个button类的登录键，则不会“变形”	--%>

</div>


<div style="color: #a6e1ec" class="modal fade" id="myInformation" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div style="background-color: #333333" class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">开发者信息</h4>
            </div>
            <div class="modal-body">
                <div style="position: relative; left: 40px;">
                    姓名：<b>${A001.name}</b><br><br>
                    登录帐号：<b>${A001.loginAct}</b><br><br>
                    部门编号：<b>${A001.deptno}</b><br><br>
                    邮箱：<b>${A001.email}</b><br><br>
                </div>
            </div>
            <div class="modal-footer">
                <button style="background-color: #333333;color: #a6e1ec" type="button" class="btn btn-default"
                        data-dismiss="modal">关闭
                </button>
            </div>
        </div>
    </div>
</div>

<div style="color: #a6e1ec" class="modal fade" id="video" role="dialog">
    <div class="modal-dialog" role="document" style="width: 70%;">
        <div style="background-size: 100%;background-image:url('./image/guanggaoback.jpg')" class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">I don't wanna see you anymore</h4>
            </div>
            <div class="modal-body">
                <div style="position: relative; left: 40px;">
                    <video controls="controls">
                        <source src="image/guanggao.mp4" type="video/mp4">
                    </video>
                </div>
            </div>
        </div>
    </div>
</div>


</body>
</html>