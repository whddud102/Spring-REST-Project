package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardAttachMapper;
import org.zerock.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;


@Log4j
@Service
@AllArgsConstructor // 모든 멤버 변수를 파라미터로 갖는 생성자를 자동으로 생성
public class BoardServiceImpl implements BoardService {
	
	// 단일 파라미터를 갖는 생성자는 파라미터가 자동으로 주입 됨
	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	
	@Setter(onMethod_ = @Autowired)
	private BoardAttachMapper attachMapper;
	
	
	@Transactional
	@Override
	public void register(BoardVO board) {
			
		log.info("register........" + board);
		// select key로 인해서, BoardVO 객체에 담아 전달한 bno 값이 select key의 결과 값으로 다시 세팅됨
		// select key의 keyProperty는 bno 이므로, bno 값이 셋팅됨
		mapper.insertSelectKey(board);
		
		// 첨부파일이 없는 경우, 게시글만 등록하고 종료
		if(board.getAttachList() == null || board.getAttachList().size() <= 0) {
			return;
		}
		
		board.getAttachList().forEach(attach -> {
			// 첨부파일 객체에, 자신이 속한 게시글의 번호를 셋팅
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
	}

	@Override
	public BoardVO get(Long bno) {
		log.info("get........." + bno);
		return mapper.read(bno);
	}
	
	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		/*
		 * 게시글의 모든 첨부파일 목록을 제거 후,
		 * 새로 전달받은 첨부파일 목록으로 재 등록
		 */
		
		log.info("게시글 수정.........." + board);
		
		// 먼저 게시글에 등록된 모든 첨부파일의 정보를 제거
		attachMapper.deleteAll(board.getBno());
		
		// 실제 게시글의 내용을 수정
		boolean modifyResult = mapper.update(board) == 1;
		
		// 게시글 수정 완료 후, 전달받은 첨부 파일 목록이 있다면 새로 등록
		if(modifyResult && board.getAttachList() != null && board.getAttachList().size() > 0) {
			
			board.getAttachList().forEach(attach -> {
				
				// 전달받은 첨부파일 목록을 돌면서 첨부 파일 정보를 DB에 삽입
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
			
		}
			
		return modifyResult;
	}

	@Override
	public boolean remove(Long bno) {
		log.info("remove.........." + bno);
		return mapper.delete(bno) == 1;
	}

	
	/*
	 @Override
	public List<BoardVO> getList() {
		log.info("getList.............");
		return mapper.getList();
	}
	*/
	
	// Criteria 객체를 전달 받도록 수정
	
	@Override
	public List<BoardVO> getList(Criteria cri) {
		log.info("get List with criteria: " + cri);
		return mapper.getListWithPaging(cri);
	}

	
	@Override
	public int getTotal(Criteria cri) {
		log.info("get total count");
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		log.info("게시글 " + bno + "번의 첨부파일 목록을 가져옴.........");
		return attachMapper.findByBno(bno);
	}
	
	
	

}
