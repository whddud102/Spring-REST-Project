package org.zerock.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.zerock.domain.CustomUser;
import org.zerock.domain.MemberVO;
import org.zerock.mapper.MemberMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
public class CustomUserDetailsService implements UserDetailsService {
	
	@Setter(onMethod_ = @Autowired)
	private MemberMapper mapper;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		log.warn("Custom User Detail Service 동작 확인 : " + username);
		
		// 전달받은 userID를 통해 user에 대한 정보/권한을 읽어옴
		MemberVO vo = mapper.read(username);
		
		// 해당하는 user가 있으면 CustomUser 반환, 없으면 null 반환
		return vo == null ? null : new CustomUser(vo);
	}

}
