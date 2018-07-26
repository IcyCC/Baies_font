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

page_id = 0;

$(document).ready(function() {

    var country_data=[];
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
        }
    })

    $('#cat_tabs').jqxTabs({width: '998px', position: 'top', theme: '<%=jqx_theme %>'});
	
	var rows = $("#news_ul");
	var data_kind_1 = [];
	var data_kind_2 = [];
	var data_kind_3 = [];
	var data_kind_4 = [];


    var upload_url = ''
	// for (var i = 0; i < 100; i++) {
	// 	var row = rows[0];
	// 	var datarow = {};
	// 	datarow['picture'] = $(row).find('li:nth-child(1)').html();
	// 	datarow['title'] = $(row).find('li:nth-child(2)').html();
	// 	datarow['author'] = $(row).find('li:nth-child(3)').html();
	// 	datarow['create_time'] = $(row).find('li:nth-child(4)').html();
	// 	datarow['modify_time'] = $(row).find('li:nth-child(5)').html();
	// 	datarow['status'] = $(row).find('li:nth-child(6)').find('span:nth-child('+(Math.floor(Math.random()*3)+1)+')').html();
	// 	datarow['operation'] = $(row).find('li:nth-child(7)').html();
	// 	data[data.length] = datarow;
	// }

    $.ajax({
        type:'GET',
        url:host+'/qualitative/Post',
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
				datarow['title'] = resp.data[index].title
				datarow['author'] = resp.data[index].user.username
				datarow['create_time'] = resp.data[index].timestamp
				datarow['status'] = resp.data[index].show
				datarow['operation'] = $(row).find('li:nth-child(7)').html();
				datarow['body'] = resp.data[index].body
				datarow['kind_id'] = resp.data[index].kind_id
                datarow['img_url'] = resp.data[index].img_url
				datarow['picture'] =  "<img width='50px' height='30px' src="+ resp.data[index].img_url +" >"+"</img>"
				datarow['country_id'] = resp.data[index].country_id

                switch(datarow['kind_id'])
                {
                    case 1:
                        data_kind_1[data_kind_1.length] = datarow;
                        break;
                    case 2:
                        data_kind_2[data_kind_2.length] = datarow;
                        break;
                    case 3:
                        data_kind_3[data_kind_3.length] = datarow;
                        break;
                    case 4:
                        data_kind_4[data_kind_4.length] = datarow;
                        break;
					default:
					    break;
                }


            }
        }
    });

	var source_kind_1 = {
			localdata: data_kind_1,
			datatype: 'array',
			datafields: [{name:'id', type:'number'},
			    		 {name: 'picture', type: 'string'},
			             {name: 'title', type: 'string'},
			             {name: 'author', type: 'string'},
			             {name: 'create_time', type: 'string'},
			             {name: 'status', type: 'string'},
			             {name: 'operation', type: 'string'},
				         {name: 'body', type:'string'},
				         {name: 'kind_id', type:'string'},
				         {name: 'country_id', type: 'number'}]
	};

	var dataAdapter_kind_1 = new $.jqx.dataAdapter(source_kind_1);
	var settings_kind_1 = {
			width: '900px',
			source: dataAdapter_kind_1,
			autoheight: true,
			autorowheight: true,
			showheader: true,
			pageable: true,
			pagesize: 10,
			theme: '<%=jqx_theme %>',
			columns: [
                      {text: '<fmt:message key="post.img_url" />', dataField: 'picture', width: 80, align: 'center'},
			          {text: '<fmt:message key="post.title" />', dataField: 'title', width: 320, align: 'center'},
			          {text: '<fmt:message key="text.author" />', dataField: 'author', width: 120, align: 'center', cellsalign: 'center'},
			          {text: '<fmt:message key="post.create_time" />', dataField: 'create_time', width: 140, align: 'center', cellsalign: 'center'},
			          // {text: '修改时间', dataField: 'modify_time', width: 100, align: 'center', cellsalign: 'center'},
                          {text: '<fmt:message key="post.status" />', dataField: 'status', width: 80, align: 'center', cellsalign: 'center'},
			          {text: '<fmt:message key="comm.operation" />', dataField: 'operation', width: 120, align: 'center', cellsalign: 'center'}
			          ],
			showtoolbar: true,
			rendertoolbar: function(toolbar) {
				var container = $('<div style="margin: 5px 10px 5px 5px; text-align: right;"></div>');
				toolbar.append(container);
				container.append('<input id="addrowbutton" type="button" value="<fmt:message key="comm.new" />" />');
				$("#addrowbutton").jqxButton();
				$("#addrowbutton").on('click', function () {
					$('#edit_title_input').val('');
					$('#edit_content_editor').val('');
					$('#country_input').val('');
					$('#edit_window').jqxWindow('open');

                    $("#cover-input-file").one("change", function(){
                        console.log("uopload")
						var formData = new FormData()
						formData.append('file',$('#cover-input-file')[0].files[0])
                        $.ajax({
                            url: host + "/user/upload",
                            type: 'POST',
                            cache: false,
                            async: false,
                            data: formData,
                            processData: false,
                            contentType: false,
                            dataType:"json",
                            beforeSend: function(){
                            },
                            success : function(resp) {
                                console.log(resp)
                                upload_url = resp.data
                            }
                        });
                    });

                    $("#edit_window_ok_button").one('click', function(event) {
                        var post_data = {title:"", body:"", kind_id:"", img_url:'/'}

                        post_data.title = $('#edit_title_input').val();
                        post_data.body = $('#edit_content_editor').val();
                        post_data.kind_id = 1
						post_data.country_id = $('#country_input').val()

						if (post_data.img_url !== ''){
                            post_data.img_url = host+upload_url
						}

                        console.log("add a post", post_data)
                        $.ajax({
                            type:'POST',
                            url:host+'/qualitative/Post',
                            data: post_data,
                            xhrFields: {
                                withCredentials: true
                            },
                            crossDomain: true,
                            async: false,
                            success: function (resp) {
                                    $('#message_notification_content').html('信息已保存。');
                                    $('#message_notification').jqxNotification('open');
                                    window.location.reload();
                            }
                        })
                    });
				});
			}
	};

    var source_kind_2 = {
        localdata: data_kind_2,
        datatype: 'array',
        datafields: [{name:'id', type:'number'},
            {name: 'picture', type: 'string'},
            {name: 'title', type: 'string'},
            {name: 'author', type: 'string'},
            {name: 'create_time', type: 'string'},
            {name: 'status', type: 'string'},
            {name: 'operation', type: 'string'},
            {name: 'body', type:'string'},
            {name: 'kind_id', type:'string'},
            {name: 'country_id', type: 'number'}]

    };

    var dataAdapter_kind_2 = new $.jqx.dataAdapter(source_kind_2);
    var settings_kind_2 = {
        width: '850px',
        source: dataAdapter_kind_2,
        autoheight: true,
        autorowheight: true,
        showheader: true,
        pageable: true,
        pagesize: 10,
        theme: '<%=jqx_theme %>',
        columns: [
            {text: '<fmt:message key="post.img_url" />', dataField: 'picture', width: 80, align: 'center'},
            {text: '<fmt:message key="post.title" />', dataField: 'title', width: 320, align: 'center'},
            {text: '<fmt:message key="text.author" />', dataField: 'author', width: 120, align: 'center', cellsalign: 'center'},
            {text: '<fmt:message key="post.create_time" />', dataField: 'create_time', width: 140, align: 'center', cellsalign: 'center'},
            // {text: '修改时间', dataField: 'modify_time', width: 100, align: 'center', cellsalign: 'center'},
            {text: '<fmt:message key="post.status" />', dataField: 'status', width: 80, align: 'center', cellsalign: 'center'},
            {text: '<fmt:message key="comm.operation" />', dataField: 'operation', width: 120, align: 'center', cellsalign: 'center'}
        ],
        showtoolbar: true,
        rendertoolbar: function(toolbar) {
            var container = $('<div style="margin: 5px 10px 5px 5px; text-align: right;"></div>');
            toolbar.append(container);
            container.append('<input id="addrowbutton2" type="button" value="<fmt:message key="comm.new" />" />');
            $("#addrowbutton2").jqxButton();
            $("#addrowbutton2").on('click', function () {
                $('#edit_title_input').val('');
                $('#edit_content_editor').val('');
                $('#edit_window').jqxWindow('open');
                $("#cover-input-file").one("change", function(){
                    console.log("uopload")
                    var formData = new FormData()
                    formData.append('file',$('#cover-input-file')[0].files[0])
                    $.ajax({
                        url: host + "/user/upload",
                        type: 'POST',
                        cache: false,
                        async: false,
                        data: formData,
                        processData: false,
                        contentType: false,
                        dataType:"json",
                        beforeSend: function(){
                        },
                        success : function(resp) {
                            console.log(resp)
                            upload_url = resp.data
                        }
                    });
                });

                $("#edit_window_ok_button").one('click', function(event) {
                    var post_data = {title:"", body:"", kind_id:"", img_url:'/'}


                    if (post_data.img_url !== ''){
                        post_data.img_url = host+upload_url
                    }

                    post_data.title = $('#edit_title_input').val();
                    post_data.body = $('#edit_content_editor').val();
                    post_data.kind_id = 2
                    post_data.country_id = $('#country_input').val()

                    console.log("add a post", post_data)
                    $.ajax({
                        type:'POST',
                        url:host+'/qualitative/Post',
                        data: post_data,
                        xhrFields: {
                            withCredentials: true
                        },
                        crossDomain: true,
                        async: false,
                        success: function (resp) {
                            $('#message_notification_content').html('信息已保存。');
                            $('#message_notification').jqxNotification('open');
                            window.location.reload();
                        }
                    })
                });
            });
        }
    };

    var source_kind_3 = {
        localdata: data_kind_3,
        datatype: 'array',
        datafields: [{name:'id', type:'number'},
            {name: 'picture', type: 'string'},
            {name: 'title', type: 'string'},
            {name: 'author', type: 'string'},
            {name: 'create_time', type: 'string'},
            {name: 'status', type: 'string'},
            {name: 'operation', type: 'string'},
            {name: 'body', type:'string'},
            {name: 'kind_id', type:'string'},
            {name: 'country_id', type: 'number'}]


    };

    var dataAdapter_kind_3 = new $.jqx.dataAdapter(source_kind_3);
    var settings_kind_3 = {
        width: '850px',
        source: dataAdapter_kind_3,
        autoheight: true,
        autorowheight: true,
        showheader: true,
        pageable: true,
        pagesize: 10,
        theme: '<%=jqx_theme %>',
        columns: [
            {text: '<fmt:message key="post.img_url" />', dataField: 'picture', width: 80, align: 'center'},
            {text: '<fmt:message key="post.title" />', dataField: 'title', width: 320, align: 'center'},
            {text: '<fmt:message key="text.author" />', dataField: 'author', width: 120, align: 'center', cellsalign: 'center'},
            {text: '<fmt:message key="post.create_time" />', dataField: 'create_time', width: 140, align: 'center', cellsalign: 'center'},
            // {text: '修改时间', dataField: 'modify_time', width: 100, align: 'center', cellsalign: 'center'},
            {text: '<fmt:message key="post.status" />', dataField: 'status', width: 80, align: 'center', cellsalign: 'center'},
            {text: '<fmt:message key="comm.operation" />', dataField: 'operation', width: 120, align: 'center', cellsalign: 'center'}
        ],
        showtoolbar: true,
        rendertoolbar: function(toolbar) {
            var container = $('<div style="margin: 5px 10px 5px 5px; text-align: right;"></div>');
            toolbar.append(container);
            container.append('<input id="addrowbutton3" type="button" value="<fmt:message key="comm.new" />" />');
            $("#addrowbutton3").jqxButton();
            $("#addrowbutton3").on('click', function () {
                $('#edit_title_input').val('');
                $('#edit_content_editor').val('');
                $('#edit_window').jqxWindow('open');
                $("#cover-input-file").one("change", function(){
                    console.log("uopload")
                    var formData = new FormData()
                    formData.append('file',$('#cover-input-file')[0].files[0])
                    $.ajax({
                        url: host + "/user/upload",
                        type: 'POST',
                        cache: false,
                        async: false,
                        data: formData,
                        processData: false,
                        contentType: false,
                        dataType:"json",
                        beforeSend: function(){
                        },
                        success : function(resp) {
                            console.log(resp)
                            upload_url = resp.data
                        }
                    });
                });

                $("#edit_window_ok_button").one('click', function(event) {
                    var post_data = {title:"", body:"", kind_id:"", img_url:'/'}


                    if (post_data.img_url !== ''){
                        post_data.img_url = host+upload_url
                    }


                    post_data.title = $('#edit_title_input').val();
                    post_data.body = $('#edit_content_editor').val();
                    post_data.kind_id = 3
                    post_data.country_id = $('#country_input').val()
                    console.log("add a post", post_data)
                    $.ajax({
                        type:'POST',
                        url:host+'/qualitative/Post',
                        data: post_data,
                        xhrFields: {
                            withCredentials: true
                        },
                        crossDomain: true,
                        async: false,
                        success: function (resp) {
                            $('#message_notification_content').html('信息已保存。');
                            $('#message_notification').jqxNotification('open');
                            window.location.reload();
                        }
                    })
                });
            });
        }
    };

    var source_kind_4 = {
        localdata: data_kind_4,
        datatype: 'array',
        datafields: [{name:'id', type:'number'},
            {name: 'picture', type: 'string'},
            {name: 'title', type: 'string'},
            {name: 'author', type: 'string'},
            {name: 'create_time', type: 'string'},
            {name: 'status', type: 'string'},
            {name: 'operation', type: 'string'},
            {name: 'body', type:'string'},
            {name: 'kind_id', type:'string'},
            {name: 'country_id', type: 'number'}]

    };

    var dataAdapter_kind_4 = new $.jqx.dataAdapter(source_kind_4);
    var settings_kind_4 = {
        width: '850px',
        source: dataAdapter_kind_4,
        autoheight: true,
        autorowheight: true,
        showheader: true,
        pageable: true,
        pagesize: 10,
        theme: '<%=jqx_theme %>',
        columns: [
            {text: '<fmt:message key="post.img_url" />', dataField: 'picture', width: 80, align: 'center'},
            {text: '<fmt:message key="post.title" />', dataField: 'title', width: 320, align: 'center'},
            {text: '<fmt:message key="text.author" />', dataField: 'author', width: 120, align: 'center', cellsalign: 'center'},
            {text: '<fmt:message key="post.create_time" />', dataField: 'create_time', width: 140, align: 'center', cellsalign: 'center'},
            // {text: '修改时间', dataField: 'modify_time', width: 100, align: 'center', cellsalign: 'center'},
            {text: '<fmt:message key="post.status" />', dataField: 'status', width: 80, align: 'center', cellsalign: 'center'},
            {text: '<fmt:message key="comm.operation" />', dataField: 'operation', width: 120, align: 'center', cellsalign: 'center'}
        ],
        showtoolbar: true,
        rendertoolbar: function(toolbar) {
            var container = $('<div style="margin: 5px 10px 5px 5px; text-align: right;"></div>');
            toolbar.append(container);
            container.append('<input id="addrowbutton4" type="button" value="<fmt:message key="comm.new" />" />');
            $("#addrowbutton4").jqxButton();
            $("#addrowbutton4").on('click', function () {
                $('#edit_title_input').val('');
                $('#edit_content_editor').val('');
                $('#edit_window').jqxWindow('open');
                $("#edit_window_ok_button").one('click', function(event) {
                    var post_data = {title:"", body:"", kind_id:""}

                    post_data.title = $('#edit_title_input').val();
                    post_data.body = $('#edit_content_editor').val();
                    post_data.kind_id = 4
                    post_data.country_id = $('#country_input').val()
                    console.log("add a post", post_data)
                    $.ajax({
                        type:'POST',
                        url:host+'/qualitative/Post',
                        data: post_data,
                        xhrFields: {
                            withCredentials: true
                        },
                        crossDomain: true,
                        async: false,
                        success: function (resp) {
                            $('#message_notification_content').html('信息已保存。');
                            $('#message_notification').jqxNotification('open');
                            window.location.reload();
                        }
                    })
                });
            });
        }
    };

	$('#news_grid_1').jqxGrid(settings_kind_1);
	$('#news_grid_2').jqxGrid(settings_kind_2);
	$('#news_grid_3').jqxGrid(settings_kind_3);
	$('#news_grid_4').jqxGrid(settings_kind_4);
    $('#country_input').jqxDropDownList({ source: country_data, displayMember: '<fmt:message key="data.field" />', valueMember: "id" ,width: '250px', height: '20px'})

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

	
	$('.delete_buttons').on('click', function() {
		$('#dialog_window_content').html('是否删除本信息？');
		$('#dialog_window').one('close', function(event) {
			if(event.args.dialogResult.OK) {
				$('#message_notification_content').html('信息已删除。');
				$('#message_notification').jqxNotification('open');
			}
		});
		$('#dialog_window').jqxWindow('open');
	});

    $('#edit_window').jqxWindow({
		width: 700, height: 580, resizable: false,  isModal: true, autoOpen: false,
		okButton: $("#edit_window_ok_button"), cancelButton: $("#edit_window_cancel_button"),
		modalOpacity: 0.3, theme: '<%=jqx_theme %>'
	});
	
	$('#edit_title_input').jqxInput({
		width: 600, theme: '<%=jqx_theme %>'
	});
	
	$('#edit_content_editor').jqxEditor({
		width: 660, height: 420, theme: '<%=jqx_theme %>'
	});
	
	$("#edit_window_ok_button").jqxButton({
		theme: '<%=jqx_theme %>'
	});
	

	
	$("#edit_window_cancel_button").jqxButton({
		theme: '<%=jqx_theme %>'
	});
	
	$('#message_notification').jqxNotification({
		width: 'auto', position: "bottom-right", opacity: 0.9, template: 'success', theme: '<%=jqx_theme %>'
	});





    $("#news_grid_1").on("cellclick", function (event)
    {
        // event arguments.
        var args = event.args;

        var post = args.row.bounddata;
        console.log(args)


        $('.edit_buttons').one('click', function() {
            $('#edit_title_input').val(post.title);
            $('#country_input').val(post.id);
            $('#edit_content_editor').val($('<div />').html(post.body).text());
            $('#edit_window').jqxWindow('open');


            $("#cover-input-file").one("change", function(){
				console.log("uopload")
                var formData = new FormData()
                formData.append('file',$('#cover-input-file')[0].files[0])
                $.ajax({
                    url: host + "/user/upload",
                    type: 'POST',
                    cache: false,
                    async: false,
                    data: formData,
                    processData: false,
                    contentType: false,
                    dataType:"json",
                    beforeSend: function(){
                    },
                    success : function(resp) {
                        console.log(resp)
						upload_url = resp.data
                    }
                });
            });


            $('#edit_window_ok_button').one('click', function (event) {
                console.log(post)
                var post_data = {
                    body: "",
                    kind_id: 1,
                    title: "",
					img_url: post.img_url
                };

                if (upload_url !== '') {
                    post_data.img_url = host + upload_url
				}



                post_data.title = $('#edit_title_input').val();
                post_data.body = $('#edit_content_editor').val();
                post_data.country_id = $('#country_input').val()

                console.log("change user", post_data)

                $.ajax({
                    type:'PUT',
                    url:host+'/qualitative/Post/'+post.id,
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
            console.log("delete use ", post)
            $('#dialog_window_ok_button').one('click', function (event) {
                console.log("delete use ok", post)
                $.ajax({
                    type:'DELETE',
                    url:host+'/qualitative/Post/'+post.id,
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

    $("#news_grid_2").on("cellclick", function (event)
    {
        // event arguments.
        var args = event.args;

        var post = args.row.bounddata;
        console.log(args)

        $('.edit_buttons').one('click', function() {
            $('#edit_title_input').val(post.title);
            $('#edit_content_editor').val($('<div />').html(post.body).text());
            $('#edit_window').jqxWindow('open');
            $('#country_input').val(post.country_id)

            $("#cover-input-file").one("change", function(){
                console.log("uopload")
                var formData = new FormData()
                formData.append('file',$('#cover-input-file')[0].files[0])
                $.ajax({
                    url: host + "/user/upload",
                    type: 'POST',
                    cache: false,
                    async: false,
                    data: formData,
                    processData: false,
                    contentType: false,
                    dataType:"json",
                    beforeSend: function(){
                    },
                    success : function(resp) {
                        console.log(resp)
                        upload_url = resp.data
                    }
                });
            });


            $('#edit_window_ok_button').one('click', function (event) {
                console.log(post)
                var post_data = {
                    body: "",
                    kind_id: 2,
                    title: ""
                };

                if (upload_url !== '') {
                    post_data.img_url = host + upload_url
                }

                post_data.title = $('#edit_title_input').val();
                post_data.body = $('#edit_content_editor').val();
                post_data.country_id = $('#country_input').val()
                console.log("change user", post_data)

                $.ajax({
                    type:'PUT',
                    url:host+'/qualitative/Post/'+post.id,
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
            console.log("delete use ", post)
            $('#dialog_window_ok_button').one('click', function (event) {
                console.log("delete use ok", post)
                $.ajax({
                    type:'DELETE',
                    url:host+'/qualitative/Post/'+post.id,
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

    $("#news_grid_3").on("cellclick", function (event)
    {
        // event arguments.
        var args = event.args;

        var post = args.row.bounddata;
        console.log(args)

        $("#cover-input-file").one("change", function(){
            console.log("uopload")
            var formData = new FormData()
            formData.append('file',$('#cover-input-file')[0].files[0])
            $.ajax({
                url: host + "/user/upload",
                type: 'POST',
                cache: false,
                async: false,
                data: formData,
                processData: false,
                contentType: false,
                dataType:"json",
                beforeSend: function(){
                },
                success : function(resp) {
                    console.log(resp)
                    upload_url = resp.data
                }
            });
        });


        $('.edit_buttons').one('click', function() {
            $('#edit_title_input').val(post.title);
            $('#edit_content_editor').val($('<div />').html(post.body).text());
            $('#edit_window').jqxWindow('open');
            $('#country_input').val(post.country_id)


            $('#edit_window_ok_button').one('click', function (event) {
                console.log(post)
                var post_data = {
                    body: "",
                    kind_id: 3,
                    title: "",
					img_url: post.img_url
                };
                if (upload_url !== '') {
                    post_data.img_url = host + upload_url
                }
                post_data.title = $('#edit_title_input').val();
                post_data.body = $('#edit_content_editor').val();
                post_data.country_id = $('#country_input').val();


                console.log("change user", post_data)

                $.ajax({
                    type:'PUT',
                    url:host+'/qualitative/Post/'+post.id,
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
            console.log("delete use ", post)
            $('#dialog_window_ok_button').one('click', function (event) {
                console.log("delete use ok", post)
                $.ajax({
                    type:'DELETE',
                    url:host+'/qualitative/Post/'+post.id,
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

    $("#news_grid_4").on("cellclick", function (event)
    {
        // event arguments.
        var args = event.args;

        var post = args.row.bounddata;
        console.log(args)


        $('.edit_buttons').one('click', function() {
            $('#edit_title_input').val(post.title);
            $('#edit_content_editor').val($('<div />').html(post.body).text());
            $('#edit_window').jqxWindow('open');
            $('#country_input').val(post.country_id);

            $("#cover-input-file").one("change", function(){
                console.log("uopload")
                var formData = new FormData()
                formData.append('file',$('#cover-input-file')[0].files[0])
                $.ajax({
                    url: host + "/user/upload",
                    type: 'POST',
                    cache: false,
                    async: false,
                    data: formData,
                    processData: false,
                    contentType: false,
                    dataType:"json",
                    beforeSend: function(){
                    },
                    success : function(resp) {
                        console.log(resp)
                        upload_url = resp.data
                    }
                });
            });


            $('#edit_window_ok_button').one('click', function (event) {
                console.log(post)
                var post_data = {
                    body: "",
                    kind_id: 3,
                    title: "",
                    img_url: '/'
                };
                if (upload_url !== '') {
                    post_data.img_url = host + upload_url
                }
                post_data.title = $('#edit_title_input').val();
                post_data.body = $('#edit_content_editor').val();
                post_data.country_id = $('#country_input').val();

                console.log("change user", post_data)

                $.ajax({
                    type:'PUT',
                    url:host+'/qualitative/Post/'+post.id,
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
            console.log("delete use ", post)
            $('#dialog_window_ok_button').one('click', function (event) {
                console.log("delete use ok", post)
                $.ajax({
                    type:'DELETE',
                    url:host+'/qualitative/Post/'+post.id,
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

});

</script>
</head>
<body>

<jsp:include page="../includes/html_body_header.jsp" />


<div id="cat_tabs">
	<ul>
		<li style="margin-left: 10px;">
			<div style="height: 20px; margin-top: 5px;">
				<div style="margin-left: 4px; vertical-align: middle; text-align: center;">
					<fmt:message key="cat.dev" />
				</div>
			</div>
		</li>
		<li>
			<div style="height: 20px; margin-top: 5px;">
				<div style="margin-left: 4px; vertical-align: middle; text-align: center;">
					<fmt:message key="cat.trade" />
				</div>
			</div>
		</li>
		<li>
			<div style="height: 20px; margin-top: 5px;">
				<div style="margin-left: 4px; vertical-align: middle; text-align: center;">
					<fmt:message key="cat.tech" />
				</div>
			</div>
		</li>
		<li>
			<div style="height: 20px; margin-top: 5px;">
				<div style="margin-left: 4px; vertical-align: middle; text-align: center;">
					<fmt:message key="cat.fish" />
				</div>
			</div>
		</li>
	</ul>
	<div style="padding: 25px;">
		<h1>
			<fmt:message key="cat.dev" />
		</h1>
		<br><br>
		<div id="news_grid_1"></div>
	</div>
	<div style="padding: 25px;">
		<h1><fmt:message key="cat.trade" /></h1>
		<br><br>
		<div id="news_grid_2"></div>
	</div>
	<div style="padding: 25px;">
		<h1><fmt:message key="cat.tech" /></h1>
		<br><br>
		<div id="news_grid_3"></div>
	</div>
	<div style="padding: 25px;">
		<h1><fmt:message key="cat.fish" /></h1>
		<br><br>
		<div id="news_grid_4"></div>
	</div>
</div>

<ul id="news_ul" style="display: none;">
	<li><img src="../images/policy.png" style="width: 65px; height: 36px;"></li>
	<li><fmt:message key="temp.policy_title" /></li>
	<li><fmt:message key="temp.policy_author" /></li>
	<li>2016-07-01 08:00</li>
	<li>2016-07-04 10:39</li>

	<li><span>等待审核</span><span>审核通过</span><span>审核未通过</span></li>
	<li>
		<button>
			<img class="edit_buttons" src="../js/jqwidgets-4.1.2/styles/images/icon-edit.png"
				title="<fmt:message key="comm.editor" />" style="width: 16px; height: 16px; vertical-align: middle;">
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
			<input type="button" id="dialog_window_ok_button" value="<fmt:message key="comm.ok" />">
			<input type="button" id="dialog_window_cancel_button" value="<fmt:message key="comm.cancel" />">
		</div>
		<div class="clear"></div>
	</div>
</div>

<div id="edit_window">
	<div>录入信息</div>
	<div style="overflow: hidden; padding: 20px;">
		<div class="left" style="width: 50px;"><fmt:message key="post.title" />:</div>
		<input class="left" type="text" id="edit_title_input">
		<span><fmt:message key="post.img_url" />: <input type="file" id="cover-input-file" name="file" accept="image/*" style="height:40px"></span>
		<div><fmt:message key="common.dimension.country" />:<div id="country_input"></div></div>
		<textarea id="edit_content_editor"></textarea>
		<div class="right margin_10">
			<input type="button" id="edit_window_ok_button" value="<fmt:message key="comm.ok" />">
			<input type="button" id="edit_window_cancel_button" value="<fmt:message key="comm.cancel" />">
		</div>
		<div class="clear"></div>
	</div>
</div>

<div id="message_notification">
	<div id="message_notification_content"></div>
</div>

<div id="editor_content" style="display: none;">
&lt;p&gt;2015年，中央一号文件提出要加快发展草牧业。农业部在河北等12个省区的37个县（团、场）组织开展了草牧业发展试验试点。这项工作开展以来，各地在政策引导和市场拉动下积极探索，草牧业发展呈现良好势头，草产业和草食畜牧业加快发展，形成了一批可复制、可推广的典型。为加快推进草牧业发展，现提出以下意见。&lt;/p&gt;
&lt;div style=&quot;text-align: center;&quot;&gt;&lt;img src=&quot;../images/sv1.jpg&quot; style=&quot;width: 550px; height: 366px;&quot;&gt;&lt;/div&gt;
&lt;p&gt;&lt;b&gt;一、进一步认识发展草牧业的重要意义&lt;/b&gt;&lt;/p&gt;
&lt;p&gt;（一）发展草牧业是统筹农村牧区生态与生产的重要平台。草牧业以饲草资源的保护利用为基础，涵盖了草原保护建设、饲草及畜产品生产加工等环节，顺应了当前草原生态文明建设和畜牧业绿色发展的大趋势，为着力打造农牧结合、种养结合的生态循环发展模式提供有力支撑，有利于实现农村牧区生产、生活与生态的有机结合，协调发展。&lt;/p&gt;
&lt;p&gt;（二）发展草牧业是推进农业供给侧结构性改革的重要切入点。我国牛羊肉和奶产品竞争力不强。依托草牧业全产业链运作，推进草畜配套和产业化，实现好草产好肉、产好奶，满足消费者对更绿色、更丰富、更优质、更安全的草畜产品的需求，增强畜产品竞争力，提高供给结构的适应性和灵活性，提升农业供给体系质量和效率。&lt;/p&gt;
&lt;p&gt;（三）发展草牧业是农牧业增效和农牧民增收的重要举措。草牧业是牧区和贫困山区的传统产业、优势产业和支柱产业，约占农牧民纯收入的50%以上。发展草牧业，转变养殖方式，优化草畜产品生产结构，推进一二三产业融合，有助于挖潜力、提质量、增效益，大幅度增加农牧民收入，有利于农牧民脱贫致富奔小康。&lt;/p&gt;
&lt;p&gt;&lt;b&gt;二、总体要求&lt;/b&gt;&lt;/p&gt;
&lt;p&gt;&lt;b&gt;（一）指导思想&lt;/b&gt;&lt;/p&gt;
&lt;p&gt;全面贯彻党的十八大和十八届三中、四中、五中全会精神和中央农村工作会议精神，认真落实创新、协调、绿色、开放、共享发展理念，以持续推进草牧业科学发展为主线，坚持“生产生态有机结合、生态优先”的基本方针，创新制度、技术和组织方式，着力提升草原保护建设水平，实现生态稳步向好；着力促进草产业发展，加快建设现代饲草料产业体系；着力转变草食畜牧业发展方式，形成规模化生产、集约化经营的产业发展格局，为农牧业可持续发展和全面建成小康社会提供重要支撑。&lt;/p&gt;
&lt;p&gt;&lt;b&gt;（二）基本原则&lt;/b&gt;&lt;/p&gt;
&lt;p&gt;——生态优先，草畜配套。根据区域自然资源的承载能力，在确保生态安全的前提下开展草原保护建设，妥善处理生产发展与生态环境保护的关系，为养而种，草畜配套，良性循环，实现生产与生态协调发展。&lt;/p&gt;
&lt;p&gt;——优化布局，分区施策。综合考虑北方干旱半干旱区、青藏高寒区、东北华北湿润半湿润区和南方区的草原生态实际及草食畜牧业发展水平，统筹资源、产业、技术和市场等因素，结合全国种植业结构调整，科学确定发展重点和空间布局，推动形成绿色发展方式。&lt;/p&gt;
&lt;p&gt;——市场主导，政府引导。充分发挥市场配置资源的决定性作用，用好价格“指挥棒”和供求“杠杆”，激活草牧业发展内生动力。更好发挥政府引导作用，为各类经营主体营造良好的发展环境，构建多形式的利益联结机制。&lt;/p&gt;
&lt;p&gt;——产业融合，提升效益。加强顶层设计，统筹规划，加快促进一二三产业融合，培育多元化产业融合主体，大力发展新型业态，引导产业集聚发展，完善多渠道产业融合服务，提升草牧业生产效率和规模效益。&lt;/p&gt;
&lt;p&gt;&lt;b&gt;（三）主要目标&lt;/b&gt;&lt;/p&gt;
&lt;p&gt;到2020年，全国天然草原鲜草总产草量达到10.5亿吨，草原综合植被盖度达到56%，重点天然草原超载率小于10%，全国草原退化和超载过牧趋势得到遏制，草原保护制度体系逐步建立，草原生态环境明显改善；人工种草保留面积达到3.5亿亩，草产品商品化程度不断提高；牛羊肉总产量达到1300万吨以上，奶类达到4100万吨以上，草食畜牧业综合生产能力明显提升。&lt;/p&gt;
&lt;p&gt;&lt;b&gt;三、区域布局及主要模式&lt;/b&gt;&lt;/p&gt;
&lt;p&gt;&lt;b&gt;（一）北方干旱半干旱区&lt;/b&gt;&lt;/p&gt;
&lt;p&gt;1.基本情况：该区位于我国西北、华北北部以及东北西部地区，涉及河北、山西、内蒙古、辽宁、吉林、黑龙江、陕西、甘肃、宁夏和新疆等10个省（区），草原面积15994.86万公顷，是我国北方重要的生态屏障。该区域气候干旱少雨，年降水量一般在400毫米以下，降水分布不均，部分地区低于50 毫米。冷季寒冷漫长，暖季干燥炎热，水分蒸发量大，一般为降水量的几倍或几十倍。该区域以荒漠化草原为主，生态系统脆弱。草食畜牧业生产方式以“放牧+补饲”为主，经营模式多样。长期以来，由于重利用轻管护，超载过牧、滥采乱挖等问题较为严重，鼠虫害发生频繁，导致草原严重退化、沙化和盐碱化，水土流失和风沙危害日趋严重。&lt;/p&gt;
&lt;p&gt;2.主攻方向：着力治理退化草原，改善草原生态，重点实施退牧还草、京津风沙源治理、新一轮退耕还林还草、农牧交错带已垦草原治理、牧区草原防灾减灾等工程，全面实施好草原生态保护补助奖励政策，巩固北方重要的生态安全屏障。着力推进草食畜牧业提质增效、转型发展，重点实施肉牛肉羊养殖大县奖励、畜牧良种补贴、标准化规模养殖扶持、肉牛基础母牛扩群增量、畜禽养殖粪污综合利用等政策，同时加大饲草产业发展扶持力度，大力实施振兴奶业苜蓿发展行动，推进粮改饲试点，夯实草牧业发展的物质基础。&lt;/p&gt;
&lt;p&gt;3.推介模式：围绕“提质、增效、绿色”的基本方针，引导流转整合草场、牲畜等生产要素，发展家庭农（牧）场和农牧民合作社，走规模化养殖、标准化生产、品牌化经营的产业化发展道路。推介企业“立草为业、创新开拓、融合发展”的“互联网+草业”模式和特色家庭农（牧）场适度规模经营的“轮牧+补饲”模式等。&lt;/p&gt;
&lt;p&gt;&lt;b&gt;（二）青藏高寒区&lt;/b&gt;&lt;/p&gt;
&lt;p&gt;1.基本情况：该区位于我国青藏高原，涉及西藏、青海全境及四川、甘肃和云南部分地区, 草原面积13908.45万公顷，是长江、黄河、雅鲁藏布江等大江大河的发源地，是我国水源涵养、水土保持的核心区，享有中华民族“水塔”之称，也是我国生物多样性最丰富的地区之一。该区主要分布在海拔3000米以上，空气稀薄，气候寒冷，无霜期短。该区域以高寒草原为主，生态系统极度脆弱，牧草生长期短，产草量低。草食畜牧业生产方式以放牧为主，经营模式主要包括单户经营、联户经营以及“公司+牧户”等。由于超载过牧、乱采滥挖草原野生植物、无序开采矿产资源等因素影响，加之自然条件恶劣，鼠虫害和雪灾发生严重，致使草原退化，涵养水源功能减弱，大量泥沙流失，直接影响江河中下游的生态环境和经济社会可持续发展。&lt;/p&gt;
&lt;p&gt;2.主攻方向：着力修复草原生态系统，恢复草原植被，维护江河源头生态安全，保护生物多样性，改善农牧民生产生活条件。重点实施退牧还草、牧区草原防灾减灾、草原自然保护区建设等工程，大力实施草原生态保护补助奖励政策，加大对“黑土滩”等退化草原的治理力度，重点搞好江河源头和生态脆弱区草原保护。着力推进传统畜牧业转型发展，重点实施肉牛肉羊养殖大县奖励、畜牧良种补贴、标准化规模养殖扶持、肉牛基础母牛扩群增量等政策，同时加大饲草产业扶持力度，发展人工种草，因地制宜推进粮改饲，推进草产业发展。&lt;/p&gt;
&lt;p&gt;3.推介模式：以科学合理利用草地资源为基础，通过培育公司、合作社、家庭农（牧）场等多种经营主体，探索推行股份制合作社为主的规模经营方式，优化配置草场、饲草料地、牲畜等基本生产要素，适度发展高原生态特色畜牧业。推介行业协会带农户的“打通信息、渠道、技术三平台”发展模式；村级合作社的“草场、牲畜、品种、劳力重新分配和统治、统种、统购、统办、统分五统一”模式等。&lt;/p&gt;
&lt;p&gt;&lt;b&gt;（三）东北华北湿润半湿润区&lt;/b&gt;&lt;/p&gt;
&lt;p&gt;1.基本情况：该区主要位于我国东北和华北地区，涉及北京、天津、河北、山西、辽宁、吉林、黑龙江、山东、河南和陕西等10省（市），草原面积2960.82万公顷。该区水热条件较好，年降水量一般在400毫米以上，是我国草原植被覆盖度较高、天然草原品质较好，产量较高的地区，也是草地畜牧业较为发达的地区，发展人工种草和草产品加工业潜力很大。草食畜牧业生产方式主要是夏秋放牧-冬春舍饲，经营模式以家庭牧场和联户经营并存。该区草原主要分布在农牧交错带，开垦比较严重，水土流失加剧，部分地区草原盐碱化、沙化。&lt;/p&gt;
&lt;p&gt;2.主攻方向：着力加强草原监督管理，遏制乱开滥垦、乱采滥挖等违法行为。大力推广人工种草，积极发展草产业，拓宽农牧民增收渠道。重点实施京津风沙源治理、农牧交错带已垦草原治理、新一轮退耕还林还草等工程和草原生态保护补助奖励政策。开展人工种草，推行粮改饲试点和振兴奶业苜蓿发展行动，加快种养业结构调整。推进草食畜牧业提质增效，重点加强畜牧良种补贴、标准化规模养殖、肉牛基础母牛扩群增量、畜禽养殖粪污综合利用等扶持，提高畜牧业发展质量和效益。&lt;/p&gt;
&lt;p&gt;3.推介模式：通过挖掘饲草料生产潜力，积极探索“牧繁农育”和“户繁企育”的养殖模式，发挥各经营主体在人力、资本、饲草等方面的优势，实现牧区与农区协调发展，种植户、养殖户与企业多方共赢。推介综合性龙头企业的“种好草、养好畜、重环保、出精品”的“种养加一体化”模式和“公司+合作社+基地+农户”的种养结合发展模式等。&lt;/p&gt;
&lt;p&gt;&lt;b&gt;（四）南方区&lt;/b&gt;&lt;/p&gt;
&lt;p&gt;1.基本情况：该区位于我国南部，涉及上海、江苏、浙江、安徽、福建、江西、湖南、湖北、广东、广西、海南、重庆、四川、贵州和云南等15省（市、区），草原面积6419.12万公顷。该区气候温暖，水热资源丰富，年降水量一般在1000毫米以上，牧草生长期长，产草量高。草食畜牧业生产方式传统上散养散放，草畜不配套，发展潜力大。该区草资源开发利用不足，垦草种地问题突出，部分地区草地石漠化严重，水土流失加剧。&lt;/p&gt;
&lt;p&gt;2.主攻方向：合理开发利用草地资源，减少水土流失，积极发展草地农业和草地畜牧业。重点实施退牧还草、岩溶地区石漠化草地综合治理、新一轮退耕还林还草等工程，推进实施草原生态保护补助奖励政策，加大草原生态保护力度。加快草食畜牧业转型发展，重点实施南方现代草地畜牧业推进行动、畜牧良种补贴、标准化规模养殖、肉牛基础母牛扩群增量、畜禽粪污资源化利用等政策，同时大力发展人工种草，推行草田轮作，因地制宜推进粮改饲，强化草畜配套，推进草食畜牧业发展。&lt;/p&gt;
&lt;p&gt;3.推介模式：&lt;/p&gt;
&lt;p&gt;依托青绿饲草资源优势，大力推广粮经饲三元结构种植和标准化规模养殖，因地制宜发展地方特色草食畜牧业。推介天然草山草坡改良、混播牧草地建植、农闲田种草养畜的“工程项目+公司+合作社”统筹发展模式和“公司+家庭农（牧）场”的产业化经营模式等。&lt;/p&gt;
&lt;p&gt;&lt;b&gt;四、保障措施&lt;/b&gt;&lt;/p&gt;
&lt;p&gt;（一）切实加强组织领导。各级农牧部门要高度重视，切实把促进草牧业发展列入重要议事日程，积极协调将草牧业纳入地方国民经济和社会发展规划。要广泛凝聚工作合力，落实目标任务，明确工作责任，建立健全“统一领导、分工协作、广泛参与”的工作机制，确保各项措施落实到位。&lt;/p&gt;
&lt;p&gt;（二）落实好已有政策。各级农牧部门要认真落实草原和畜牧业各类财政专项资金及重大工程建设投资，积极发挥财政资金“四两拨千斤”的作用，探索创新资金使用方式，放大资金效应，夯实草牧业发展基础设施，不断扩大中央投入的引导示范作用。要创新项目管理，加强督导检查，确保各项政策措施落实到项目建设主体和草场地块。&lt;/p&gt;
&lt;p&gt;（三）完善创设新政策。各级农牧部门要结合当前生态文明体制和农业农村改革新要求，立足本地区草牧业发展实际，突出问题导向，围绕草原保护、培育新型经营主体、提升物质装备水平、加强科技推广支撑和完善金融服务等方面，加强政策创设力度，不断完善草牧业发展政策体系。&lt;/p&gt;
&lt;p&gt;（四）加强舆论宣传。各级农牧部门要积极总结好经验好模式，运用多种传播方式，加大对“保护草原得力、产业优势突出、农牧增收显著、示范带动强劲”的现代草牧业模式的宣传推介力度，营造良好社会氛围，推动草牧业又好又快发展。&lt;/p&gt;
</div>


<jsp:include page="../includes/html_body_footer.jsp" />

</body>
</html>
