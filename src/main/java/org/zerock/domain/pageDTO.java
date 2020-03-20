package org.zerock.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class pageDTO {
	
	// 10개씩 페이지 번호를 보여줄 때, 시작 페이지, 끝 페이지 번호
	private int startPage;
	private int endPage;
	private boolean prev, next;
	
	private int total;	// 전체 데이터 수
	private Criteria cri; // 현재 페이지 번호, 보여줄 게시글 수 정보
	
	public pageDTO(Criteria cri, int total) {
		this.cri = cri;
		this.total = total;
		
		this.endPage = (int)(Math.ceil(cri.getPageNum() / 10.0)) * 10;
		
		this.startPage = this.endPage - 9;	// 페이지 번호를 10개씩 보여준다는 전제
		
		// 실제 가지고 있는 데이터에 맞는 끝 페이지 번호를 계산
		int realEnd = (int) (Math.ceil((total * 1.0) / cri.getAmount()));
		
		// 실제 끝 페이지 번호가 표시된 페이지 끝 번호보다 적을 경우 재 계산
		if(realEnd < this.endPage) {
			this.endPage = realEnd;	
		}
			
		this.prev = this.startPage > 1;
		this.next = this.endPage < realEnd;
	}
}
