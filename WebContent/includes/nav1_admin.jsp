<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="language" value="${not empty param.language ? param.language : not empty language ? language : pageContext.request.locale}" scope="session" />
<fmt:setLocale value="${language}" />
<fmt:setBundle basename="org.brics_baies.bricsbaies.i18n.text" />
<%
request.setCharacterEncoding("UTF-8");

String jqx_nav_theme = (String)request.getSession().getAttribute("jqx_nav_theme");
%>

<div id="nav1_admin" style="visibility: hidden;">
	<ul>
		<li style="height: 35px; line-height: 35px;"><fmt:message key="nav.system_admin.approval" /></li>
		<li style="height: 35px; line-height: 35px;"><fmt:message key="nav.system_admin.indicator" /></li>
		<li style="height: 35px; line-height: 35px;"><fmt:message key="nav.system_admin.user" /></li>
		<li style="height: 35px; line-height: 35px;"><fmt:message key="nav.system_admin.images" /></li>
	</ul>
	<div></div>
	<div></div>
	<div></div>
</div>
<script>
$(document).ready(function() {
	$('#nav1_admin').jqxTabs({width: '998px', height: '50px', theme: '<%=jqx_nav_theme %>',
		selectedItem: page_id, position: 'top'});
	$('#nav1_admin').jqxTabs('collapse');
	$('#nav1_admin').on('selected', function(event) {
		var idx = event.args.item;
		window.location.href=nav_items_admin[idx];
	});
	$('#nav1_admin').css('visibility', 'visible');
});
</script>
