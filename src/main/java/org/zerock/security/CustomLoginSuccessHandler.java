package org.zerock.security;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import lombok.extern.log4j.Log4j;

@Log4j
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {

		log.warn("로그인 성공했습니다");

		List<String> roleNames = new ArrayList<String>();

		// 사용자가 가진 모든 권한을 리스트에 담음
		authentication.getAuthorities().forEach(authority -> {
			roleNames.add(authority.getAuthority());
		});

		log.warn("ROLE NAME : " + roleNames);

		// 어드민이 로그인 했을 경우
		if (roleNames.contains("ROLE_ADMIN")) {
				response.sendRedirect("/sample/admin");
				return;
		}

		// 멤버가 로그인 했을 경우
		if (roleNames.contains("ROLE_MEMBER")) {
			response.sendRedirect("/sample/member");
			return;
		}
		
		
		response.sendRedirect("/");
	}

}
