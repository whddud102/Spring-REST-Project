package org.zerock.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.pageDTO;
import org.zerock.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Controller
@AllArgsConstructor	// 멤버 변수를 파라미터로 갖는 생성자를 생성
@RequestMapping("/board/*")
public class BoardController {
	
	// 단일 파라미터를 갖는 생성자는 스프링이 자동으로 의존성 주입
	private BoardService service;
	
	/* 이전 버전 코드
	@GetMapping("/list")
	public void list(Model model) {
		log.info("list");
		model.addAttribute("list",	service.getList());
	}
	*/
	
	@GetMapping("/list")
	public void list(Criteria cri, Model model) {
		log.info("list: " + cri);
		model.addAttribute("list",	service.getList(cri));
		
		int total = service.getTotal(cri);
		
		log.info("totla: " + total);
		model.addAttribute("pageMaker", new pageDTO(cri, total));
		
		//model.addAttribute("pageMaker", new pageDTO(cri, 123));
	}
	
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {
		
		log.info("register: " + board);
		
		log.info("\n\n======================== 전달받은 첨부파일 목록 ===========================");
		if(board.getAttachList() != null) {
			board.getAttachList().forEach(attach -> log.info(attach));
		}
		log.info("======================================================================");
		
		service.register(board);	// 새 게시글을 등록
		
		// redirect시에 게시글 번호를 같이 전달
		rttr.addFlashAttribute("result", board.getBno());
		
		return "redirect:/board/list";
	}
	
	@GetMapping({"/get", "/modify"})
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
		log.info("/get or modify");
		model.addAttribute("board", service.get(bno));
		
	}
	 
	@PostMapping("/modify")
	public String modify(BoardVO board, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		
		log.info("modify: " + board);
		
		// 수정 작업 성공시에는 result 속성에 success를 담아서 반환
		if(service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}
		
		return "redirect:/board/list" + cri.getListLink();
	}
	
	@GetMapping("/register")
	public void register() {
		// 게시글 등록화면으로 안내해주는 역할만 수행
	}
	
	@GetMapping(value = "/getAttachList", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno) {
		
		log.info("getAttachList(" + bno + ")");
		log.info(service.getAttachList(bno));
		
		return new ResponseEntity<List<BoardAttachVO>>(service.getAttachList(bno), HttpStatus.OK);
	}
	
	/**
	 * 첨부 파일과 게시글의 정보를 DB에서 먼저 제거 후, 성공했다면 실제 첨부파일을 제거
	 * @param bno 게시글 번호
	 * @param cri 검색 조건
	 * @param rttr redirect 속성 객체
	 * @return
	 */
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, Criteria cri, RedirectAttributes rttr) {
		log.info(" ====== 첨부 파일 제거 ======");

		// 첨부파일들의 정보 목록을 가져옴
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		
		// DB상에서 데이터를 제거
		if(service.remove(bno)) {
			// 실제로 첨부파일 제거
			deleteFiles(attachList);
			
			// redirect의 파라미터에 result = success 값을 설정
			rttr.addFlashAttribute("result", "success");
		}
		
		return "redirect:/board/list" + cri.getListLink();
	
	}
	
	
	/**
	 * 업로드 폴더의 첨부 파일을 삭제
	 * @param attachList 첨부 파일들의 정보를 담은 리스트
	 */
	private void deleteFiles(List<BoardAttachVO> attachList) {
		if(attachList == null || attachList.size() == 0) {
			return;
		}
		
		log.info("첨부 파일들을 서버에서 삭제합니다....");
		log.info(attachList);
		
		attachList.forEach(attach -> {
			try {
				Path file = Paths.get("C:\\upload\\" + attach.getUploadPath() + "\\" + attach.getUuid() + "_" + attach.getFileName());
				
				Files.deleteIfExists(file);
				
				// 이미지 파일인 경우, 썸네일도 제거
				if(Files.probeContentType(file).startsWith("image")) {
					Path thumbnail = Paths.get("C:\\upload\\" + attach.getUploadPath() + "\\s_" + attach.getUuid() + "_" + attach.getFileName());
					
					Files.delete(thumbnail);
				}
			} catch (Exception e) {
				log.error("파일 제거 중 에러 발생 : " + e.getMessage());
			}
		});
	}
}
