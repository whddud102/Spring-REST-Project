package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;

public interface ReplyMapper {
	
	// 댓글 객체를 전달받아 DB에 등록
	public int insert(ReplyVO vo);
	
	// 게시글 번호를 전달받고 해당하는 댓글을 보여줌
	public ReplyVO read(Long rno);
	
	public int delete(Long rno);
	
	public int update(ReplyVO reply);
	
	// Mapper에 하나 이상의 파라미터를 전달할 땐 @Param 이용
	public List<ReplyVO> getListWithPaging(
			@Param("cri") Criteria cri,	// 페이징 처리 정보가 들어 있는 객체
			@Param("bno") Long bno);	// 게시글을 특정할 게시글 번호
	
	public int getCountByBno(Long bno);
}
