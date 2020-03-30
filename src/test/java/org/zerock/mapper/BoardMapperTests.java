package org.zerock.mapper;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;


import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardMapperTests {
	
	@Setter(onMethod_ = {@Autowired})
	private BoardMapper mapper;	// 스프링이 알아서 Mapper 구현 객체를 주입해 줌.
	
	@Test
	public void testGetList() {
		mapper.getList().forEach(board -> log.info(board));
	}
	
	@Test
	public void testInsert() {
		
		BoardVO board = new BoardVO();
		board.setTitle("새로 작성하는 글");
		board.setContent("새로 작성하는 내용");
		board.setWriter("newbie");
		
		mapper.insert(board);
		
		log.info(board);
	}
	
	@Test
	public void testInsertSelectKey() {
		BoardVO board = new BoardVO();
		board.setTitle("새로 작성하는 글 select key");
		board.setContent("새로 작성하는 내용 select key");
		board.setWriter("newbie");
		
		mapper.insertSelectKey(board);
		
		log.info(board);
	}
	
	
	@Test
	public void testRead() {
		BoardVO board = mapper.read(2L);
		
		log.info(board);
	}
	
	@Test
	public void testDelete() {
		log.info("DELETE COUNT: " + mapper.delete(4L));
	}
	
	@Test
	public void testUpdate() {
		BoardVO board = new BoardVO();
		// 가상의 게시믈 객체에 pk값을 부여해줌
		board.setBno(1L);
		board.setTitle("수정된 제목");
		board.setContent("수정된 내용");
		board.setWriter("user00");
		
		int count = mapper.update(board);
		
		log.info("UPDATE COUNT: " + count);
	}
	
	@Test
	public void testPaging() {
		
		Criteria criteria = new Criteria();
		
		// 10개씩 총 3페이지를 보여주도록
		criteria.setAmount(5);
		criteria.setPageNum(1);
		
		List<BoardVO> list = mapper.getListWithPaging(criteria);
		
		list.forEach(board -> log.info(board.getBno()));
		
	}
	
	@Test
	public void testSearch() {
		
		Criteria cri = new Criteria();
		cri.setKeyword("새로");
		cri.setType("TWC");
		
		List<BoardVO> list = mapper.getListWithPaging(cri);
		
		list.forEach(board -> log.info(board));
	}
	
	@Test
	public void testUpdateRelply() {
		// 200번 게시글로 테스트
		BoardVO boardVO = mapper.read(200L);
		
		log.info("\n\n\n" + boardVO.getBno() + "번 게시글의 댓글 수 : " + boardVO.getReplyCnt() + " \n\n");
		
		mapper.updateReplyCount(200L, 1);
		boardVO = mapper.read(200L);
		
		log.info("\n\n댓글 수 + 1 : " + boardVO.getReplyCnt() + " \n\n");
		
		mapper.updateReplyCount(200L, -1);
		boardVO = mapper.read(200L);
		 
		log.info("\n\n댓글 수 -1 : " + boardVO.getReplyCnt() + "\n\n");
		
	}
}
