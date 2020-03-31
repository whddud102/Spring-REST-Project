<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="../includes/header.jsp" %>

<style>
	.uploadResult {
		width: 100%;
		background-color: gray;
	}
	
	.uploadResult ul {
		display: flex;
		flex-flow: row;
		justify-content: center;
		align-items: center;
	}
	
	.uploadResult ul li {
		list-style: none;
		padding: 10px;
	}
	
	.uploadResult ul li img{
		width: 60px;
	}

</style>

	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">게시글 등록</h1>
		</div>	
		<!-- /.col-lg-12 -->
	</div>
	<!--  /.row -->
	
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">
					게시글 등록 화면
				</div>
				<!-- /.pannel heading -->
				
				<div class="panel-body">
					<form role="form" action="/board/register" method="post">
						<div class="form-group">
							<label>제목</label> <input class="form-control" name="title"> 
						</div>
						
						<div class="form-group">
							<label>내용</label> <textarea class="form-control" rows="3" name="content"></textarea> 
						</div>
						
						<div class="form-group">
							<label>작성자</label> <input class="form-control" name="writer"> 
						</div>
						
						<button type="submit" class="btn btn-default">등록</button>
						<button type="reset" class="btn btn-default">지우기</button>
					</form>
				</div>
				<!-- end panel body -->
			</div>
		</div>
		<!-- end panel -->
	
	</div>
	<!-- /.row -->
	
	<!-- 첨부파일 등록 영역 -->
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">파일 첨부</div>
				<div class="panel-body">
					<div class="form-group uploadDiv">
						<input type="file" name="uploadFile" multiple="multiple">
					</div>
					
					<div class="uploadResult">
						<ul>
							<!-- 첨부 결과가 출력될 리스트 -->
						</ul>
					</div>
				</div>
				<!-- /.panel-body -->
			</div>
		</div>
		<!-- /.col -->
	</div>
	<!-- /.row -->

<script type="text/javascript">


$(document).ready(function() {
	var formObj = $("form[role='form']");
	
	// type이 submit인 버튼을 찾아서 접근
	$("button[type='submit']").on("click", function(e) {
		e.preventDefault();
		console.log("게시글 등록 버튼 클릭 됨");
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
				
				str += "<li><div>";
				str += "<span>" + obj.fileName + "</span>";
				str += "<button type='button' class='btn btn-warning btn-circle' data-file=\'" + fileCallPath + "\' data-type='image'><i class='fa fa-times'></i></button><br>";
				str += "<img src='/display?fileName=" + fileCallPath + "'>";
				str += "</div>";
				str += "</li>";
			} 
			// 일반 파일인 경우
			else {
				
				// 한글이나 공백등을 url 호출에 적합한 문자열로 변환
				var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
				var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
				
				str += "<li><div>";
				str += "<span>" + obj.fileName + "</span>";
				str += "<button type='button' class='btn btn-warning btn-circle' data-file=\'" + fileCallPath + "\' data-type='file'><i class='fa fa-times'></i></button><br>";
				str += "<img src='/resources/img/attach.png'></a>";
				str += "</div>";
				str += "</li>";
				
			}
		});
		
		uploadUL.append(str);
	}
	
	$(".uploadResult").on("click", "button", function(e) {
		
		var targetFile = $(this).data("file");
		var type =  $(this).data("type");
		
		console.log("제거 대상 파일 : " + targetFile);
		console.log("제거 파일 타입 : " +type); 
		
		
		var targetLi = $(this).closest("li");
		
		$.ajax({
			url: "/deleteFile",
			data: {fileName : targetFile, type: type},
			// 서버에서 전달받을 데이터 타입
			type: "POST",
			success: function(result) {
				alert("업로드 파일 삭제 성공 : " + targetFile);
				targetLi.remove();
			}
		})
	})
	
});
</script>

<%@include file="../includes/footer.jsp"%>

