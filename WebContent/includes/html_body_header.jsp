<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="language" value="${not empty param.language ? param.language : not empty language ? language : pageContext.request.locale}" scope="session" />
<fmt:setLocale value="${language}" />
<fmt:setBundle basename="org.brics_baies.bricsbaies.i18n.text" />
<%
	request.setCharacterEncoding("UTF-8");

	String jqx_theme = (String)request.getSession().getAttribute("jqx_theme");
	String jqx_nav_theme = (String)request.getSession().getAttribute("jqx_nav_theme");
%>

<style>
	#submit {
		margin-top: 10px;
		text-align: center;
	}
	#username{
		margin-bottom: 10px;
	}
	#country_manage{
		display: none;
	}
	#system_manage{
		display: none;
	}
</style>

<script type="text/javascript">
    var current_user = {};

    $(document).ready(function () {

        $.ajax({
            type:'GET',
            url:host+'/user/current_user',
            data: {},
            xhrFields: {
                withCredentials: true
            },
            crossDomain: true,
            async: false ,
            success: function (resp) {
                current_user = resp.data[0]
                $("#curent_user_detail").text( resp.data[0].username)
            }.bind(this)
        })

        user_ban = function () {
            console.log(current_user)
            if (current_user.role.name === "Anonymous")
            {
                console.log("匿名登录")
                $('#login').css("display","inline-block")
                $('#country_manage').css("display","none")
                $('#system_manage').css("display","none")
                $('#logout').css("display","none")
            }
            else if(current_user.role.name === "CountryQualitative" || current_user.role.name === "User"|| current_user.role.name === "CountryQuantify")
            {
                console.log("用户")
                $('#login').css("display","none")
                $('#country_manage').css("display","inline-block")
                $('#system_manage').css("display","none")
                $('#logout').css("display","inline-block")
            }
            else if(current_user.role.name === "Administrator")
            {
                console.log("管理")
                $('#login').css("display","none")
                $('#country_manage').css("display","inline-block")
                $('#system_manage').css("display","inline-block")
                $('#logout').css("display","inline-block")
            }
        }

        user_ban()

        $("#jqxwindow").jqxWindow({ height:150, width: 200, theme: 'summer',isModal: true,autoOpen: false});

        $("#login").click(function () {
            var opened = $("#jqxwindow").jqxWindow('isOpen');
            if (opened == false){
                $("#jqxwindow").jqxWindow('open');
                return false;
            }
        })


        $('#logout').click(function () {
            $.ajax({
                type:'GET',
                url:host+'/user/logout',
                data: {},
                xhrFields: {
                    withCredentials: true
                },
                crossDomain: true,
                async: false ,
                success: function (resp) {
                    current_user = {}
                    window.location.href = 'index.jsp'
                }.bind(this)
            })
        })

        $("#submit").click(function () {
            var name= $("#userName").val();
            if(name == ''){
                alert("请填写账号")
            }
            var password = $("#password").val();
            if(password == ''){
                alert("请填写密码")
            }
            $.ajax({
                //几个参数需要注意一下
                type: "POST",//方法类型
                url: host+"/user/login" ,//url
                data: $('#loginForm').serialize(),
                xhrFields: {
                    withCredentials: true
                },
                crossDomain: true,
                success: function (resp) {
                    if (resp.status === "success") {
                        window.location.href = 'index.jsp'
                    }
                    else {
                        alert("登录错误")
                    }
                }
            });
        })
    });
</script>

<!--background start-->
<div id="background">
	<!--container start-->
	<div id="container">
		<!--header start-->
		<div id="header" style="background-image: url(../images/banner_<fmt:message key="common.language" />.png);">
			<div class="right margin_10">
				<a href="./index.jsp?language=zh">中文</a>
				&nbsp;
				<a href="./index.jsp?language=en">English</a>
				&nbsp;&nbsp;|&nbsp;&nbsp;
				<a href="" id="login">登录</a>
				<span id="manage">
			欢迎您<span id="curent_user_detail"></span>
			<span id="logout"> <a href="./"><fmt:message key="text.logout" /></a></span>
			&nbsp;&nbsp;|&nbsp;&nbsp;
			<a id="country_manage" href="country_policy_management.jsp"><fmt:message key="common.sub_system.country_manage" /></a>
			&nbsp;
			<a id="system_manage" href="admin_policy_approval.jsp"><fmt:message key="common.sub_system.system_manage" /></a>
		</span>
			</div>
			<div class="clear"></div>
			<div class="right margin_10" style="visibility: hidden;">
				<div id="theme_dropdownlist" class="right"></div>
				<div class="right margin_5"></div>
				<div id="nav_theme_dropdownlist" class="right"></div>
				<div class="clear"></div>
				<script type="text/javascript">
                    $(document).ready(function() {
                        var themes = [
                            { label: 'Light', group: 'Themes', value: 'light' },
                            { label: 'Dark', group: 'Themes', value: 'dark' },
                            { label: 'Arctic', group: 'Themes', value: 'arctic' },
                            { label: 'Web', group: 'Themes', value: 'web' },
                            { label: 'Bootstrap', group: 'Themes', value: 'bootstrap' },
                            { label: 'Metro', group: 'Themes', value: 'metro' },
                            { label: 'Metro Dark', group: 'Themes', value: 'metrodark' },
                            { label: 'Office', group: 'Themes', value: 'office' },
                            { label: 'Orange', group: 'Themes', value: 'orange' },
                            { label: 'Fresh', group: 'Themes', value: 'fresh' },
                            { label: 'Energy Blue', group: 'Themes', value: 'energyblue' },
                            { label: 'Dark Blue', group: 'Themes', value: 'darkblue' },
                            { label: 'Black', group: 'Themes', value: 'black' },
                            { label: 'Shiny Black', group: 'Themes', value: 'shinyblack' },
                            { label: 'Classic', group: 'Themes', value: 'classic' },
                            { label: 'Summer', group: 'Themes', value: 'summer' },
                            { label: 'High Contrast', group: 'Themes', value: 'highcontrast' },
                            { label: 'Lightness', group: 'UI Compatible', value: 'ui-lightness' },
                            { label: 'Darkness', group: 'UI Compatible', value: 'ui-darkness' },
                            { label: 'Smoothness', group: 'UI Compatible', value: 'ui-smoothness' },
                            { label: 'Start', group: 'UI Compatible', value: 'ui-start' },
                            { label: 'Redmond', group: 'UI Compatible', value: 'ui-redmond' },
                            { label: 'Sunny', group: 'UI Compatible', value: 'ui-sunny' },
                            { label: 'Overcast', group: 'UI Compatible', value: 'ui-overcast' },
                            { label: 'Le Frog', group: 'UI Compatible', value: 'ui-le-frog' }
                        ];

                        $('#theme_dropdownlist').jqxDropDownList({
                            width: 150, theme: '<%=jqx_theme %>', source: themes
                        });
                        $('#theme_dropdownlist').jqxDropDownList('selectItem',
                            $('#theme_dropdownlist').jqxDropDownList('getItemByValue', '<%=jqx_theme %>'));
                        $('#theme_dropdownlist').on('change', function(event) {
                            var args = event.args;
                            if(!args) {
                                return;
                            }
                            var value = args.item.value;
                            window.location.href='change_theme.jsp?theme='+value+'&url='+window.location.href;
                        });

                        $('#nav_theme_dropdownlist').jqxDropDownList({
                            width: 150, theme: '<%=jqx_theme %>', source: themes
                        });
                        $('#nav_theme_dropdownlist').jqxDropDownList('selectItem',
                            $('#nav_theme_dropdownlist').jqxDropDownList('getItemByValue', '<%=jqx_nav_theme %>'));
                        $('#nav_theme_dropdownlist').on('change', function(event) {
                            var args = event.args;
                            if(!args) {
                                return;
                            }
                            var value = args.item.value;
                            window.location.href='change_nav_theme.jsp?theme='+value+'&url='+window.location.href;
                        });

                    });
				</script>
			</div>
		</div>
		<!--header end-->

		<!--nav1 start-->
			<% if(request.getRequestURI().contains("/admin_")) { %>
		<jsp:include page="../includes/nav1_admin.jsp" />
			<% } else if(request.getRequestURI().contains("/country_")) { %>
		<jsp:include page="../includes/nav1_country.jsp" />
			<% } else { %>
		<jsp:include page="../includes/nav1.jsp" />
			<% } %>
		<!--nav1 end-->

		<!--nav2 start-->
		<jsp:include page="../includes/nav2.jsp" />
		<!--nav2 end-->

		<!--main start-->
		<div id="main">
			<div id='jqxwindow'>
				<div>登录</div>
				<div>
					<form id="loginForm" onsubmit="return false" action="##" method="post">
						<div>用户名：<input name="username" type="text" id="username" size="15" value=""/></div>
						<div>密　码：<input name="password" type="password" id="password" size="15" value=""/></div>
						<div id="submit"><input type="button" value="登录"></div>
					</form>
					<%--<form id="loginForm" method="post">--%>
					<%--<div>--%>
					<%--<label>账号</label>--%>
					<%--<input type="text" id="userName" placeholder="请输入账号"/>--%>
					<%--</div>--%>
					<%--<div>--%>
					<%--<lable>密码</lable>--%>
					<%--<input type="password" id="password" placeholder="密码"/>--%>
					<%--</div>--%>
					<%--<div class="submit">--%>
					<%--<button type="submit" id="submit" onclick="login()">登录</button>--%>
					<%--</div>--%>
					<%--</form>--%>
				</div>
			</div>