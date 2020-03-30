package org.zerock.mapper;


import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

public interface BoardMapper {
	
	public List<BoardVO> getList();
	
	public void insert(BoardVO board);
	
	public void insertSelectKey(BoardVO board);
	
	public BoardVO read(Long bno);
	
	public int delete(Long bno);
	
	public int update(BoardVO board);
	
	public List<BoardVO> getListWithPaging(Criteria cri);
	
	public int getTotalCount(Criteria cri);
	
	/**
	 * 게시글에 작성된 댓글 수를 업데이트
	 * @param bno 게시글 번호
	 * @param amount 게시글의 증가나 감소를 의미하는 수
	 */
	public void updateReplyCount(@Param("bno") Long bno, @Param("amount") int amount);
}
