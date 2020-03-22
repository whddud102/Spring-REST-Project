<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="../includes/header.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">게시글 조회</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!--  /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">게시글 조회 화면</div>
			<!-- /.pannel heading -->

			<div class="panel-body">
					<div class="form-group">
						<label>게시글 번호</label> <input class="form-control" name="Bno" value='<c:out value="${board.bno }"/>' readonly="readonly">
					</div>

					<div class="form-group">
							<label>제목</label> <input class="form-control" name="title" value='<c:out value="${board.title }"/>' readonly="readonly">
					</div>

					<div class="form-group">
						<label>내용</label>
						<textarea class="form-control" rows="3" name="content" readonly="readonly" ><c:out value="${board.content }"/></textarea>
					</div>

					<div class="form-group">
						<label>작성자</label> <input class="form-control" name="writer" value='<c:out value="${board.writer }"/>' readonly="readonly">
					</div>

					<button data-oper='modify' class="btn btn-default"> 수정</button>
					<button data-oper='list' class="btn btn-info">목록</button>
					
					<form id="operForm" action="/board/modify" method="get">
						<input type='hidden' id='bno' name='bno' value='<c:out value="${board.bno}"/>'>
						<input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
						<input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
						<input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
						<input type="hidden" name="keyword" value='<c:out value="${cri.keyword }"/>'>		
					</form>
			</div>
			<!-- end panel body -->
		</div>
	</div>
	<!-- end panel -->

</div>
<!-- /.row -->

<!-- reply.js를 로드 -->
<script type="text/javascript" src="/resources/js/reply.js"></script>
<script type="text/javascript">
	console.log("============================");
	console.log("JS REPLY TEST");
	
	var bnoValue = '<c:out value="${board.bno}"/>';
	
	// for ReplyService add test
	/*
	replyService.add(
			{reply:"ajax 댓글 등록 테스트", replyer:"어드민", bno : bnoValue}, 
			function(result) {
				alert("RESULT : " + result)
			});
	
	
	
	// for Reply List Test
	replyService.getList({bno : bnoValue, page : 1}, function(list) {
		
		console.log("================= getList()================================")
		for(var i = 0, len = list.length||0; i < len; i++) {
			console.log(list[i]);
		}
		console.log("==========================================================");
	});
	
	
	// 댓글 삭제 테스트
 	replyService.remove(44, function(status) {
		console.log("Status: " + status);
		
		if(status === "success") {
			alert("댓글 삭제 완료");
		}
		
	},	function(err) {
		alert("ERROR : " + err);
	}); 
	
	
	replyService.update(
	{rno:5, bno : bnoValue, reply:"수정된 댓글"}, 
	function(result) {
		console.log("진짜 댓글 수정 완료");
	});
	

	*/
	
	replyService.get(10, function(result) {
		console.log(result);
	});
	
</script>

<script type="text/javascript">
	$(document).ready(function() {
		var operForm = $("#operForm");
		
		$("button[data-oper='modify']").on("click", function(e) {
			operForm.attr("action", "/board/modify").submit();
		});
		
		$("button[data-oper='list']").on("click", function(e) {
			operForm.find("#bno").remove();
			operForm.attr("action", "/board/list");
			operForm.submit();
		});
	});

</script>

<%@include file="../includes/footer.jsp"%>

