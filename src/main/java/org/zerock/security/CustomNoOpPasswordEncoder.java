package org.zerock.security;

import org.springframework.security.crypto.password.PasswordEncoder;

import lombok.extern.log4j.Log4j;

@Log4j
public class CustomNoOpPasswordEncoder implements PasswordEncoder {

	@Override
	public String encode(CharSequence rawPassword) {
		log.warn("인코딩 되기 전의 패스워드 : " + rawPassword);
		// 인코딩 하지 않고 반환
		return rawPassword.toString();
	}

	@Override
	public boolean matches(CharSequence rawPassword, String encodedPassword) {
		// 패스워드의 매칭 여부를 파악하는 메소드
		log.warn("패스워드 매칭 : " + rawPassword + " : " + encodedPassword);
		return rawPassword.toString().equals(encodedPassword);
	}

}
