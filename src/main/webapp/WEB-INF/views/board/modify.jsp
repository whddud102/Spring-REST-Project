<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="../includes/header.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">게시글 수정</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!--  /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">게시글 수정 화면</div>
			<!-- /.pannel heading -->

			<div class="panel-body">
				<form role="form" action="/board/modify" method="post">
					<!-- pageNum, amount 정보도 같이 전송하도록 추가 -->
					<input type="hidden" name="pageNum"	value='<c:out value="${cri.pageNum}"/>'> 
					<input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
					<input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
					<input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
					
					<div class="form-group">
						<label>게시글 번호</label> <input class="form-control" name="bno"
							value='<c:out value="${board.bno }"/>' readonly="readonly">
					</div>

					<div class="form-group">
						<label>제목</label> <input class="form-control" name="title"
							value='<c:out value="${board.title }"/>'>
					</div>

					<div class="form-group">
						<label>내용</label>
						<textarea class="form-control" rows="3" name="content"><c:out
								value="${board.content }" /></textarea>
					</div>

					<div class="form-group">
						<label>작성자</label> <input class="form-control" name="writer"
							value='<c:out value="${board.writer }"/>' readonly="readonly">
					</div>

					<div class="form-group">
						<input class="form-control" name="regDate"
							value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.regdate}"/>'
							readonly="readonly" type="hidden" />
					</div>

					<div class="form-group">
						<input class="form-control" name="updateDate"
							value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.updateDate}"/>'
							readonly="readonly" type="hidden" />
					</div>

					<button type="submit" data-oper='modify' class="btn btn-default">수정</button>
					<button type="submit" data-oper='remove' class="btn btn-danger">삭제</button>
					<button type="submit" data-oper='list' class="btn btn-info">목록</button>
				</form>
			</div>
			<!-- end panel body -->
		</div>
	</div>
	<!-- end panel -->
</div>
<!-- /.row -->

<script type="text/javascript">
	$(document).ready(function() {
		
		var formObj = $("form");
		
		$('button').on("click", function(e) {
			e.preventDefault();
			
			var operation = $(this).data("oper");
			
			console.log(operation);
			
			if(operation === 'remove') {
				formObj.attr("action", "/board/remove");
			}else if(operation === 'list') {
				//move to list
				formObj.attr("action", "/board/list");
				formObj.attr("method", "get");
				
				// 필요한 태그들을 복사해 두고, form 내의 태그들 전부 삭제
				var pageNumTag = $("input[name='pageNum']").clone();
				var amountTag = $("input[name='amount']").clone();
				var keywordTag = $("input[name='keyword']").clone();
				var typeTag = $("input[name='type']").clone();
				
				formObj.empty();
				formObj.append(pageNumTag);	// 필요한 태그만 붙여넣기
				formObj.append(amountTag);	// 필요한 태그만 붙여넣기
				formObj.append(keywordTag);	// 필요한 태그만 붙여넣기
				formObj.append(typeTag);	// 필요한 태그만 붙여넣기

			} 
			formObj.submit();
		})
		
	});
</script>

<%@include file="../includes/footer.jsp"%>



