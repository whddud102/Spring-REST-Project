package org.zerock.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;


@Log4j
@Service
@AllArgsConstructor // 모든 멤버 변수를 파라미터로 갖는 생성자를 자동으로 생성
public class BoardServiceImpl implements BoardService {
	
	// 단일 파라미터를 갖는 생성자는 파라미터가 자동으로 주입 됨
	private BoardMapper mapper;
	
	@Override
	public void register(BoardVO board) {
		
		log.info("register........" + board);
		mapper.insertSelectKey(board);
	}

	@Override
	public BoardVO get(Long bno) {
		log.info("get........." + bno);
		return mapper.read(bno);
	}

	@Override
	public boolean modify(BoardVO board) {
		log.info("modify.........." + board);

		return mapper.update(board) == 1;
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
	

}
