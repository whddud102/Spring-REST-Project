package org.zerock.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class MemberVO {
	private String userid;
	private String userpw;
	private String userName;
	private boolean enabled;
	
	private Date regDate;
	private Date updateDate;
	private List<AuthVO> authList;	// MemberVO의 내부적으로 여러개의 사용자의 권한을 가질 수 있도록 설계
}
