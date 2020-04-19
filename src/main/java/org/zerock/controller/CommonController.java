package org.zerock.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class CommonController {
	
	@GetMapping("/accessError")
	public void accessDenied(Authentication auth, Model model) {
		log.info("요청에 대한 접근이 거부되었습니다 : " + auth);
		
		model.addAttribute("msg", "Access Denied");
	}
	
	@GetMapping("/customLogin")
	public void logInput(String error, String logout, Model model) {
		log.info("error : " + error);
		log.info("logout : " + logout);
		
		if(error != null) {
			model.addAttribute("error", "로그인 에러 발생, 계정을 확인하세요");
		}
		
		if(logout != null) {
			model.addAttribute("logout", "로그아웃!!");
		}
	}
	
	@GetMapping("/customLogout")
	public void logoutGET() {
		log.info("로그아웃 요청됨");
	}

}
