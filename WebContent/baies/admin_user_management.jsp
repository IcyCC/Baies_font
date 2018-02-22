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
%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="../includes/html_head.jsp" />
<title><fmt:message key="common.title" /></title>
<script>

page_id = 2;

$(document).ready(function() {
	
	var rows = $("#user_ul");
	var data = [];
	var role_data = [];
	var country_data=[];
	// for (var i = 0; i < 100; i++) {
	// 	var row = rows[0];
	// 	var datarow = {};
	// 	datarow['id'] = i + 1;
	// 	datarow['name'] = 'user' + (Math.floor(Math.random()*1000)+1);
	// 	datarow['real_name'] = $(row).find('li:nth-child(3)').find('span:nth-child('+(Math.floor(Math.random()*4)+1)+')').html();
	// 	datarow['country'] = $(row).find('li:nth-child(4)').find('span:nth-child('+(Math.floor(Math.random()*5)+1)+')').html();
	// 	datarow['create_time'] = $(row).find('li:nth-child(5)').html();
	// 	datarow['last_login_time'] = $(row).find('li:nth-child(6)').html();
	// 	datarow['role'] = $(row).find('li:nth-child(7)').find('span:nth-child('+(Math.floor(Math.random()*3)+1)+')').html();
	// 	datarow['operation'] = $(row).find('li:nth-child(8)').html();
	// 	data[data.length] = datarow;
	// }



    $.ajax({
        type:'GET',
        url:host+'/user/User',
        data: {},
        xhrFields: {
            withCredentials: true
        },
        crossDomain: true,
		async: false,
        success: function (resp) {
            for (var index in resp.data) {
                var row = rows[0];
                var datarow = {}
                datarow['id'] = resp.data[index].id
                datarow['email'] = resp.data[index].email
                datarow['country'] = resp.data[index].country.<fmt:message key="data.field" />
				datarow['name'] = resp.data[index].username
				datarow['role'] = resp.data[index].role.name
				datarow['operation'] = $(row).find('li:nth-child(8)').html()
                data[data.length] = datarow;
            }
		}
    });
    $.ajax({
        type:'GET',
        url:host+'/user/Role',
        data: {},
        async: false,
        xhrFields: {
            withCredentials: true
        },
        crossDomain: true,
        success: function (resp) {
            for (var index in resp.data) {
                role_data.push({label:resp.data[index].name, value: resp.data[index].id})
            }
            console.log('role_data', role_data)
        }
    })

    $.ajax({
        type:'GET',
        url:host+'/quantify/country',
        data: {},
        async: false,
        xhrFields: {
            withCredentials: true
        },
        crossDomain: true,
        success: function (resp) {
            for (var index in resp.data) {
                country_data.push(resp.data[index])
            }
            console.log('role_data', country_data)
        }
    })

	var source = {
			localdata: data,
			datatype: 'array',
			datafields: [{name: 'id', type: 'number'},
			             {name: 'name', type: 'string'},
			             {name: 'email', type: 'string'},
			             {name: 'country', type: 'string'},
			             // {name: 'create_time', type: 'string'},
			             // {name: 'last_login_time', type: 'string'},
			             {name: 'role', type: 'string'},
			             {name: 'operation', type: 'string'}],
	};
	var dataAdapter = new $.jqx.dataAdapter(source);
	var settings = {
			width: '850px',
			source: dataAdapter,
			autoheight: true,
			autorowheight: true,
			showheader: true,
			pageable: true,
			pagesize: 10,
			theme: '<%=jqx_theme %>',
			columns: [{text: '编号', dataField: 'id', width: 100, align: 'center', cellsalign: 'center'},
			          {text: '登录名', dataField: 'name', width: 150, align: 'center', cellsalign: 'center'},
			          {text: '邮箱', dataField: 'real_name', width: 100, align: 'center', cellsalign: 'center'},
			          {text: '<fmt:message key="common.dimension.country" />', dataField: 'country', width: 100, align: 'center', cellsalign: 'center'},
			          // {text: '创建时间', dataField: 'create_time', width: 100, align: 'center', cellsalign: 'center'},
			          // {text: '最后登录时间', dataField: 'last_login_time', width: 100, align: 'center', cellsalign: 'center'},
			          {text: '角色', dataField: 'role', width: 100, align: 'center', cellsalign: 'center'},
			          {text: '操作', dataField: 'operation', width: 100, align: 'center', cellsalign: 'center'}
			          ],
			showtoolbar: true,
			rendertoolbar: function(toolbar) {
				var container = $('<div style="margin: 5px 10px 5px 5px; text-align: right;"></div>');
				toolbar.append(container);
				container.append('<input id="addrowbutton" type="button" value="添加用户" />');
				$("#addrowbutton").jqxButton();
				$("#addrowbutton").on('click', function () {
					$('#edit_title_input').val('');
					$('#edit_content_editor').val('');
					$('#edit_window').jqxWindow('open');

					$('#edit_window_ok_button').one('click', function (event) {
                        console.log("add");
					    var post_data = {
                            email: "",
                            username: "",
                            country_id: "",
                            role_id: "",
							password:""
						};

					    post_data.email = $('#email_input').val();
						post_data.username = $('#name_input').val();
						post_data.country_id = $('#country_input').val();
						post_data.role_id = $('#role_input').val();
						post_data.password = $('#password_input').val();

						console.log("add user", post_data);

                        $.ajax({
                            type:'POST',
                            url:host+'/user/User',
                            data: post_data,
                            async: true,
                            xhrFields: {
                                withCredentials: true
                            },
                            crossDomain: true,
                            success: function (resp) {
                                if (resp.status === "success")
								{
								    window.location.reload()
								}
                            }
                        })

                    })


				});
			}
	};
	$('#user_grid').jqxGrid(settings);
	
	$('#dialog_window').jqxWindow({
		width: 350, height: 'auto', resizable: false,  isModal: true, autoOpen: false,
		okButton: $("#dialog_window_ok_button"), cancelButton: $("#dialog_window_cancel_button"),
		modalOpacity: 0.3, theme: '<%=jqx_theme %>'
	});
	$("#dialog_window_ok_button").jqxButton({
		theme: '<%=jqx_theme %>'
	});
	$("#dialog_window_cancel_button").jqxButton({
		theme: '<%=jqx_theme %>'
	});

    $("#user_grid").on("cellclick", function (event)
    {
        // event arguments.
        var args = event.args;

        var user = args.row.bounddata;
        console.log(args)

        $('.edit_buttons').one('click', function() {
            $('#edit_title_input').val('<fmt:message key="temp.policy_title" />');
            $('#edit_content_editor').val($('<div />').html($('#editor_content').html()).text());
            $('#edit_window').jqxWindow('open');


            $('#edit_window_ok_button').one('click', function (event) {
                console.log(user)
                var post_data = {
                    email: "",
                    username: "",
                    country_id: "",
                    role_id: "",
                    password:""
                };

                post_data.email = $('#email_input').val();
                post_data.username = $('#name_input').val();
                post_data.country_id = $('#country_input').val();
                post_data.role_id = $('#role_input').val();
                post_data.password = $('#password_input').val();

                console.log("change user", post_data)

                $.ajax({
                    type:'PUT',
                    url:host+'/user/User/'+user.id,
                    data: post_data,
                    async: true,
                    xhrFields: {
                        withCredentials: true
                    },
                    crossDomain: true,
                    success: function (resp) {
                        if (resp.status === "success")
                        {
                            window.location.reload()
                        }
                    }
                })

            }.bind(this))

        }.bind(this));


        $('.delete_buttons').one('click', function() {
            console.log("delete use ", user)
            $('#dialog_window_ok_button').one('click', function (event) {
				console.log("delete use ok", user)
                $.ajax({
                    type:'DELETE',
                    url:host+'/user/User/'+user.id,
                    data: {},
                    async: true,
                    xhrFields: {
                        withCredentials: true
                    },
                    crossDomain: true,
                    success: function (resp) {
                        if (resp.status === "success")
                        {
                            window.location.reload()
                        }
                    }
                })

            }.bind(this))

        }.bind(this));
    });


	
	$('.delete_buttons').on('click', function() {
		$('#dialog_window_content').html('是否删除用户？');
		$('#dialog_window').one('close', function(event) {
			if(event.args.dialogResult.OK) {
				$('#message_notification_content').html('用户已删除。');
				$('#message_notification').jqxNotification('open');
			}
		});
		$('#dialog_window').jqxWindow('open');
	});
	
	$('#edit_window').jqxWindow({
		width: 350, height: 'auto', resizable: false,  isModal: true, autoOpen: false,
		okButton: $("#edit_window_ok_button"), cancelButton: $("#edit_window_cancel_button"),
		modalOpacity: 0.3, theme: '<%=jqx_theme %>'
	});
	
	$("#edit_window_ok_button").jqxButton({
		theme: '<%=jqx_theme %>'
	});
	
	$("#edit_window_ok_button").on('click', function(event) {
		$('#message_notification_content').html('用户已保存。');
		$('#message_notification').jqxNotification('open');
	});
	
	$("#edit_window_cancel_button").jqxButton({
		theme: '<%=jqx_theme %>'
	});
	
	$('#message_notification').jqxNotification({
		width: 'auto', position: "bottom-right", opacity: 0.9, template: 'success', theme: '<%=jqx_theme %>'
	});

    $("#role_input").jqxDropDownList({ source: role_data, displayMember: "label", valueMember: "value" , width: '200px', height: '15px'});

    $('#country_input').jqxDropDownList({ source: country_data, displayMember: '<fmt:message key="data.field" />', valueMember: "id" , width: '200px', height: '15px'})
});

</script>
</head>
<body>

<jsp:include page="../includes/html_body_header.jsp" />


<div style="padding: 25px;">
	<h1>用户管理</h1>
	<br><br>
	<div id="user_grid"></div>
</div>

<ul id="user_ul" style="display: none;">
	<li>（用户编号）</li>
	<li>（登录名）</li>
	<li><span><fmt:message key="temp.policy_author" /></span><span>李四</span><span>王五</span><span>赵六</span></li>
	<li><span><fmt:message key="common.country.brazil" /></span><span><fmt:message key="common.country.russia" /></span><span><fmt:message key="common.country.india" /></span><span><fmt:message key="common.country.china" /></span><span><fmt:message key="common.country.south_africa" /></span></li>
	<li>2016-07-01 08:00</li>
	<li>2016-07-04 10:39</li>
	<li><span>查询用户</span><span><fmt:message key="common.dimension.country" />管理员</span><span>系统管理员</span></li>
	<li>
		<button>
			<img class="edit_buttons" src="../js/jqwidgets-4.1.2/styles/images/icon-edit.png"
				title="编辑" style="width: 16px; height: 16px; vertical-align: middle;">
		</button>
		<button>
			<img class="delete_buttons" src="../js/jqwidgets-4.1.2/styles/images/icon-delete.png"
				title="删除" style="width: 16px; height: 16px; vertical-align: middle;">
		</button>
	</li>
</ul>

<div id="dialog_window">
	<div>请选择</div>
	<div style="overflow: hidden;">
		<div id="dialog_window_content" style="margin: 20px;">&nbsp;</div>
		<div class="right margin_10">
			<input type="button" id="dialog_window_ok_button" value="确定">
			<input type="button" id="dialog_window_cancel_button" value="取消">
		</div>
		<div class="clear"></div>
	</div>
</div>

<div id="edit_window">
	<div>录入信息</div>
	<div style="overflow: hidden; padding: 20px;">
		<table>
			<tr>
				<td>登录名:</td>
				<td><input type="text" id="name_input" style="width: 200px;"></td>
			</tr>
			<tr>
				<td>邮箱:</td>
				<td><input type="text" id="email_input" style="width: 200px;"></td>
			</tr>
			<tr>
				<td><fmt:message key="common.dimension.country" />:</td>
				<td id="country_input"></td>
			</tr>
			<tr>
				<td>角色:</td>
				<td id="role_input">
				</td>
			</tr>

			<tr>
				<td>密码:</td>
				<td><input type="password" id="password_input" style="width: 200px;"></td>
				</td>
			</tr>
		</table>
		<div class="right margin_10" id="operator_column">
			<input type="button" id="edit_window_ok_button" value="保存">
			<input type="button" id="edit_window_cancel_button" value="取消">
		</div>
		<div class="clear"></div>
	</div>
</div>

<div id="message_notification">
	<div id="message_notification_content"></div>
</div>


<jsp:include page="../includes/html_body_footer.jsp" />

</body>
</html>
