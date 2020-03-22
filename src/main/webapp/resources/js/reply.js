/**
 * 
 */
console.log(".....Reply Module.....");

// javaScript 에서는 함수도 변수로 지정 가능
// 즉시 실행 함수를 통해 함수 안의 내용을 즉시 실행 후 변수에 저장
var replyService = (function() {
	// ----------- 즉시 실행 할 내용을 정의 -----------
	// 댓글 등록 함수를 정의, ajax 방식으로 서버에 댓글 등록을 요청
	function add(reply, callback, error) {
		console.log("add reply.............");
		
		
		$.ajax({
			// 전송 방식 지정 (댓글 등록은 post 방식만 처리)
			type : 'post',
			
			// 요청 url
			url : '/replies/new',
			
			// 서버에 요청 시 전송할 데이터
			// JSON.stringigy(value) = 주어진 value를 JSON 형태로 변환
			data : JSON.stringify(reply),
			
			// 서버에 보내는 데이터의 형식
			contentType : "application/json; charset=utf-8",
			
			// http 요청 성공 시 수행되는 이벤트 핸들러
			success : function(result, status, xhr) {
				console.log("ajax의 요청 result : " + result);
				console.log("ajax의 요청 status : " + status);
				console.log("ajax의 요청 xhr : " + xhr);
				if(callback) {
					callback(result);
				}
			},
			
			// http 요청 실패 시 수행되는 이벤트 핸들러
			error :  function(xhr, status, er) {
				if (error) {
					error(er);
				}
			}
		})
	}
	
	function getList(param, callback, error) {
		console.log("getList()........");
		
		// 전달받은 파라미터에서 게시글 번호와 페이지 번호 정보를 가져옴
		var bno = param.bno;
		var page = param.page || 1;
		
		// getJSON(요청 URL, [서버로 보낼 데이터], [성공 콜백]) : 서버로 부터 받은 JSON데이터를 로드
		$.getJSON("/replies/pages/" + bno + "/" + page + ".json",
				// 성공 콜백
				function(data) {
					if(callback) {
						callback(data);
					}
				}).fail(function(xhr, status, err) {
					if(error) {
						error();
					}
				});
	}
	
	function remove(rno, callback, error) {
		$.ajax({
			// 전송 방식 지정 (댓글 등록은 post 방식만 처리)
			type : 'delete',
			
			// 요청 url
			url : '/replies/' + rno,
			
			// http 요청 성공 시 수행되는 이벤트 핸들러
			success : function(result, status, xhr) {
				if(callback) {
					console.log("댓글 삭제 요청 성공")
					callback(result);
				}
			},
			
			// http 요청 실패 시 수행되는 이벤트 핸들러
			error :  function(xhr, status, er) {
				if (error) {
					console.log("댓글 삭제 요청 실패")
					error(er);
				}
			}
		})
	}
	
	
	function update(reply, callback, error) {
		console.log("댓글 수정......");
		
		$.ajax({
			type : 'put',
			url: "/replies/" + reply.rno,
			data: JSON.stringify(reply),
			contentType: "application/json; charset=utf-8",
			function(result, status, xhr) {
				if(callback) {
					console.log("성공 콜백 호출");
					callback(result);
				}
			},
			function(xhr, status, er) {
				if(error) {
					error(er);
				}
			}
		});
		
		console.log("댓글 수정 완료....");
		
	}
	
	function get(rno, callback, error) {
		$.get("/replies/" + rno + ".json", function(result) {
			if(callback) {
				callback(result);
			}
		}).fail(function(xhr, status, err) {
			if(error) {
				error();
			}
		});
	}
	
	
	// 변수에 반환 할 값을 정의
	// 위에서 정의한 함수를 멤버로 갖는 객체를 반환
	// javaScript 에서는 {} 로 객체를 표현
	return {
		add : add,
		getList : getList,
		remove : remove,
		update : update,
		get : get
	};
	
})();