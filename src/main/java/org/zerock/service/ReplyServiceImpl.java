package org.zerock.service;

import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.log;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;
import org.zerock.mapper.BoardMapper;
import org.zerock.mapper.ReplyMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class ReplyServiceImpl implements ReplyService {

	@Setter(onMethod_ = {@Autowired})
	private ReplyMapper mapper;	// 영속 계층을 이용해 서비스 구현
	
	@Setter(onMethod_ = {@Autowired})
	private BoardMapper boardMapper;	// 영속 계층을 이용해 서비스 구현

	@Transactional
	@Override
	public int register(ReplyVO vo) {
		// 댓글 등록 및 게시글의 댓글 수 증가
		log.info("댓글 등록......." + vo);
		
		boardMapper.updateReplyCount(vo.getBno(), 1);
		
		return mapper.insert(vo);
	}

	@Override
	public ReplyVO get(Long rno) {
		log.info("댓글 조회 - 댓글 id : " + rno);
		return mapper.read(rno);
	}

	@Override
	public int modify(ReplyVO vo) {
		log.info("댓글 수정...." + vo);
		return mapper.update(vo);
	}

	@Transactional
	@Override
	public int remove(Long rno) {
		// 댓글 삭제 및 게시글의 댓글 수 -1
		
		ReplyVO replyVO = mapper.read(rno);
		
		log.info("댓글 삭제 - 댓글 id : " + rno);
		boardMapper.updateReplyCount(replyVO.getBno(), -1);
		return mapper.delete(rno);
	}

	@Override
	public List<ReplyVO> getList(Criteria cri, Long bno) {
		log.info("게시글 " + bno + "번의 댓글 목록 조회");
		return mapper.getListWithPaging(cri, bno);
	}

	@Override
	public ReplyPageDTO getListPage(Criteria cri, Long bno) {
		return new ReplyPageDTO(mapper.getCountByBno(bno), mapper.getListWithPaging(cri, bno));
	}

}
