package org.zerock.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class BoardVO {
	
	private Long bno;	// 게시글 고유 번호
	private String title;
	private String content;
	private String writer;
	private Date regdate;
	private Date updateDate;
	
	private int replyCnt;	// 게시글에 작성된 댓글의 수
	
	// BoardVO 클래스에 첨부파일 처리를 위한 BoardAttachVO의 리스트를 필드로 선언
	private List<BoardAttachVO> attachList;
	
}
