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



removeByValue = function(ary,val) {
    var index = ary.indexOf(val);
    if (index > -1) {
        ary.splice(index, 1);
    }
};

findArrayByValue = function (ary, value,func) {
    for (var index in ary) {
        if (func(ary[index], value) === true) {
            return ary[index]
        }
    }
    return {}
}

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
var query_args = getQueryString()
var old_query_args = getQueryString();
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
        url:'http://123.206.8.125:5000/quantify/socioeconomic_table',
        data: {},
        withCredentials: true,
        async: false,
        success: function (resp) {
            for (var table in resp.data) {
                console.log('table', resp.data[table])
                table_data.push({label: resp.data[table].name, value: resp.data[table].id, id:resp.data[table].id})
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
        url:'http://123.206.8.125:5000/quantify/country',
        data: {},
        withCredentials: true,
        async: false,
        success: function (resp) {
            for (var index in resp.data) {
                country_data.push(resp.data[index])
            }
            console.log(country_data,'r2')}.bind(this)
    });



	console.log(data_fields,data_columns)

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
        displayMember:"name",valueMember:"id"
	});
	
	// $("#location_list").jqxDropDownList('checkIndex', 0);
	// $("#location_list").jqxDropDownList('checkIndex', 1);
	// $("#location_list").jqxDropDownList('checkIndex', 2);
	// $("#location_list").jqxDropDownList('checkIndex', 3);
	// $("#location_list").jqxDropDownList('checkIndex', 4);
	// $("#location_list").jqxDropDownList('checkIndex', 5);
	// $("#location_list").jqxDropDownList('checkIndex', 6);
	
	$('#variable_expander').jqxExpander({
		width: '170px', showArrow: false, toggleMode: 'none', theme: '<%=jqx_theme %>'
	});
	
	$('#variable_list').jqxDropDownList({
		source: index_data, checkboxes: true,
		width: '100%', theme: '<%=jqx_theme %>',
        displayMember:"label",valueMember:"value"
	});
	
	// $("#variable_list").jqxDropDownList('checkIndex', 0);
	// $("#variable_list").jqxDropDownList('checkIndex', 1);
	// $("#variable_list").jqxDropDownList('checkIndex', 2);
	// $("#variable_list").jqxDropDownList('checkIndex', 3);
	// $("#variable_list").jqxDropDownList('checkIndex', 4);

	
	$('#time_slider').jqxSlider({
		width: '220px', values: [2005, 2010], min: 2000, max: 2016, mode: 'fixed',
		rangeSlider: true, theme: '<%=jqx_theme %>', ticksFrequency: 1
	});
	
	$('#time_slider').on('change', function(event) {
		$('#time1').html(event.args.value.rangeStart);
		$('#time2').html(event.args.value.rangeEnd);
	});
	
	$('#query_button').jqxButton({
		width: '100px', height: '47px', template: 'primary', theme: '<%=jqx_theme %>'
	});
	
	$('#query_button').on('click', function() {
		//window.location.href='econ_data_table.jsp';
	});
	
	$('#chart_button').jqxButton({
		width: '100px', height: '47px', theme: '<%=jqx_theme %>'
	});
	
	$('#chart_button').on('click', function() {
		window.location.href='econ_data_chart.jsp';
	});
	
	$('#export_button').jqxButton({
		width: '100px', height: '47px', theme: '<%=jqx_theme %>'
	});
	

	$('#data_grid').jqxGrid({
		width: '650px', height: '270px', source: data_adapter, columnsresize: true,
		columns: data_columns, theme: '<%=jqx_theme %>'
	});

    // 处理事件
    $('#cat_tree').on('select',function (event)
    {
        var args = event.args;
        var item = $('#cat_tree').jqxTree('getItem', args.element);

        query_args.table_id=item.value
        index_data.splice(0,index_data.length);
        query_args.index_ids=[]
        for (var i in table_index_data[item.id]) {
            index_data.push({label:table_index_data[item.id][i].name, value:table_index_data[item.id][i].id, id:table_index_data[item.id][i].id})
        }
        console.log('qu', query_args)
        $("#variable_list").jqxDropDownList('render');
    });

    $('#variable_list').on('select', function (event) {
        var args = event.args;
        console.log(args)
        var item = $('#variable_list').jqxDropDownList('getItem', args.index);
        if (item.checked === true) {
            query_args.index_ids.push(item.value)
        }
        else {
            removeByValue(query_args.index_ids,item.value)
        }
        console.log('qu', query_args)
    })


    $('#location_list').on('select', function (event) {
        var args = event.args;
        var item = $('#location_list').jqxDropDownList('getItem', args.index);
        if (item.checked === true) {
            query_args.country_ids.push(item.id)
        }
        else {
            removeByValue(query_args.country_ids,item.id)
        }
        console.log('qu', query_args)
    })
    // var values = $('#time_slider').jqxSlider('values');
    // query_args.start_time = values[0].toString();
    // query_args.end_time = values[1].toString();

    // $('#time_slider').on('change', function (event) {
    //     var values = $('#time_slider').jqxSlider('values');
    //     query_args.start_time = values[0]
    //     query_args.end_time = values[1]
    //     console.log('qu', query_args)
    // });

    $('#cat_tree').jqxTree('selectItem',$("#cat_tree").find('li:first')[0])


    var checked_variable_list_func = function () {
        for (var country_id_i in old_query_args.country_ids) {
            var country_id = old_query_args.country_ids[country_id_i]
            $("#location_list").jqxDropDownList('checkItem',  $("#location_list").jqxDropDownList('getItemByValue',  country_id));
        }

        for (var index_id_i in old_query_args.index_ids) {
            var index_id = old_query_args.country_ids[index_id_i]
            $("#variable_list").jqxDropDownList('checkItem',  $("#variable_list").jqxDropDownList('getItemByValue',  index_id));
        }

    }()

    var tmp = function init_data_columns () {
        for (var year = old_query_args.start_time;year<=old_query_args.end_time; year++){
            data_fields.push({name: 'y'+year, type: 'object', map: 'y'+year.toString()+'>value'} );
            data_fields.push({name: 'y'+year+'_id', type: 'object', map: 'y'+year.toString()+'>id'} );
            data_columns.push({text: year.toString(), datafield: 'y'+year, width: 70, cellsalign: 'right'})
            console.log('fill',year)
        }
        console.log("PUll data")
        $.ajax({
            type:'GET',
            url:'http://123.206.8.125:5000/quantify/socioeconomic_facts'+location.search,
            data: {},
            withCredentials: true,
            async: true,
            success: function (resp) {

                for (var index_id_i in old_query_args.index_ids) {
                    var index_id = old_query_args.index_ids[index_id_i]
                    var tmp_same_index_data = findArrayByValue(
                        resp.data,
                        index_id,
                        function (x,y) {
                            if (x.index.id === y) {
                                return true
                            }
                            return false
                        })

                    console.log("tmp_same_index_data",tmp_same_index_data)
                    for (var country_id_i in old_query_args.country_ids) {
                        var country_id = old_query_args.country_ids[country_id_i]
                        var tmp_same_country_data = findArrayByValue(
                            tmp_same_index_data.data,
                            country_id,
                            function (x,y) {
                                if (x.country.id === y) {
                                    return true
                                }
                                return false
                            }).data

                        console.log("tmp_same_country_data",tmp_same_country_data)
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
                            ).name,
                            variable: findArrayByValue(index_data,
                                index_id,
                                function (x,y) {
                                    if (x.id === y) {
                                        return true
                                    }
                                    return false
                                }
                            ).name,
                            country_id: country_id,
                            index_id: index_id
                        }
                        for (var tmp_data_i in tmp_same_country_data) {
                            var tmp_data = tmp_same_country_data[tmp_data_i]
                            console.log('fill_data',tmp_data)
                            line['y'+tmp_data.time] = {value:tmp_data.value, id:tmp_data.id}
                        }

                        local_data.push(line)
                        console.log('line',line)
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
			<input type="button" id="chart_button" value="<fmt:message key="text.chart" />" class="right">
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


<jsp:include page="../includes/html_body_footer.jsp" />

</body>
</html>
