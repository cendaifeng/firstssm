<%--
  Created by IntelliJ IDEA.
  User: cendaifeng
  Date: 2020/8/17
  Time: 11:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% pageContext.setAttribute("APP_PATH", request.getContextPath()); %>
<html>
<head>
    <title>list of Emps</title>
    <%-- Bootstrap 核心 CSS 文件 --%>
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <%-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) --%>
    <script src="${APP_PATH}/static/js/jquery-3.5.1.min.js"></script>
    <%-- Bootstrap 核心 JavaScript 文件 --%>
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js" ></script>
</head>
<body>

<!-- 员工修改的模态框 -->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel_02">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel_02">员工修改</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Emp Name</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empName_update_static"><!-- EmpName to display --></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email_update_input" class="col-sm-2 control-label">Email</label>
                        <div class="col-sm-10">
                            <input type="email" name="email" class="form-control" id="email_update_input" placeholder="Email@xxx.com">
                            <span class="help-block"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender_update_input1" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender_update_input2" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Department Name</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="dId">
                                <%-- <option>1</option> --%>
                            </select>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">Update</button>
            </div>
        </div>
    </div>
</div>


<!-- 员工添加的模态框 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="empName_add_input" class="col-sm-2 control-label">Emp Name</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="EmpName">
                            <span class="help-block"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email_input" class="col-sm-2 control-label">Email</label>
                        <div class="col-sm-10">
                            <input type="email" name="email" class="form-control" id="email_input" placeholder="Email@xxx.com">
                            <span class="help-block"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender_input1" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender_input2" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Department Name</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="dId">
                                <%-- <option>1</option> --%>
                            </select>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">Save</button>
            </div>
        </div>
    </div>
</div>


<%-- 搭建显示页面 --%>
<div class="container">
    <%-- 标题 --%>
    <div class="row">
        <div class="col-md-12">
            <h1>员工信息列表</h1>
        </div>
    </div>
    <%-- 按钮 --%>
    <div class="row">
        <%-- 一行总共 12 个单位，这里的 div 占 4 个单位，向右偏移 8 个单位 --%>
        <div class="col-md-4 col-md-offset-8">
            <button type="button" class="btn btn-primary" id="emp_add_modal_btn">新增</button>
            <button type="button" class="btn btn-danger" id="emp_delete_bat_btn">删除</button>
        </div>
    </div>
    <%-- 显示表格数据 --%>
    <div class="row">
        <%-- table-hover 鼠标经过高亮 table-striped 条纹样式 --%>
        <table class="table table-hover table-striped" id="emps_table">
            <thead>
                <tr>
                    <th>
                        <input type='checkbox' id="check_all" hidden="true"/>
                    </th>
                    <th>ID</th>
                    <th>姓名</th>
                    <th>性别</th>
                    <th>邮箱</th>
                    <th>部门</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
            <%-- build_emps_table(result) --%>
            </tbody>
        </table>
    </div>
    <%-- 显示分页信息 --%>
    <div class="row">
        <%-- 分页文字信息 --%>
        <div class="col-md-5" id="page_info_area">
        <%-- build_page_info(result) --%>
        </div>
        <%-- 分页条 --%>
        <div class="col-md-7">
            <nav aria-label="Page navigation" id="page_nav_area">
            <%-- build_page_nav(result) --%>
            </nav>
        </div>
    </div>

</div>
<script type="application/javascript">

<%--  ================================================ 员工信息页面的显示 ================================================  --%>

    var totalRecord, currentPage, pagesCount, itemPerPage;
    //1、页面加载完成以后，直接去发送ajax请求,要到分页数据
    $(function (){
        to_page(1);
    });

    function to_page(pn) {
        $.ajax({
            url:"${APP_PATH}/emps",
            data:"pn="+pn,
            type:"get",
            success:function (result) {
                // 解析显示员工信息
                build_emps_table(result);
                // 解析显示分页信息
                build_page_info(result);
                // 解析显示导航条
                build_page_nav(result);
            }
        });
        clear_checkbox();
    }

    function build_emps_table(result) {
        $("#emps_table tbody").empty();
        var emps = result.extend.pageInfo.list;
        $.each(emps, function () {
            var checkbox_item = $("<th></th>").append("<input type='checkbox' class='check_item' hidden='true'/>");
            var empIdTd = $("<th></th>").append(this.empId);
            var empNameTd = $("<th></th>").append(this.empName);
            var genderTd = $("<th></th>").append(this.gender=="M"?"男":"女");
            var emailTd = $("<th></th>").append(this.email);
            var deptNameTd = $("<th></th>").append(this.department.deptName);
            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                .append($("<span></span>")).addClass("glyphicon glyphicon-th-list").append(" <b>编辑</b>");

            // 给编辑按钮添加data
            editBtn.data({"empid":this.empId, "empname":this.empName, "gender":this.gender, "email":this.email,
                "department":this.department});

            var deleteBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                .append($("<span></span>")).addClass("glyphicon glyphicon-remove").append(" <b>删除</b>");

            // 给删除按钮添加自定义属性
            deleteBtn.attr("del_id", this.empId);

            var btnTd = $("<th></th>").append(editBtn).append("  ").append(deleteBtn);
            $("<tr></tr>")
                .append(checkbox_item)
                .append(empIdTd)
                .append(empNameTd)
                .append(genderTd)
                .append(emailTd)
                .append(deptNameTd)
                .append(btnTd)
                    .appendTo("#emps_table tbody");
        });
    }

    function build_page_info(result) {
        $("#page_info_area").empty();
        $("#page_info_area").append("<h4>当前页码: 第 "
            +result.extend.pageInfo.pageNum +" 页 <small>总 "
            +result.extend.pageInfo.pages+" 页 共 "
            +result.extend.pageInfo.total +" 记录</small></h4>")
        totalRecord = result.extend.pageInfo.total;
        currentPage = result.extend.pageInfo.pageNum;
        pagesCount = result.extend.pageInfo.pages;
        itemPerPage = result.extend.pageInfo.pageSize;
    }

    function build_page_nav(result){
        $("#page_nav_area").empty();
        var ul = $("<ul></ul>").addClass("pagination");

        //构建元素
        var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
        var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
        if(result.extend.pageInfo.hasPreviousPage == false){
            firstPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        }else{
            //为元素添加点击翻页的事件
            firstPageLi.click(function(){
                to_page(1);
            });
            prePageLi.click(function(){
                to_page(result.extend.pageInfo.pageNum -1);
            });
        }

        var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
        if(result.extend.pageInfo.hasNextPage == false){
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        }else{
            nextPageLi.click(function(){
                to_page(result.extend.pageInfo.pageNum +1);
            });
            lastPageLi.click(function(){
                to_page(result.extend.pageInfo.pages);
            });
        }

        //添加首页和前一页 的提示
        ul.append(firstPageLi).append(prePageLi);
        //1,2,3遍历给ul中添加页码提示
        $.each(result.extend.pageInfo.navigatepageNums,function(index,item){

            var numLi = $("<li></li>").append($("<a></a>").append(item));
            if(result.extend.pageInfo.pageNum == item){
                numLi.addClass("active");
            }
            numLi.click(function(){
                to_page(item);
            });
            ul.append(numLi);
        });
        //添加下一页和末页 的提示
        ul.append(nextPageLi).append(lastPageLi);

        //把ul加入到nav
        var navEle = $("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    }

<%--  ================================================ 员工添加功能操作 ================================================  --%>

    // 点击新增按钮弹出模态框
    $("#emp_add_modal_btn").click(function () {
        // 表单重置
        reset_form("#empAddModal form");
        // 发送 ajax 请求，查出部门信息，显示在下拉列表中
        getDepts("#empAddModal select");
        // 弹出
        $("#empAddModal").modal({
            backdrop:"static"
        });
    });

    function getDepts(ele) {
        $.ajax({
            url:"${APP_PATH}/depts",
            type:"GET",
            async:false,
            success:function (result) {
                // console.log(result)
                // 清空下拉列表
                $("select").empty();
                // 显示部门信息在下拉列表中
                $.each(result.extend.depts, function (){
                   var optionEle = $("<option></option>").append(this.deptName).attr("value", this.deptId);
                   optionEle.appendTo(ele)
                });
            }
        })
    }

    // 校验用户名是否可用
    $("#empName_add_input").change(function (){
        // 发送 ajax 请求校验
        var empName = this.value;
        $.ajax({
            url:"${APP_PATH}/checkuser",
            data:"empName="+empName,
            type:"POST",
            success:function (result) {
                if (result.code == 100) {
                    show_validate_msg("#empName_add_input", "success", "用户名可用");
                    $("#emp_save_btn").attr("ajax-validate", "success");
                } else {
                    show_validate_msg("#empName_add_input", "error", result.extend.va_msg);
                    $("#emp_save_btn").attr("ajax-validate", "error");
                }
            }
        });
    });

    // 点击保存按钮，将填写的数据提交给服务器
    $("#emp_save_btn").click(function () {
        // 数据格式校验
        if (!validate_add_form()){ return false; }
        // ajax 验证用户名是否重复
        if ($(this).attr("ajax-validate")=="error") {
            return false;
        }
        // 发送 ajax 请求保存员工
        $.ajax({
            url:"${APP_PATH}/emps",
            type:"POST",
            // 将 form 表单中的数据序列化为一个 Employee 对象
            data:$("#empAddModal form").serialize(),
            success:function (result){
                if (result.code == 100) {
                    // 关闭框框
                    $("#empAddModal").modal('hide');
                    // 跳转到最后一页
                    if (totalRecord%itemPerPage != 0) {
                        to_page(pagesCount);
                    } else {
                        to_page(pagesCount+1);
                    }
                } else {
                    // console.log(result);
                    // 显示失败信息
                    // 如果不是未定义
                    if (undefined != result.extend.errorFields.empName) {
                        show_validate_msg("#empName_add_input", "error", "用户名必须为 2-5 位汉字或者 6-16 位英文与数字的组合");
                    }
                    if (undefined != result.extend.errorFields.email) {
                        show_validate_msg("#email_input", "error", "电子邮箱格式不正确");
                    }
                }
            }
        });
    });

    function validate_add_form() {
        var empName = $("#empName_add_input").val();
        var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
        var email = $("#email_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        var ifName = false;
        var ifEmail = false;
        // 检验用户名
        if (!regName.test(empName)) {
            // alert("用户名必须为 2-5 位汉字或者 6-16 位英文与数字的组合");
            show_validate_msg("#empName_add_input","error","用户名必须为 2-5 位汉字或者 6-16 位英文与数字的组合");
        } else {
            show_validate_msg("#empName_add_input","success","");
            ifName = true;
        }
        // 检验邮箱
        if (!regEmail.test(email)) {
            // alert("电子邮箱格式不正确");
            show_validate_msg("#email_input","error","电子邮箱格式不正确");
        } else {
            show_validate_msg("#email_input","success","");
            ifEmail = true;
        }

        if (ifName && ifEmail == true) {
            return true;
        } else {
            return false;
        }
    }

    //显示校验结果的提示信息
    function show_validate_msg(ele,status,msg){
        //清除当前元素的校验状态
        $(ele).parent().removeClass("has-success has-error");
        $(ele).next("span").text("");
        if("success" == status){
            $(ele).parent().addClass("has-success");
        }else if("error" == status){
            $(ele).parent().addClass("has-error");
        }
        $(ele).next("span").text(msg);
    }

    // 清空表单样式及内容
    function reset_form(ele){
        $(ele)[0].reset();
        //清空表单样式
        $(ele).find("*").removeClass("has-error has-success");
        $(ele).find(".help-block").text("");
    }

<%--  ================================================ 员工更新功能操作 ================================================  --%>

    // 为编辑按钮绑定上单击事件
    // 创建按钮时动态绑定
    $(document).on("click", ".edit_btn", function () {
        // alert("click");
        // 清空表单样式
        reset_form("#empUpdateModal form");
        // 发送 ajax 请求，查出部门信息，显示在下拉列表中
        getDepts("#empUpdateModal select");
        // 获取员工信息并显示
        displayEmp(this);
        // 将员工的id传递给模态框的更新按钮
        var empid = $(this).data("empid");
        $("#emp_update_btn").attr("update_id", empid);
        // 弹出
        $("#empUpdateModal").modal({
            backdrop:"static"
        });
    });

    function displayEmp(ele) {
        $("#empName_update_static").text($(ele).data("empname"));
        $("#email_update_input").val($(ele).data("email"));
        $("#empUpdateModal input[name=gender]").val([$(ele).data("gender")]);
        $("#empUpdateModal select").val([$(ele).data("department").deptId]);
    }

    // 点击更新按钮，将填写的数据提交给服务器
    $("#emp_update_btn").click(function () {
        // 将更新按钮中的 empid 信息取出
        let empid = $(this).attr("update_id");
        // 发送 ajax 请求保存员工
        $.ajax({
            url:"${APP_PATH}/emps/"+empid,
            type:"POST",
            // 将 form 表单中的数据序列化为一个 Employee 对象
            data:$("#empUpdateModal form").serialize()+"&_method=PUT",
            success:function (result) {
                if (result.code == 100) {
                    // 关闭框框
                    $("#empUpdateModal").modal('hide');
                    // 跳转到当前页
                    to_page(currentPage);
                } else {
                    // console.log(result);
                    // 显示失败信息
                    // 如果不是未定义
                    if (undefined != result.extend.errorFields.email) {
                        show_validate_msg("#email_update_input", "error", "电子邮箱格式不正确");
                    }
                }
            }
        });
    });

<%--  ================================================ 员工删除功能操作 ================================================  --%>

    /* 单个员工删除 */
    // 为每行的删除按钮绑定上单击事件
    // 创建按钮时动态绑定
    $(document).on("click", ".delete_btn", function () {
        // 弹出确认删除框
        let empName = $(this).parents("tr").find("th:eq(2)").text();
        if (confirm("确认删除『"+empName+"』吗！")) {
            // 将自定义属性 del_id 取出
            let empid = $(this).attr("del_id");
            // 发送 ajax 请求删除员工
            $.ajax({
                url:"${APP_PATH}/emps/"+empid,
                type:"POST",
                data:"_method=DELETE",
                success:function (result) {
                    alert(result.msg);
                    to_page(currentPage);
                }
            });
        }
    });

    /* 多个员工删除 */
    $("#emp_delete_bat_btn").click(function () {
        // 显示隐藏的选项框
        display_checkbox();
        // 将删除改为确认
        let bat_btn = document.getElementById("emp_delete_bat_btn");
        bat_btn.innerHTML = "确认";
        // 再次点击该按钮
        if (bat_btn.hasAttribute("conf")) {
            // 获取员工名和 ID 信息
            let empNames = "", delIds = "";
            $.each($(".check_item:checked"), function () {
                let empName = $(this).parents("tr").find("th:eq(2)").text();
                empNames = empNames + empName + ",";
                let delId = $(this).parents("tr").find("th:eq(1)").text();
                delIds = delIds + delId + "-";
            });
            empNames = empNames.substring(0,empNames.length-1);
            delIds = delIds.substring(0,delIds.length-1);

            // 弹出确认删除框
            if ($(".check_item:checked").length < 1) {
                alert("未选择员工！")
                return;
            }
            if (confirm("确认删除『"+empNames+"』吗！")) {
                // 发送 ajax 请求删除员工
                $.ajax({
                    url:"${APP_PATH}/emps/"+delIds,
                    type:"POST",
                    data:"_method=DELETE",
                    success:function (result) {
                        alert(result.msg);
                    }
                });
            }
            // 刷新页面以还原选项框
            to_page(currentPage);
            // 跳过函数末行的属性标记设置
            return;
        }

        // 第一次点击该按钮
        bat_btn.setAttribute("conf", "true");
    });

    // 全选功能
    $("#check_all").click(function () {
        // 对于原生 dom，attr 获取自定义的值，prop 获取 dom 原生属性的值
        $(".check_item").prop("checked", $("#check_all").prop("checked"));
    });

    // check_item 关联 check_all
    $(document).on("click", ".check_item", function() {
        let flag = $(".check_item:checked").length ==  $(".check_item").length;
        $("#check_all").prop("checked", flag);
    });

    // 显示隐藏的选项框
    function display_checkbox() {
        let checkbox_top = document.getElementById("check_all");
        let checkbox_item = document.getElementsByClassName("check_item");

        // 点击删除按钮显示选项框
        if (checkbox_top.hasAttribute("hidden")) {
            checkbox_top.removeAttribute("hidden");
        }
        for (i in checkbox_item) {
            if (checkbox_item.item(i).hasAttribute("hidden")) {
                checkbox_item.item(i).removeAttribute("hidden");
            }
        }
    }

    // 还原选项框功能（跳转页面时会调用）
    function clear_checkbox() {
        let bat_btn = document.getElementById("emp_delete_bat_btn");
        let checkbox_top = document.getElementById("check_all");

        // 仅对全选选项框进行隐藏，单项选项框由于是动态变更的，所以只在页面刷新时隐藏
        if (!checkbox_top.hasAttribute("hidden")) {
            checkbox_top.setAttribute("hidden", "true");
        }
        // 重置为删除
        bat_btn.innerHTML = "删除";
        // 移除按钮已点击的属性标记
        if (bat_btn.hasAttribute("conf")) {
            bat_btn.removeAttribute("conf");
        }
        // 清空选项框
        $("#check_all").prop("checked", false);
        $(".check_item").prop("checked", false);
    }


</script>
</body>
</html>

