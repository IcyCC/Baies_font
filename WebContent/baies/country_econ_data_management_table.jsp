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

page_id = 1;
var myDate = new Date();

removeByValue = function(ary,val) {
    var index = ary.indexOf(val);
    if (index > -1) {
        ary.splice(index, 1);
    }
};

findArrayByValue = function (ary, value,func) {
	for (var index in ary) {
		if (func(ary[index], value) === true) {
		    console.log("compare",value)
			return ary[index]
		}
	}
	return {}
}

findIndexByValue = function (ary, value,func) {
    for (var index in ary) {
        if (func(ary[index], value) === true) {
            console.log("compare",value)
            return index
        }
    }
    return -1
}

var parseParam=function(param){
    var paramStr="";
    for (var key in param) {
        paramStr = paramStr+ "&"+ key + '=' + JSON.stringify(param[key])
    }
    return paramStr.substr(1);
};

function getQueryString() {
    var qs = location.search.substr(1), // 获取url中"?"符后的字串
        args = {}, // 保存参数数据的对象
        items = qs.length ? qs.split("&") : [], // 取得每一个参数项,
        item = null,
        len = items.length;

    for(var i = 0; i < len; i++) {
        item = items[i].split("=");
        var name = decodeURIComponent(item[0]),
            value = decodeURIComponent(item[1]);
        if(name) {
            console.log(value)
            args[name] = $.parseJSON(value);
        }
    }
    return args;
}

var table_index_data= {};
var table_data = [];
var country_data = [];
var index_data = [];
var old_query_args = getQueryString();
var query_args = getQueryString();
var grid_edited_cells = {};
var upload_url = ''
var local_data = [
];
var data_fields = [
    {name: 'location', type: 'string', map: 'location'},
    {name: 'variable', type: 'string', map: 'variable'},
    {name: 'country_id', type:'number',map: 'country_id'},
    {name: 'index_id', type:'number', map:'index_id'}
];
var data_columns = [
    {text: '<fmt:message key="common.dimension.country" />', datafield: 'location', width: 70},
    {text: '<fmt:message key="common.dimension.indicator" />', datafield: 'variable', width: 100}];

var data_source = {
    localdata: local_data,
    datafields: data_fields,
    datatype: 'array'
};
var data_adapter = new $.jqx.dataAdapter(data_source);

$(document).ready(function() {
	
	var cat_tree_src = econ_data_cat_tree_src_<fmt:message key="common.language" />;

    $.ajax({
        type:'GET',
        url:host+'/quantify/socioeconomic_table',
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

    $.ajax({
        type:'GET',
        url:host+'/quantify/country',
        data: {},
        xhrFields: {
            withCredentials: true
        },
        crossDomain: true,
        async: false,
        success: function (resp) {
            for (var index in resp.data) {
                country_data.push(resp.data[index])
            }
            console.log(country_data,'r2')}.bind(this)
    });

    $('#data_grid').jqxGrid({
        width: '650px', height: '270px', source: data_adapter, columnsresize: true,
        columns: data_columns, theme: '<%=jqx_theme %>', selectionmode: 'singlecell',
        editable: true
    });

	$('#cat_expander').jqxExpander({
		width: '250px', height: '400px', showArrow: false, toggleMode: 'none', theme: '<%=jqx_theme %>'
	});

    $('#cat_tree').jqxTree({
        source: table_data, width: '100%', height: '100%', theme: '<%=jqx_theme %>'
    });
	
	$('#location_expander').jqxExpander({
		width: '170px', showArrow: false, toggleMode: 'none', theme: '<%=jqx_theme %>'
	});

    $('#location_list').jqxDropDownList({
        source: country_data, checkboxes: true,
        width: '100%', theme: '<%=jqx_theme %>',
        displayMember:'<fmt:message key="data.field" />',valueMember:"id"
    });
	
	$("#location_list").jqxDropDownList('checkIndex', 0);
	$("#location_list").jqxDropDownList('checkIndex', 1);
	$("#location_list").jqxDropDownList('checkIndex', 2);
	$("#location_list").jqxDropDownList('checkIndex', 3);
	$("#location_list").jqxDropDownList('checkIndex', 4);
	$("#location_list").jqxDropDownList('checkIndex', 5);
	$("#location_list").jqxDropDownList('checkIndex', 6);
	
	$('#variable_expander').jqxExpander({
		width: '170px', showArrow: false, toggleMode: 'none', theme: '<%=jqx_theme %>'
	});

    $('#variable_list').jqxDropDownList({
        source: index_data, checkboxes: true,
        width: '100%', theme: '<%=jqx_theme %>',
        displayMember:'<fmt:message key="data.field" />',valueMember:"id"
    });
	
	$("#variable_list").jqxDropDownList('checkIndex', 0);
	$("#variable_list").jqxDropDownList('checkIndex', 1);
	$("#variable_list").jqxDropDownList('checkIndex', 2);
	$("#variable_list").jqxDropDownList('checkIndex', 3);
	$("#variable_list").jqxDropDownList('checkIndex', 4);
	
	$('#time_slider').jqxSlider({
		width: '220px', values: [2005, 2010], min: 2000, max: myDate.getFullYear(), mode: 'fixed',
		rangeSlider: true, theme: '<%=jqx_theme %>', ticksFrequency: 1
	});
	
	$('#time_slider').on('change', function(event) {
		$('#time1').html(event.args.value.rangeStart);
		$('#time2').html(event.args.value.rangeEnd);
	});
	
	$('#query_button').jqxButton({
		width: '75px', height: '35px', theme: '<%=jqx_theme %>'
	});
	
	$('#query_button').on('click', function() {
        window.location.href='country_econ_data_management_table.jsp'+'?'+ parseParam(query_args);
	});
	
	$('#save_button').jqxButton({
		width: '75px', height: '35px', theme: '<%=jqx_theme %>', disabled: true
	});

	$('#save_button').on('click', function() {
		$('#dialog_window_content').html('请输入版本说明: <input id="econ_note_input" type="text" >');
		// 提交


		$('#dialog_window').one('close', function(event) {
			if(event.args.dialogResult.OK) {
				$('#save_button').jqxButton({ disabled: true });

                var post_data = {note:"", data:[], table_id:""}
                post_data.table_id = query_args.table_id;
                post_data.note = $('#econ_note_input').val();

                for (var cell in grid_edited_cells) {
                    post_data.data.push(grid_edited_cells[cell])
                }

                console.log(post_data)

                $.ajax({
                    async: true,
                    xhrFields: {
                        withCredentials: true
                    },
                    crossDomain: true,
                    processData: false,
                    url: host+"/quantify/socioeconomic_facts/batch",
                    method: "POST",
                    data: JSON.stringify(post_data),
                    headers: {
                        "Content-Type": "application/json",
                        "Cache-Control": "no-cache"
                    },
                    success: function (resp) {
                        console.log(resp);
                        $('#message_notification_content').html('修订版本已保存。');
                        $('#message_notification').jqxNotification('open');
                        window.location.reload();
                    }
                })
			}
		});
		$('#dialog_window').jqxWindow('open');
	});
	
	$('#import_button').jqxButton({
		width: '75px', height: '35px', theme: '<%=jqx_theme %>'
	});
	
	$('#import_button').on('click', function() {
		$('#dialog_window_content').html('<table><tr><td>请选择文件:</td><td><input type="file" id="file-uploader"></td></tr>'
				+ '<tr><td>请输入版本说明:</td><td><input type="text" id="note-input"></td></tr></table>');

		$('#file-uploader').on('change', function (event) {

            var formData = new FormData()
            formData.append('file',$('#file-uploader')[0].files[0])
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



		$('#dialog_window').one('close', function(event) {
			if(event.args.dialogResult.OK) {
				var note = $("note-input").input()
				var table_id = query_args.table_id
                $.ajax({
                    async: true,
                    xhrFields: {
                        withCredentials: true
                    },
                    crossDomain: true,
                    processData: true,
                    url: host+"/quantify/socioeconomic_excel",
                    method: "POST",
                    data: {filename:upload_url.split('/')[3], note:note, table_id:table_id, field:'<fmt:message key="data.field" />'},
                    success: function (resp) {
                        console.log(resp);
                        $('#message_notification_content').html('修订版本已保存。');
                        $('#message_notification').jqxNotification('open');
                        window.location.reload();
                    }
                })

                $('#message_notification_content').html('文件已导入。');
                $('#message_notification').jqxNotification('open');
            }
		});

		$('#dialog_window').jqxWindow('open');
	});
	
	$('#export_button').jqxButton({
		width: '75px', height: '35px', theme: '<%=jqx_theme %>'
	});

    $('#export_button').on('click', function () { $("#data_grid").jqxGrid('exportdata', 'csv', '经济数据');});


	
	$('#data_grid').on('cellendedit', function(event) {
		var args = event.args;
		var rowindex = args.rowindex;
		var datafield = args.datafield;
		var value = args.value;
		var oldvalue = args.oldvalue;
		var row = args.row;
		console.log(args)
		if(value == oldvalue) {
			return;
		}
		$('#save_button').jqxButton({ disabled: false });
		grid_edited_cells[rowindex+datafield] = {
            country_id:row.country_id,
            time:datafield.substr(1,5),
            index_id:row.index_id,
            value: value
		};
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

    // 处理事件
    $('#cat_tree').on('select',function (event)
    {
        var args = event.args;
        var item = $('#cat_tree').jqxTree('getItem', args.element);

        query_args.table_id=item.value
        index_data.splice(0,index_data.length);
        query_args.index_ids.length = 0
        for (var i in table_index_data[item.id]) {
            index_data.push(table_index_data[item.id][i])
        }
        console.log('qu', query_args)
        $("#variable_list").jqxDropDownList('render');
    });


    $('#variable_list').on('checkChange', function (event) {
        var checked = args.checked;
        // get the item and it's label and value fields.
        var item = args.item;
        if (item.checked === true) {
            console.log("指标选择")
            query_args.index_ids.push(item.value)
        }
        else {
            console.log("指标删除")
            removeByValue(query_args.index_ids,item.value)
        }
        console.log('qu', query_args)
    })




    $('#location_list').on('checkChange', function (event) {
        var checked = args.checked;
        // get the item and it's label and value fields.
        var item = args.item;

        if (item.checked === true) {
            query_args.country_ids.push(item.value)
            console.log("国家选择")
        }
        else {
            console.log("国家取消")
            removeByValue(query_args.country_ids,item.value)
        }
        console.log('qu', query_args)
    })


    $('#time_slider').on('change', function (event) {
        var values = $('#time_slider').jqxSlider('values');
        query_args.start_time = values[0]
        query_args.end_time = values[1]
        console.log('qu', query_args)
    });



    var checked_variable_list_func = function () {

        // 选择变量

        $('#cat_tree').jqxTree('selectItem',$("#cat_tree").find('li:eq('+findIndexByValue(table_data,
            old_query_args.
                table_id, function (x,y) {
                if (x["id"] === y) {
                    return true
                }
                return false
            })+')')[0])

        console.log("清空")

        query_args.country_ids.length = 0
        query_args.index_ids.length = 0

        for (var index_id_i in old_query_args.index_ids) {
            var index_id = old_query_args.country_ids[index_id_i]
            $("#variable_list").jqxDropDownList('checkItem',  $("#variable_list").jqxDropDownList('getItemByValue',  index_id));
        }

        for (var country_id_i in old_query_args.country_ids) {
            var country_id = old_query_args.country_ids[country_id_i]
            $("#location_list").jqxDropDownList('checkItem',  $("#location_list").jqxDropDownList('getItemByValue',  country_id));
        }

        $('#time_slider').jqxSlider('setValue', [old_query_args.start_time, old_query_args.end_time]);


    }()


    var tmp = function init_data_columns () {

        for (var year = old_query_args.start_time;year<=old_query_args.end_time; year++){
            data_fields.push({name: 'y'+year, type: 'object', map: 'y'+year.toString()+'>value'} );
            data_fields.push({name: 'y'+year+'_id', type: 'object', map: 'y'+year.toString()+'>id'} );
            data_columns.push({text: year.toString(), datafield: 'y'+year, width: 70, cellsalign: 'right'})
            console.log('fill',year)
        }
        console.log(data_fields,data_columns)
        $.ajax({
            type:'GET',
            url:host+'/quantify/socioeconomic_facts'+location.search,
            data: {},
            xhrFields: {
                withCredentials: true
            },
            crossDomain: true,
            async: true,
            success: function (resp) {

                for (var index_id_i in old_query_args.index_ids) {
  					var index_id = old_query_args.index_ids[index_id_i]
                    for (var country_id_i in old_query_args.country_ids) {
  					    var country_id = old_query_args.country_ids[country_id_i]

                        var datas = findArrayByValue(
                            resp.data, {"index_id":index_id, "country_id":country_id},
							function (x,y) {
								if (x.country.id === y["country_id"] && x.index.id === y["index_id"]) {
								    return true
								}
								return false
                            }
						).data

						console.log("fill datas", datas)

                        var line = {
                            location:
                            findArrayByValue(country_data,
                                country_id,
                                function (x,y) {
                                    if (x.id === y) {
                                        return true
                                    }
                                    return false
                                }
                            ).<fmt:message key="data.field" />,
                            variable: findArrayByValue(index_data,
                                index_id,
                                function (x,y) {
                                    if (x.id === y) {
                                        return true
                                    }
                                    return false
                                }
                            ).<fmt:message key="data.field" />,
                            country_id: country_id,
                            index_id: index_id}

                        for (var data_i in datas) {
							var tmp_data = datas[data_i];
							console.log("当数据是",[country_id, index_id], "填充",tmp_data)
                            line['y'+tmp_data.time] = {value:tmp_data.value, id:tmp_data.id}
  					    }
  					    console.log("填充完成",line)
  					    local_data.push(line)

					}
                }


                console.log('local',local_data)
                data_adapter.dataBind()
                $('#data_grid').jqxGrid('render');
                $('#data_grid').jqxGrid('refresh');
            }
        });

    }()

});

</script>
</head>
<body>

<jsp:include page="../includes/html_body_header.jsp" />


<div id="cat_expander" class="left margin_15">
	<div><fmt:message key="text.category" /></div>
	<div style="overflow: hidden;">
		<div id="cat_tree" style="border: none;"></div>
	</div>
</div>

<div class="left margin_15" style="width: 650px;">
	<div style="width: 650px;">
		<div id="location_expander" class="left">
			<div><fmt:message key="common.dimension.country" /></div>
			<div style="overflow: hidden;">
				<div id="location_list" style="border: none;"></div>
			</div>
		</div>
		<div class="left" style="margin: 1px 15px 1px 15px;"></div>
		<div id="variable_expander" class="left">
			<div><fmt:message key="common.dimension.indicator" /></div>
			<div style="overflow: hidden;">
				<div id="variable_list" style="border: none;"></div>
			</div>
		</div>
		<div class="left" style="margin: 1px 15px 1px 15px;"></div>
		<div class="left">
			<div style="width: 100%;" class="center">
				<div id="time1" class="left">2005</div>
				<div id="time2" class="right">2010</div>
			</div>
			<div id="time_slider" class="center"></div>
		</div>
		<div class="clear"></div>
		<div class="margin_20"></div>
		<div class="left margin_h_150"></div>
		<div class="left">
			<input type="button" id="query_button" value="<fmt:message key="text.query" />" class="right">
		</div>
		<div class="left margin_10"></div>
		<div class="left">
			<input type="button" id="save_button" value="保存" class="right">
		</div>
		<div class="left margin_10"></div>
		<div class="left">
			<input type="button" id="import_button" value="导入" class="right">
		</div>
		<div class="left margin_10"></div>
		<div class="left">
			<input type="button" id="export_button" value="<fmt:message key="text.export" />" class="right">
		</div>
		<div class="clear"></div>
	</div>
	<div class="margin_15"></div>
	<div style="width: 650px;">
		<div id="data_grid"></div>
	</div>
</div>

<div class="clear"></div>

<div id="dialog_window">
	<div>请选择</div>
	<div style="overflow: hidden;">
		<div id="dialog_window_content" style="margin: 20px; height: 50px;">&nbsp;</div>
		<div class="right margin_10">
			<input type="button" id="dialog_window_ok_button" value="确定">
			<input type="button" id="dialog_window_cancel_button" value="取消">
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
