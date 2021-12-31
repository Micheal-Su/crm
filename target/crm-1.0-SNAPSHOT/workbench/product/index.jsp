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

        /*功能：鼠标悬停校徽放大。点击进入官网
                鼠标悬停文本内容变色，链接变色
                页脚点击信息弹开页面

            /*用于调整产品信息和表格的容器的大小参数*/
        #middle {
            height: 800px;
            width: 500px;
        }

        /*超链接颜色修改*/
        a:link {
            color: grey
        }

        /* 未访问的链接 */
        a:visited {
            color: black
        }

        /* 已访问的链接 */
        a:hover {
            color: darkred
        }

        /* 鼠标移动到链接上 */

        /*"交给我们!"背景悬停*/
        body {
            /*idea的尿性，可以用但是却报错*/
            background-image: url('image/jiaogeiwomen.png');
            background-repeat: no-repeat;
            background-position: 900px;
            margin-right: 100px;
            background-attachment: fixed;
        }

        /*页脚属性*/
        #foot {
            color: grey;
            font-size: 15px;
            height: 10%;
            position: absolute;
            text-align: center;
            bottom: 0;
            position: fixed;
        }

        /*版权属性设置*/
        #banquan {
            font-size: 15px;
            color: grey;
            bottom: 0;
            position: fixed;

        }

        /*校徽缩放外边框属性设置*/
        #divzoom {
            width: 80px;
            height: 80px;
            margin: 25px auto; /*校徽水平居中*/
        }

        #divzoom img {
            cursor: pointer; /*鼠标悬停放大*/
            transition: all 0.6s; /*缩放时间*/
        }

        #divzoom img:hover {
            transform: scale(1.2); /*放大比例*/
        }

    </style>
</head>

<body style="position: relative;left: 10px" bgcolor="ivory"><!---背景颜色--->
<!---校徽---->
<div id="divzoom">
    <a href="https://www.gpnu.edu.cn/" target="_blank">
        <img src="image/xiaohui.png" title="点击进入学校官网" alt="校徽">
    </a>
    <!---大标题---->
</div>
<h1 style="text-align: center;">这些产品,
    <span style="color: grey"><!---一行多色---->
		体验都称心,服务更如意
	</span>
</h1>

<hr>
<div style="width: 100%;height: 1px;color: #333333;position: relative;"></div>
<!--小标题---->
<h3><i><p>快来体验新产品吧！</p></i></h3>

<div id="middle">

    <!---带序号小段--->
    <ul>

        <li>
            <a href="https://cn.aliyun.com/" target="_blank">产品信息类1</a>
        </li>
        <li>
            <a href="https://cn.aliyun.com/" target="_blank">产品信息类1</a>
        </li>
        <li>
            <a href="https://cn.aliyun.com/" target="_blank">产品信息类1</a>
        </li>
        <li>
            <a href="https://cn.aliyun.com/" target="_blank">产品信息类1</a>
        </li>
    </ul>


    <!---表格部分---->
    <table border="1px" cellspacing="0" width="600px">
        <!----设置边框显示---->
        <tbody>
        <tr height="60px"><!---行高度---->
            <td style="background-color: orange">代理项目</td>
            <td style="background-color: orange">项目负责人</td>
            <td style="background-color: orange">项目说明</td>
            <td style="background-color: orange">联系方式</td>
        </tr>
        <tr height="60px">
            <td>JavaScript</td>
            <td>苏俊彬</td>
            <td>代码代写</td>
            <td>136**** ***** *</td>
        </tr>
        <tr height="60px">
            <td>C++</td>
            <td>黄宏基</td>
            <td>代写</td>
            <td>136**** **** *</td>
        </tr>
        <tr height="60px">
            <td>web前端</td>
            <td>姚燕龄</td>
            <td>代写</td>
            <td>136**** *** **</td>
        </tr>
        <tr height="60px">
            <td>制作ppt</td>
            <td>黄达豪</td>
            <td>代理制作</td>
            <td>136**** *****</td>

        </tr>

        </tbody>
    </table>
    <div/>
</div>
<!----版权---->
<div>
    <p id="banquan" style="text-align: center;">
        Copyright © 2021 Lamgo inc. 保留所有权利。
    </p>
</div>

<!---!"关于"弹出框设置----->
<div id="foot">
    <!----调用member方法---->
    <a href>隐私政策 |</a>
    <a href>广告 |</a>   <!---链接到广告页面---->
    <a style="color: black" href="javascript:void(0)" onclick="contact()">联系方式 |</a>
    <a style="color: black" href="javascript:void(0)" onclick="member()">产品负责人 |</a>
    <a href="https://www.gpnu.edu.cn/" target="_blank">官网信息</a> <!---另启页面---->

</div>

<!---页脚关于弹出信息框方法---->
<script type="text/javascript">
    function member() {
        alert("姓名：苏俊彬 项目：JavaScript\n" + "姓名：黄宏基 项目：C++\n" + "姓名：姚燕龄 项目：Web前端\n" + "姓名：黄达豪 项目：ppt定制");
    }

    function contact() {
        alert("姓名：黄达豪 学号：2020044743132")
    }
</script>

</body>
</html>


