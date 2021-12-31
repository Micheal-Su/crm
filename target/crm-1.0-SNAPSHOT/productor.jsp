<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="http://at.alicdn.com/t/font_1786038_m62pqneyrzf.css">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <link rel="shortcut icon" href="#"/>
    <style type="text/css">
        body, form {
            padding: 0px;
            margin: 0px;
        }

        body {
            overflow: hidden;
        }

        #divMain {
            width: 100%;
            height: 100%;
            border: 1px solid black;
            background-color: #ffffff;
            overflow: auto;
            opacity: 0.8;
        }

        #divMessage {
            background-color: white;
            border: 2px inset;
            position: absolute;
            left: 50%;
            top: 50%;
            height: 300px;
            width: 400px;
            margin: 0px;
            margin-top: -170px;
            margin-left: -200px;
            padding: 0px;
            opacity: 0.8;
        }

        #divMessage table {
            width: 100%;
            height: 100%;
            margin: 0px;
            padding: 0px;
        }

        #divMessage table td {
            padding: 2px;
        }

        a:link, a:visited {
            color: black;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
            color: green;
        }

        a:active {
            color: black;
        }

    </style>
</head>

<body style="overflow: hidden;">
<div id="divMain">
    <div style="height: 100%; background-image: url('image/schoolback.jpg') ; background-repeat: no-repeat;background-size: 100% 100%;"></div>
</div>
<div id="divMessage">
    <table cellpadding="0" cellspacing="0">
        <tr>
            <td style="padding:0px; margin:0px;">
                <div style="border:2px outset; height:100%; width:100%; padding:3px;">开发者信息</div>
            </td>
        </tr>

        <tr>
            <td height="100%"> &nbsp; &nbsp;&nbsp;&nbsp;
                <a href="javascript:void(0)" data-toggle="modal" data-target="#myInformation1">·苏俊彬 2020044743102</a>
                <br><br><br>&nbsp; &nbsp;&nbsp;&nbsp;
                <a href="javascript:void(0)" data-toggle="modal" data-target="#myInformation2">·黄宏基 2020044743105</a><br>
                <br><br>&nbsp; &nbsp;&nbsp;&nbsp;
                <a href="javascript:void(0)" data-toggle="modal" data-target="#myInformation3">·姚燕龄 2020044743107</a>
                <br><br><br>&nbsp; &nbsp;&nbsp;&nbsp;
                <a href="javascript:void(0)" data-toggle="modal" data-target="#myInformation4">·黄达豪 2020044743132</a>
            </td>
        </tr>
    </table>
</div>
<div style="color: #a6e1ec" class="modal fade" id="myInformation1" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div style="position: relative;left: 300px;background-color: #333333" class="modal-content">
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
<div style="color: #a6e1ec" class="modal fade" id="myInformation2" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div style="position: relative;left: 300px;background-color: #333333" class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">开发者信息</h4>
            </div>
            <div class="modal-body">
                <div style="position: relative; left: 40px;">
                    姓名：<b>${A002.name}</b><br><br>
                    登录帐号：<b>${A002.loginAct}</b><br><br>
                    部门编号：<b>${A002.deptno}</b><br><br>
                    邮箱：<b>${A002.email}</b><br><br>
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
<div style="color: #a6e1ec" class="modal fade" id="myInformation3" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div style="position: relative;left: 300px;background-color: #333333" class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">开发者信息</h4>
            </div>
            <div class="modal-body">
                <div style="position: relative; left: 40px;">
                    姓名：<b>${A003.name}</b><br><br>
                    登录帐号：<b>${A003.loginAct}</b><br><br>
                    部门编号：<b>${A003.deptno}</b><br><br>
                    邮箱：<b>${A003.email}</b><br><br>
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
<div style="color: #a6e1ec" class="modal fade" id="myInformation4" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div style="position: relative;left: 300px; background-color: #333333" class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">开发者信息</h4>
            </div>
            <div class="modal-body">
                <div style="position: relative; left: 40px;">
                    姓名：<b>${A004.name}</b><br><br>
                    登录帐号：<b>${A004.loginAct}</b><br><br>
                    部门编号：<b>${A004.deptno}</b><br><br>
                    邮箱：<b>${A004.email}</b><br><br>
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
</body>
</html>
