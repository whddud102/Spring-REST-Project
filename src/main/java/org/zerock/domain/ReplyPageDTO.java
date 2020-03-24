package org.zerock.domain;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;


/**
 * 댓글의 페이징 처리를 위해서 댓글 목록과 댓글 수를 전달할 DTO 객체
 * @author whddu
 *
 */
@Data
@Getter
@AllArgsConstructor
public class ReplyPageDTO {
	private int replyCnt;	// 전체 댓글 수
	private List<ReplyVO> list;
}
