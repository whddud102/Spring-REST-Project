package org.zerock.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
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
	
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		
		log.info("remove........");
		if(service.remove(bno)) {
			rttr.addFlashAttribute("result", "success");
		}
		
		return "redirect:/board/list" + cri.getListLink();
	}

	@GetMapping("/register")
	public void register() {
		// 게시글 등록화면으로 안내해주는 역할만 수행
	}
}
