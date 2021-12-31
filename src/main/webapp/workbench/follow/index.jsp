<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <base href="<%=basePath%>">
    <title>跟进页面</title>
    <meta charset="utf-8">
    <style>
        /*导航框以下，版权以上的部分放置一个容器*/
        .allmiddle-lamgo {
            height: 700px;
            width: 1500px;
            margin-top: 30px;
        }

        /* 设置页眉的样式 */
        .top-lamgo {
            background-color: #f1f1f1;
            padding: 10px; /*页眉块之间距离*/
            text-align: center;
            box-sizing: border-box;
        }

        body {
            margin: 0;
        }


        /* 设置顶部导航栏的样式 */
        .daohang-lamgo {
            overflow: hidden; /*隐藏溢出*/
            background-color: #333;
        }

        /* 设置 daohang 链接的样式 */
        .daohang-lamgo a {
            float: left;
            display: block; /*块状盒子*/
            color: #f2f2f2;
            padding: 14px 16px;
            text-decoration: none; /*去除下划线*/
        }

        /* 改变鼠标悬停时的颜色 */
        .daohang-lamgo a:hover {
            background-color: #ddd;
            color: black;
        }

        /* 创建并排的三个非等列 */
        .column-lamgo {
            float: right;
            width: 33.33%;
            padding: 20px;
        }

        /* 清除列之后的浮动 */

        .gonggao-lamgo {
            float: right;
            width: 200px;
            height: 200px;
            text-align: center;

        }

        /*有阴影的灰色块*/
        .shadow-lamgo {
            width: 300px;
            height: 300px;
            background-color: lightgrey;
            box-shadow: 10px 10px 5px #888888;
            box-shadow: 10px 10px 5px #888888;
            float: right;

        }

        /*版权属性设置*/
        #banquan-lamgo {
            font-size: 15px;
            color: grey;
            bottom: 0;
            position: fixed;
            text-align: center;

        }

    </style>
</head>
<body bgcolor="#f6efe9">
<div class="top" style="text-align: center;">
    <h1>客户跟进</h1>
</div>

<!---导航框---->
<div class="daohang-lamgo">
    <a href="workbench/activity/index.jsp">市场活动</a>
    <a href>售后回访</a>
    <a href>对接负人</a>
    <a href>统计图表</a>
</div>

<!---公告栏--->
<div class="allmiddle-lamgo">

    <div class="shadow-lamgo">
        <ul>
            <h2>公告栏</h2>
            <li><p style="color: black"><b>跟进后续售后工作</b></p></li>
            <li><p style="color: black"><b>记得复习JAVA,计组，离散数学</b></p></li>
            <li><p style="color: black"><b>写好课程设计实验报告</b></p></li>
            <li><p style="color: black"><b>做好答辩准备，好好复习</b></p></li>
        </ul>
    </div>

    <!----文本栏---->
    <div class="column-lamgo">
        <h2>市场活动</h2>
        <p>
            此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入</p>
    </div>

    <div class="column-lamgo">
        <h2>对接责人</h2>
        <p>
        <ul>
            <li style="font-size: 20px"> C++ ——黄宏基</li>
            <li style="font-size: 20px">ppt定制 ——黄达豪</li>
            <li style="font-size: 20px">web前端 ——姚燕龄</li>
            <li style="font-size: 20px">JavaScript ——苏俊彬</li>
        </ul>
        </p>
    </div>
    <div class="column-lamgo">
        <h2>售后回访</h2>
        <p>
            此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入</p>
    </div>

    <div class="column-lamgo">
        <h2>数据统计</h2>
        <p>
            此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入此处插入文本插入</p>
    </div>


    <!----版权---->
    <div>
        <p id="banquan-lamgo">
            Copyright © 2021 Lamgo inc. 保留所有权利。| &nbsp;&nbsp;预祝老师同学们新年快乐 &#128516;
        </p>

    </div>
</div>
</body>
</html>
