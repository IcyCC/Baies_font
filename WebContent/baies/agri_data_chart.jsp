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

page_id = 3;

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
var query_args = getQueryString()
var old_query_args = getQueryString();
var chart_title = ''
var kind_data = []

$(document).ready(function() {
	
	var cat_tree_src = agri_data_cat_tree_src_<fmt:message key="common.language" />;

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
            console.log(country_data,'r2')
            $('#location_list').jqxDropDownList('render')
            $('#location_list').jqxDropDownList('refresh')
        }.bind(this)

    });

    $.ajax({
        type:'GET',
        url:host+'/quantify/agriculture_kinds',
        data: {},
        xhrFields: {
            withCredentials: true
        },
        crossDomain: true,
        async: false,
        success: function (resp) {
            for (var index in resp.data) {
                kind_data.push(resp.data[index])
            }
            console.log(kind_data,'r2')
            $('#product_list').jqxDropDownList('render')
            $('#product_list').jqxDropDownList('refresh')
        }.bind(this)

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
	
	// $("#location_list").jqxDropDownList('checkIndex', 0);
	// $("#location_list").jqxDropDownList('checkIndex', 1);
	// $("#location_list").jqxDropDownList('checkIndex', 2);
	// $("#location_list").jqxDropDownList('checkIndex', 3);
	// $("#location_list").jqxDropDownList('checkIndex', 4);
	
	$('#product_expander').jqxExpander({
		width: '170px', showArrow: false, toggleMode: 'none', theme: '<%=jqx_theme %>'
	});

    $('#product_list').jqxDropDownList({
        source: kind_data, checkboxes: true,
        width: '100%', theme: '<%=jqx_theme %>',
        displayMember:'<fmt:message key="data.field" />',valueMember:"id"
    });

	// $("#product_list").jqxDropDownList('checkIndex', 0);
	//
	$('#variable_expander').jqxExpander({
		width: '170px', showArrow: false, toggleMode: 'none', theme: '<%=jqx_theme %>'
	});

    $('#variable_list').jqxDropDownList({
        source: index_data, checkboxes: true,
        width: '100%', theme: '<%=jqx_theme %>',
        displayMember:'<fmt:message key="data.field" />',valueMember:"id"
    });
	
	$("#variable_list").jqxDropDownList('checkIndex', 1);

    $('#time_slider').jqxSlider({
        width: '220px', values: [2005, 2010], min: 2000, max:myDate.getFullYear(), mode: 'fixed',
        rangeSlider: true, theme: '<%=jqx_theme %>', ticksFrequency: 1
    });


    $('#time_slider').on('change', function(event) {
		$('#time1').html(event.args.value.rangeStart);
		$('#time2').html(event.args.value.rangeEnd);
	});
	
	$('#query_button').jqxButton({
		width: '100px', height: '47px', theme: '<%=jqx_theme %>'
	});
	
	$('#query_button').on('click', function() {
        window.location.href='agri_data_table.jsp'+'?'+parseParam(query_args);
        window.location.reload()
	});
	
	$('#chart_button').jqxButton({
		width: '100px', height: '47px', template: 'primary', theme: '<%=jqx_theme %>'
	});

    $('#chart_button').on('click', function() {
        window.location.href='agri_data_chart.jsp'+parseParam(old_query_args);;
    });
	
	$('#export_button').jqxButton({
		width: '100px', height: '47px', theme: '<%=jqx_theme %>'
	});

    $('#export_button').on('click', function () { $("#data_grid").jqxGrid('exportdata', 'csv', '农业数据');});

    var data_source= [];
    var group_source=[];
	var settings = {
			title: chart_title,
			description: '',
			source: data_source,
			enableAnimations: true,
			xAxis: {
				dataField: 'time',
				valuesOnTicks: false,
				minValue: query_args.start_time,
				maxValue: query_args.end_time,
				gridLines: {visible: false},
			},
			valueAxis: {
				visible: true,
				title: {text: '<fmt:message key="common.indicator.total_production" /> (<fmt:message key="common.unit.ten_thousand_tons" />)'}
			},
			colorScheme: 'scheme04',
			seriesGroups: [
			               {
			            	   type: 'line',
			            	   toolTipFormatFunction: function(value, itemIndex, serie, group, categoryValue, categoryAxis) {
			            		   return value;
			            	   },
			            	   series: group_source
			               }
			               ]
	};
	$('#data_chart').jqxChart(settings);

	// 事件

    $('#cat_tree').on('select',function (event)
    {
        var args = event.args;
        var item = $('#cat_tree').jqxTree('getItem', args.element);

        query_args.table_id=item.value
        index_data.splice(0,index_data.length);
        query_args.index_ids.length=0
        for (var i in table_index_data[item.id]) {
            index_data.push(table_index_data[item.id][i])
        }
        console.log('qu', query_args)
        $("#variable_list").jqxDropDownList('render');
    });

    $('#variable_list').on('select', function (event) {
        var args = event.args;
        console.log(args)
        var item = $('#variable_list').jqxDropDownList('getItem', args.index);
        console.log("指标选择开始",item)
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


    $('#location_list').on('select', function (event) {
        var args = event.args;
        var item = $('#location_list').jqxDropDownList('getItem', args.index);
        console.log("国家选择开始s",item)

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

    $('#product_list').on('select', function (event) {
        var args = event.args;
        var item = $('#product_list').jqxDropDownList('getItem', args.index);
        console.log("国家选择开始s",item)

        if (item.checked === true) {
            query_args.kind_ids.push(item.value)
            console.log("国家选择")
        }
        else {
            console.log("国家取消")
            removeByValue(query_args.kind_ids,item.value)
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

        $('#cat_tree').jqxTree('selectItem',$("#cat_tree").find('li:eq(1)')[0])

        // for (var index_id_i in old_query_args.index_ids) {
        //    var index_id = old_query_args.index_ids[index_id_i]
        // 	query_args.index_ids.push(index_id)
        // }
        console.log("清空")
        query_args.country_ids.length = 0
        for (var country_id_i in old_query_args.country_ids) {
            var country_id = old_query_args.country_ids[country_id_i]
            $("#location_list").jqxDropDownList('checkItem',  $("#location_list").jqxDropDownList('getItemByValue',  country_id));
            $("#location_list").jqxDropDownList('selectItem',  $("#location_list").jqxDropDownList('getItemByValue',  country_id));

        }

        for (var index_id_i in old_query_args.index_ids) {
            var index_id = old_query_args.country_ids[index_id_i]

            $("#variable_list").jqxDropDownList('checkItem',  $("#variable_list").jqxDropDownList('getItemByValue',  index_id));
            $("#variable_list").jqxDropDownList('selectItem',  $("#variable_list").jqxDropDownList('getItemByValue',  index_id));

        }

        $('#time_slider').jqxSlider('setValue', [old_query_args.start_time, old_query_args.end_time]);


    }()

    var tmp = function init_data_columns () {

        $.ajax({
            type:'GET',
            url:host+'/quantify/agriculture_facts/graph'+location.search,
            data: {},
            xhrFields: {
                withCredentials: true
            },
            crossDomain: true,
            async: true,
            success: function (resp) {

                for (var cur = old_query_args.start_time;cur<= old_query_args.end_time; cur++) {
                    data_source.push({time:cur})
                }
                console.log('time')

                for (var conuntry_i in old_query_args.country_ids) {
                    var country = findArrayByValue(country_data, old_query_args.country_ids[conuntry_i], function (x, y) {
                        if (x.id === y) {
                            return true
                        }
                        return false
                    })
                    console.log('country', country)

                    for (var kind_i in old_query_args.kind_ids) {
                        var kind = findArrayByValue(kind_data, old_query_args.kind_ids[kind_i], function (x, y) {
                            if (x.id === y) {
                                return true
                            }
                            return false
                        })

                        console.log('kind', kind)
                        for (var index_i in old_query_args.index_ids) {
                            var index = findArrayByValue(index_data, old_query_args.index_ids[index_i], function (x, y) {
                                if (x.id === y) {
                                    return true
                                }
                                return false
                            })

                            console.log('index', index)
                            group_source.push({
                                dataField: '' + country.id + kind.id + index.id,
                                displayText: country.<fmt:message key="data.field" />+kind.<fmt:message key="data.field" /> + index.<fmt:message key="data.field" />,
                                symbolType: 'circle'
                            })
                        }

                    }
                }
                console.log('group', group_source)
                for (var data_i in resp.data) {
					var data = resp.data[data_i]
					console.log("获得数据",data)
					for (var point_i in data.series) {
					    var point = data.series[point_i]

						for (var source_i in data_source) {
					        if (data_source[source_i].time === point.x) {
					            data_source[source_i]['' + data.country.id + data.kind.id + data.index.id] = point.y
								break
							}
						}
					}
                }
                console.log('local',data_source)
                $('#data_chart').jqxChart("refresh")
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
		<div class="left" style="margin: 1px 35px 1px 35px;"></div>
		<div id="product_expander" class="left">
			<div><fmt:message key="common.dimension.product" /></div>
			<div style="overflow: hidden;">
				<div id="product_list" style="border: none;"></div>
			</div>
		</div>
		<div class="left" style="margin: 1px 35px 1px 35px;"></div>
		<div id="variable_expander" class="left">
			<div><fmt:message key="common.dimension.indicator" /></div>
			<div style="overflow: hidden;">
				<div id="variable_list" style="border: none;"></div>
			</div>
		</div>
		<div class="clear"></div>
		<div class="margin_20"></div>
		<div class="left">
			<div style="width: 100%;" class="center">
				<div id="time1" class="left">2005</div>
				<div id="time2" class="right">2010</div>
			</div>
			<div id="time_slider" class="center"></div>
		</div>
		<div class="left margin_20"></div>
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
		<div id="data_chart" style="width: 650px; height: 270px;"></div>
	</div>
</div>

<div class="clear"></div>


<jsp:include page="../includes/html_body_footer.jsp" />

</body>
</html>
