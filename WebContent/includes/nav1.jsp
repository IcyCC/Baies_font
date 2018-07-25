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

<div id="nav1">
	<ul>
		<li><fmt:message key="nav.query_user.index" /></li>
		<li><fmt:message key="nav.query_user.policy" /></li>
		<li><fmt:message key="nav.query_user.econ_data" /></li>
		<li><fmt:message key="nav.query_user.agri_data" /></li>
	</ul>
</div>
<script>
$(document).ready(function() {
	$('#nav1').jqxNavBar({width: 998, height: 40, theme: 'darkblue',
		selectedItem: page_id});
	$('#nav1').on('change', function() {
		var idx = $('#nav1').jqxNavBar('getSelectedIndex');
		window.location.href=nav_items[idx];
	});
});
</script>
