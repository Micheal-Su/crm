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
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

    <script type="text/javascript">

        $(function () {

            $(".time1").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            $(".time2").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "top-left"
            });

            $("#create-customerName").typeahead({
                source: function (query, process) {
                    $.post(
                        "workbench/contacts/getCustomerName.do",
                        { "name" : query },
                        function (data) {
                            process(data);
                        },
                        "json"
                    );
                },
                delay: 150
            });
            $("#edit-customerName").typeahead({
                source: function (query, process) {
                    $.post(
                        "workbench/contacts/getCustomerName.do",
                        { "name" : query },
                        function (data) {
                            //alert(data);
                            process(data);
                        },
                        "json"
                    );
                },
                delay: 150
            });

            $("#addBtn").click(function () {

                $.ajax({
                    url: "workbench/contacts/getUserList.do",
                    type: "get",
                    dataType: "json",
                    success: function (data) {
                        var html;
                        $.each(data, function (i, n) {
                            html += "<option value='" + n.id + "'>" + n.name + "</option>";
                        })
                        $("#create-owner").html(html);
                        var id = "${user.id}";
                        $("#create-owner").val(id);
                        $("#createContactsModal").modal("show");

                    }
                })
            })

            //为保存按钮添加事件，执行联系人添加操作
            $("#saveBtn").click(function () {
                if ($("#create-fullname").val() == "") {
                    alert("姓名不能为空");
                    return false;
                }
                if ($("#create-customerName").val() == "") {
                    alert("客户名称不能为空");
                    return false;
                }
                $.ajax({
                    url: "workbench/contacts/save.do",
                    data: {
                        "id": $.trim($("#create-id").val()),
                        "owner": $.trim($("#create-owner").val()),
                        "source": $.trim($("#create-source").val()),
                        "customerName": $.trim($("#create-customerName").val()),
                        "fullname": $.trim($("#create-fullname").val()),
                        "appellation": $.trim($("#create-appellation").val()),
                        "email": $.trim($("#create-email").val()),
                        "mphone": $.trim($("#create-mphone").val()),
                        "job": $.trim($("#create-job").val()),
                        "birth": $.trim($("#create-birth").val()),
                        "description": $.trim($("#create-description").val()),
                        "contactSummary": $.trim($("#create-contactSummary").val()),
                        "nextContactTime": $.trim($("#create-nextContactTime").val()),
                        "address": $.trim($("#create-address").val())
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            alert("联系人添加成功")
                            pageList(1, $("#contactsPage").bs_pagination('getOption', 'rowsPerPage'));
                            $("#contactsAddForm")[0].reset();
                            $("#createContactsModal").modal("hide");
                        } else {
                            alert("联系人添加失败")
                        }
                    }
                })
            })
            pageList(1, 4);

            $("#searchBtn").click(function () {
                /*
                    点击查询按钮的时候，我们应该将搜索框中的信息保存起来，保存到隐藏域中，接着会pageList刷新，再次将hidden数据搬到search中
                    之后点击下一页时再次利用search中的内容
                */
                $("#hidden-owner").val($.trim($("#search-owner").val()));
                $("#hidden-customerName").val($.trim($("#search-customerName").val()));
                $("#hidden-fullname").val($.trim($("#search-fullname").val()));
                $("#hidden-source").val($.trim($("#search-source").val()));
                $("#hidden-birth").val($.trim($("#search-birth").val()));

                pageList(1, $("#contactsPage").bs_pagination('getOption', 'rowsPerPage'));
            })
            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });
            $("#qx").on("click", function () {
                $("input[name=xz]").prop("checked", this.checked);
            })
            $("#contactsBody").on("click", $("input[name=xz]"), function () {
                $("#qx").prop("checked", $("input[name=xz]").length == $("input[name=xz]:checked").length);
            })

            $("#editBtn").click(function () {

                var $xz = $("input[name=xz]:checked");
                if ($xz.length == 0) {
                    alert("请选择需要修改的记录")
                } else if ($xz.length > 1) {
                    alert("对不起，一次只能同时修改一个记录，请重新选择")
                } else if ($xz.length == 1) {
                    var id = $xz.val();
                    $.ajax({
                        url: "workbench/contacts/getUserListAndContacts.do",
                        data: {
                            "id": id
                        },
                        type: "get",
                        dataType: "json",
                        success: function (data) {
                            var html;
                            $.each(data.contactsUserList, function (i, n) {
                                html += "<option value='" + n.id + "'>" + n.name + "</option>"
                            })
                            $("#edit-owner").html(html);
                            $("#edit-id").val(data.c.id);
                            $("#edit-owner").val(data.c.owner);
                            $("#edit-source").val(data.c.source);
                            $("#edit-customerName").val(data.c.customerName);
                            $("#edit-fullname").val(data.c.fullname);
                            $("#edit-appellation").val(data.c.appellation);
                            $("#edit-email").val(data.c.email);
                            $("#edit-mphone").val(data.c.mphone);
                            $("#edit-job").val(data.c.job);
                            $("#edit-birth").val(data.c.birth);
                            $("#edit-description").val(data.c.description);
                            $("#edit-contactSummary").val(data.c.contactSummary);
                            $("#edit-nextContactTime").val(data.c.nextContactTime);
                            $("#edit-address").val(data.c.address);
                            //所有的值都填写好之后，打开修改操作的模态窗口
                            $("#editContactsModal").modal("show");
                        }
                    })
                }
            })

            $("#updateBtn").click(function () {
                if ($("#edit-fullname").val() == "") {
                    alert("姓名不能为空");
                    return false;
                }
                if ($("#edit-customerName").val() == "") {
                    alert("客户名称不能为空");
                    return false;
                }
                $.ajax({
                    url: "workbench/contacts/update.do",
                    data: {
                        "id": $.trim($("#edit-id").val()),
                        "owner": $.trim($("#edit-owner").val()),
                        "source": $.trim($("#edit-source").val()),
                        "job": $.trim($("#edit-job").val()),
                        "customerName": $.trim($("#edit-customerName").val()),
                        "fullname": $.trim($("#edit-fullname").val()),
                        "appellation": $.trim($("#edit-appellation").val()),
                        "email": $.trim($("#edit-email").val()),
                        "mphone": $.trim($("#edit-mphone").val()),
                        "birth": $.trim($("#edit-birth").val()),
                        "description": $.trim($("#edit-description").val()),
                        "address": $.trim($("#edit-address").val()),
                        "nextContactTime": $.trim($("#edit-nextContactTime").val()),
                        "contactSummary": $.trim($("#edit-contactSummary").val())
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            alert("修改成功")
                            //关闭修改操作的模态窗口
                            $("#editContactsModal").modal("hide");
                            pageList($("#contactsPage").bs_pagination('getOption', 'currentPage')
                                , $("#contactsPage").bs_pagination('getOption', 'rowsPerPage'));

                        } else {
                            alert("修改联系人活动失败");
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
                            url:"workbench/contacts/delete.do",
                            data:param,
                            type:"post",
                            dataType:"json",
                            success:function (data){
                                if (data.success){
                                    pageList(1,4);
                                }else {
                                    alert("删除联系人失败")
                                }
                            }
                        })
                    }

                }
            })


        });

        function pageList(pageNo, pageSize) {
            $("#qx").prop("checked", false);

            //查询前，将隐藏域中保存的信息取出来，重新赋予到搜索框中，防止进入别的页时，搜索框的内容刷新没了
            $("#search-fullname").val($.trim($("#hidden-fullname").val()));
            $("#search-customerName").val($.trim($("#hidden-customerName").val()));
            $("#search-owner").val($.trim($("#hidden-owner").val()));
            $("#search-source").val($.trim($("#hidden-source").val()));
            $("#search-birth").val($.trim($("#hidden-birth").val()));
            $.ajax({
                url: "workbench/contacts/pageList.do",
                data: {
                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    "fullname": $.trim($("#search-fullname").val()),
                    "customerName": $.trim($("#search-customerName").val()),
                    "owner": $.trim($("#search-owner").val()),
                    "source": $.trim($("#search-source").val()),
                    "birth": $.trim($("#search-birth").val()),

                },
                type: "get",
                dataType: "json",
                success: function (data) {

                    var html = "";
                    $.each(data.dataList, function (i, n) {
                        html += '<tr class="active">';
                        html += '<td><input type="checkbox" name="xz" value="' + n.id + '"/></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/contacts/detail.do?id=' + n.id + '\';">' + n.fullname + '</a></td>';
                        html += '<td>' + n.customerName + '</td>';
                        html += '<td>' + n.owner + '</td>';
                        html += '<td>' + n.source + '</td>';
                        html += '<td>' + n.birth + '</td>';
                        html += '</tr>';

                    })
                    $("#contactsBody").html(html);

                    //计算总页数
                    var totalPages =
                        Math.ceil(data.total / pageSize);

                    //数据添加完毕后，结合分页插件，对前端显示分页信息
                    $("#contactsPage").bs_pagination({
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
<input type="hidden" id="hidden-fullname"/>
<input type="hidden" id="hidden-customerName"/>
<input type="hidden" id="hidden-birth"/>
<input type="hidden" id="hidden-source"/>
<input type="hidden" id="hidden-owner"/>

<!-- 创建联系人的模态窗口 -->
<div class="modal fade" id="createContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="contactsAddForm">

                    <div class="form-group">
                        <label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">

                            </select>
                        </div>
                        <label for="create-contactsSource" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
                                <option></option>
                                <c:forEach items="${sourceList}" var="s">
                                    <option value="${s.value}">${s.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-fullname">
                        </div>
                        <label for="create-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-appellation">
                                <option></option>
                                <c:forEach items="${appellationList}" var="a">
                                    <option value="${a.value}">${a.text}</option>
                                </c:forEach>
                            </select>
                        </div>

                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                        <label for="create-birth" class="col-sm-2 control-label">生日</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time1" id="create-birth" readonly>
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-customerName" class="col-sm-2 control-label">客户名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-customerName" name="create-customerName"
                                   placeholder="支持自动补全，输入客户不存在则新建">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
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
                                <input type="text" class="form-control time2" id="create-nextContactTime" readonly>
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
                <button type="button" id="saveBtn" class="btn btn-primary" data-dismiss="modal">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改联系人的模态窗口 -->
<div class="modal fade" id="editContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改联系人</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <input type="hidden" id="edit-id">

                    <div class="form-group">
                        <label for="edit-contactsOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">

                            </select>
                        </div>
                        <label for="edit-contactsSource1" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <option></option>
                                <c:forEach items="${sourceList}" var="s">
                                    <option value="${s.value}" ${c.source eq s.value ? "selected" : ""}>${s.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-fullname" >
                        </div>
                        <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-appellation">
                                <option></option>
                                <c:forEach items="${appellationList}" var="a">
                                    <option value="${a.value}" ${c.appellation eq a.value ? "selected" : ""}>${a.text}</option>
                                </c:forEach><
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job">
                        </div>
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email">
                        </div>
                        <label for="edit-birth" class="col-sm-2 control-label">生日</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time1" id="edit-birth" readonly>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-customerName" class="col-sm-2 control-label">客户名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-customerName"
                                   value="${c.customerName}" placeholder="支持自动补全，输入客户不存在则新建">
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
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time2" id="edit-nextContactTime" readonly>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" id="updateBtn" class="btn btn-primary">更新</button>
            </div>
        </div>
    </div>
</div>

<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>联系人列表</h3>
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
                        <div class="input-group-addon">姓名</div>
                        <input class="form-control" type="text" id="search-fullname">
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
                        <div class="input-group-addon">来源</div>
                        <select class="form-control" id="search-source">
                            <option></option>
                            <c:forEach items="${sourceList}" var="s">
                                <option value="${s.value}" ${c.source eq s.value ? "selected" : ""}>${s.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">生日</div>
                        <input class="form-control time1" type="text" id="search-birth">
                    </div>
                </div>

                <button type="button" id="searchBtn" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span>
                    创建
                </button>
                <button type="button" class="btn btn-default" id="editBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" id="deleteBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>


        </div>
        <div style="position: relative;top: 20px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>姓名</td>
                    <td>客户名称</td>
                    <td>所有者</td>
                    <td>来源</td>
                    <td>生日</td>
                </tr>
                </thead>
                <tbody id="contactsBody">

                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">
            <div id="contactsPage"></div>

        </div>

    </div>

</div>
</body>
</html>