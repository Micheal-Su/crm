<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
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
</head>
<style>
    * {
        margin: 0px;
        padding: 0px;
    }

    #zhu {
        border: 1px solid #CCCCCC;
        margin: auto;
        width: 100%;
        height: 100%;
        background-image: url('image/daima.jpg');
        background-size: 100% 100%;
    }

    #sheji {
        border: 1px #FF0000;
        margin: 60px auto;
        width: 370px;
        height: 650px;
        /* background-image:url("image/1.webp"); */
    }

    input {
        width: 100px;
        height: auto;
        font-size: 12px;
    }

    span {
        font-size: 12px;
    }

    #fajianren {
        margin-left: 25px;
    }

    #shoujianren {
        margin-left: 25px;
        width: 300px;
    }


    #baobeiming {
        width: 150px;
        height: auto;
        position: relative;
        left: 30px;
        font-size: 12px;
        text-align: center;
    }

    #shuliang {
        width: 60px;
        font-size: 12px;
        text-align: center;
    }

    .dizhi {
        width: 250px;

    }

    .riqi {
        width: 100px;
    }

    #anniu {
        width: auto;
        float: right
    }
</style>
<body style="overflow: hidden">
<form style="color: #84fab0;">
    <div id="zhu">
        <div id="sheji">
            <div id="shoujianren">
                <span>?????????:&nbsp;</span> &nbsp;<input type="text"/>
                <span>?????????</span><input type="text"/><br/><br/>
                <span>????????????:</span>&nbsp;
                <form>
                    <select style="color: black" id="province" onchange="changeCity()">
                        <option>---????????????---</option>
                        <option value="0">?????????</option>
                        <option value="1">?????????</option>
                        <option value="2">?????????</option>
                        <option value="3">?????????</option>
                        <option value="4">?????????</option>
                        <option value="5">?????????</option>
                    </select>
                    <select style="color: black" id="city">
                        <option>---????????????---</option>
                    </select>
                </form>
                </span><br>
                <span>???????????????</span><input type="text" class="dizhi"/><br>
            </div>
            <br>
            <hr style="height:1px;border:none;border-top:1px dashed #0066CC;"/>
            &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <span>????????????</span>
            &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;
            &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <span>??????</span>
            &nbsp; &nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
            <input type="text" id="baobeiming"/>
            &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
            <input type="text" id="shuliang"/>
            <br/><br/>
            <hr style="height:1px;border:none;border-top:1px dashed #0066CC;"/>
            <div id="fajianren">
                <span>????????? :&nbsp;</span> &nbsp;<input type="text"/> &nbsp; &nbsp; &nbsp;
                <span>?????????</span><input type="text"/><br/><br/>
                <span>  ??? ??? ???</span>&nbsp; &nbsp;<input type="text" class="riqi time"/><br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <br><span>????????????:</span>&nbsp<input type="text"/><br><br><br><br>
                <hr style="height:1px;border:none;border-top:1px dashed #0066CC;"/>
                <div style="color: black" id="anniu">
                    <input type="reset" value="????????????"/>&nbsp;&nbsp;&nbsp;
                    <input type="submit" value="??????"/>&nbsp;&nbsp;
                    <input type="button" id="bt" value="??????" onclick="show()"/>
                </div>
            </div>
        </div>
    </div>
    <script language="javascript">
        function show() {
            window.print();
        }
    </script>
    <script>
        function changeCity() {
            var provinces = new Array(3);
            provinces[0] = new Array("?????????", "?????????", "?????????", "?????????", "?????????", "?????????",);
            provinces[1] = new Array("?????????", "?????????", "?????????", "?????????", "?????????", "?????????", "?????????", "?????????", "?????????", "?????????", "?????????");
            provinces[2] = new Array("?????????", "?????????", "?????????", "?????????", "?????????", "?????????", "?????????", "?????????",);
            provinces[3] = new Array("?????????", "?????????", "?????????", "?????????", "????????????", "?????????", "?????????", "?????????",);
            provinces[4] = new Array("?????????", "?????????", "?????????", "?????????", "?????????", "?????????", "????????????",);
            provinces[5] = new Array("?????????", "?????????", "?????????", "?????????", "?????????", "?????????", "?????????",);
            var choiceProvince = document.getElementById('province').value;
            var selectEleNode = document.getElementById('city');
            selectEleNode.length = 0;
            for (var i = 0; i < provinces.length; i++) {
                if (choiceProvince == i) {
                    for (var j = 0; j < provinces[i].length; j++) {
                        var textNode = document.createTextNode(provinces[i][j]);
                        var optionEleNode = document.createElement("option");
                        optionEleNode.appendChild(textNode);
                        selectEleNode.appendChild(optionEleNode);
                    }
                }
            }
        }
    </script>
</body>
</html>
