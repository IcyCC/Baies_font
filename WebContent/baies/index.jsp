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
if(jqx_theme == null) {
	request.getSession().setAttribute("jqx_theme", "arctic");
	jqx_theme = (String)request.getSession().getAttribute("jqx_theme");
}

String jqx_nav_theme = (String)request.getSession().getAttribute("jqx_nav_theme");
if(jqx_nav_theme == null) {
	request.getSession().setAttribute("jqx_nav_theme", "darkblue");
	jqx_nav_theme = (String)request.getSession().getAttribute("jqx_nav_theme");
}
%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="../includes/html_head.jsp" />
<title><fmt:message key="common.title" /></title>
<script>

page_id = 0;

var arg_query_args = {
    country_ids: [1,2],
    end_time: 2018,
    start_time: 2014,
    table_id: 2,
    kind_ids: [1,2,3,4],
    index_ids: [3,4]
}

var econ_query_args = {
    country_ids: [1,3,2],
	table_id: 1,
	index_ids: [2,3,1],
	start_time: 2013,
	end_time: 2018
};


var country_data = [];
var arg_index_data = [];
var arg_kind_data = [];
var arg_table_data = [];
var arg_table_index_data= {};

var table_index_data= {};
var table_data = [];
var index_data = [];


var parseParam=function(param){
    var paramStr="";
    for (var key in param) {
        paramStr = paramStr+ "&"+ key + '=' + JSON.stringify(param[key])
    }
    return paramStr.substr(1);
};

var findArrayByValue = function (ary, value,func) {
    for (var index in ary) {
        if (func(ary[index], value) === true) {
            return ary[index]
        }
    }
    return {}
}

$(document).ready(function() {
    $("#jqxLoader").jqxLoader('open')
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
            console.log(country_data,'r2')
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
        async: true,
        success: function (resp) {
            for (var index in resp.data) {
                arg_kind_data.push(resp.data[index])
            }
            console.log(arg_kind_data,'r2')
        }.bind(this)
    });

    $.ajax({
        type:'GET',
        url:host+'/quantify/agriculture_table',
        data: {},
        xhrFields: {
            withCredentials: true
        },
        crossDomain: true,
        async: true,
        success: function (resp) {
            for (var table in resp.data) {
                console.log('table', resp.data[table])
                arg_table_data.push({label: resp.data[table].<fmt:message key="data.field" />, value: resp.data[table].id, id:resp.data[table].id})
                arg_table_index_data[resp.data[table].id] = resp.data[table].indexes
            }
            arg_index_data = arg_table_index_data[2]
            console.log('table', arg_table_data, 'index', arg_table_index_data)
        }.bind(this)
    })

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
            index_data = table_index_data[1]

        }.bind(this)
    })

    $.ajax({
        type: "get",
        async: false,
        xhrFields: {
            withCredentials: true
        },
        crossDomain: true,
        url: host+"/qualitative/Images?status=1",
        data: {},
        success: function (result) {
            console.log(result)
            var data = result.data
            console.log(data)
            data.forEach(function (value) {
                $("#scroll_view").append('<div><div class="photo" style="background-image: url(' + value.img_url+
                    ')"></div></div>')
            })
        }
    });

	$('#scroll_view').jqxScrollView({
		width: 520, height: 280, buttonsOffset: [0, 0], slideShow: true, slideDuration: 5000, theme: '<%=jqx_theme %>'
	});
	
	$('#news_expander').jqxExpander({
		width: '400px', height: '280px', showArrow: false, toggleMode: 'none', theme: '<%=jqx_theme %>'
	});
	
	$('#econ_expander').jqxExpander({
		width: '350px', height: '280px', showArrow: false, toggleMode: 'none', theme: '<%=jqx_theme %>'
	});
	
	$('#policy_expander_1').jqxExpander({
		width: '290px', height: '280px', showArrow: false, toggleMode: 'none', theme: '<%=jqx_theme %>'
	});
	
	$('#policy_expander_2').jqxExpander({
		width: '290px', height: '280px', showArrow: false, toggleMode: 'none', theme: '<%=jqx_theme %>'
	});
	
	var init_econ_widgets = function (tab) {
        var econ_data_source= [];
        var econ_group_source=[];
        var chart_settings = {
            title: '',
            description: '',
            source: econ_data_source,
            enableAnimations: true,
            xAxis: {
                dataField: 'time',
                valuesOnTicks: false,
                minValue: econ_query_args.start_time,
                maxValue: econ_query_args.end_time,
                gridLines: {visible: false},
            },
            valueAxis: {
                visible: true,
                title: {text: '<fmt:message key="common.indicator.population" /> (<fmt:message key="common.unit.ten_thousand_people" />)'}
            },
            colorScheme: 'scheme04',
            seriesGroups: [
                {
                    type: 'line',
                    toolTipFormatFunction: function(value, itemIndex, serie, group, categoryValue, categoryAxis) {
                        return value;
                    },
                    series: econ_group_source
                }
            ]
        };
        $.ajax({
            type:'GET',
            url:host+'/quantify/socioeconomic_facts/graph?'+parseParam(econ_query_args),
            data: {},
            xhrFields: {
                withCredentials: true
            },
            crossDomain: true,
            async: false,
            success: function (resp) {

                for (var cur = econ_query_args.start_time;cur<= econ_query_args.end_time; cur++) {
                    econ_data_source.push({time:cur})
                }

                for (var conuntry_i in econ_query_args.country_ids) {
                    var country = findArrayByValue(country_data, econ_query_args.country_ids[conuntry_i], function (x, y) {
                        if (x.id === y) {
                            return true
                        }
                        return false
                    })
                    console.log('country', country)

                    for (var index_i in econ_query_args.index_ids) {
                        var index = findArrayByValue(index_data, econ_query_args.index_ids[index_i], function (x, y) {
                            if (x.id === y) {
                                return true
                            }
                            return false
                        })

                        console.log('index', index)
                        econ_group_source.push({
                            dataField: '' + country.id + index.id,
                            displayText: country.<fmt:message key="data.field" />+ index.<fmt:message key="data.field" />,
                            symbolType: 'circle'
                        })
                    }
                }

                for (var data_i in resp.data) {
                    var data = resp.data[data_i]
                    console.log("获得数据",data)
                    for (var point_i in data.series) {
                        var point = data.series[point_i]

                        for (var source_i in econ_data_source) {
                            if (econ_data_source[source_i].time === point.x) {
                                econ_data_source[source_i]['' + data.country.id + data.index.id] = point.y
                                break
                            }
                        }
                    }
                }
                $('#data_chart_1').jqxChart(chart_settings);
            }
        });
	};
	$('#econ_tabs').jqxTabs({width: '100%', position: 'top', initTabContent: init_econ_widgets, theme: '<%=jqx_theme %>'});

	$('#agri_expander').jqxExpander({
		width: '350px', height: '280px', showArrow: false, toggleMode: 'none', theme: '<%=jqx_theme %>'
	});

	var init_agri_widgets = function (tab) {

        var local_data = [
        ];

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

        var data_source = {
            localdata: local_data,
            datafields: data_fields,
            datatype: 'array'
        };
        var data_adapter = new $.jqx.dataAdapter(data_source);
        $('#data_grid_1').jqxGrid({
            width: '345px', height: '215px', source: data_adapter, columnsresize: true, columns: data_columns, theme: '<%=jqx_theme %>'
        });

        for (var year = arg_query_args.start_time;year<=arg_query_args.end_time; year++){
            data_fields.push({name: 'y'+year, type: 'object', map: 'y'+year.toString()+'>value'} );
            data_fields.push({name: 'y'+year+'_id', type: 'object', map: 'y'+year.toString()+'>id'} );
            data_columns.push({text: year.toString(), datafield: 'y'+year, width: 70, cellsalign: 'right'})
            console.log('fill',year)
        }
        $.ajax({
            type:'GET',
            url:host+'/quantify/agriculture_facts?'+parseParam(arg_query_args),
            data: {},
            xhrFields: {
                withCredentials: true
            },
            crossDomain: true,
            async: true,
            success: function (resp) {

                for (var index_id_i in arg_query_args.index_ids) {
                    var index_id = arg_query_args.index_ids[index_id_i]
                    for (var country_id_i in arg_query_args.country_ids) {
                        var country_id = arg_query_args.country_ids[country_id_i]
                        for (var kind_id_i in arg_query_args.kind_ids) {
                            var kind_id = arg_query_args.kind_ids[kind_id_i]

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
                                index: findArrayByValue(arg_index_data,
                                    index_id,
                                    function (x,y) {
                                        if (x.id === y) {
                                            return true
                                        }
                                        return false
                                    }
                                ).<fmt:message key="data.field" />,
                                kind: findArrayByValue(arg_kind_data,
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
                            local_data.push(line)
                        }
                    }
                }
                console.log('local',local_data)
                data_adapter.dataBind()

            }
        });
	};

	$('#agri_tabs').jqxTabs({ width: '100%', position: 'top', initTabContent: init_agri_widgets, theme: '<%=jqx_theme %>'});
	
	$('#policy_expander_3').jqxExpander({
		width: '290px', height: '280px', showArrow: false, toggleMode: 'none', theme: '<%=jqx_theme %>'
	});
	
	$('#policy_expander_4').jqxExpander({
		width: '290px', height: '280px', showArrow: false, toggleMode: 'none', theme: '<%=jqx_theme %>'
	});
	
});

    $(document).ready(function() {
    $.ajax({
        type: "get",
        async: false,
        xhrFields: {
            withCredentials: true
        },
        crossDomain: true,
        url: host+"/qualitative/Post/simple?show=true",
        data: {},
        success: function (result) {
            console.log(result)
            var data = result.data
            console.log(data)
            data.forEach(function (value,index) {
				console.log(value.kind_id)
				if(index <10){
                    // $(".scroll_view").append('<div><div class="photo" style="background-image: url('+value.img_url+')"></div></div>')
                    $(".news_expander").append('<div class="news_content">·<a href="policy_detail.jsp?id='+ value.id+'">'+value.title+'</a></div>')
                }
				if(value.kind_id == 1){
                    $(".policy_expander_1").append('<div class="news_content">· <a href="policy_detail.jsp?id='+ value.id+'">'+value.title+'</a></div>')
                }else if(value.kind_id == 2){
                    $(".policy_expander_2").append('<div class="news_content">· <a href="policy_detail.jsp?id='+ value.id+'">'+value.title+'</a></div>')
                }else if(value.kind_id == 3){
                    $(".policy_expander_3").append('<div class="news_content">·<a href="policy_detail.jsp?id='+ value.id+'">'+value.title+'</a></div>')
                }else{
                    $(".policy_expander_4").append('<div class="news_content">·<a href="policy_detail.jsp?id='+ value.id+'">'+value.title+'</a></div>')
                }
            })
        }

    });
        $("#jqxLoader").jqxLoader('close')

})

</script>
<style type="text/css">
.photo {
	width: 520px;
	height: 280px;
	background-color: #000;
	background-position: center;
	background-repeat: no-repeat;
}
.news_content {
	font-size: 14px;
	margin: 20px 0 20px 10px;
}
</style>
</head>
<body>

<jsp:include page="../includes/html_body_header.jsp" />


<div class="margin_20">
	<div id="jqxLoader">

	</div>
	<div id="scroll_view" class="left">
	</div>
	<div class="left margin_15"></div>
	<div id="news_expander" class="left">
		<div style="width: 98%;"><div class="left"><fmt:message key="index.latest_news" /></div><div class="right"><a href=""><fmt:message key="text.more" />&gt;</a></div></div>
		<div style="overflow: hidden;" class="news_expander">
			<div class="margin_30"></div>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title" /></a></div>--%>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title" /></a></div>--%>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title" /></a></div>--%>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title" /></a></div>--%>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title" /></a></div>--%>
		</div>
	</div>
	<div class="clear"></div>
</div>

<div style="margin: 0 20px 20px 20px;">
	<div id="econ_expander" class="left">
		<div style="width: 98%;"><div class="left"><fmt:message key="cat.econ" /></div><div class="right"><a href=""><fmt:message key="text.more" />&gt;</a></div></div>
		<div style="overflow: hidden;">
			<div id="econ_tabs">
				<ul>
					<li><fmt:message key="text.population" /></li>
				</ul>
				<div style="overflow: hidden;"><div id="data_chart_1" style="width: 350px; height: 220px;"></div></div>
			</div>
		</div>
	</div>
	<div class="left margin_5"></div>
	<div id="policy_expander_1" class="left">
		<div style="width: 98%;"><div class="left"><fmt:message key="cat.dev" /></div><div class="right"><a href=""><fmt:message key="text.more" />&gt;</a></div></div>
		<div style="overflow: hidden;" class="policy_expander_1">
			<div class="margin_30"></div>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title_short" /></a></div>--%>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title_short" /></a></div>--%>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title_short" /></a></div>--%>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title_short" /></a></div>--%>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title_short" /></a></div>--%>
		</div>
	</div>
	<div class="left margin_5"></div>
	<div id="policy_expander_2" class="left">
		<div style="width: 98%;"><div class="left"><fmt:message key="cat.trade" /></div><div class="right"><a href=""><fmt:message key="text.more" />&gt;</a></div></div>
		<div style="overflow: hidden;" class="policy_expander_2">
			<div class="margin_30"></div>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title_short" /></a></div>--%>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title_short" /></a></div>--%>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title_short" /></a></div>--%>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title_short" /></a></div>--%>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title_short" /></a></div>--%>
		</div>
	</div>
	<div class="clear"></div>
</div>

<div style="margin: 0 20px 20px 20px;">
	<div id="agri_expander" class="left">
		<div style="width: 98%;"><div class="left"><fmt:message key="cat.agri" /></div><div class="right"><a href=""><fmt:message key="text.more" />&gt;</a></div></div>
		<div style="overflow: hidden;">
			<div id="agri_tabs">
				<ul>
					<li><fmt:message key="text.production" /></li>
				</ul>
				<div><div id="data_grid_1"></div></div>
			</div>
		</div>
	</div>
	<div class="left margin_5"></div>
	<div id="policy_expander_3" class="left">
		<div style="width: 98%;"><div class="left"><fmt:message key="cat.tech" /></div><div class="right"><a href=""><fmt:message key="text.more" />&gt;</a></div></div>
		<div style="overflow: hidden;" class="policy_expander_3">
			<div class="margin_30"></div>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title_short" /></a></div>--%>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title_short" /></a></div>--%>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title_short" /></a></div>--%>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title_short" /></a></div>--%>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title_short" /></a></div>--%>
		</div>
	</div>
	<div class="left margin_5"></div>
	<div id="policy_expander_4" class="left">
		<div style="width: 98%;"><div class="left"><fmt:message key="cat.fish" /></div><div class="right"><a href=""><fmt:message key="text.more" />&gt;</a></div></div>
		<div style="overflow: hidden;" class="policy_expander_4">
			<div class="margin_30"></div>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title_short" /></a></div>--%>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title_short" /></a></div>--%>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title_short" /></a></div>--%>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title_short" /></a></div>--%>
			<%--<div class="news_content">· <a href="#"><fmt:message key="temp.policy_title_short" /></a></div>--%>
		</div>
	</div>
	<div class="clear"></div>
</div>

<jsp:include page="../includes/html_body_footer.jsp" />

</body>
<script>

</script>
</html>
