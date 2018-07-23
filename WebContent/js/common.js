function formatCurrentDate(fmt) {
	var today = new Date();
	var dd = today.getDate();
	var mm = today.getMonth() + 1; // January is 0!
	var yyyy = today.getFullYear();

	if (dd < 10) {
		dd = '0' + dd;
	}
	if (mm < 10) {
		mm = '0' + mm;
	}

	if (fmt == 'yyyy') {
		return yyyy;
	} else if (fmt == 'yyyy-MM') {
		return yyyy + '-' + mm;
	} else if (fmt == 'yyyy-MM-dd') {
		return yyyy + '-' + mm + '-' + dd;
	} else {
		return '';
	}
}


nav_items = [ "../baies/index.jsp", "../baies/policy.jsp",
		"../baies/econ_data.jsp", "../baies/agri_data.jsp" ];

nav_items_admin = [ "../baies/admin_policy_approval.jsp",
		"../baies/admin_econ_data_indicator.jsp",
		"../baies/admin_user_management.jsp",
"../baies/admin_images_management.jsp"];

nav_items_country = [ "../baies/country_policy_management.jsp",
		"../baies/country_econ_data_management.jsp",
		"../baies/country_agri_data_management.jsp" ];

nav2_items_approval = [ "../baies/admin_policy_approval.jsp",
		"../baies/admin_econ_data_approval.jsp",
		"../baies/admin_agri_data_approval.jsp" ];

nav2_items_indicator = [ "../baies/admin_econ_data_indicator.jsp",
		"../baies/admin_agri_data_indicator.jsp" ];

agri_data_cat_tree_src_zh = [ {
	label : '农产品信息',
	expanded : true,
	items : [ {
		label : '农业生产情况',
		expanded : true,
		items : [ {
			label : '农业生产总值概况'
		}, {
			label : '农业总产量概况'
		}, {
			label : '谷物生产概况'
		}, {
			label : '其他重要作物种植概况'
		}, {
			label : '肉类生产概况'
		}, {
			label : '牲畜存、出栏状况'
		}, {
			label : '水产业概况'
		}, {
			label : '种植业概况'
		}, {
			label : '畜牧业和水产业概况'
		} ]
	}, {
		label : '农产品贸易情况',
		expanded : true,
		items : [ {
			label : '农产品贸易概况'
		}, {
			label : '分品种贸易额概况'
		}, {
			label : '分品种贸易量概况'
		} ]
	}, {
		label : '农业投资情况',
		expanded : true,
		items : [ {
			label : '农业对外投资存量'
		}, {
			label : '农业对外直接投资存量结构'
		}, {
			label : '农业外商直接投资净流量'
		}, {
			label : '农业外商直接投资流入量'
		}, {
			label : '农业外商投资实际使用外资结构'
		} ]
	} ]
} ];

agri_data_cat_tree_src_en = [ {
	label : 'Agricultural Products',
	expanded : true,
	items : [ {
		label : 'Agricultural Production',
		expanded : true,
		items : [ {
			label : 'Value of agricultural production'
		}, {
			label : 'Survey of agricultural production'
		}, {
			label : 'Survey of cereals production'
		}, {
			label : 'Survey of other crops production'
		}, {
			label : 'Survey of meat production'
		}, {
			label : 'Slaughtered and stock of live animals'
		}, {
			label : 'Survey of aquaculture'
		}, {
			label : 'Survey of crops'
		}, {
			label : 'Survey of livestock and aquaculture'
		} ]
	}, {
		label : 'Agricultural Trade',
		expanded : true,
		items : [ {
			label : 'Survey of agriculture products trade'
		}, {
			label : 'Agricultural product trade value'
		}, {
			label : 'Agricultural product trade quantity'
		} ]
	}, {
		label : 'Agricultural Investment',
		expanded : true,
		items : [ {
			label : 'Main investors of agricultural overseas direct investment stock'
		}, {
			label : 'Agricultural overseas direct investment stock structure'
		}, {
			label : 'Agricultural FDI flows'
		}, {
			label : 'Agricultural FDI inflows'
		}, {
			label : 'Actually utilized of agricultural FDI inflows structure'
		} ]
	} ]
} ];

econ_data_cat_tree_src_zh = [ {
	label : '社会经济信息',
	expanded : true,
	items : [ {
		label : '金砖国家概况'
	}, {
		label : '人口概况'
	}, {
		label : '性别分布概况'
	}, {
		label : '劳动人口概况'
	}, {
		label : '经济概况'
	}, {
		label : '经济指数概况'
	}, {
		label : '居民生活水平概况'
	}, {
		label : '居民消费支出'
	}, {
		label : '贸易概况'
	}, {
		label : '储备概况'
	}, {
		label : '贷款概况'
	}, {
		label : '健康概况'
	}, {
		label : '出生（死亡）率概况'
	}, {
		label : '生育概况'
	}, {
		label : '年龄概况'
	}, {
		label : '出入境人数概况'
	}, {
		label : '旅游收入（支出）概况'
	}, {
		label : '旅游项目收入（支出）概况'
	}, {
		label : '客运项目收入（支出）概况'
	}, {
		label : '外债概况'
	}, {
		label : '环境与资源概况'
	}, {
		label : '发电量概况'
	}, {
		label : '教育概况'
	}, {
		label : '燃料消耗概况'
	}, {
		label : '交通概况'
	}, {
		label : '投资概况'
	}, {
		label : '援助概况'
	}, {
		label : '矿产储量概况'
	}, {
		label : '农业对外投资主要投资国'
	}, {
		label : '农林牧渔业对外直接投资流量主要投资地'
	}, {
		label : '农林牧渔业对外直接投资净额'
	}, {
		label : 'FDI主要来源国投资存量'
	}, {
		label : '农业利用外资主要国家（地区）'
	}, {
		label : '外商直接投资存量'
	} ]
} ];

econ_data_cat_tree_src_en = [ {
	label : 'Society & Economy',
	expanded : true,
	items : [ {
		label : 'Survey of economic and social index'
	}, {
		label : 'Survey of population'
	}, {
		label : 'Survey of sex distribution'
	}, {
		label : 'Survey of labor force'
	}, {
		label : 'Survey of economy'
	}, {
		label : 'Survey of economy proportion'
	}, {
		label : 'Survey of residents\' living standards'
	}, {
		label : 'Survey of consumer spending'
	}, {
		label : 'Survey of trade'
	}, {
		label : 'Survey of reserve'
	}, {
		label : 'Survey of loan'
	}, {
		label : 'Survey of health'
	}, {
		label : 'Survey of birth rate and death rate'
	}, {
		label : 'Survey of birth'
	}, {
		label : 'Survey of age'
	}, {
		label : 'Survey of entry and exit'
	}, {
		label : 'Survey of tourism revenue (expenditure)'
	}, {
		label : 'Survey of travel project revenue (expenditure)'
	}, {
		label : 'Survey of passenger transport project revenue (expenditure)'
	}, {
		label : 'Survey of foreign debt'
	}, {
		label : 'Survey of resources and environment'
	}, {
		label : 'Survey of generating capacity'
	}, {
		label : 'Survey of education'
	}, {
		label : 'Survey of fuel oil'
	}, {
		label : 'Survey of traffic'
	}, {
		label : 'Survey of investment'
	}, {
		label : 'Survey of assistance'
	}, {
		label : 'Survey of mineral resources'
	}, {
		label : '农业对外投资主要投资国'
	}, {
		label : '农林牧渔业对外直接投资流量主要投资地'
	}, {
		label : '农林牧渔业对外直接投资净额'
	}, {
		label : 'FDI主要来源国投资存量'
	}, {
		label : '农业利用外资主要国家（地区）'
	}, {
		label : '外商直接投资存量'
	} ]
} ];
