<%@ page contentType="text/html; charset=euc-kr"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<html>
<head>
<title>상품 목록조회</title>

<meta charset="EUC-KR">
<link rel="stylesheet" href="/css/admin.css" type="text/css">
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<!-- <script src="../javascript/infinityScroll.js" type="text/javascript"></script> -->
<script type="text/javascript">
 $(document).ready(function() {
	var currentP = ${resultPage.currentPage};
	var maxP =  ${resultPage.maxPage};

	$(document).scroll(function(){
		
		var windowHeight = window.innerHeight; 
		var pageHeight = document.documentElement.scrollHeight;		
		var scroller = $(document).scrollTop();

		//var currentP = ${resultPage.currentPage};
		if(	((scroller + windowHeight) >= pageHeight) && (currentP !== maxP)) {	
			console.log(currentP);
			fncGetList((currentP+1));
		}
		
		if((scroller <= 2) && (currentP !== 1)) {
			console.log(currentP);
			var displayValue = "<a href='javascript:fncGetList("+(currentP-1)+")'><h2>이전</h2></a>"
				$("#pageNav").html(displayValue);
		}
		
})});	 
	// list
	function fncGetList(currentPage) {
		$("#currentPage").val(currentPage)
		$("form").attr("method", "POST").attr("action",
				"/product/listProduct?menu=manage").submit();
	}

	// 검색
	$(function() {
		$("td.ct_btn01:contains('검색')").on("click", function() {
			fncGetList(1);
		})
	});

	// 상품명
	$(function() {
		$("td.prodName").on(
				"click",
				function() {
					//self.location ="/product/getProduct?prodNo="+$(this).attr('prodNo')+"&menu=search";
					var prodNo = $(this).attr('prodNo');
					$.ajax({
						url : "/product/json/getProduct/" + prodNo,
						method : "GET",
						dataType : "json",
						headers : {
							"Accept" : "application/json",
							"Content-Type" : "application/json"
						},
						success : function(JSONData, status) {
							const dueDate = JSONData.dueDate.substring(0,4)+"년 "+JSONData.dueDate.substring(4,6)+"월 "+JSONData.dueDate.substring(6)+"일";
							const fileArr = JSONData.fileName.split(",");
							
							function thumbnail(fileArr) {
								var str="";
								for(var file of fileArr) {
									str += "<img src='../images/uploadFiles/";
									str += file + "'/>";
								}
								return str;
							}
							
							var displayValue = "<h3>" + "상품명 : "
									+ JSONData.prodName + "<br/>" + "가격 : "
									+ JSONData.price + "<br/>" + "상세정보 : "
									+ JSONData.prodDetail + "<br/>" + "유효기간 : "
									+ dueDate + "<br/>" + "사진 : "
									+ thumbnail(fileArr) + "<br/>" + "판매자 ID: "
									+ JSONData.sellerId + "<br/>" 
									+ "<a href='/product/getProduct?prodNo="+JSONData.prodNo+"&menu=search'><h1>상세보기</h1></a>" 
									+								
									"</h3>"
									;
							$("h3").remove();
							$("#" + prodNo + "").html(displayValue);
						}
					}
					)
				})
			});
</script>
</head>

<body bgcolor="#ffffff" text="#000000">

	<div style="width: 98%; margin-left: 10px;">

		<form name="detailForm">

			<table width="100%" height="37" border="0" cellpadding="0"
				cellspacing="0">
				<tr>
					<td width="15" height="37"><img src="/images/ct_ttl_img01.gif"
						width="15" height="37"></td>
					<td background="/images/ct_ttl_img02.gif" width="100%"
						style="padding-left: 10px;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="93%" class="ct_ttl01">상품 목록조회</td>
							</tr>
						</table>
					</td>
					<td width="12" height="37"><img src="/images/ct_ttl_img03.gif"
						width="12" height="37"></td>
				</tr>
			</table>

			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				style="margin-top: 10px;">
				<tr>
					<td align="right"><select name="searchCondition"
						class="ct_input_g" style="width: 80px">
							<option value="0"
								${ ! empty search.searchCondition && search.searchCondition==0 ? "selected" : "" }>상품명</option>
							<option value="1"
								${ ! empty search.searchCondition && search.searchCondition==1 ? "selected" : "" }>상품번호</option>
					</select> <%-- <input 	type="text" name="searchKeyword"  value="<%=searchKeyword %>" class="ct_input_g" style="width:200px; height:19px" />--%>
						<input type="text" name="searchKeyword"
						value="${! empty search.searchKeyword ? search.searchKeyword : ""}"  
			class="ct_input_g" style="width: 200px; height: 20px">
						<br /> <!-- ////// 0413 추가 가격 검색 --> <%-- 			<input type="text" name="searchKeyPriceMin" 
			value="${! empty search.searchKeyword ? search.searchKeyword : ""}"  
			class="ct_input_g" style="width:200px; height:20px" > 
			<input type="text" name="searchKeyPriceMax" 
			value="${! empty search.searchKeyword ? search.searchKeyword : ""}"  
			class="ct_input_g" style="width:200px; height:20px" >  --%></td>

					<td align="right" width="70">
						<table border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="17" height="23"><img
									src="/images/ct_btnbg01.gif" width="17" height="23"></td>
								<td background="/images/ct_btnbg02.gif" class="ct_btn01"
									style="padding-top: 3px;">검색</td>
								<td width="14" height="23"><img
									src="/images/ct_btnbg03.gif" width="14" height="23"></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>

			<div id="pageNav"></div>

			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				style="margin-top: 10px;">
				<tr>
					<%-- <td colspan="11" >
			전체  <%= resultPage.getTotalCount() %> 건수,	현재 <%= resultPage.getCurrentPage() %> 페이지
		</td>--%>
					<td colspan="11">전체 ${resultPage.totalCount } 건수, 현재
						${resultPage.currentPage} 페이지</td>
				</tr>
				<tr>
					<td class="ct_list_b" width="100">No</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b" width="150">상품명</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b" width="150">가격</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b" width="150">할인율</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b">원가</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b">유효기한</td>

				</tr>
				<tr>
					<td colspan="11" bgcolor="808285" height="1"></td>
				</tr>
				<%-- 
	<% 	
		for(int i=0; i<list.size(); i++) {
			Product vo = (Product)list.get(i);
	%>
	<tr class="ct_list_pop">
		<td align="center"><%= i + 1 %></td>
		<td></td>
		<td align="left">
		<!-- 여기 menu에 따라 다르게 -->
			<a href="/getProduct.do?prodNo=<%=vo.getProdNo() %>&menu=<%= menu%>"><%= vo.getProdName() %></a>
		</td>
		<td></td>
		<td align="left"><%= vo.getPrice() %></td>
		<td></td>
		<td align="left"><%= vo.getRegDate() %></td>
		<td></td>		
		<td align="left"><%= vo.getRegDate() %>
		</td>		
	</tr>
	<tr>
		<td colspan="11" bgcolor="D6D7D6" height="1"></td>
	</tr>
	<% } %>--%>
				<c:set var="i" value="0" />
				<c:forEach var="product" items="${list}">
					<c:set var="i" value="${ i+1 }" />
					<tr class="ct_list_pop">
						<td align="center">${ i }</td>
						<td></td>
						<td align="left" class="prodName" prodNo="${product.prodNo}">${product.prodName}</td>
						<td></td>
						<td align="left">${product.price}</td>
						<td></td>
						<td align="left"><fmt:formatNumber var="discount"
								pattern="###"
								value="${(product.cost-product.price)/product.cost*100}" />
							${discount}%</td>
						<td></td>
						<td align="left">${product.cost}</td>
						<td></td>
						<td align="left">${product.dueDate.substring(0,4)}년
							${product.dueDate.substring(4,6)}월
							${product.dueDate.substring(6)}일</td>
					</tr>
					<tr>
						<td id="${product.prodNo}" colspan="11" bgcolor="D6D7D6"
							height="1"></td>
					</tr>
				</c:forEach>
			</table>

			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				style="margin-top: 10px;">
				<tr>
					<td align="center"><input type="hidden" id="currentPage"
						name="currentPage" value="" /> <jsp:include
							page="../common/pageNavigator.jsp" /></td>
				</tr>
			</table>
			<!--  페이지 Navigator 끝 -->
		</form>
	</div>

</body>
</html>
