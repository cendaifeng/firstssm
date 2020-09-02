<%--
  Created by IntelliJ IDEA.
  User: cendaifeng
  Date: 2020/8/19
  Time: 0:09
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
                <button type="button" class="btn btn-primary">新增</button>
                <button type="button" class="btn btn-danger">删除</button>
            </div>
        </div>
        <%-- 显示表格数据 --%>
        <div class="row">
            <%-- table-hover 鼠标经过高亮 table-striped 条纹样式 --%>
            <table class="table table-hover table-striped">
                <tr>
                    <th>ID</th>
                    <th>姓名</th>
                    <th>性别</th>
                    <th>邮箱</th>
                    <th>部门</th>
                    <th>操作</th>
                </tr>
                <c:forEach items="${pageInfo.list}" var="emp">
                <tr>
                    <th>${emp.empId}</th>
                    <th>${emp.empName}</th>
                    <th>${emp.gender=="M"?"男":"女"}</th>
                    <th>${emp.email}</th>
                    <th>${emp.department.deptName}</th>
                    <th>
                        <button type="button" class="btn btn-primary btn-sm">
                            <span class="glyphicon glyphicon-th-list" aria-hidden="true"></span>
                            编辑
                        </button>
                        <button type="button" class="btn btn-danger btn-sm">
                            <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>
                            删除
                        </button>
                    </th>
                </tr>
                </c:forEach>
            </table>
        </div>
        <%-- 显示分页信息 --%>
        <div class="row">
            <%-- 分页文字信息 --%>
            <div class="col-md-5">
                <h4>当前页码: 第 ${pageInfo.pageNum} 页 <small>总 ${pageInfo.pages} 页 共 ${pageInfo.total} 记录</small></h4>
            </div>
            <%-- 分页条 --%>
            <div class="col-md-7">
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <li>
                            <a href="${APP_PATH}/emps?pn=1">首页</a>
                        </li>
                        <li>
                            <c:if test="${pageInfo.hasPreviousPage}">
                            <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum-1}" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                            </c:if>
                        </li>

                        <c:forEach items="${pageInfo.navigatepageNums}" var="page_num">
                            <c:if test="${page_num == pageInfo.pageNum}">
                                <li class="active"><a href="#">${page_num}</a></li>
                            </c:if>
                            <c:if test="${page_num != pageInfo.pageNum}">
                                <li ><a href="${APP_PATH}/emps?pn=${page_num}">${page_num}</a></li>
                            </c:if>
                        </c:forEach>

                        <li>
                            <c:if test="${pageInfo.hasNextPage}">
                            <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum+1}" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                            </c:if>
                        </li>
                        <li>
                            <a href="${APP_PATH}/emps?pn=${pageInfo.pages}">末页</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>

    </div>

</body>
</html>
