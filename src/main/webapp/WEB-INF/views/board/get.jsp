<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%@include file="../includes/header.jsp"%>

<style >

	
</style>


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
	
				<!-- 로그인한 사용자 ID와 글 작성자 ID가 같을 때만 수정 버튼을 출력 -->
				<sec:authentication property="principal" var="pinfo"/>
				
				<sec:authorize access="isAuthenticated()">
						<c:if test="${pinfo.username eq board.writer}">
							<button data-oper='modify' class="btn btn-default">수정</button>
						</c:if>
				</sec:authorize>

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

<!-- 이미지의 원본을 보여주기 위한 div 영역 -->
<div class="bigPictureWrapper">
	<div class="bigPicture">
		
	</div>
</div>

<!-- 첨부파일 영역 -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">첨부파일</div>
			<!-- /.panel heading -->
			<div class="panel-body">
				<div class="uploadResult">
					<ul>
						<!--  동적으로 첨부파일 목록을 보여줄 영역 -->
					</ul>				
				</div>
			</div>
			<!-- /.pnael body -->
		</div>
	</div>
</div>

<!-- 댓글 영역 -->
<div class="row">
	<div class="col-lg-12">

		<!-- /.panel -->
		<div class="panel panel-default">
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i>댓글
				
				<sec:authorize access="isAuthenticated()">
					<button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">댓글
					등록</button>
				</sec:authorize>
				
			</div>
			<!-- /.panel-heading -->

			<div class="panel-body">
				<ul class="chat">
					<!-- 댓글 영역 -->
				</ul>
				<!-- /.end ul -->
			</div>
			
			<!-- 댓글의 페이지를 동적으로 출력할 영역 -->	
			<div class="panel-footer">
			
			</div>
			<!-- end panel footer -->
			
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
						value='replyer' readonly="readonly">
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

<!-- 동적으로 댓글의 페이지를 출력하는 showReplyPage(replyCnt) 정의 코드 -->
<script type="text/javascript" src="/resources/js/showReplyPage.js"></script>

<!-- 댓글 관련 js -->
<script type="text/javascript">

	$(document).ready(function () {
		var bnoValue = '<c:out value="${board.bno}"/>';
		var replyUL = $(".chat");		// 댓글 ul 태그에 접근
		
		showList(1);
		
		function showList(page) {
			console.log("댓글 목록 " + page + " 페이지 출력");
			
			replyService.getList({bno: bnoValue, page: page || 1}, function(replyCnt, list) {
					
				console.log("전체 댓글 수 : " + replyCnt);
				
				// page로 -1을 받으면 마지막 댓글페이지로 다시 호출
				if(page == -1) {
					pageNum = Math.ceil(replyCnt/10.0);
					showList(pageNum);
					return;
				}
				
				pageNum = page;
				console.log("PageNum = " + pageNum );
				var str ="";
				
				// 댓글 목록이 없으면 공백을 출력하고 종료
				if(!(list == null || list.length == 0)) {
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
				}
				
				
				// 댓글 목록 태그를 동적으로 만든 뒤 한번에 추가해줌
				replyUL.html(str);
				
				showReplyPage(replyCnt);
				
			});	// end function	
		} // end showList()
		
		var modal = $(".modal");
		// Input 태그 찾기
		var modalInputReply = modal.find("input[name='reply']");
		var modalInputReplyer = modal.find("input[name='replyer']");
		var modalInputReplyDate = modal.find("input[name='replyDate']");
		
		// 댓글 모달창의 버튼 찾기
		var modalModBtn = $("#modalModBtn");
		var modalRemoveBtn = $("#modalRemoveBtn");
		var modalRegisterBtn = $("#modalRegisterBtn");
		var modalCloseBtn = $("#modalCloseBtn");

		var replyer = null;
		
		<sec:authorize access = "isAuthenticated()">
			replyer = '<sec:authentication property="principal.username"/>';
		</sec:authorize>
		
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";

		// 모든 Ajax 전송시 csrf 토큰을 같이 전송하도록 세팅
		$(document).ajaxSend(function(e, xhr, options) {
			xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		})
		
		// 댓글 등록 버튼에 클릭 리스너 등록
		$("#addReplyBtn").on("click", function(e) {
			
			modal.find("input").val("");
			modal.find("input[name='replyer']").val(replyer);
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
				showList(-1);
			});
			
		});
		
		// 닫기 버튼 처리
		modalCloseBtn.on("click", function(e) {
			modal.modal("hide");
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
			var originalReplyer = modalInputReplyer.val();
			
			var reply = {
					rno : modal.data("rno"),	// 댓글 번호 
					reply : modalInputReply.val(),	// 댓글 내용
					replyer : originalReplyer};	// 작성자
			
			console.log("댓글 수정 시작합니다...");
					
			if(!replyer) {
				alert("로그인후 수정이 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			if(replyer != originalReplyer) {
				alert("자신이 작성한 댓글만 수정이 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			replyService.update(reply, function(result) {
				alert(result);
				modal.modal("hide");
				showList(pageNum);
			});
		});
		
		modalRemoveBtn.on("click", function(e) {
			
			if(!replyer) {
				alert("로그인 후 삭제가 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			var originalReplyer = modalInputReplyer.val();
			
			if(replyer != originalReplyer) {
				alert("자신이 작성한 댓글만 삭제가 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			var rno = modal.data("rno");
			
			replyService.remove(rno, originalReplyer, function(result) {
				alert("댓글 삭제 완료");
				modal.modal("hide");
				showList(pageNum);
			});
		});
		
		
		replyPageFooter.on("click", "li a", function(e) {
			e.preventDefault();
			console.log("페이지 버튼 클릭 됨");
			
			// href 속성 값을 가져옴
			var targetPageNum = $(this).attr("href");
			
			console.log("targetPageNum : " + targetPageNum);
			
			pageNum = targetPageNum;
			
			showList(pageNum);
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

<script type="text/javascript">
	// 조회 화면 로딩 시, 게시글의 첨부파일 목록을 받아옴
	$(document).ready(function() {
		var bno = '<c:out value ="${board.bno}"/>';
		
		$.getJSON("/board/getAttachList", {bno : bno}, function(arr) {
			console.log(arr);
			
			var str = "";
			
			$(arr).each(function(i, attach) {
				
				// 이미지 파일인 경우
				if(attach.image) {
					var fileCallPath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);
					
					str += "<li data-path='" + attach.uploadPath + "'";
					str += "data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type = '" + attach.image + "'";
					str += "><div>";
					str += "<img src='/display?fileName=" + fileCallPath + "'>";
					str += "</div>";
					str += "</li>";
				} 
				// 일반 파일인 경우
				else {
					// 한글이나 공백등을 url 호출에 적합한 문자열로 변환
					var fileCallPath = encodeURIComponent(attach.uploadPath + "/" + attach.uuid + "_" + attach.fileName);
					
					str += "<li data-path='" + attach.uploadPath + "'";
					str += "data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type = '" + attach.image + "'";
					str += "><div>";
					str += "<span>" + attach.fileName + "</span><br>";
					str += "<img src='/resources/img/attach.png'></a>";
					str += "</div>";
					str += "</li>";
					
				}
			});
				
			$(".uploadResult ul").html(str);
		});
		
		$(".uploadResult").on("click", "li", function(e) {
			console.log("view image");
			
			var liObj = $(this);
			
			var path = encodeURIComponent(liObj.data("path") + "/" + liObj.data("uuid") + "_" + liObj.data("filename"));
			
			// image type 인 경우
			if(liObj.data("type")) {
				showImage(path.replace(new RegExp(/\\/g), "/"));
			} else {
				// download
				self.location = "/download?fileName=" + path
			}
		});
		
		function showImage(fileCallPath) {
			
			$(".bigPictureWrapper").css("display", "flex").show();
			
			$(".bigPicture").html("<img src='/display?fileName=" + fileCallPath + "'>")
			.animate({width: "100%", height: "100%"}, 1000);
			
		}
		
		
		$(".bigPictureWrapper").on("click", function(e) {
			$(".bigPicture").animate({width: "0%", height: "0%"}, 1000);
			setTimeout(function() {
				$(".bigPictureWrapper").hide();
			}, 1000);
			
		});
	});
</script>

<%@include file="../includes/footer.jsp"%>

