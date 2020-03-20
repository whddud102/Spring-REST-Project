package org.zerock.service;

import java.util.List;

import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;

public interface ReplyService {
	// 댓글 등록 - Create
	public int register(ReplyVO vo);
	
	// 댓글 조회 - Read
	public ReplyVO get(Long rno);
	
	// 댓글 수정 - Update
	public int modify(ReplyVO vo);
	
	// 댓글 삭제 - Remove
	public int remove(Long rno);
	
	/**
	 * 특정 게시글의 댓글 목록 조회 
	 * @param cri 검색 조건
	 * @param bno 게시글 번호
	 * @return 댓글 리스트
	 */
	public List<ReplyVO> getList(Criteria cri, Long bno);
}
