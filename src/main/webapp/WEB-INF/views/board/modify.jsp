<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

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
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token }">
					
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
					
					<sec:authentication property="principal" var="pinfo"/>
					
					<!-- 로그인한 ID와 작성자 ID가 같을 때만 수정/삭제 버튼 출력 -->
					<sec:authorize access="isAuthenticated()">
					
						<c:if test="${pinfo.username eq board.writer}">	
							<button type="submit" data-oper='modify' class="btn btn-default">수정</button>
							<button type="submit" data-oper='remove' class="btn btn-danger">삭제</button>
						</c:if>
					</sec:authorize>
					
					<button type="submit" data-oper='list' class="btn btn-info">목록</button>
				</form>
			</div>
			<!-- end panel body -->
		</div>
	</div>
	<!-- end panel -->
</div>
<!-- /.row -->

<!-- 첨부파일 영역 -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">첨부파일</div>
			<!-- /.panel heading -->
			<div class="panel-body">
				<!-- form을 그룹핑 해주는 form-group 클래스 -->
				<div class="form-group uploadDiv">
					<input type="file" name="uploadFile" multiple="multiple">
				</div>
				
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

			} else if(operation === 'modify') {
				console.log("수정 버튼 클릭 됨");
				
				var str = "";
				
				$(".uploadResult ul li").each(function(i, obj) {
					var jobj = $(obj);
					
					console.dir(jobj);
					
					str += "<input type='hidden' name = 'attachList[" + i + "].fileName' value = '" + jobj.data("filename") + "'>"; 
					str += "<input type='hidden' name = 'attachList[" + i + "].uuid' value = '" + jobj.data("uuid") + "'>";
					str += "<input type='hidden' name = 'attachList[" + i + "].uploadPath' value = '" + jobj.data("path") + "'>";
					str += "<input type='hidden' name = 'attachList[" + i + "].image' value = '" + jobj.data("type") + "'>";
				});
				
				
				formObj.append(str).submit();
			}
			
			formObj.submit();
		})
		
	});
</script>

<!-- 첨부파일을 가져오는 자바스크립트 -->
<script type="text/javascript">

var csrfHeaderName = "${_csrf.headerName}";
var csrfTokenValue = "${_csrf.token}";

$(document).ready(function() {
	(function() {
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
					str += "<span>" + attach.fileName + "</span>";
					str += "<button type='button' data-file=\'" + fileCallPath + "\' data-type='" + attach.image + "'";
					str += "class = 'btn btn-warning btn-circle'><i class = 'fa fa-times'></i></button><br>";
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
					str += "<span>" + attach.fileName + "</span>";
					str += "<button type='button' data-file=\'" + fileCallPath + "\' data-type='" + attach.image + "'";
					str += "class = 'btn btn-warning btn-circle'><i class = 'fa fa-times'></i></button><br>";
					str += "<img src='/resources/img/attach.png'></a>";
					str += "</div>";
					str += "</li>";
				}
			});
			$(".uploadResult ul").html(str);
		});
	})();
	
	$(".uploadResult").on("click", "button", function() {
		console.log("삭제 버튼 클릭 됨");
		
		if(confirm("해당 첨부 파일을 삭제 하시겠습니까?")) {
			
			// 가장 가까운 li 태그 선택
			var targetLi = $(this).closest("li");
			targetLi.remove();
		}
	});
	
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	var maxSize = 5242880; // 5MB
	
	// 파일 확장자 검사
	function checkExtension(fileName, fileSize) {
		if(fileSize > maxSize) {
			alert("파일 사이즈 초과 : " + fileSize);
			return false;
		}
		
		if(regex.test(fileName)){
			alert("해당 종류의 파일은 업로드 할 수 없습니다 : " + fileName);
			return false;
		}
		
		return true;
	}
	
	$("input[type='file']").change(function(e) {
		var formData = new FormData();
		
		// input 태그에 접근
		var inputFile = $("input[name='uploadFile']");
		
		// 첨부 파일에 접근
		var files = inputFile[0].files;
		
		// formData 객체에 파일 첨부
		for(var i = 0; i <files.length; i++) {
			if(!checkExtension(files[i].name, files[i].size)) {
				return false;
			}
			formData.append("uploadFile", files[i]);
		}
			
		
		$.ajax({
			url: '/uploadAjaxAction',
			processData: false,
			contentType: false,
			beforeSend : function(xhr) {
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			data : formData,
			type: "POST",
			dataType: 'json',
			success: function(result) {
				alert("업로드 성공");
				console.log(result);
				showUploadResult(result)
			}
		});
	});
	
	function showUploadResult(uploadResultArr) {
		
		if(!uploadResultArr || uploadResultArr.length == 0) {
			return;
		}
		
		// uploadResult 영역의 ul 태그에 접근 
		var uploadUL = $(".uploadResult ul");
		
		var str = "";
		
		$(uploadResultArr).each(function(i, obj) {
			
			// 이미지 파일인 경우
			if(obj.image) {
				var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
				
				str += "<li data-path='" + obj.uploadPath + "'";
				str += "data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type = '" + obj.image + "'";
				str += "><div>";
				str += "<span>" + obj.fileName + "</span>";
				str += "<button type='button' class='btn btn-warning btn-circle' data-file=\'" + fileCallPath + "\'><i class='fa fa-times'></i></button><br>";
				str += "<img src='/display?fileName=" + fileCallPath + "'>";
				str += "</div>";
				str += "</li>";
			} 
			// 일반 파일인 경우
			else {
				
				// 한글이나 공백등을 url 호출에 적합한 문자열로 변환
				var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
				var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
				
				str += "<li data-path='" + obj.uploadPath + "'";
				str += "data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type = '" + obj.image + "'";
				str += "><div>";
				str += "<span>" + obj.fileName + "</span>";
				str += "<button type='button' class='btn btn-warning btn-circle' data-file=\'" + fileCallPath + "\' ><i class='fa fa-times'></i></button><br>";
				str += "<img src='/resources/img/attach.png'></a>";
				str += "</div>";
				str += "</li>";
				
			}
		});
		
		console.log(str);
		uploadUL.append(str);
	}
	
});


</script>

<%@include file="../includes/footer.jsp"%>



