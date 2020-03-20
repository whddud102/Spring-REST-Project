package org.zerock.mapper;

import static org.hamcrest.CoreMatchers.instanceOf;

import java.util.List;
import java.util.stream.IntStream;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ReplyMapperTests {

	//테스트를 위한 게시글들의 bno 배열
	private Long[] bnoArr = {20525L, 20524L, 20523L, 20521L, 20520L};
	
	
	@Setter(onMethod_ = {@Autowired})
	private ReplyMapper mapper;
	
	@Test
	public void testMapper() {
		log.info("\n\n------------------ Mapper의 의존성 주입 테스트 ---------------------");
		log.info(mapper + "\n");
	}
	
	@Test
	public void testCreate() {
		IntStream.range(1, 10).forEach(i -> {
			ReplyVO vo = new ReplyVO();
			
			vo.setBno(bnoArr[i % 5]);
			vo.setReply("댓글 테스트 " + i);
			vo.setReply("replyer" + i);
			
			mapper.insert(vo);
		});
	}
	
	@Test
	public void testRead() {
		Long targetLno = 5L;
		
		ReplyVO vo = mapper.read(targetLno);
		
		log.info(vo);
	}
	
	@Test
	public void testDelete() {
		Long targetLno = 1L;
		
		mapper.delete(targetLno);
	}
	
	@Test
	public void testUpdate() {
		Long targetLno = 10L;
		
		ReplyVO vo = mapper.read(targetLno);
		
		vo.setReply("Update Reply");
		
		int count = mapper.update(vo);
		
		log.info("UPDATE COUNT: " + count);
	}
	
	@Test
	public void testList() {
		
		// 기본 검색 조건을 가진 객체를 생성
		Criteria cri = new Criteria();
		
		// 목표 게시글 번호 = bnoArr[0] = 20525L
		List<ReplyVO> replies = mapper.getListWithPaging(cri, bnoArr[0]);
		
		replies.forEach(reply -> {
			log.info(reply);
		});
	}
	
}
