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

<!-- 댓글 영역 -->
<div class="row">
	<div class="col-lg-12">

		<!-- /.panel -->
		<div class="panel panel-default">
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i>댓글
				<button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">댓글
					등록</button>
			</div>
			<!-- /.panel-heading -->

			<div class="panel-body">
				<ul class="chat">
					<!-- Test Reply
					 
					<li class="left clearfix" data-rno='12'>
						<div>
							<div class="header">
								<strong class="primary-font"></strong><small
									class="pull-right text-muted"></small>
							</div>
							<p></p>
						</div>
					</li>
					
					End test Reply -->
				</ul>
				<!-- /.end ul -->
			</div>

			<!-- /.panel .chat-panel -->
		</div>
	</div>
</div>

<!-- 댓글 등록 모달창 -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">댓글 등록 모달</h4>
			</div>
			<div class="modal-body">

				<div class="form-group">
					<label>댓글 등록</label> <input class="form-control" name='reply'
						value='New Reply!!!!!'>
				</div>

				<div class="form-group">
					<label>작성자</label> <input class="form-control" name='replyer'
						value='eplyer'>
				</div>

				<div class="form-group">
					<label>작성 날짜</label> <input class="form-control" name='replyDate'
						value=''>
				</div>

			</div>
			<div class="modal-footer">
				<button id="modalModBtn" type="button" class="btn btn-warning">수정</button>
				<button id="modalRemoveBtn" type="button" class="btn btn-danger">삭제</button>
				<button id="modalRegisterBtn" type="button" class="btn btn-primary">등록</button>
				<button id="modalCloseBtn" type="button" class="btn btn-default">닫기</button>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
<!-- /.modal -->



<!-- reply.js를 로드 -->
<script type="text/javascript" src="/resources/js/reply.js"></script>

<!-- 댓글 관련 js -->
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
							str += "<small class='pull-right text-muted'>" + replyService.displayTime(list[i].replyDate) + "</small>";
						str += "</div>";
						str += "<p>" + list[i].reply + "</p>";
					str += "</div>";
					str += "</li>";
				}
				
				
				// 댓글 목록 태그를 동적으로 만든 뒤 한번에 추가해줌
				replyUL.html(str);
				
			});	// end function	
		} // end showList
		
		var modal = $(".modal");
		// Input 태그 찾기
		var modalInputReply = modal.find("input[name='reply']");
		var modalInputReplyer = modal.find("input[name='replyer']");
		var modalInputReplyDate = modal.find("input[name='replyDate']");
		
		// 댓글 모달창의 버튼 찾기
		var modalModBtn = $("#modalModBtn");
		var modalRemoveBtn = $("#modalRemoveBtn");
		var modalRegisterBtn = $("#modalRegisterBtn");
		
		// 댓글 등록 버튼에 클릭 리스너 등록
		$("#addReplyBtn").on("click", function(e) {
			
			modal.find("input").val("");
			modalInputReplyDate.closest("div").hide();
			// 닫기 버튼 제외 하고 버튼 숨김
			modal.find("button[id != 'modalCloseBtn']").hide();
			
			// 등록 버튼은 다시 표사
			modalRegisterBtn.show();
			
			$(".modal").modal("show");
		});
		
		
		modalRegisterBtn.on("click", function(e) {
			
			// 댓글 등록에 필요한 정보 가져오기
			var reply = {
					reply : modalInputReply.val(),
					replyer : modalInputReplyer.val(),
					bno : bnoValue
			};
			
			replyService.add(reply, function(result) {
				
				alert("등록 완료");
				
				modal.find("input").val("");
				modal.modal("hide");
				
				// 댓글 등록 성공 후, 갱신된 댓글 목록을 출력
				showList(1);
			});
			
		});
		
		// 댓글 조회 클릭 이벤트 처리
		$(".chat").on("click", "li", function(e) {
			var rno = $(this).data("rno");
			
			replyService.get(rno, function(reply) {
				modalInputReply.val(reply.reply);
				modalInputReplyer.val(reply.replyer);
				modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly", "readonly");
				// 모달에 rno 속성을 추가한 후 값을 넣어줌
				modal.data("rno", reply.rno);
				
				modal.find("button[id != 'modalCloseBtn']").hide();
				modalModBtn.show();
				modalRemoveBtn.show();
				
				$(".modal").modal("show");
			});
			
		});
		
		modalModBtn.on("click", function(e) {
			
			var reply = {rno : modal.data("rno"), reply : modalInputReply.val()};
			
			console.log("댓글 수정 시작합니다...");
			
			replyService.update(reply, function(result) {
				alert(result);
				modal.modal("hide");
				showList(1);
			});
		});
		
		modalRemoveBtn.on("click", function(e) {
			
			var rno = modal.data("rno");
			
			replyService.remove(rno, function(result) {
				alert("댓글 삭제 완료");
				modal.modal("hide");
				showList(1);
			});
		});
	});
</script>

<!-- 조회 창의 버튼 클릭 이벤트 -->
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

