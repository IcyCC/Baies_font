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
       //获取url中的参数
       function getUrlParam(name) {
           var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
           var r = window.location.search.substr(1).match(reg);  //匹配目标参数
           if (r != null) return decodeURI(r[2]); return null; //返回参数值
       }
       var id = getUrlParam('id');
       $.ajax({
           type: "get",
           async: false,
           xhrFields: {
               withCredentials: true
           },
           crossDomain: true,
           url: host+"/qualitative/Post/"+id,
           data: {},
           success: function (result) {
               var data = result.data
    			$(".news_title").text(data[0].title)
    			$(".author").text(data[0].user.username)
    			$(".publish_time").text(data[0].timestamp)
    			$(".content").html(data[0].body)
    			var kind_id = data[0].kind_id -1
               console.log(kind_id)
               $("#cat_tabs").find('li').removeClass("jqx-tabs-title-selected-top jqx-fill-state-pressed jqx-fill-state-pressed-arctic jqx-tabs-title-selected-top-arctic")
    			$("#cat_tabs li").eq(kind_id).addClass("jqx-tabs-title-selected-top jqx-fill-state-pressed jqx-fill-state-pressed-arctic jqx-tabs-title-selected-top-arctic")
           }
       });
    })

$(document).ready(function() {
    page_id = 1;
	console.log(page_id)

    var init_tab_content = function (tab) {
		$('#news_detail_1').html($('#news_detail').html());
		$('#news_detail_2').html($('#news_detail').html());
		$('#news_detail_3').html($('#news_detail').html());
		$('#news_detail_4').html($('#news_detail').html());
	};

	
	// $('#news_detail_1').html($('#news_detail').html());
	// $('#news_detail_2').html($('#news_detail').html());
	// $('#news_detail_3').html($('#news_detail').html());
	// $('#news_detail_4').html($('#news_detail').html());

	$('#cat_tabs').jqxTabs({width: '998px', position: 'top',
		theme: '<%=jqx_theme %>', initTabContent: init_tab_content});
    $('#cat_tabs').on('tabclick', function (event)
    {
        var clickedItem = event.args.item;
        window.location.href="policy.jsp?tabIndex="+ clickedItem;
    });

});


</script>
<style type="text/css">
#news_content p {
	margin: 6px 0 12px 0;
	text-indent: 2em;
	line-height: 28px;
	font-size: 14px;
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
	<div id="news_detail_1"></div>
	<div id="news_detail_2"></div>
	<div id="news_detail_3"></div>
	<div id="news_detail_4"></div>
</div>

<div id="news_detail" style="display: none;">
	<div id="news_content" style="width: 978px; border: 10px solid #E9E9E9;">
		<div class="news_title" style="width: 100%; padding: 15px 0 20px 0; height: 40px; line-height: 40px; text-align: center; <fmt:message key="policy_detail.title_font" />">
			<fmt:message key="temp.policy_title" />
		</div>
		<div style="width: 100%; height: 27px; line-height: 27px; font-size: 12px; text-align: center; background-color: #DBDDD8">
			<fmt:message key="text.author_country" />: <fmt:message key="common.country.china" />
			&nbsp;&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;
			<fmt:message key="text.author" />:  <span class="author"></span>
			<%--<fmt:message key="text.author" />: <fmt:message key="temp.policy_author" />--%>
			&nbsp;&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;
			<fmt:message key="text.read_times" />: 100
			&nbsp;&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;
			<fmt:message key="text.publish_time" />:<span class="publish_time"></span>
			<%--<fmt:message key="text.publish_time" />: 2016-6-23--%>
		</div>
		<div style="width: 788px; padding: 20px 95px 20px 95px;" class="content">

<c:choose>
	<c:when test="${language == 'zh'}">

<p>2015年，中央一号文件提出要加快发展草牧业。农业部在河北等12个省区的37个县（团、场）组织开展了草牧业发展试验试点。这项工作开展以来，各地在政策引导和市场拉动下积极探索，草牧业发展呈现良好势头，草产业和草食畜牧业加快发展，形成了一批可复制、可推广的典型。为加快推进草牧业发展，现提出以下意见。</p>
<div style="text-align: center;"><img src="../images/sv1.jpg" style="width: 550px; height: 366px;"></div>
<p><b>一、进一步认识发展草牧业的重要意义</b></p>
<p>（一）发展草牧业是统筹农村牧区生态与生产的重要平台。草牧业以饲草资源的保护利用为基础，涵盖了草原保护建设、饲草及畜产品生产加工等环节，顺应了当前草原生态文明建设和畜牧业绿色发展的大趋势，为着力打造农牧结合、种养结合的生态循环发展模式提供有力支撑，有利于实现农村牧区生产、生活与生态的有机结合，协调发展。</p>
<p>（二）发展草牧业是推进农业供给侧结构性改革的重要切入点。我国牛羊肉和奶产品竞争力不强。依托草牧业全产业链运作，推进草畜配套和产业化，实现好草产好肉、产好奶，满足消费者对更绿色、更丰富、更优质、更安全的草畜产品的需求，增强畜产品竞争力，提高供给结构的适应性和灵活性，提升农业供给体系质量和效率。</p>
<p>（三）发展草牧业是农牧业增效和农牧民增收的重要举措。草牧业是牧区和贫困山区的传统产业、优势产业和支柱产业，约占农牧民纯收入的50%以上。发展草牧业，转变养殖方式，优化草畜产品生产结构，推进一二三产业融合，有助于挖潜力、提质量、增效益，大幅度增加农牧民收入，有利于农牧民脱贫致富奔小康。</p>
<p><b>二、总体要求</b></p>
<p><b>（一）指导思想</b></p>
<p>全面贯彻党的十八大和十八届三中、四中、五中全会精神和中央农村工作会议精神，认真落实创新、协调、绿色、开放、共享发展理念，以持续推进草牧业科学发展为主线，坚持“生产生态有机结合、生态优先”的基本方针，创新制度、技术和组织方式，着力提升草原保护建设水平，实现生态稳步向好；着力促进草产业发展，加快建设现代饲草料产业体系；着力转变草食畜牧业发展方式，形成规模化生产、集约化经营的产业发展格局，为农牧业可持续发展和全面建成小康社会提供重要支撑。</p>
<p><b>（二）基本原则</b></p>
<p>——生态优先，草畜配套。根据区域自然资源的承载能力，在确保生态安全的前提下开展草原保护建设，妥善处理生产发展与生态环境保护的关系，为养而种，草畜配套，良性循环，实现生产与生态协调发展。</p>
<p>——优化布局，分区施策。综合考虑北方干旱半干旱区、青藏高寒区、东北华北湿润半湿润区和南方区的草原生态实际及草食畜牧业发展水平，统筹资源、产业、技术和市场等因素，结合全国种植业结构调整，科学确定发展重点和空间布局，推动形成绿色发展方式。</p>
<p>——市场主导，政府引导。充分发挥市场配置资源的决定性作用，用好价格“指挥棒”和供求“杠杆”，激活草牧业发展内生动力。更好发挥政府引导作用，为各类经营主体营造良好的发展环境，构建多形式的利益联结机制。</p>
<p>——产业融合，提升效益。加强顶层设计，统筹规划，加快促进一二三产业融合，培育多元化产业融合主体，大力发展新型业态，引导产业集聚发展，完善多渠道产业融合服务，提升草牧业生产效率和规模效益。</p>
<p><b>（三）主要目标</b></p>
<p>到2020年，全国天然草原鲜草总产草量达到10.5亿吨，草原综合植被盖度达到56%，重点天然草原超载率小于10%，全国草原退化和超载过牧趋势得到遏制，草原保护制度体系逐步建立，草原生态环境明显改善；人工种草保留面积达到3.5亿亩，草产品商品化程度不断提高；牛羊肉总产量达到1300万吨以上，奶类达到4100万吨以上，草食畜牧业综合生产能力明显提升。</p>
<p><b>三、区域布局及主要模式</b></p>
<p><b>（一）北方干旱半干旱区</b></p>
<p>1.基本情况：该区位于我国西北、华北北部以及东北西部地区，涉及河北、山西、内蒙古、辽宁、吉林、黑龙江、陕西、甘肃、宁夏和新疆等10个省（区），草原面积15994.86万公顷，是我国北方重要的生态屏障。该区域气候干旱少雨，年降水量一般在400毫米以下，降水分布不均，部分地区低于50 毫米。冷季寒冷漫长，暖季干燥炎热，水分蒸发量大，一般为降水量的几倍或几十倍。该区域以荒漠化草原为主，生态系统脆弱。草食畜牧业生产方式以“放牧+补饲”为主，经营模式多样。长期以来，由于重利用轻管护，超载过牧、滥采乱挖等问题较为严重，鼠虫害发生频繁，导致草原严重退化、沙化和盐碱化，水土流失和风沙危害日趋严重。</p>
<p>2.主攻方向：着力治理退化草原，改善草原生态，重点实施退牧还草、京津风沙源治理、新一轮退耕还林还草、农牧交错带已垦草原治理、牧区草原防灾减灾等工程，全面实施好草原生态保护补助奖励政策，巩固北方重要的生态安全屏障。着力推进草食畜牧业提质增效、转型发展，重点实施肉牛肉羊养殖大县奖励、畜牧良种补贴、标准化规模养殖扶持、肉牛基础母牛扩群增量、畜禽养殖粪污综合利用等政策，同时加大饲草产业发展扶持力度，大力实施振兴奶业苜蓿发展行动，推进粮改饲试点，夯实草牧业发展的物质基础。</p>
<p>3.推介模式：围绕“提质、增效、绿色”的基本方针，引导流转整合草场、牲畜等生产要素，发展家庭农（牧）场和农牧民合作社，走规模化养殖、标准化生产、品牌化经营的产业化发展道路。推介企业“立草为业、创新开拓、融合发展”的“互联网+草业”模式和特色家庭农（牧）场适度规模经营的“轮牧+补饲”模式等。</p>
<p><b>（二）青藏高寒区</b></p>
<p>1.基本情况：该区位于我国青藏高原，涉及西藏、青海全境及四川、甘肃和云南部分地区, 草原面积13908.45万公顷，是长江、黄河、雅鲁藏布江等大江大河的发源地，是我国水源涵养、水土保持的核心区，享有中华民族“水塔”之称，也是我国生物多样性最丰富的地区之一。该区主要分布在海拔3000米以上，空气稀薄，气候寒冷，无霜期短。该区域以高寒草原为主，生态系统极度脆弱，牧草生长期短，产草量低。草食畜牧业生产方式以放牧为主，经营模式主要包括单户经营、联户经营以及“公司+牧户”等。由于超载过牧、乱采滥挖草原野生植物、无序开采矿产资源等因素影响，加之自然条件恶劣，鼠虫害和雪灾发生严重，致使草原退化，涵养水源功能减弱，大量泥沙流失，直接影响江河中下游的生态环境和经济社会可持续发展。</p>
<p>2.主攻方向：着力修复草原生态系统，恢复草原植被，维护江河源头生态安全，保护生物多样性，改善农牧民生产生活条件。重点实施退牧还草、牧区草原防灾减灾、草原自然保护区建设等工程，大力实施草原生态保护补助奖励政策，加大对“黑土滩”等退化草原的治理力度，重点搞好江河源头和生态脆弱区草原保护。着力推进传统畜牧业转型发展，重点实施肉牛肉羊养殖大县奖励、畜牧良种补贴、标准化规模养殖扶持、肉牛基础母牛扩群增量等政策，同时加大饲草产业扶持力度，发展人工种草，因地制宜推进粮改饲，推进草产业发展。</p>
<p>3.推介模式：以科学合理利用草地资源为基础，通过培育公司、合作社、家庭农（牧）场等多种经营主体，探索推行股份制合作社为主的规模经营方式，优化配置草场、饲草料地、牲畜等基本生产要素，适度发展高原生态特色畜牧业。推介行业协会带农户的“打通信息、渠道、技术三平台”发展模式；村级合作社的“草场、牲畜、品种、劳力重新分配和统治、统种、统购、统办、统分五统一”模式等。</p>
<p><b>（三）东北华北湿润半湿润区</b></p>
<p>1.基本情况：该区主要位于我国东北和华北地区，涉及北京、天津、河北、山西、辽宁、吉林、黑龙江、山东、河南和陕西等10省（市），草原面积2960.82万公顷。该区水热条件较好，年降水量一般在400毫米以上，是我国草原植被覆盖度较高、天然草原品质较好，产量较高的地区，也是草地畜牧业较为发达的地区，发展人工种草和草产品加工业潜力很大。草食畜牧业生产方式主要是夏秋放牧-冬春舍饲，经营模式以家庭牧场和联户经营并存。该区草原主要分布在农牧交错带，开垦比较严重，水土流失加剧，部分地区草原盐碱化、沙化。</p>
<p>2.主攻方向：着力加强草原监督管理，遏制乱开滥垦、乱采滥挖等违法行为。大力推广人工种草，积极发展草产业，拓宽农牧民增收渠道。重点实施京津风沙源治理、农牧交错带已垦草原治理、新一轮退耕还林还草等工程和草原生态保护补助奖励政策。开展人工种草，推行粮改饲试点和振兴奶业苜蓿发展行动，加快种养业结构调整。推进草食畜牧业提质增效，重点加强畜牧良种补贴、标准化规模养殖、肉牛基础母牛扩群增量、畜禽养殖粪污综合利用等扶持，提高畜牧业发展质量和效益。</p>
<p>3.推介模式：通过挖掘饲草料生产潜力，积极探索“牧繁农育”和“户繁企育”的养殖模式，发挥各经营主体在人力、资本、饲草等方面的优势，实现牧区与农区协调发展，种植户、养殖户与企业多方共赢。推介综合性龙头企业的“种好草、养好畜、重环保、出精品”的“种养加一体化”模式和“公司+合作社+基地+农户”的种养结合发展模式等。</p>
<p><b>（四）南方区</b></p>
<p>1.基本情况：该区位于我国南部，涉及上海、江苏、浙江、安徽、福建、江西、湖南、湖北、广东、广西、海南、重庆、四川、贵州和云南等15省（市、区），草原面积6419.12万公顷。该区气候温暖，水热资源丰富，年降水量一般在1000毫米以上，牧草生长期长，产草量高。草食畜牧业生产方式传统上散养散放，草畜不配套，发展潜力大。该区草资源开发利用不足，垦草种地问题突出，部分地区草地石漠化严重，水土流失加剧。</p>
<p>2.主攻方向：合理开发利用草地资源，减少水土流失，积极发展草地农业和草地畜牧业。重点实施退牧还草、岩溶地区石漠化草地综合治理、新一轮退耕还林还草等工程，推进实施草原生态保护补助奖励政策，加大草原生态保护力度。加快草食畜牧业转型发展，重点实施南方现代草地畜牧业推进行动、畜牧良种补贴、标准化规模养殖、肉牛基础母牛扩群增量、畜禽粪污资源化利用等政策，同时大力发展人工种草，推行草田轮作，因地制宜推进粮改饲，强化草畜配套，推进草食畜牧业发展。</p>
<p>3.推介模式：</p>
<p>依托青绿饲草资源优势，大力推广粮经饲三元结构种植和标准化规模养殖，因地制宜发展地方特色草食畜牧业。推介天然草山草坡改良、混播牧草地建植、农闲田种草养畜的“工程项目+公司+合作社”统筹发展模式和“公司+家庭农（牧）场”的产业化经营模式等。</p>
<p><b>四、保障措施</b></p>
<p>（一）切实加强组织领导。各级农牧部门要高度重视，切实把促进草牧业发展列入重要议事日程，积极协调将草牧业纳入地方国民经济和社会发展规划。要广泛凝聚工作合力，落实目标任务，明确工作责任，建立健全“统一领导、分工协作、广泛参与”的工作机制，确保各项措施落实到位。</p>
<p>（二）落实好已有政策。各级农牧部门要认真落实草原和畜牧业各类财政专项资金及重大工程建设投资，积极发挥财政资金“四两拨千斤”的作用，探索创新资金使用方式，放大资金效应，夯实草牧业发展基础设施，不断扩大中央投入的引导示范作用。要创新项目管理，加强督导检查，确保各项政策措施落实到项目建设主体和草场地块。</p>
<p>（三）完善创设新政策。各级农牧部门要结合当前生态文明体制和农业农村改革新要求，立足本地区草牧业发展实际，突出问题导向，围绕草原保护、培育新型经营主体、提升物质装备水平、加强科技推广支撑和完善金融服务等方面，加强政策创设力度，不断完善草牧业发展政策体系。</p>
<p>（四）加强舆论宣传。各级农牧部门要积极总结好经验好模式，运用多种传播方式，加大对“保护草原得力、产业优势突出、农牧增收显著、示范带动强劲”的现代草牧业模式的宣传推介力度，营造良好社会氛围，推动草牧业又好又快发展。</p>

	</c:when>
	<c:otherwise>

<p>More than 33.6 million students living in poverty have become healthier overall as a result of government subsidized meals, but improved food availability and safety remain top priorities, along with health education, the Ministry of Education said.</p>
<p>Fifteen organizations, including the finance and education ministries, launched a nutrition drive in 2011 to help needy children from first to ninth grade.</p>
<div style="text-align: center;"><img src="../images/article_en.jpg" style="width: 550px; height: 366px;"></div>
<p>Since then, more than 159 billion yuan ($23.7 billion) has been spent on improving meals and dining spaces in 137,000 schools in 29 provinces. The program covers more than 33.6 million students, according to the program's assessment report published on Tuesday.</p>
<p>"We used to only eat what was most abundant in the market, and sometimes our menu wouldn't change for days," said Li Bo, an elementary schoolteacher from Cangxi county, Sichuan province. "Now we have the means to diversify our meals and provide a balanced diet for our children."</p>
<p>The meals consist of locally grown foods that are rich in protein and fiber.</p>
<p>"Thanks to the program, children in rural areas are healthier and happier every day," said He Xiuchao, the director of educational supervision at the Ministry of Education.</p>
<p>However, not every school can implement the plan effectively. An online database of information related to the program, compiled by the Children Center at the China Development Research Foundation, said schools in the Xinjiang Uygur and Tibet autonomous regions in general had the most comprehensive meals, while some schools in Hunan and Gansu provinces could only provide a sausage or a carton of milk.</p>
<p>"Xinjiang and Tibet, which have a large ethnic population, enjoy more subsidies than other provinces, hence the better food," said Du Zhixin, director of the center.</p>
<p>Some schools will buy snacks to replace proper meals, but that generally costs more and adds little nutritional value, Du said. However, most children don't know the harmful effects. More than 66 percent of students spent at least 1 yuan ($0.15) on a snack every day, and close to half consume soft drinks.</p>
<p>Deng Fei, the founder of the Free Lunch Foundation, an organization that provides free meals for rural Chinese students, expressed concern that "apart from food additives, some snacks sold by local stores are counterfeit or even expired, which can be harmful to children".</p>
<p>Besides strengthening education effort, Deng suggested that government and schools should focus on improving the quantity and quality of meals.</p>
<p>"Food availability shouldn't be a problem," he said. "Schools can buy food from local residents. This not only helps alleviate poverty in the community but also ensures a sustainable source."</p>
<p>Further, schools need to have the authority to negotiate deals and be transparent in the process, Deng said.</p>

	</c:otherwise>
</c:choose>

		</div>
	</div>
</div>

<jsp:include page="../includes/html_body_footer.jsp" />

</body>
<script>

</script>
</html>
