	function fncGetList(currentPage) {
		$("#currentPage").val(currentPage)
		$("form").attr("method", "POST").attr("action",
				"/product/listProduct?menu=manage").submit();
	}

