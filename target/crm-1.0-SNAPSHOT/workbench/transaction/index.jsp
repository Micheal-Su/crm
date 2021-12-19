<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
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

        $(function () {

            pageList(1,3);

            $("#searchBtn").click(function (){
                /*
                    点击查询按钮的时候，我们应该将搜索框中的信息保存起来，保存到隐藏域中，接着会pageList刷新，再次将hidden数据搬到search中
                    之后点击下一页时再次利用search中的内容
                */
                $("#hidden-owner") .val($.trim($("#search-owner").val()));
                $("#hidden-name").val($.trim($("#search-name").val()));
                $("#hidden-customerName").val($.trim($("#search-customerName").val()));
                $("#hidden-stage").val($.trim($("#search-stage").val()));
                $("#hidden-type").val($.trim($("#search-type").val()));
                $("#hidden-source").val($.trim($("#search-source").val()));
                $("#hidden-contactsName").val($.trim($("#search-contactsName").val()));

                pageList(1,$("#tranPage").bs_pagination('getOption', 'rowsPerPage'));
            })
            $("#editBtn").click(function (){

                var $xz = $("input[name=xz]:checked");
                if ($xz.length==0){
                    alert("请选择需要修改的记录")
                }else if ($xz.length>1){
                    alert("对不起，一次只能同时修改一个记录，请重新选择")
                }else if ($xz.length==1){
                    var id = $xz.val();
                    window.location.href="workbench/transaction/edit2.do?id="+id;
                //    取得tran的detail

                }
            })
            $("#qx").on("click",function (){
                $("input[name=xz]").prop("checked",this.checked);
            })

            $("#tranBody").on("click",$("input[name=xz]"),function (){
                $("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
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
                            url:"workbench/transaction/delete.do",
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

        function pageList(pageNo,pageSize) {
            //每次刷新列表的时候将全选复选框的√干掉
            $("#qx").prop("checked", false);
            //查询前，将隐藏域中保存的信息取出来，重新赋予到搜索框中
            $("#search-owner").val($.trim($("#hidden-owner").val()));
            $("#search-name").val($.trim($("#hidden-name").val()));
            $("#search-customerName").val($.trim($("#hidden-customerName").val()));
            $("#search-stage").val($.trim($("#hidden-stage").val()));
            $("#search-type").val($.trim($("#hidden-type").val()));
            $("#search-source").val($.trim($("#hidden-source").val()));
            $("#search-contactsName").val($.trim($("#hidden-contactsName").val()));
            $.ajax({
                url: "workbench/transaction/pageList.do",
                data: {
                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    "owner": $.trim($("#search-owner").val()),
                    "name": $.trim($("#search-name").val()),
                    "customerName": $.trim($("#search-customerName").val()),
                    "stage": $.trim($("#search-stage").val()),
                    "type": $.trim($("#search-type").val()),
                    "source": $.trim($("#search-source").val()),
                    "contactsName": $.trim($("#search-contactsName").val()),

                },
                type: "get",
                dataType: "json",
                success: function (data) {
                    var html = "";
                    $.each(data.dataList, function (i,n) {
                        html += '<tr class="active">';
                        html += '<td><input type="checkbox" name="xz" value="' + n.id + '"/></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/detail.do?id=' + n.id + '\';">' + n.name + '</a></td>';
                        html += '<td>' + n.owner + '</td>';
                        html += '<td>' + n.customerName + '</td>';
                        html += '<td>' + n.stage + '</td>';
                        html += '<td>' + n.type + '</td>';
                        html += '<td>' + n.source + '</td>';
                        html += '<td>' + n.contactsName + '</td>';
                        html += '</tr>';

                    })
                    $("#tranBody").html(html);

                    //计算总页数
                    var totalPages =
                        Math.ceil(data.total / pageSize);

                    //数据添加完毕后，结合分页插件，对前端显示分页信息
                    $("#tranPage").bs_pagination({
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

                        onChangePage: function (event, data) {
                            pageList(data.currentPage, data.rowsPerPage);
                        }
                    });

                }
            })
        }

    </script>
</head>
<body>
<input type="hidden" id="hidden-owner"/>
<input type="hidden" id="hidden-name"/>
<input type="hidden" id="hidden-customerName"/>
<input type="hidden" id="hidden-stage"/>
<input type="hidden" id="hidden-type"/>
<input type="hidden" id="hidden-source"/>
<input type="hidden" id="hidden-contactsName"/>
<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>交易列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">客户名称</div>
                        <input class="form-control" type="text" id="search-customerName">
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">阶段</div>
                        <select class="form-control" id="search-stage">
                            <option></option>
                            <c:forEach items="${stageList}" var="s">
                                <option value="${s.value}">${s.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">类型</div>
                        <select class="form-control" id="search-type">
                            <option></option>
                            <option>已有业务</option>
                            <option>新业务</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">来源</div>
                        <select class="form-control" id="search-source">
                            <option></option>
                            <c:forEach items="${sourceList}" var="s">
                                <option value="${s.value}">${s.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">联系人名称</div>
                        <input class="form-control" type="text" id="search-contactsName">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary"
                        onclick="window.location.href='workbench/transaction/add.do';"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>
        </div>
        <div style="position: relative;top: 25px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx" /></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>客户名称</td>
                    <td>交易阶段</td>
                    <td>类型</td>
                    <td>线索来源</td>
                    <td>联系人名称</td>
                </tr>
                </thead>
                <tbody id="tranBody">

                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">
            <div id="tranPage"></div>

        </div>

    </div>

</div>
</body>
</html>