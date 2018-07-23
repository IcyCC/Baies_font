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
        url:host+'/qualitative/Images',
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
                datarow['img_url'] = resp.data[index].img_url
				datarow['show_img'] = '<img src="'+resp.data[index].img_url + '" height="50" width="50" ></img>'
				datarow['to_url'] = resp.data[index].to_url
				datarow['status'] = resp.data[index].status
                datarow['operation'] =	'<img class="edit_buttons" src="../js/jqwidgets-4.1.2/styles/images/icon-edit.png" title="编辑" style="width: 16px; height: 16px; vertical-align: middle;">'
                data[data.length] = datarow;
            }
		}
    });

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
            console.log('country', country_data)
        }
    })

	var source = {
			localdata: data,
			datatype: 'array',
			datafields: [{name: 'id', type: 'number'},
			             {name: 'img_url', type: 'string'},
                		{name: 'show_img', type: 'string'},
			             {name: 'to_url', type: 'string'},
			             {name: 'status', type: 'string'},
                		{name: 'operation', type: 'string'},
            ],
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
			          {text: '图片地址', dataField: 'show_img', width: 150, align: 'center', cellsalign: 'center'},
			          {text: '跳转体制', dataField: 'to_url', width: 100, align: 'center', cellsalign: 'center'},
			          {text: '状态', dataField: 'status', width: 100, align: 'center', cellsalign: 'center'},
				{text: '操作', dataField: 'operation', width: 80, align: 'center', cellsalign: 'center'}
            ],
			showtoolbar: true,
			rendertoolbar: function(toolbar) {
				var container = $('<div style="margin: 5px 10px 5px 5px; text-align: right;"></div>');
				toolbar.append(container);
				container.append('<input id="addrowbutton" type="button" value="添加图片" />');
				$("#addrowbutton").jqxButton();
				$("#addrowbutton").on('click', function () {
					$('#edit_title_input').val('');
					$('#edit_content_editor').val('');
					$('#edit_window').jqxWindow('open');

					$('#edit_window_ok_button').one('click', function (event) {
                        console.log("add");
					    var post_data = {
							img_url: "",
							to_url: "",
							status: 0
						};

					    post_data.img_url = $('#img_url_input').val();
						post_data.to_url = $('#to_url_input').val();
						post_data.status = $('#status_input').val();

						console.log("add user", post_data);

                        $.ajax({
                            type:'POST',
                            url:host+'/qualitative/Images',
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

    $("#user_grid").on("cellclick", function (event) {
        // event arguments.
        var args = event.args;

        var image = args.row.bounddata;
        console.log(args)

        $('.edit_buttons').one('click', function () {
            $('#img_url_input').val(image.img_url);
            $('#to_url_input').val(image.to_url);
            $('#status_input').val(image.status);
            $('#edit_content_editor').val($('<div />').html($('#editor_content').html()).text());
            $('#edit_window').jqxWindow('open');

            $('#edit_window_ok_button').one('click', function (event) {
                var post_data = {
                    img_url: image.img_url,
                    to_url: image.to_url,
                    status: image.status
                };

                post_data.img_url = $('#img_url_input').val();
                post_data.to_url = $('#to_url_input').val();
                post_data.status = $('#status_input').val();

                $.ajax({
                    type: 'PUT',
                    url: host + '/qualitative/Images/' + image.id,
                    data: post_data,
                    async: true,
                    xhrFields: {
                        withCredentials: true
                    },
                    crossDomain: true,
                    success: function (resp) {
                        if (resp.status === "success") {
                            window.location.reload()
                        }
                    }
                })

            }.bind(this))

        }.bind(this));
    })


	
	$('.delete_buttons').on('click', function() {
		$('#dialog_window_content').html('是否删除图片？');
		$('#dialog_window').one('close', function(event) {
			if(event.args.dialogResult.OK) {
				$('#message_notification_content').html('图片已删除。');
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
		$('#message_notification_content').html('图片已保存。');
		$('#message_notification').jqxNotification('open');
	});
	
	$("#edit_window_cancel_button").jqxButton({
		theme: '<%=jqx_theme %>'
	});
	
	$('#message_notification').jqxNotification({
		width: 'auto', position: "bottom-right", opacity: 0.9, template: 'success', theme: '<%=jqx_theme %>'
	});

    $('#status_input').jqxDropDownList(
        { source: [{label:"展示", value:1},
			{label:"不展示", value:0}], displayMember: 'label',
			valueMember: "value" ,
			width: '200px', height: '15px'})
});

</script>
</head>
<body>

<jsp:include page="../includes/html_body_header.jsp" />


<div style="padding: 25px;">
	<h1>图片管理</h1>
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
		<%--<button>--%>
			<%--<img class="delete_buttons" src="../js/jqwidgets-4.1.2/styles/images/icon-delete.png"--%>
				<%--title="删除" style="width: 16px; height: 16px; vertical-align: middle;">--%>
		<%--</button>--%>
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
				<td>图片链接:</td>
				<td><input type="text" id="img_url_input" style="width: 200px;"></td>
			</tr>
			<tr>
				<td>目标链接:</td>
				<td><input type="text" id="to_url_input" style="width: 200px;"></td>
			</tr>
			<tr>
				<td>状态:</td>
				<td id="status_input"></td>
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
