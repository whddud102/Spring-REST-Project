package org.zerock.domain;

import lombok.Data;

/**
 * 첨부파일의 정보 전달을 위한 클래스
 * @author whddud
 *
 */
@Data
public class AttachFileDTO {
	private String fileName;
	private String uploadPath;
	private String uuid;
	private boolean image;
}
