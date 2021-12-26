<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function(){

            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            $("#remark").focus(function(){
                if(cancelAndSaveBtnDefault){
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height","130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function(){
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height","90px");
                cancelAndSaveBtnDefault = true;
            });

            $(".remarkDiv").mouseover(function(){
                $(this).children("div").children("div").show();
            });

            $(".remarkDiv").mouseout(function(){
                $(this).children("div").children("div").hide();
            });

            $(".myHref").mouseover(function(){
                $(this).children("span").css("color","red");
            });

            $(".myHref").mouseout(function(){
                $(this).children("span").css("color","#E6E6E6");
            });
            showRemarkList();
            $("#remarkBody").on("mouseover",".remarkDiv",function(){
                $(this).children("div").children("div").show();
            });
            $("#remarkBody").on("mouseout",".remarkDiv",function(){
                $(this).children("div").children("div").hide();
            });

            $("#updateBtn").click(function (){

                $.ajax({
                    url: "workbench/activity/update.do",
                    data:{
                        "id":"${a.id}",
                        "owner":$.trim($("#edit-owner").val()),
                        "name":$.trim($("#edit-name").val()),
                        "startDate":$.trim($("#edit-startDate").val()),
                        "endDate":$.trim($("#edit-endDate").val()),
                        "cost":$.trim($("#edit-cost").val()),
                        "description":$.trim($("#edit-description").val())
                    },
                    type: "post",
                    dataType: "json",
                    success:function (data){

                        if (data.success){

                            $("#editActivityModal").modal("hide");
                            window.location.reload();

                        }else{
                            alert("修改市场活动失败");
                        }
                    }
                })
            })

            $("#deleteBtn").click(function (){
                if(confirm("确定要删除该活动吗？")){

                    $.ajax({
                        url:"workbench/activity/deleteInDetail.do",
                        data: {
                            "activityId":"${a.id}",
                        },
                        type:"post",
                        dataType:"json",
                        success:function (data){
                            if (data.success){
                                window.location.href="workbench/activity/index.jsp";
                            }else {
                                alert("删除市场活动失败")
                            }
                        }
                    })
                }
            })

            //为保存按钮绑定事件
            $("#saveRemarkBtn").on("click",function (){
                $.ajax({
                    url:"workbench/activity/saveRemark.do",
                    data:{
                        "noteContent":$.trim($("#remark").val()),
                        "activityId":"${a.id}"
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data){

                        if (data.success){
                            //如果添加成功
                            //将textarea中内容清空
                            $("#remark").val("");
                            //在textarea文本域上方新增一个div
                            var html = "";
                            html += '<div id="' + data.ar.id + '" class="remarkDiv" style="height: 60px;">';
                            html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                            html += '<div style="position: relative; top: -40px; left: 40px;" >';
                            html += '<h5 style="color: aquamarine" id="e' + data.ar.id + '">' + data.ar.noteContent + '</h5>';
                            html += '<font color="aqua">市场活动</font> <font color="aqua">-</font> <b>${a.name}</b> <small style="color: aqua;"> ' + (data.ar.createTime) + ' 由' + (data.ar.createBy) + '</small>';
                            html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\'' + data.ar.id + '\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
                            html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\'' + data.ar.id + '\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                            html += '</div>';
                            html += '</div>';
                            html += '</div>';
                            $("#remarkDiv").before(html);

                        }else {
                            alert("添加备注失败")
                        }
                    }
                })
            })
            $("#updateRemarkBtn").on("click",function (){
                var id = $("#remarkId").val();
                $.ajax({
                    url:"workbench/activity/updateRemark.do",
                    data:{
                        "id":id,
                        "noteContent":$.trim($("#noteContent").val())
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data){
                        /*
                            data
                                {"success":true/false,"ar":{备注}}
                         */
                        if (data.success){
                            //修改备注成功后
                            //更新div中相应的信息，需要更新的内容有 noteContent editTime editBy
                            $("#e"+id).html(data.ar.noteContent);
                            $("#s"+id).html(data.ar.editTime+" 由"+data.ar.editBy);
                            //更新内容之后，关闭模态窗口
                            $("#editRemarkModal").modal("hide");

                        }else{
                            alert("更新备注失败")
                        }

                    }
                })
            })
        });

        function showRemarkList(){
            $.ajax({
                url:"workbench/activity/getRemarkListByAid.do",
                data:{
                    "activityId":"${a.id}"
                },
                type:"get",
                dataType:"json",
                success:function (data){
                    /*
                       data
                          [{备注1},{2},{3}]
                     */
                    var html = "";
                    $.each(data,function (i,n){
                        html += '<div id="'+n.id+'" class="remarkDiv" style="height: 60px;">';
                        html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                        html += '<div style="position: relative; top: -40px; left: 40px;" >';
                        html += '<h5 style="color: aquamarine" id="e'+n.id+'">'+n.noteContent+'</h5>';
                        html += '<font color="aqua">市场活动</font> <font color="aqua">-</font> <b style="color: aqua">${a.name}</b> <small style="color: aqua;"id="s'+n.id+'"> '+(n.editFlag==0?n.createTime:n.editTime)+' 由'+(n.editFlag==0?n.createBy:n.editBy)+'</small>';
                        html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                        html += '<a class="myHref" href="javascript:void(0);"onclick="editRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
                        html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                        html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                        html += '</div>';
                        html += '</div>';
                        html += '</div>';
                    })
                    //在添加备注的文本框头上插入
                    $("#remarkDiv").before(html);
                }
            })
        }
        function editRemark(id){

            $("#remarkId").val(id);

            var noteContent = $("#e"+id).html();

            $("#noteContent").val(noteContent);

            $("#editRemarkModal").modal("show");

        }
        function deleteRemark(id){
            $.ajax({
                url:"workbench/activity/deleteRemark.do",
                data: {
                    "id":id
                },
                type: "post",
                dataType: "json",
                success:function (data){
                    /*
                        data
                            "success:true/false"
                     */
                    if (data.success){
                        $("#"+id).remove()
                        //showRemarkList()，在添加备注文本框的头上：$("#remarkDiv").before(html);
                        //使用showRemarkList(),会在原来前端有的备注上再插入删除后剩下的备注（2n - 1）
                        //因为只有数据库删了选中的备注，showRemarkList()从数据库中将剩下的备注拿了过来，
                        //没有整个页面刷新导致出现了重复的记录

                    }else {
                        alert("删除备注失败")
                    }
                }
            })
        }

    </script>

</head>
<body style="background-color: #222222">

<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div style="width: 40%;" class="modal-dialog" role="document">
        <div style="background-color: rgba(41, 45, 62, .8);" class="modal-content">
            <div class="modal-header">
                <button style="color: aquamarine" type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 style="color: aqua" class="modal-title" id="myModalLabel1">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label style="color: aqua" for="edit-describe" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div style="background-color: rgba(41, 45, 62, .8);" class="modal-content">
            <div class="modal-header">
                <button style="color: aquamarine" type="button" class="close" data-dismiss="modal">
                    <span style="color: aquamarine" aria-hidden="true">×</span>
                </button>
                <h4 style="color: aqua" class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label style="color: aqua" for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <c:forEach items="${activityUserList}" var="u">
                                    <option style="background-color: #333333;color:aquamarine" style="background-color: #333333;color:aquamarine" value="${u.id}" ${a.owner eq u.name ? "selected" : ""}>${u.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label style="color: aqua" for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name" value="${a.name}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label style="color: aqua" for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" readonly id="edit-startDate" value="${a.startDate}" >
                        </div>
                        <label style="color: aqua" for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" readonly id="edit-endDate" value="${a.endDate}" >
                        </div>
                    </div>

                    <div class="form-group">
                        <label style="color: aqua" for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="${a.cost}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label style="color: aqua" for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description">${a.description}</textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateBtn" data-dismiss="modal">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.location.href='workbench/activity/index.jsp';"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #FFFFFF"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <%--            a必须是请求转发而来的  --%>
        <h3 style="color: whitesmoke">市场活动-${a.name} <small>${a.startDate} ~ ${a.endDate}</small></h3>
    </div>
    <div style="background-color: #222222; position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
        <button style="background-color: #dd21ff;color: #56ffca" type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
        <button style="background-color: #1fe8ff; color: #222222" type="button" class="btn btn-danger" id="deleteBtn"><span style="color: #333333" class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: aqua;">所有者</div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; bottom: -1px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; left: 450px"></div>
        <div style="width: 300px;position: relative; left: 450px; top: -20px; color: aqua;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -40px; color: aquamarine;"><b>${a.owner}</b></div>
        <div style="width: 300px;position: absolute; left: 650px; top: 0px; color: aquamarine;"><b>${a.name}</b></div>
    </div>

    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: aqua;">开始日期</div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; bottom: -1px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; left: 450px"></div>
        <div style="width: 300px;position: relative; left: 450px; top: -20px; color: aqua;">结束日期</div>
        <div style="width: 300px;position: relative; left: 200px; top: -40px;color: aquamarine;"><b>${a.startDate}</b></div>
        <div style="width: 300px;position: absolute; left: 650px; top: 0px;color: aquamarine;"><b>${a.endDate}</b></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: aqua;">成本</div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; bottom: 1px;"></div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;color: aquamarine;"><b>${a.cost}</b></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: aqua;">创建者</div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; bottom: 1px;"></div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;color: aquamarine"><b>${a.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: whitesmoke;;">${a.createTime}</small></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: aqua;">修改者</div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; bottom: 1px;"></div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;color: aquamarine"><b>${a.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: whitesmoke;">${a.editTime}</small></div>

    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: aqua;">描述</div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; bottom: 1px;"></div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;color: aquamarine">
            <b>
                ${a.description}
            </b>
        </div>

    </div>
</div>

<!-- 备注 -->
<div id="remarkBody" style="color: aqua ;position:relative; top: 30px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <div id="remarkDiv" style="background-color: #5e5e5e; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="background-color: #9d9d9d;color: #c8e5bc; width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button id="saveRemarkBtn" type="button" class="btn btn-primary">保存</button>
            </p>
        </form>
    </div>
</div>
<div style="height: 200px;"></div>
</body>
</html>