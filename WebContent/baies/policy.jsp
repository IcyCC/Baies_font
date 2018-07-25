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

$(document).ready(function() {

	$('#cat_tabs').jqxTabs({width: '998px', position: 'top', theme: '<%=jqx_theme %>'});

	var rows = $("#news_ul");
    var data_kind_1 = [];
    var data_kind_2 = [];
    var data_kind_3 = [];
    var data_kind_4 = [];
    $.ajax({
        type: "get",
        async: false,
        xhrFields: {
            withCredentials: true
        },
        crossDomain: true,
        url: host+"/qualitative/Post?show=true",
        data: {},
        success: function (result) {
            var datas = result.data
            datas.forEach(function (value,index) {
                var row = rows[0];
                var datarow = {};
                datarow['id'] = value.id;
                datarow['title'] = value.title;
                datarow['body'] = value.body;
                datarow['kind_id'] = value.kind_id;
                datarow['img_url'] = "<img width='50px' height='30px' src="+ value.img_url +" >"+"</img>"
                // console.log(datarow)

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
            })
        }
    });
    var source_kind_1 = {
        localdata: data_kind_1,
        datatype: 'array',
        datafields: [{name:'id', type:'number'},
            {name: 'title', type: 'string'},
            {name: 'body', type:'string'},
            {name: 'kind_id', type:'string'},
            {name: 'img_url', type:'string'}]
    };

    var dataAdapter_kind_1 = new $.jqx.dataAdapter(source_kind_1);
    var settings_kind_1 = {
        width: '90%',
        source: dataAdapter_kind_1,
		autoheight: true,
		autorowheight: true,
		showheader: false,
		pageable: true,
		pagesize: 5,
		columns: [
		    {text: '<fmt:message key="post.title" />', dataField: 'title'},
            {text: '<fmt:message key="post.img_url" />', dataField:'img_url'},
		    {text: '<fmt:message key="post.body" />', dataField: 'body'}
		    ]
    };

    var source_kind_2 = {
        localdata: data_kind_2,
        datatype: 'array',
        datafields: [{name:'id', type:'number'},
            {name: 'title', type: 'string'},
            {name: 'body', type:'string'},
            {name: 'kind_id', type:'string'},
            {name: 'img_url', type:'string'}]
    };
    var dataAdapter_kind_2 = new $.jqx.dataAdapter(source_kind_2);
    var settings_kind_2 = {
        width: '90%',
        source: dataAdapter_kind_2,
		autoheight: true,
		autorowheight: true,
		showheader: false,
		pageable: true,
		pagesize: 5,
		columns: [
            {text: '<fmt:message key="post.title" />', dataField: 'title'},
            {text: '<fmt:message key="post.img_url" />', dataField:'img_url'},
            {text: '<fmt:message key="post.body" />', dataField: 'body'}
		    ]
    };

    var source_kind_3 = {
        localdata: data_kind_3,
        datatype: 'array',
        datafields: [{name:'id', type:'number'},
            {name: 'title', type: 'string'},
            {name: 'body', type:'string'},
            {name: 'kind_id', type:'string'},
            {name: 'img_url', type:'string'}]
    };
    var dataAdapter_kind_3 = new $.jqx.dataAdapter(source_kind_3);
    var settings_kind_3 = {
        width: '90%',
        source: dataAdapter_kind_3,
		autoheight: true,
		autorowheight: true,
		showheader: false,
		pageable: true,
		pagesize: 5,
		columns: [
            {text: '<fmt:message key="post.title" />', dataField: 'title'},
            {text: '<fmt:message key="post.img_url" />', dataField:'img_url'},
            {text: '<fmt:message key="post.body" />', dataField: 'body'}
		    ]
    };

    var source_kind_4 = {
        localdata: data_kind_4,
        datatype: 'array',
        datafields: [{name:'id', type:'number'},
            {name: 'title', type: 'string'},
            {name: 'body', type:'string'},
            {name: 'kind_id', type:'string'},
            {name: 'img_url', type:'string'}]
    };
    var dataAdapter_kind_4 = new $.jqx.dataAdapter(source_kind_4);
    var settings_kind_4 = {
        width: '90%',
        source: dataAdapter_kind_4,
		autoheight: true,
		autorowheight: true,
		showheader: false,
		pageable: true,
		pagesize: 5,
		columns: [
            {text: '<fmt:message key="post.title" />', dataField: 'title'},
            {text: '<fmt:message key="post.img_url" />', dataField:'img_url'},
            {text: '<fmt:message key="post.body" />', dataField: 'body'}

		    ]
    };

    // var data = [];
	// for (var i = 0; i < 100; i++) {
	// 	var row = rows[0];
	// 	var datarow = {};
	// 	datarow['news'] = $(row).find('li').html();
	// 	console.log($(row).find('li').html())
	// 	data[data.length] = datarow;
	// }
	// var source = {
	// 		localdata: data,
	// 		datatype: 'array',
	// 		datafields: [{name: 'news', type: 'string'}],
	// };
	// var dataAdapter = new $.jqx.dataAdapter(source);
	// var settings = {
	// 		width: '90%',
	// 		source: dataAdapter,
	// 		autoheight: true,
	// 		autorowheight: true,
	// 		showheader: false,
	// 		pageable: true,
	// 		pagesize: 5,
	// 		columns: [{text: 'news', dataField: 'news'}]
	// };
	$('#news_grid_1').jqxGrid(settings_kind_1);
	$('#news_grid_2').jqxGrid(settings_kind_2);
	$('#news_grid_3').jqxGrid(settings_kind_3);
	$('#news_grid_4').jqxGrid(settings_kind_4);

    // $("#contenttablenews_grid_1 div").click(function () {
    //     window.location.href="输入另一个页面的链接"
    // })
    $('#news_grid_1').on('rowclick', function (event) {
        var args = event.args;
        var boundIndex = args.rowindex;
        var data = $('#news_grid_1').jqxGrid('getrowdata', boundIndex);
        var id = data.id;
        window.location.href="policy_detail.jsp?id="+ id;
        console.log(data)
	}) ;
	$('#news_grid_2').on('rowclick', function (event) {
        var args = event.args;
        var boundIndex = args.rowindex;
        var data = $('#news_grid_2').jqxGrid('getrowdata', boundIndex);
        var id = data.id;
        window.location.href="policy_detail.jsp?id="+ id;
        console.log(data)
	});
	$('#news_grid_3').on('rowclick', function (event) {
        var args = event.args;
        var boundIndex = args.rowindex;
        var data = $('#news_grid_3').jqxGrid('getrowdata', boundIndex);
        var id = data.id;
        window.location.href="policy_detail.jsp?id="+ id;
        console.log(data)
	});
	$('#news_grid_4').on('rowclick', function (event) {
        var args = event.args;
        var boundIndex = args.rowindex;
        var data = $('#news_grid_4').jqxGrid('getrowdata', boundIndex);
        var id = data.id;
        window.location.href="policy_detail.jsp?id="+ id;
        console.log(data)
	})
	// $('#news_grid_2').jqxGrid(settings);
	// $('#news_grid_3').jqxGrid(settings);
	// $('#news_grid_4').jqxGrid(settings);

    //获取url中的参数
    function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg);  //匹配目标参数
        if (r != null) return decodeURI(r[2]); return null; //返回参数值
    }
    // var tabIndex = getUrlParam('tabIndex');
    //
    // $('#cat_tabs').jqxTabs({ selectedItem: tabIndex });

});

</script>
<style>
.news_title a {
	font-size: large;
}
.jqx-grid {
	border-style: none !important;
}
.jqx-grid-cell {
	border-style: none !important;
}
.jqx-grid-content {
	border-style: none !important;
}
</style>
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
		<h1><fmt:message key="cat.dev" /></h1>
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
	<li>
		<div class="margin_10">
			<div class="left"><img src="../images/policy.png"></div>
			<div class="left margin_10"></div>
			<div class="left">
				<div class="news_title"><a href="policy_detail.jsp"><fmt:message key="temp.policy_title" /></a></div>
				<p style="margin-top:5px;width: 600px;"><fmt:message key="temp.policy_abstract" /></p>
			</div>
			<div class="clear"></div>
		</div>
	</li>
</ul>


<jsp:include page="../includes/html_body_footer.jsp" />

</body>
</html>
