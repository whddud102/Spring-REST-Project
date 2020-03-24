/**
 * 동적으로 댓글의 페이지를 출력하는 코드
 */

var pageNum = 1;
var replyPageFooter = $(".panel-footer");

function showReplyPage(replyCnt) {
	
	var endNum = Math.ceil(pageNum / 10.0) * 10;
	var startNum = endNum - 9;
	
	var prev = startNum != 1;
	var next = false;
	
	if(endNum * 10 >= replyCnt) {
		endNum = Math.ceil(replyCnt/10.0);
	}
	
	if(endNum * 10 < replyCnt) {
		next = true;
	}
	
	var str = "<ul class='pagination pull-right'>";
	
	if(prev) {
		str += "<li class='page-item'><a class='page-link' href='" + (startNum - 1) + "'>Previous</a></li>";
	}
	
	
	for(var i = startNum; i <= endNum; i++) {
		// 현재 전달된 페이지만 활성화 표시를 해 둠
		var active = pageNum == i? "active" : "";
		str += "<li class='page-item " + active + " ' ><a class='page-link' href='" + i + "'>" + i + "</a></li>";
	}
		
	
	if(next) {
		str += "<li class='page-item'><a class='page-link' href='" + (endNum + 1) + "'>Next</a></li>";
	}
	
	str += "</ul></div>";
	
	replyPageFooter.html(str);
}