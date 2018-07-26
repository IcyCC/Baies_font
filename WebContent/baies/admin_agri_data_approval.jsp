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
<style>
.grid_edited_cell {
	background-color: #FF9;
}
</style>
<script>

    findArrayByValue = function (ary, value,func) {
        for (var index in ary) {
            if (func(ary[index], value) === true) {
                console.log("compare",value)
                return ary[index]
            }
        }
        return {}
    };

    var parseParam=function(param){
        var paramStr="";
        for (var key in param) {
            paramStr = paramStr+ "&"+ key + '=' + JSON.stringify(param[key])
        }
        return paramStr.substr(1);
    };


    var myDate = new Date();
    var start_year = 2005
    var end_year = myDate.getFullYear()

    var data = [];
    <%--for (var i = 0; i < 100; i++) {--%>
    <%--var row = rows[0];--%>
    <%--var datarow = {};--%>
    <%--datarow['version_id'] = 162 - i;--%>
    <%--var objs = econ_data_cat_tree_src_<fmt:message key="common.language" />[0].items;--%>
    <%--datarow['category'] = objs[Math.floor(Math.random()*objs.length)].label;--%>
    <%--datarow['country'] = $(row).find('li:nth-child(3)').html();--%>
    <%--datarow['author'] = $(row).find('li:nth-child(4)').html();--%>
    <%--datarow['time'] = $(row).find('li:nth-child(5)').html();--%>
    <%--datarow['description'] = $(row).find('li:nth-child(6)').find('span:nth-child('+(Math.floor(Math.random()*2)+1)+')').html();--%>
    <%--datarow['operation'] = $(row).find('li:nth-child(7)').html();--%>
    <%--data[data.length] = datarow;--%>
    <%--}--%>
    var grid_edited_cells = [];
    var grid_cell_class = function (row, datafield, value, rowdata) {
        for (var i = 0; i < grid_edited_cells.length; i++) {
            if(grid_edited_cells[i].row == row && grid_edited_cells[i].datafield == datafield) {
                return 'grid_edited_cell';
            }
        }
    };
    var source = {
        localdata: data,
        datatype: 'array',
        datafields: [{name: 'id', type: 'number'},
            {name: 'table_name', type: 'string', map:'table>cn_alis'},
            {name: 'table_id', type: 'number', map:'table>id'},
            {name: 'country', type: 'string', map:'country'},
            {name: 'user', type: 'object', map: 'user>username'},
            {name: 'time', type: 'string'},
            {name: 'note', type: 'string'},
            {name: 'operation', type: 'string'},
            {name: 'pre_log_id', type: 'number'}
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
        columns: [{text: '<fmt:message key="text.edition" />', dataField: 'id', width: 65, align: 'center', cellsalign: 'center'},
            {text: '<fmt:message key="text.category" />', dataField: 'table_id',displayfield:'table_name', width: 160, align: 'center', cellsalign: 'center'},
            {text: '<fmt:message key="common.dimension.country" />', dataField: 'country', width: 80, align: 'center', cellsalign: 'center'},
            {text: '<fmt:message key="text.author" />', dataField: 'user', width: 80, align: 'center', cellsalign: 'center'},
            {text: '<fmt:message key="common.dimension.time" />', dataField: 'time', width: 100, align: 'center', cellsalign: 'center'},
            {text: '<fmt:message key="log.note" />', dataField: 'note', width: 285, align: 'center'},
            {text: '<fmt:message key="comm.operation" />', dataField: 'operation', width: 80, align: 'center', cellsalign: 'center'}
        ]
    };


    var page_id = 0;


    var local_data_1 = [];
    var local_data_2 = [];
    var data_adapter_1;
    var data_adapter_2;

    var country_data = [];
    var kind_data = [];

$(document).ready(function() {
	
	$('#nav2_tabs').jqxTabs({width: '998px', position: 'top', theme: '<%=jqx_theme %>'});
	$('#nav2_tabs').jqxTabs({ selectedItem: 2 });
	$('#nav2_tabs').on('selected', function (event) {
		var idx = event.args.item;
		window.location.href=nav2_items_approval[idx];
	});
	
	var rows = $("#data_ul");


    $.ajax({
        type:'GET',
        url:host+'/quantify/country',
        data: {},
        xhrFields: {
            withCredentials: true
        },
        crossDomain: true,
        async: true,
        success: function (resp) {
            for (var index in resp.data) {
                country_data.push(resp.data[index])
            }
            console.log(country_data,'r2')}.bind(this)
    });

    $.ajax({
        type:'GET',
        url:host+'/quantify/agriculture_kinds',
        data: {},
        xhrFields: {
            withCredentials: true
        },
        crossDomain: true,
        async: true,
        success: function (resp) {
            for (var index in resp.data) {
                kind_data.push(resp.data[index])
            }
            console.log(kind_data,'r2')}.bind(this)
    });

    getAllLog = function () {
        $.ajax({
            type:'GET',
            url:host+'/user/ArgLog',
            data:{},
            xhrFields: {
                withCredentials: true
            },
            crossDomain: true,
            async: true,
            success: function (resp) {
                console.log(resp)
                for (var index in resp.data) {
                    var row = rows[0];
                    var per_log = resp.data[index];
                    console.log(per_log)
                    var datarow = {}
                    if (per_log.per_log_id === 0 ){
                        continue
                    }

                    datarow["id"] = per_log.id

                    datarow['table'] = per_log.table;
                    datarow['country'] = per_log.user.country.<fmt:message key="data.field" />;
                    datarow['user'] = per_log.user;
                    datarow['time'] = per_log.timestamp;
                    datarow['note'] = per_log.note;
                    datarow['pre_log_id'] = per_log.per_log_id
                    console.log(row)
                    datarow['operation'] = $(row).find('li:nth-child(7)').html();
                    data[data.length] = datarow;
                    console.log(data)
                }
                dataAdapter.dataBind()
                $('#data_grid').jqxGrid('render');
                $('#data_grid').jqxGrid('refresh');
            }
        });
    }

    <%--var data = [];--%>
	<%--&lt;%&ndash;for (var i = 0; i < 100; i++) {&ndash;%&gt;--%>
		<%--&lt;%&ndash;var row = rows[0];&ndash;%&gt;--%>
		<%--&lt;%&ndash;var datarow = {};&ndash;%&gt;--%>
		<%--&lt;%&ndash;datarow['version_id'] = 162 - i;&ndash;%&gt;--%>
		<%--&lt;%&ndash;var objs = agri_data_cat_tree_src_<fmt:message key="common.language" />[0].items[0].items;&ndash;%&gt;--%>
		<%--&lt;%&ndash;datarow['category'] = objs[Math.floor(Math.random()*objs.length)].label;&ndash;%&gt;--%>
		<%--&lt;%&ndash;datarow['country'] = $(row).find('li:nth-child(3)').html();&ndash;%&gt;--%>
		<%--&lt;%&ndash;datarow['author'] = $(row).find('li:nth-child(4)').html();&ndash;%&gt;--%>
		<%--&lt;%&ndash;datarow['time'] = $(row).find('li:nth-child(5)').html();&ndash;%&gt;--%>
		<%--&lt;%&ndash;datarow['description'] = $(row).find('li:nth-child(6)').find('span:nth-child('+(Math.floor(Math.random()*2)+1)+')').html();&ndash;%&gt;--%>
		<%--&lt;%&ndash;datarow['operation'] = $(row).find('li:nth-child(7)').html();&ndash;%&gt;--%>
		<%--&lt;%&ndash;data[data.length] = datarow;&ndash;%&gt;--%>
	<%--&lt;%&ndash;}&ndash;%&gt;--%>
	<%--var source = {--%>
			<%--localdata: data,--%>
			<%--datatype: 'array',--%>
			<%--datafields: [{name: 'version_id', type: 'number'},--%>
			             <%--{name: 'category', type: 'string'},--%>
			             <%--{name: 'country', type: 'string'},--%>
			             <%--{name: 'author', type: 'string'},--%>
			             <%--{name: 'time', type: 'string'},--%>
			             <%--{name: 'description', type: 'string'},--%>
			             <%--{name: 'operation', type: 'string'}],--%>
	<%--};--%>
	<%--var dataAdapter = new $.jqx.dataAdapter(source);--%>
	<%--var settings = {--%>
			<%--width: '850px',--%>
			<%--source: dataAdapter,--%>
			<%--autoheight: true,--%>
			<%--autorowheight: true,--%>
			<%--showheader: true,--%>
			<%--pageable: true,--%>
			<%--pagesize: 10,--%>
			<%--theme: '<%=jqx_theme %>',--%>
			<%--columns: [{text: '<fmt:message key="text.edition" />', dataField: 'version_id', width: 65, align: 'center', cellsalign: 'center'},--%>
			          <%--{text: '<fmt:message key="text.category" />', dataField: 'category', width: 160, align: 'center', cellsalign: 'center'},--%>
			          <%--{text: '<fmt:message key="common.dimension.country" />', dataField: 'country', width: 80, align: 'center', cellsalign: 'center'},--%>
			          <%--{text: '<fmt:message key="text.author" />', dataField: 'author', width: 80, align: 'center', cellsalign: 'center'},--%>
			          <%--{text: '<fmt:message key="common.dimension.time" />', dataField: 'time', width: 100, align: 'center', cellsalign: 'center'},--%>
			          <%--{text: '版本说明', dataField: 'description', width: 285, align: 'center'},--%>
			          <%--{text: '操作', dataField: 'operation', width: 80, align: 'center', cellsalign: 'center'}--%>
			          <%--]--%>
	<%--};--%>

	$('#data_grid').jqxGrid(settings);

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

	$('.detail_buttons').on('click', function() {
		$('#diff_category').html('<fmt:message key="temp.agri_data_approval.category" />');
		$('#diff_window').jqxWindow('open');
	});

	$('.approve_buttons').on('click', function() {
		$('#dialog_window_content').html('是否通过本信息？');
		$('#dialog_window').one('close', function(event) {
			if(event.args.dialogResult.OK) {
				$('#message_notification_content').html('信息已通过。');
				$('#message_notification').jqxNotification('open');
			}
		});
		$('#dialog_window').jqxWindow('open');
	});

	$('.reject_buttons').on('click', function() {
		$('#dialog_window_content').html('是否拒绝本信息？');
		$('#dialog_window').one('close', function(event) {
			if(event.args.dialogResult.OK) {
				$('#message_notification_content').html('信息已拒绝。');
				$('#message_notification').jqxNotification('open');
			}
		});
		$('#dialog_window').jqxWindow('open');
	});

	$('#diff_window').jqxWindow({
		width: 700, height: 550, resizable: false,  isModal: true, autoOpen: false,
		okButton: $("#diff_window_ok_button"), cancelButton: $("#diff_window_cancel_button"),
		modalOpacity: 0.3, theme: '<%=jqx_theme %>'
	});

	$("#diff_window_ok_button").jqxButton({
		theme: '<%=jqx_theme %>'
	});

	$("#diff_window_ok_button").on('click', function(event) {
		$('#message_notification_content').html('信息已通过。');
		$('#message_notification').jqxNotification('open');
	});

	$("#diff_window_cancel_button").jqxButton({
		theme: '<%=jqx_theme %>'
	});

	$("#diff_window_cancel_button").on('click', function(event) {
		$('#message_notification_content').html('信息已拒绝。');
		$('#message_notification').jqxNotification('open');
	});

	$('#message_notification').jqxNotification({
		width: 'auto', position: "bottom-right", opacity: 0.9, template: 'success', theme: '<%=jqx_theme %>'
	});

	$('#diff_content_splitter').jqxSplitter({
		width: 660, height: 400, theme: '<%=jqx_theme %>',
		panels: [
		         {size: 330, min: 100, collapsible: true, collapsed: false},
		         {size: 330, min: 100, collapsible: true, collapsed: false}
		         ]
	});

    getAllLog()

	var init_diff_grid_widgets = function () {

		var data_fields = [
            {name: 'country', type: 'string', map: 'country'},
            {name: 'index', type: 'string', map: 'index'},
            {name: 'country_id', type:'number',map: 'country_id'},
            {name: 'index_id', type:'number', map:'index_id'},
            {name: 'kind', type: 'string', map: 'kind'},
            {name: 'kind_id', type: 'number' , map:'kind_id'}
		                   ];

		var data_columns = [
		    {text: '<fmt:message key="common.dimension.country" />', datafield: 'country', width: 70},
            {text: '<fmt:message key="common.dimension.product" />', datafield: 'kind', width: 70},
            {text: '<fmt:message key="common.dimension.indicator" />', datafield: 'index', width: 100}];

        for (var year = start_year ,t= 0; year<=end_year; year++,t++) {
            data_fields.push({name: 'y'+year, type: 'object', map: 'y'+year.toString()+'>value'})
            data_columns.push({text: year.toString(), datafield: 'y'+year,  width: 70, cellsalign: 'right', cellclassname: grid_cell_class})
            grid_edited_cells.push({row: t, datafield: 'y'+year.toString()+'>value'})
        }

		var data_source_1 = {
				localdata: local_data_1,
				datafields: data_fields,
				datatype: 'array'
		};
		var data_source_2 = {
				localdata: local_data_2,
				datafields: data_fields,
				datatype: 'array'
		};
		data_adapter_1 = new $.jqx.dataAdapter(data_source_1);
		data_adapter_2 = new $.jqx.dataAdapter(data_source_2);
		$('#diff_grid_1').jqxGrid({
			width: '330px', height: '400px', source: data_adapter_1, columnsresize: true, columns: data_columns, theme: '<%=jqx_theme %>'
		});
		$('#diff_grid_2').jqxGrid({
			width: '330px', height: '400px', source: data_adapter_2, columnsresize: true, columns: data_columns, theme: '<%=jqx_theme %>'
		});

	};
	init_diff_grid_widgets();

    $("#data_grid").on("cellclick", function (event)
    {
        // event arguments.
        var args = event.args;

        var log = args.row.bounddata;
        console.log(args)


        $('.detail_buttons').on('click', function() {
            $('#diff_category').html(log.table_name);


            $('#diff_window').one('close', function(event) {
                if(event.args.dialogResult.OK) {

                    var post_data = {
                        id: log.table_id,
                        cur_log_id: log.id
                    };
                    console.log("切换")

                    $.ajax({
                        async: true,
                        xhrFields: {
                            withCredentials: true
                        },
                        crossDomain: true,
                        url: host+"/quantify/agriculture_table",
                        method: "PUT",
                        data: post_data,
                        success: function (resp) {
                            console.log(resp);
                            $('#message_notification_content').html('修订版本已保存。');
                            $('#message_notification').jqxNotification('open');
                            window.location.reload();
                        }
                    })
                }
                else if(event.args.dialogResult.Cancel){
                    var post_data = {
                        id: log.table_id,
                        cur_log_id: log.pre_log_id
                    };
                    console.log("回滚")

                    $.ajax({
                        async: true,
                        xhrFields: {
                            withCredentials: true
                        },
                        crossDomain: true,
                        url: host+"/quantify/agriculture_table",
                        method: "PUT",
                        data: post_data,
                        success: function (resp) {
                            console.log(resp);
                            $('#message_notification_content').html('修订版本已保存。');
                            $('#message_notification').jqxNotification('open');
                            window.location.reload();
                        }
                    })
                }
            });

            $('#diff_window').jqxWindow('open');
            local_data_1.splice(0,local_data_1.length)
            local_data_2.splice(0,local_data_2.length)
            var cur_indexes = [];



            $.ajax({
                async: true,
                xhrFields: {
                    withCredentials: true
                },
                crossDomain: true,
                url: host+"/quantify/agriculture_table/"+log.table_id+"/indexes",
                method: "GET",
                data: {},
                success: function (resp) {
                    cur_indexes = resp.data
                    console.log(cur_indexes)

                    var query_args = {
                        country_ids: country_data.map(function (x) {
                            return x.id
                        }),
                        table_id: log.table_id,
                        index_ids: cur_indexes.map(function (x) {
                            return x.id
                        }),
						kind_ids: kind_data.map(function (x) {
                            return x.id
                        }),
                        start_time: start_year,
                        end_time: end_year,
                        log_id: log.id
                    }

                    $.ajax({
                        type:'GET',
                        url:host+'/quantify/agriculture_facts'+'?'+ parseParam(query_args),
                        data: {},
                        xhrFields: {
                            withCredentials: true
                        },
                        crossDomain: true,
                        async: true,
                        success: function (resp) {
                            for (var index_id_i in query_args.index_ids) {
                                var index_id = query_args.index_ids[index_id_i]
                                for (var country_id_i in query_args.country_ids) {
                                    var country_id =query_args.country_ids[country_id_i]
                                    for (var kind_id_i in query_args.kind_ids) {
                                        var kind_id = query_args.kind_ids[kind_id_i]

                                        var datas = findArrayByValue(
                                            resp.data, {"index_id":index_id, "country_id":country_id, "kind_id": kind_id},
                                            function (x,y) {
                                                if (x.country.id === y["country_id"] && x.index.id === y["index_id"] && x.kind.id== y['kind_id']) {
                                                    console.log("查找成功", 'x:', x, 'y', y)
                                                    return true
                                                }
                                                return false
                                            }
                                        ).data

                                        console.log("fill datas", datas)

                                        var line = {
                                            country:
                                            findArrayByValue(country_data,
                                                country_id,
                                                function (x,y) {
                                                    if (x.id === y) {
                                                        return true
                                                    }
                                                    return false
                                                }
                                            ).<fmt:message key="data.field" />,
                                            index: findArrayByValue(cur_indexes,
                                                index_id,
                                                function (x,y) {
                                                    if (x.id === y) {
                                                        return true
                                                    }
                                                    return false
                                                }
                                            ).<fmt:message key="data.field" />,
                                            kind: findArrayByValue(kind_data,
                                                kind_id,
                                                function (x,y) {
                                                    if (x.id === y) {
                                                        return true
                                                    }
                                                    return false
                                                }
                                            ).<fmt:message key="data.field" />,
                                            country_id: country_id,
                                            index_id: index_id,
                                            kind_id: kind_id}

                                        for (var data_i in datas) {
                                            var tmp_data = datas[data_i];
                                            console.log("当数据是",[country_id, index_id, kind_id], "填充",tmp_data)
                                            line['y'+tmp_data.time] = {value:tmp_data.value, id:tmp_data.id}
                                        }
                                        console.log("填充完成",line)
                                        local_data_1.push(line)
                                    }
                                }
                            }
                            data_adapter_1.dataBind();
                            grid_cell_class()
                            $('#diff_grid_1').jqxGrid('render');
                            $('#diff_grid_1').jqxGrid('refresh');

                        }
                    });

                    query_args.log_id = log.pre_log_id

                    $.ajax({
                        type:'GET',
                        url:host+'/quantify/agriculture_facts'+'?'+ parseParam(query_args),
                        data: {},
                        xhrFields: {
                            withCredentials: true
                        },
                        crossDomain: true,
                        async: true,
                        success: function (resp) {
                            for (var index_id_i in query_args.index_ids) {
                                var index_id =query_args.index_ids[index_id_i]
                                for (var country_id_i in query_args.country_ids) {
                                    var country_id = query_args.country_ids[country_id_i]
                                    for (var kind_id_i in query_args.kind_ids) {
                                        var kind_id = query_args.kind_ids[kind_id_i]

                                        var datas = findArrayByValue(
                                            resp.data, {"index_id":index_id, "country_id":country_id, "kind_id": kind_id},
                                            function (x,y) {
                                                if (x.country.id === y["country_id"] && x.index.id === y["index_id"] && x.kind.id== y['kind_id']) {
                                                    console.log("查找成功", 'x:', x, 'y', y)
                                                    return true
                                                }
                                                return false
                                            }
                                        ).data

                                        console.log("fill datas", datas)

                                        var line = {
                                            country:
                                            findArrayByValue(country_data,
                                                country_id,
                                                function (x,y) {
                                                    if (x.id === y) {
                                                        return true
                                                    }
                                                    return false
                                                }
                                            ).<fmt:message key="data.field" />,
                                            index: findArrayByValue(cur_indexes,
                                                index_id,
                                                function (x,y) {
                                                    if (x.id === y) {
                                                        return true
                                                    }
                                                    return false
                                                }
                                            ).<fmt:message key="data.field" />,
                                            kind: findArrayByValue(kind_data,
                                                kind_id,
                                                function (x,y) {
                                                    if (x.id === y) {
                                                        return true
                                                    }
                                                    return false
                                                }
                                            ).<fmt:message key="data.field" />,
                                            country_id: country_id,
                                            index_id: index_id,
                                            kind_id: kind_id}

                                        for (var data_i in datas) {
                                            var tmp_data = datas[data_i];
                                            console.log("当数据是",[country_id, index_id, kind_id], "填充",tmp_data)
                                            line['y'+tmp_data.time] = {value:tmp_data.value, id:tmp_data.id}
                                        }
                                        console.log("填充完成",line)
                                        local_data_2.push(line)
                                    }
                                }
                            }


                            console.log('local',resp.data)
                            data_adapter_2.dataBind()
                            grid_cell_class()
                            $('#diff_grid_2').jqxGrid('render');
                            $('#diff_grid_2').jqxGrid('refresh');
                        }
                    });

                }
            })

        });

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
					<fmt:message key="nav.system_admin.approval.policy" />
				</div>
			</div>
		</li>
		<li>
			<div style="height: 20px; margin-top: 5px;">
				<div style="margin-left: 4px; vertical-align: middle; text-align: center;">
					<fmt:message key="nav.system_admin.approval.econ" />
				</div>
			</div>
		</li>
		<li>
			<div style="height: 20px; margin-top: 5px;">
				<div style="margin-left: 4px; vertical-align: middle; text-align: center;">
					<fmt:message key="nav.system_admin.approval.agri" />
				</div>
			</div>
		</li>
	</ul>
	<div></div>
	<div></div>
	<div></div>
</div>

<div style="padding: 25px;">
	<h1><fmt:message key="nav.system_admin.approval.agri" /></h1>
	<br><br>
	<div id="data_grid"></div>
</div>

<ul id="data_ul" style="display: none;">
	<li>（<fmt:message key="text.edition" />）</li>
	<li>（<fmt:message key="text.category" />）</li>
	<li><fmt:message key="common.country.china" /></li>
	<li><fmt:message key="temp.policy_author" /></li>
	<li>2016-07-04 10:39</li>
	<li><span><fmt:message key="temp.agri_data_approval.desc_1" /></span><span><fmt:message key="temp.agri_data_approval.desc_2" /></span></li>
	<li>
		<button>
			<img class="detail_buttons" src="../js/jqwidgets-4.1.2/styles/images/search.png"
				title="查看" style="width: 16px; height: 16px; vertical-align: middle;">
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

<div id="diff_window">
	<div><fmt:message key="agri_data_approval.edition_comparison" /></div>
	<div style="overflow: hidden; padding: 20px;">
		<div class="left" style="width: 70px;"><fmt:message key="text.category" />:</div>
		<div class="left" id="diff_category" style="font-weight: bold;"></div>
		<div class="clear"></div>
		<div class="margin_10"></div>
		<div style="width: 100%; height: 20px;">
			<div class="left" style="margin-left: 50px;"><fmt:message key="text.original_edition" /></div>
			<div class="right" style="margin-right: 50px;"><fmt:message key="text.revised_edition" /></div>
			<div class="clear"></div>
		</div>
		<div id="diff_content_splitter">
			<div class="splitter-panel">
				<div id="diff_grid_1"></div>
			</div>
			<div class="splitter-panel">
				<div id="diff_grid_2"></div>
			</div>
		</div>
		<div class="right margin_10">
			<input type="button" id="diff_window_ok_button" value="切换当前版本">
			<input type="button" id="diff_window_cancel_button" value="回到上一版本">
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
