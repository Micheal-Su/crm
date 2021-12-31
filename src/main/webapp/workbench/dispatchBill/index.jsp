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
                <span>收件人:&nbsp;</span> &nbsp;<input type="text"/>
                <span>电话：</span><input type="text"/><br/><br/>
                <span>收货地址:</span>&nbsp;
                <form>
                    <select style="color: black" id="province" onchange="changeCity()">
                        <option>---选择省份---</option>
                        <option value="0">北京市</option>
                        <option value="1">广东省</option>
                        <option value="2">福建省</option>
                        <option value="3">湖南省</option>
                        <option value="4">江西省</option>
                        <option value="5">湖北省</option>
                    </select>
                    <select style="color: black" id="city">
                        <option>---选择城市---</option>
                    </select>
                </form>
                </span><br>
                <span>详细地址：</span><input type="text" class="dizhi"/><br>
            </div>
            <br>
            <hr style="height:1px;border:none;border-top:1px dashed #0066CC;"/>
            &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <span>货物名称</span>
            &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;
            &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <span>数量</span>
            &nbsp; &nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
            <input type="text" id="baobeiming"/>
            &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
            <input type="text" id="shuliang"/>
            <br/><br/>
            <hr style="height:1px;border:none;border-top:1px dashed #0066CC;"/>
            <div id="fajianren">
                <span>发件人 :&nbsp;</span> &nbsp;<input type="text"/> &nbsp; &nbsp; &nbsp;
                <span>电话：</span><input type="text"/><br/><br/>
                <span>  日 期 ：</span>&nbsp; &nbsp;<input type="text" class="riqi time"/><br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <br><span>留言备注:</span>&nbsp<input type="text"/><br><br><br><br>
                <hr style="height:1px;border:none;border-top:1px dashed #0066CC;"/>
                <div style="color: black" id="anniu">
                    <input type="reset" value="重新填写"/>&nbsp;&nbsp;&nbsp;
                    <input type="submit" value="提交"/>&nbsp;&nbsp;
                    <input type="button" id="bt" value="打印" onclick="show()"/>
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
            provinces[0] = new Array("昌平区", "朝阳区", "房山区", "大兴区", "通州区", "延庆区",);
            provinces[1] = new Array("广州市", "潮州市", "汕头市", "河源市", "佛山市", "惠州市", "江门市", "茂名市", "湛江市", "揭阳市", "韶关市");
            provinces[2] = new Array("福州市", "南平市", "莆田市", "厦门市", "漳州市", "龙岩市", "三明市", "宁德市",);
            provinces[3] = new Array("长沙市", "衡阳市", "怀化市", "湘潭市", "张家界市", "益阳市", "邵阳市", "永州市",);
            provinces[4] = new Array("南昌市", "九江市", "赣州市", "上饶市", "鹰潭市", "吉安市", "景德镇市",);
            provinces[5] = new Array("武汉市", "荆州市", "十堰市", "天门市", "仙桃市", "宜昌市", "孝感市",);
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
