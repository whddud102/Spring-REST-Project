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
					<label>게시글 번호</label> <input class="form-control" name="Bno"
						value='<c:out value="${board.bno }"/>' readonly="readonly">
				</div>

				<div class="form-group">
					<label>제목</label> <input class="form-control" name="title"
						value='<c:out value="${board.title }"/>' readonly="readonly">
				</div>

				<div class="form-group">
					<label>내용</label>
					<textarea class="form-control" rows="3" name="content"
						readonly="readonly"><c:out value="${board.content }" /></textarea>
				</div>

				<div class="form-group">
					<label>작성자</label> <input class="form-control" name="writer"
						value='<c:out value="${board.writer }"/>' readonly="readonly">
				</div>

				<button data-oper='modify' class="btn btn-default">수정</button>
				<button data-oper='list' class="btn btn-info">목록</button>

				<form id="operForm" action="/board/modify" method="get">
					<input type='hidden' id='bno' name='bno'
						value='<c:out value="${board.bno}"/>'> <input
						type="hidden" name="pageNum"
						value='<c:out value="${cri.pageNum}"/>'> <input
						type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
					<input type="hidden" name="type"
						value='<c:out value="${cri.type}"/>'> <input type="hidden"
						name="keyword" value='<c:out value="${cri.keyword }"/>'>
				</form>
			</div>
			<!-- end panel body -->
		</div>
	</div>
	<!-- end panel -->
</div>
<!-- /.row -->

<!-- 댓글 목록 -->
<div class="row">
	<div class="col-lg-12">

		<!-- /.panel -->
		<div class="panel panel-default">
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i>댓글
			</div>
			<!-- /.panel-heading -->

			<div class="panel-body">
				<ul class="chat">
					<!-- start reply -->
					<li class="left clearfix" data-rno='12'>
						<div>
							<div class="header">
								<strong class="primary-font">user00</strong> <small
									class="pull-right text-muted">2018-01-01 13:13</small>
							</div>
							<p>댓글 내용 테스트입니다</p>
						</div>
					</li>
					<!-- end reply -->
				</ul>
				<!-- /.end ul -->
			</div>

			<!-- /.panel .chat-panel -->
		</div>
	</div>
</div>



<!-- reply.js를 로드 -->
<script type="text/javascript" src="/resources/js/reply.js"></script>
<script type="text/javascript">

	$(document).ready(function () {
		var bnoValue = '<c:out value="${board.bno}"/>';
		var replyUL = $(".chat");		// 댓글 ul 태그에 접근
		
		showList(1);
		
		function showList(page) {
			replyService.getList({bno: bnoValue, page: page || 1}, function(list) {
				
				var str ="";
				
				// 댓글 목록이 없으면 공백을 출력하고 종료
				if(list == null || list.length == 0) {
					replyUL.html("");
					return;
				}
				
				for(var i = 0; i < list.length || 0; i++) {
					str += "<li class='left clearfix' data-rno='" + list[i].rno + "'>";
					str += "<div>";
						str += "<div class='header>'";
							str += "<strong class='primary-font'>" + list[i].replyer + "</string>";
							str += "<small class='pull-right text-muted'>" + list[i].replyDate + "</small>";
						str += "</div>";
						str += "<p>" + list[i].reply + "</p>";
					str += "</div>";
					str += "</li>";
				}
				
				
				// 댓글 목록 태그를 동적으로 만든 뒤 한번에 추가해줌
				replyUL.html(str);
				
			});	// end function	
		} // end showList
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

