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

page_id = 1;
var table_index_data= {};
var table_data = [];
var index_data = [];
var kind_data = [];

$.ajax({
    type:'GET',
    url:host+'/quantify/agriculture_table',
    data: {},
    xhrFields: {
        withCredentials: true
    },
    crossDomain: true,
    async: false,
    success: function (resp) {
        for (var table in resp.data) {
            console.log('table', resp.data[table])
            table_data.push({label: resp.data[table].<fmt:message key="data.field" />, value: resp.data[table].id, id:resp.data[table].id})
            table_index_data[resp.data[table].id] = resp.data[table].indexes
        }
        console.log('table', table_data, 'index', table_index_data)
        // $('#cat_tree').jqxTree('refresh')
        // $('#variable_list').jqxListBox('render')
        // $('#cat_expander').jqxExpander('refresh')
    }.bind(this)
})


$(document).ready(function() {
	
	$('#nav2_tabs').jqxTabs({width: '998px', position: 'top', theme: '<%=jqx_theme %>'});
	$('#nav2_tabs').jqxTabs({ selectedItem: 1 });
	$('#nav2_tabs').on('selected', function (event) {
		var idx = event.args.item;
		window.location.href=nav2_items_indicator[idx];
	});
	
	var cat_tree_src = agri_data_cat_tree_src_<fmt:message key="common.language" />;
	
	$('#cat_expander').jqxExpander({
		width: '250px', height: '300px', showArrow: false, toggleMode: 'none', theme: '<%=jqx_theme %>'
	});
	
	$('#cat_tree').jqxTree({
		source: table_data, width: '100%', height: '240px', theme: '<%=jqx_theme %>'
	});
	
	$('#cat_add_button').jqxButton({
		width: '82px', height: '30px', theme: '<%=jqx_theme %>'
	});
	
	$('#cat_delete_button').jqxButton({
		width: '82px', height: '30px', theme: '<%=jqx_theme %>'
	});
	
	$('#cat_edit_button').jqxButton({
		width: '82px', height: '30px', theme: '<%=jqx_theme %>'
	});
	
	$('#product_expander').jqxExpander({
		width: '280px', height: '300px', showArrow: false, toggleMode: 'none', theme: '<%=jqx_theme %>'
	});
	
	$('#product_list').jqxListBox({
		source: kind_data, checkboxes: false,
		multiple: false, width: '100%', height: '240px', theme: '<%=jqx_theme %>',
        displayMember:'<fmt:message key="data.field" />',valueMember:'id'
	});
	
	$('#product_add_button').jqxButton({
		width: '92px', height: '30px', theme: '<%=jqx_theme %>'
	});
	
	$('#product_delete_button').jqxButton({
		width: '92px', height: '30px', theme: '<%=jqx_theme %>'
	});
	
	$('#product_edit_button').jqxButton({
		width: '92px', height: '30px', theme: '<%=jqx_theme %>'
	});
	
	$('#variable_expander').jqxExpander({
		width: '280px', height: '300px', showArrow: false, toggleMode: 'none', theme: '<%=jqx_theme %>'
	});
	
	$('#variable_list').jqxListBox({
		source: index_data,
		         checkboxes: false,
		multiple: false, width: '100%', height: '240px', theme: '<%=jqx_theme %>',
        displayMember:'<fmt:message key="data.field" />',valueMember:'id'

	});
	
	$('#variable_add_button').jqxButton({
		width: '92px', height: '30px', theme: '<%=jqx_theme %>'
	});
	
	$('#variable_delete_button').jqxButton({
		width: '92px', height: '30px', theme: '<%=jqx_theme %>'
	});
	
	$('#variable_edit_button').jqxButton({
		width: '92px', height: '30px', theme: '<%=jqx_theme %>'
	});
	
	$('#dialog_window').jqxWindow({
		width: 400, height: 'auto', resizable: false,  isModal: true, autoOpen: false,
		okButton: $("#dialog_window_ok_button"), cancelButton: $("#dialog_window_cancel_button"),
		modalOpacity: 0.3, theme: '<%=jqx_theme %>'
	});
	$("#dialog_window_ok_button").jqxButton({
		theme: '<%=jqx_theme %>'
	});
	$("#dialog_window_cancel_button").jqxButton({
		theme: '<%=jqx_theme %>'
	});
	
	$('#message_notification').jqxNotification({
		width: 'auto', position: "bottom-right", opacity: 0.9, template: 'success', theme: '<%=jqx_theme %>'
	});

	// 数据请求

    $.ajax({
        type:'GET',
        url:host+'/quantify/agriculture_kinds',
        data: {},
        xhrFields: {
            withCredentials: true
        },
        crossDomain: true,
        success: function (resp) {
            for (var index in resp.data) {
                kind_data.push(resp.data[index])
            }
            $('#product_list').jqxListBox('refresh')

            console.log(kind_data,'kind')}.bind(this)
    });

	// 事件處理


    $('#cat_add_button').on('click', function(event) {
        $('#dialog_window_content').html('<p>请输入表在数据库的名字: <input type="text" id="d_table_editor_name"></p>\n ' +
            '<p>请输入表的中文名: <input type="text" id="d_table_editor_cn_alis"></p> ' +
            '<p>请输入表的英文名<input type="text" id="d_table_editor_en_alis"></p>' )
        $('#dialog_window').one('close', function(event) {
            if(event.args.dialogResult.OK) {

                var post_data = {name:'', cn_alis: '', en_alis:''}
                post_data.name = $('#d_table_editor_name').val()
                post_data.cn_alis = $('#d_table_editor_cn_alis').val()
                post_data.en_alis = $('#d_table_editor_en_alis').val()
                console.log('post', post_data)
                $.ajax({
                    type:'POST',
                    url:host+'/quantify/agriculture_table',
                    data: post_data,
                    xhrFields: {
                        withCredentials: true
                    },
                    crossDomain: true,
                    async: false,
                    success: function (resp) {
                        $('#message_notification_content').html('编辑成功。');
                        $('#message_notification').jqxNotification('open');
                        window.location.reload()
                    }
                })

            }
        });
        $('#dialog_window').jqxWindow('open');
    });


    $('#cat_edit_button').on('click', function(event) {
        $('#dialog_window_content').html('<p>请输入表在数据库的名字: <input type="text" id="d_table_editor_name"></p>\n ' +
            '<p>请输入表的中文名: <input type="text" id="d_table_editor_cn_alis"></p> ' +
            '<p>请输入表的英文名<input type="text" id="d_table_editor_en_alis"></p>' )
        $('#dialog_window').one('close', function(event) {
            if(event.args.dialogResult.OK) {

                var post_data = {id: '',name:'', cn_alis: '', en_alis:''}

                post_data.name = $('#d_table_editor_name').val()
                post_data.cn_alis = $('#d_table_editor_cn_alis').val()
                post_data.en_alis = $('#d_table_editor_en_alis').val()
                post_data.id = $('#cat_tree').jqxTree('getSelectedItem').value
                console.log('post', post_data)
                $.ajax({
                    type:'PUT',
                    url:host+'/quantify/agriculture_table',
                    data: post_data,
                    xhrFields: {
                        withCredentials: true
                    },
                    crossDomain: true,
                    async: false,
                    success: function (resp) {
                        $('#message_notification_content').html('编辑成功。');
                        $('#message_notification').jqxNotification('open');
                        window.location.reload()
                    }
                })

            }
        });
        $('#dialog_window').jqxWindow('open');
    })

    $('#variable_add_button').on('click', function(event) {
        $('#dialog_window_content').html('<table><tr><td>请输入名称:</td><td><input id="d_index_editor_name" type="type"></td></tr>'
            + '<tr><td>请输入单位:</td><td><input id="d_index_editor_unit" type="text"></td></tr>'+
            '\'<tr><td>请输入中文名:</td><td><input id="d_index_editor_cn_alis" type="text"></td></tr>'+
            '<tr><td>请输入英文名:</td><td><input id="d_index_editor_en_alis" type="text"></td></tr>'+'</table>');
        $('#dialog_window').one('close', function(event) {

            if(event.args.dialogResult.OK) {
                var post_data = {name:'', cn_alis: '', en_alis:'', unit:'', table_id:0}

                post_data.name = $('#d_index_editor_name').val()
                post_data.cn_alis = $('#d_index_editor_cn_alis').val()
                post_data.en_alis = $('#d_index_editor_en_alis').val()
                post_data.unit = $('#d_index_editor_unit').val()
                post_data.table_id = $('#cat_tree').jqxTree('getSelectedItem').value
                $.ajax({
                    type:'POST',
                    url:host+'/quantify/agriculture_index',
                    data: post_data,
                    xhrFields: {
                        withCredentials: true
                    },
                    crossDomain: true,
                    async: false,
                    success: function (resp) {
                        if(event.args.dialogResult.OK) {
                            $('#message_notification_content').html('编辑成功。');
                            $('#message_notification').jqxNotification('open');
                            window.location.reload();
                        }
                    }
                })
            }

        });
        $('#dialog_window').jqxWindow('open');
    });

    $('#variable_edit_button').on('click', function(event) {
        $('#dialog_window_content').html('<table><tr><td>请输入名称:</td><td><input id="d_index_editor_name" type="type"></td></tr>'
            + '<tr><td>请输入单位:</td><td><input id="d_index_editor_unit" type="text"></td></tr>'+
            '\'<tr><td>请输入中文名:</td><td><input id="d_index_editor_cn_alis" type="text"></td></tr>'+
            '<tr><td>请输入英文名:</td><td><input id="d_index_editor_en_alis" type="text"></td></tr>'+'</table>');
        $('#dialog_window').one('close', function(event) {

            var post_data = {name:'', cn_alis: '', en_alis:'', unit:'', table_id:0}


            post_data.name = $('#d_index_editor_name').val()
            post_data.cn_alis = $('#d_index_editor_cn_alis').val()
            post_data.en_alis = $('#d_index_editor_en_alis').val()
            post_data.unit = $('#d_index_editor_unit').val()
            post_data.table_id = $('#cat_tree').jqxTree('getSelectedItem').value
            post_data.id = $('#variable_list').jqxListBox('getSelectedItem').value
            if(event.args.dialogResult.OK) {
                $.ajax({
                    type:'PUT',
                    url:host+'/quantify/agriculture_index',
                    data: post_data,
                    xhrFields: {
                        withCredentials: true
                    },
                    crossDomain: true,
                    async: false,
                    success: function (resp) {

                        $('#message_notification_content').html('编辑成功。');
                        $('#message_notification').jqxNotification('open');
                        window.location.reload();

                    }
                })
            }
        });
        $('#dialog_window').jqxWindow('open');
    });


    $('#variable_delete_button').on('click', function(event) {
        $('#dialog_window_content').html('是否删除？');
        $('#dialog_window').one('close', function(event) {
            if(event.args.dialogResult.OK) {
                console.log("index delete")
                var post_data = {id:$('#variable_list').jqxListBox('getSelectedItem').value}
                console.log('post', post_data)
                $.ajax({
                    type:'DELETE',
                    url:host+'/quantify/agriculture_index',
                    data: post_data,
                    xhrFields: {
                        withCredentials: true
                    },
                    crossDomain: true,
                    async: false,
                    success: function (resp) {
                        $('#message_notification_content').html('删除成功。');
                        $('#message_notification').jqxNotification('open');
                        window.location.reload()
                    }
                })
            }
        });
        $('#dialog_window').jqxWindow('open');
    });


    $('#product_add_button').on('click', function(event) {
        $('#dialog_window_content').html('<table><tr><td>请输入名称:</td><td><input id="d_kind_editor_name" type="type"></td></tr>'
            + '\'<tr><td>请输入中文名:</td><td><input id="d_kind_editor_cn_alis" type="text"></td></tr>'+
            '<tr><td>请输入英文名:</td><td><input id="d_kind_editor_en_alis" type="text"></td></tr>'+'</table>');
        $('#dialog_window').one('close', function(event) {

            if(event.args.dialogResult.OK) {
                var post_data = {name:'', cn_alis: '', en_alis:''}
                post_data.name = $('#d_kind_editor_name').val()
                post_data.cn_alis = $('#d_kind_editor_cn_alis').val()
                post_data.en_alis = $('#d_kind_editor_en_alis').val()
                $.ajax({
                    type:'POST',
                    url:host+'/quantify/agriculture_kinds',
                    data: post_data,
                    xhrFields: {
                        withCredentials: true
                    },
                    crossDomain: true,
                    async: false,
                    success: function (resp) {
                        if(event.args.dialogResult.OK) {
                            $('#message_notification_content').html('编辑成功。');
                            $('#message_notification').jqxNotification('open');
                            window.location.reload();
                        }
                    }
                })
            }



        });
        $('#dialog_window').jqxWindow('open');
    });

    $('#product_edit_button').on('click', function(event) {
        $('#dialog_window_content').html('<table><tr><td>请输入名称:</td><td><input id="d_kind_editor_name" type="type"></td></tr>'   +
            '\'<tr><td>请输入中文名:</td><td><input id="d_kind_editor_cn_alis" type="text"></td></tr>'+
            '<tr><td>请输入英文名:</td><td><input id="d_kind_editor_en_alis" type="text"></td></tr>'+'</table>');
        $('#dialog_window').one('close', function(event) {
            var post_data = {name:'', cn_alis: '', en_alis:''}


            post_data.name = $('#d_kind_editor_name').val()
            post_data.cn_alis = $('#d_kind_editor_cn_alis').val()
            post_data.en_alis = $('#d_kind_editor_en_alis').val()
            if(event.args.dialogResult.OK) {
                $.ajax({
                    type:'PUT',
                    url:host+'/quantify/agriculture_kinds',
                    data: post_data,
                    xhrFields: {
                        withCredentials: true
                    },
                    crossDomain: true,
                    async: false,
                    success: function (resp) {

                        $('#message_notification_content').html('编辑成功。');
                        $('#message_notification').jqxNotification('open');
                        window.location.reload();

                    }
                })
            }
        });
        $('#dialog_window').jqxWindow('open');
    });


    $('#product_delete_button').on('click', function(event) {
        $('#dialog_window_content').html('是否删除？');
        $('#dialog_window').one('close', function(event) {
            if(event.args.dialogResult.OK) {
                console.log("kind delete")
                var post_data = {id:$('#product_list').jqxListBox('getSelectedItem').id}
                console.log('post', post_data)
                $.ajax({
                    type:'DELETE',
                    url:host+'/quantify/agriculture_kinds',
                    data: post_data,
                    xhrFields: {
                        withCredentials: true
                    },
                    crossDomain: true,
                    async: false,
                    success: function (resp) {
                        $('#message_notification_content').html('删除成功。');
                        $('#message_notification').jqxNotification('open');
                        window.location.reload()
                    }
                })
            }
        });
        $('#dialog_window').jqxWindow('open');
    });

    // 处理事件
    $('#cat_tree').on('select',function (event)
    {
        var args = event.args;
        var item = $('#cat_tree').jqxTree('getItem', args.element);

        index_data.splice(0,index_data.length);
        for (var i in table_index_data[item.id]) {
            index_data.push({label:table_index_data[item.id][i].<fmt:message key="data.field" />, value:table_index_data[item.id][i].id, id:table_index_data[item.id][i].id})
        }
        $('#variable_list').jqxListBox('refresh')
        console.log("change", index_data)
    });
});

</script>
</head>
<body>

<jsp:include page="../includes/html_body_header.jsp" />


<div id="nav2_tabs" style="border: none;">
	<ul>
		<li style="margin-left: 30px;">
			<div style="height: 20px; margin-top: 5px;">
				<div style="margin-left: 4px; vertical-align: middle; text-align: center;">
					<fmt:message key="nav.system_admin.indicator.econ" />
				</div>
			</div>
		</li>
		<li>
			<div style="height: 20px; margin-top: 5px;">
				<div style="margin-left: 4px; vertical-align: middle; text-align: center;">
					<fmt:message key="nav.system_admin.indicator.agri" />
				</div>
			</div>
		</li>
	</ul>
	<div></div>
	<div></div>
</div>

<div style="padding: 25px;">
	<h1><fmt:message key="nav.system_admin.indicator.agri" /></h1>
</div>

<div id="cat_expander" class="left margin_15">
	<div><fmt:message key="text.category" /></div>
	<div style="overflow: hidden;">
		<div id="cat_tree" style="border: none;"></div>
		<input type="button" id="cat_add_button" value="<fmt:message key="text.add" />" class="left">
		<input type="button" id="cat_delete_button" value="<fmt:message key="text.delete" />" class="left">
		<input type="button" id="cat_edit_button" value="<fmt:message key="text.edit" />" class="left">
		<div class="clear"></div>
	</div>
</div>

<div class="left margin_15" style="width: 650px;">
	<div style="width: 650px;">
		<div id="product_expander" class="left">
			<div><fmt:message key="common.dimension.product" /></div>
			<div style="overflow: hidden;">
				<div id="product_list" style="border: none;"></div>
				<input type="button" id="product_add_button" value="<fmt:message key="text.add" />" class="left">
				<input type="button" id="product_delete_button" value="<fmt:message key="text.delete" />" class="left">
				<input type="button" id="product_edit_button" value="<fmt:message key="text.edit" />" class="left">
				<div class="clear"></div>
			</div>
		</div>
		<div class="left margin_20"></div>
		<div id="variable_expander" class="left">
			<div><fmt:message key="common.dimension.indicator" /></div>
			<div style="overflow: hidden;">
				<div id="variable_list" style="border: none;"></div>
				<input type="button" id="variable_add_button" value="<fmt:message key="text.add" />" class="left">
				<input type="button" id="variable_delete_button" value="<fmt:message key="text.delete" />" class="left">
				<input type="button" id="variable_edit_button" value="<fmt:message key="text.edit" />" class="left">
				<div class="clear"></div>
			</div>
		</div>
		<div class="clear"></div>
	</div>
</div>

<div class="clear"></div>

<div id="dialog_window">
	<div>请选择</div>
	<div style="overflow: hidden;">
		<div id="dialog_window_content" style="margin: 20px; height: 50px;">&nbsp;</div>
		<div class="right margin_10">
			<input type="button" id="dialog_window_ok_button" value="<fmt:message key="comm.ok" />">
			<input type="button" id="dialog_window_cancel_button" value="<fmt:message key="comm.cancel" />">
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
