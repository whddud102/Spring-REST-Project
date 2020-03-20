package org.zerock.domain;

import java.sql.Date;

import lombok.Data;

@Data
public class ReplyVO {
	
	private Long bno;
	private Long rno;
	
	private String reply;
	private String replyer;
	private Date replyDate;
	private Date updateDate;
}
