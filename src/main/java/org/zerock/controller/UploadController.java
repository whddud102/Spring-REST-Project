package org.zerock.controller;

import java.io.File; 
import java.io.FileOutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.AttachFileDTO;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {
	
	@PostMapping(value =  "/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		
		log.info("----------------------- Ajax 업로드 요청 처리 ------------------------");
		
		List<AttachFileDTO> list = new ArrayList<AttachFileDTO>();
		String uploadFolder = "C:\\upload";
		
		String uploadFolderPath = getFolder();
		// 현재 날짜 별로 폴더 만들기
		File uploadPath = new File(uploadFolder, uploadFolderPath);
		log.info("파일 업로드 경로 : " + uploadPath);
		
		if(!uploadPath.exists()) {
			uploadPath.mkdirs();
		}
		
		for(MultipartFile multipartFile : uploadFile) {
			
			AttachFileDTO attachDTO = new AttachFileDTO();
			
			String uploadFileName = multipartFile.getOriginalFilename();
			
			// IE는 파일 이름에 파일 경로가 포함되어 있음
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
			log.info("only file name : " + uploadFileName);
			attachDTO.setFileName(uploadFileName);
			
			UUID uuid = UUID.randomUUID();
			
			uploadFileName = uuid.toString() + "_" + uploadFileName;
			
			try {
				File saveFile = new File(uploadPath, uploadFileName);
				multipartFile.transferTo(saveFile);
				
				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadPath(uploadFolderPath);
				
				// 이미지 파일 여부 체크
				if(checkImageType(saveFile)) {
					
					attachDTO.setImage(true);
					
					// 썸네일 사진을 저장
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);
					thumbnail.close();
				}
				
				// 첨부파일 리스트에 첨부파일을 추가
				list.add(attachDTO);
				
			} catch (Exception e) {
				log.error(e.getMessage());
			}
		}
		
		return new ResponseEntity<List<AttachFileDTO>>(list, HttpStatus.OK);
	}
	
	@GetMapping("/display")
	public ResponseEntity<byte[]> getFile(String fileName) {
		
		log.info("fileName : " + fileName);
		
		// 주어진 경로에 위치한 파일을 객체로 가져옴
		File file = new File("C:\\upload\\" + fileName);
		
		log.info("file : " + file);
		
		ResponseEntity<byte[]> result = null;
		
		try {
			HttpHeaders header = new HttpHeaders();
			
			// 헤더에 전송할 파일의 MIME 타입 명시
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<byte[]>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
		}catch (Exception e) {
			log.info("getFile() 오류 : " + e.getMessage()); 
		}
		
		return result;
	}
	
	@PostMapping(value = "/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type) {
		log.info("파일 : " + fileName + " 삭제 요청");
		
		File file;
		
		try {
			file = new File("c:\\upload\\" + URLDecoder.decode(fileName, "UTF-8"));
			
			file.delete();
			
			// 이미지 파일인 경우 추가로 원본 이미지 삭제
			if(type.equals("image")) {
				String largeFilName = file.getAbsolutePath().replace("s_", "");
				
				log.info("원본 이미지 파일 : " + largeFilName);
				
				file = new File(largeFilName);
				
				file.delete();
			}
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		return new ResponseEntity<>("deleted", HttpStatus.OK);
	}
	
	@GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, String fileName) {
		log.info("file Name for download : " +  fileName);
		
		Resource resource = new FileSystemResource("C:\\upload\\" + fileName);
		
		if(!resource.exists()) {
			return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
		}
		
		
		String resourceName = resource.getFilename();
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_") + 1);
		HttpHeaders headers = new HttpHeaders();
		
		try {
			String downloadName = null;
			
			// IE 인 경우
			if(userAgent.contains("Trident")) {
				log.info("IE Browser");
				
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8").replaceAll("\\+", " ");
				
				log.info("IE name: " + downloadName);
			} else if (userAgent.contains("Edge")) {	// Edge 인 경우
				
				log.info("Edge Browser");
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8");
				log.info("Edge name: " + downloadName);
			
			} else { // chrome과 그 외의 경우
				log.info("Chrome Browser");
				downloadName = new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");
			}
			
			headers.add("Content-Disposition", "attachment; filename=" + downloadName);
			
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
	
	
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Date date = new Date();
		
		String str = sdf.format(date);
		
		return str.replace("-", File.separator);
	}
	
	
	private boolean checkImageType(File file) {
		
		try {
			String contentType = Files.probeContentType(file.toPath());
			
			return contentType.startsWith("image");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
}
