package org.zerock.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;
import org.zerock.service.ReplyService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@RequestMapping("/replies/")
@RestController
@Log4j
@AllArgsConstructor
public class ReplyController {

	private ReplyService service;

	/**
	 * JSON 형태의 댓글 데이터를 받아서 댓글을 등록
	 * 
	 * @param vo JSON 형태의 댓글을 ReplyVo 객체로 받음
	 * @return 수행 결과를 헤더에 표시 한 뒤 ResponseEntitiy 반환
	 */
	@PostMapping(value = "/new", consumes = "application/JSON", produces = { MediaType.TEXT_PLAIN_VALUE })
	public ResponseEntity<String> create(@RequestBody ReplyVO vo) {
		log.info("전달 받은 댓글 : " + vo);

		int insertCount = service.register(vo);

		log.info("댓글 등록 결과 카운트 : " + insertCount);

		return insertCount == 1 ? 
				new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	/**
	 * 특정 게시글의 댓글 목록을 반환
	 * @param bno - 경로상의 bno를 게시글 번호 데이터로 이용
	 * @param page - 경로상의 page를 페이지 번호 데이터로 이용
	 * @return - 댓글 목록의 리스트를 json, xml 형태로 반환
	 */
	@GetMapping(value = "/pages/{bno}/{page}",
			produces = {
					MediaType.APPLICATION_XML_VALUE, 
					MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<List<ReplyVO>> getList(
			@PathVariable("bno") Long bno,	// 경로에서 데이터를 뽑아옴
			@PathVariable("page") int page) {
		
		log.info("getList()............");
		Criteria cri = new Criteria(page, 10);
		
		log.info(cri);
		
		return new ResponseEntity<List<ReplyVO>>(service.getList(cri, bno), HttpStatus.OK);
	}
	
	/**
	 * 전달받은 댓글번호에 해당하는 댓글 조회
	 * @param rno 댓글 번호
	 * @return xml/json 형태의 댓글 데이터
	 */
	@GetMapping(value = "/{rno}", 
			produces = {
					MediaType.APPLICATION_XML_VALUE,
					MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno) {
		log.info("댓글 조회(댓글 번호 : " + rno + ")");
		
		return new ResponseEntity<ReplyVO>(service.get(rno), HttpStatus.OK);
	}
	
	@DeleteMapping(value = "/{rno}", 
			produces = {
					MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> remove(@PathVariable("rno") Long rno) {
		log.info("댓글 삭제(댓글 번호 : " + rno + ")");
		
		return service.remove(rno) == 1 
				? new ResponseEntity<String>("success", HttpStatus.OK)
				: new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@RequestMapping(method = {RequestMethod.PUT, RequestMethod.PATCH},
			value = "/{rno}",
			produces = {MediaType.TEXT_PLAIN_VALUE})	// text_plain_value = string
	public ResponseEntity<String> modify(@RequestBody ReplyVO vo, @PathVariable("rno") Long rno) {
		log.info("댓글 수정(댓글 번호 : " + rno);
		log.info("전달 받은 댓글 데이터 : " + vo);
		
		vo.setRno(rno);
		
		return service.modify(vo) == 1
				? new ResponseEntity<String>("success", HttpStatus.OK)
				: new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
}
