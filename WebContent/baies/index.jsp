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


$(document).ready(function() {

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
		
		var chart_data_source = [
	           		{<fmt:message key="common.dimension.time" />:2005, <fmt:message key="common.country.brazil" />:18848, <fmt:message key="common.country.russia" />:14362, <fmt:message key="common.country.india" />:114433, <fmt:message key="common.country.china" />:133562, '<fmt:message key="common.country.south_africa" />':4835 },
	           		{<fmt:message key="common.dimension.time" />:2006, <fmt:message key="common.country.brazil" />:19070, <fmt:message key="common.country.russia" />:14334, <fmt:message key="common.country.india" />:116209, <fmt:message key="common.country.china" />:134277, '<fmt:message key="common.country.south_africa" />':4903 },
	           		{<fmt:message key="common.dimension.time" />:2007, <fmt:message key="common.country.brazil" />:19278, <fmt:message key="common.country.russia" />:14318, <fmt:message key="common.country.india" />:117969, <fmt:message key="common.country.china" />:134994, '<fmt:message key="common.country.south_africa" />':4969 },
	           		{<fmt:message key="common.dimension.time" />:2008, <fmt:message key="common.country.brazil" />:19477, <fmt:message key="common.country.russia" />:14312, <fmt:message key="common.country.india" />:119707, <fmt:message key="common.country.china" />:135715, '<fmt:message key="common.country.south_africa" />':5035 },
	           		{<fmt:message key="common.dimension.time" />:2009, <fmt:message key="common.country.brazil" />:19670, <fmt:message key="common.country.russia" />:14313, <fmt:message key="common.country.india" />:121418, <fmt:message key="common.country.china" />:136441, '<fmt:message key="common.country.south_africa" />':5099 },
	           		{<fmt:message key="common.dimension.time" />:2010, <fmt:message key="common.country.brazil" />:19861, <fmt:message key="common.country.russia" />:14316, <fmt:message key="common.country.india" />:123098, <fmt:message key="common.country.china" />:137170, '<fmt:message key="common.country.south_africa" />':5162 }
	           	                   ];
		var chart_settings = {
	           			title: '<fmt:message key="common.indicator.population" /> <fmt:message key="text.trend_chart" /> (2005 - 2010)',
	           			description: '',
	           			source: chart_data_source,
	           			enableAnimations: true,
	           			xAxis: {
	           				dataField: '<fmt:message key="common.dimension.time" />',
	           				valuesOnTicks: false,
	           				minValue: 2005,
	           				maxValue: 2010,
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
	           			            	   series: [
	           			            	            {dataField: '<fmt:message key="common.country.brazil" />', displayText: '<fmt:message key="common.country.brazil" />', symbolType: 'circle'},
	           			            	            {dataField: '<fmt:message key="common.country.russia" />', displayText: '<fmt:message key="common.country.russia" />', symbolType: 'square'},
	           			            	            {dataField: '<fmt:message key="common.country.india" />', displayText: '<fmt:message key="common.country.india" />', symbolType: 'diamond'},
	           			            	            {dataField: '<fmt:message key="common.country.china" />', displayText: '<fmt:message key="common.country.china" />', symbolType: 'triangle_up'},
	           			            	            {dataField: '<fmt:message key="common.country.south_africa" />', displayText: '<fmt:message key="common.country.south_africa" />', symbolType: 'triangle_down'}
	           			            	            ]
	           			               }
	           			               ]
		};
		$('#data_chart_1').jqxChart(chart_settings);
		$('#data_chart_2').jqxChart(chart_settings);
		$('#data_chart_3').jqxChart(chart_settings);
	};
	$('#econ_tabs').jqxTabs({width: '100%', position: 'top', initTabContent: init_econ_widgets, theme: '<%=jqx_theme %>'});

	$('#agri_expander').jqxExpander({
		width: '350px', height: '280px', showArrow: false, toggleMode: 'none', theme: '<%=jqx_theme %>'
	});
	
	var init_agri_widgets = function (tab) {
		
		var local_data = [
		                   ['<fmt:message key="common.country.brazil" />', '<fmt:message key="common.product.rice" />', '<fmt:message key="common.indicator.total_production" /> (<fmt:message key="common.unit.ten_thousand_tons" />)', 392, 297, 289, 285, 287, 272],
		                   ['<fmt:message key="common.country.russia" />', '<fmt:message key="common.product.rice" />', '<fmt:message key="common.indicator.total_production" /> (<fmt:message key="common.unit.ten_thousand_tons" />)', 14, 16, 16, 16, 18, 20],
		                   ['<fmt:message key="common.country.india" />', '<fmt:message key="common.product.rice" />', '<fmt:message key="common.indicator.total_production" /> (<fmt:message key="common.unit.ten_thousand_tons" />)', 4366, 4381, 4391, 4554, 4192, 4286],
		                   ['<fmt:message key="common.country.china" />', '<fmt:message key="common.product.rice" />', '<fmt:message key="common.indicator.total_production" /> (<fmt:message key="common.unit.ten_thousand_tons" />)', 2912, 2956, 2918, 2949, 2988, 3012],
		                   ['<fmt:message key="common.country.south_africa" />', '<fmt:message key="common.product.rice" />', '<fmt:message key="common.indicator.total_production" /> (<fmt:message key="common.unit.ten_thousand_tons" />)', 0, 0, 0, 0, 0, 0]
		                   ];
		var data_fields = [
		                   {name: 'location', type: 'string', map: '0'},
		                   {name: 'product', type: 'string', map: '1'},
		                   {name: 'variable', type: 'string', map: '2'},
		                   {name: 'y2005', type: 'number', map: '3'},
		                   {name: 'y2006', type: 'number', map: '4'},
		                   {name: 'y2007', type: 'number', map: '5'},
		                   {name: 'y2008', type: 'number', map: '6'},
		                   {name: 'y2009', type: 'number', map: '7'},
		                   {name: 'y2010', type: 'number', map: '8'}
		                   ];
		var data_columns = [
		                   {text: '<fmt:message key="common.dimension.country" />', datafield: 'location', width: 50},
		                   {text: '<fmt:message key="common.dimension.product" />', datafield: 'product', width: 40},
		                   {text: '<fmt:message key="common.dimension.indicator" />', datafield: 'variable', width: 70},
		                   {text: '2005', datafield: 'y2005', width: 40, cellsalign: 'right'},
		                   {text: '2006', datafield: 'y2006', width: 40, cellsalign: 'right'},
		                   {text: '2007', datafield: 'y2007', width: 40, cellsalign: 'right'},
		                   {text: '2008', datafield: 'y2008', width: 40, cellsalign: 'right'},
		                   {text: '2009', datafield: 'y2009', width: 40, cellsalign: 'right'},
		                   {text: '2010', datafield: 'y2010', width: 40, cellsalign: 'right'}
		               ];
		var data_source = {
				localdata: local_data,
				datafields: data_fields,
				datatype: 'array'
		};
		var data_adapter = new $.jqx.dataAdapter(data_source);
		$('#data_grid_1').jqxGrid({
			width: '345px', height: '215px', source: data_adapter, columnsresize: true, columns: data_columns, theme: '<%=jqx_theme %>'
		});
		$('#data_grid_2').jqxGrid({
			width: '345px', height: '215px', source: data_adapter, columnsresize: true, columns: data_columns, theme: '<%=jqx_theme %>'
		});
		$('#data_grid_3').jqxGrid({
			width: '345px', height: '215px', source: data_adapter, columnsresize: true, columns: data_columns, theme: '<%=jqx_theme %>'
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
	<div id="scroll_view" class="left">
		<div><div class="photo" style="background-image: url(../images/sv1.jpg)"></div></div>
		<div><div class="photo" style="background-image: url(../images/sv2.jpg)"></div></div>
		<div><div class="photo" style="background-image: url(../images/sv3.jpg)"></div></div>
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
					<li><fmt:message key="text.economy" /></li>
					<li><fmt:message key="text.trade" /></li>
				</ul>
				<div style="overflow: hidden;"><div id="data_chart_1" style="width: 350px; height: 220px;"></div></div>
				<div style="overflow: hidden;"><div id="data_chart_2" style="width: 350px; height: 220px;"></div></div>
				<div style="overflow: hidden;"><div id="data_chart_3" style="width: 350px; height: 220px;"></div></div>
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
					<li><fmt:message key="text.trade" /></li>
					<li><fmt:message key="text.investment" /></li>
				</ul>
				<div><div id="data_grid_1"></div></div>
				<div><div id="data_grid_2"></div></div>
				<div><div id="data_grid_3"></div></div>
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
