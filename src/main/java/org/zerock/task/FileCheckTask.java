package org.zerock.task;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;import java.util.stream.Collector;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.zerock.domain.BoardAttachVO;
import org.zerock.mapper.BoardAttachMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Component
@Log4j
public class FileCheckTask {
	
	@Setter(onMethod_ = @Autowired) 
	private BoardAttachMapper attachMapper; 
	
	/**
	 * 새벽 2시마다 동작
	 * 데이터베이스의 첨부파일들의 정보와 실제 업로드된 파일들의 정보를 비교하여 불필요한 파일을 제거
	 * @throws Exception
	 */
	@Scheduled(cron = "0 0 2 * * *")
	public void checkFiles() throws Exception {
		log.warn("File Check Task 실행 중............");
		log.warn(new Date());
		
		// 데이터베이스에서 어제 정상적으로 업로드된 첨부파일들의 리스트를 가져옴
		List<BoardAttachVO> fileList = attachMapper.getOldFiles();
		
		// 첨부파일 정보 리스트를 이용해서 예상파일 목록을 생성
		List<Path> fileListPaths = fileList.stream()
			.map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), vo.getUuid() + "_" +vo.getFileName()))
				.collect(Collectors.toList() );
		
		// 이미지 파일은 섬네일 파일도 가지고 있음
		fileList.stream().filter(vo -> vo.isImage() == true)
			.map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), "s_" + vo.getUuid() + "_" + vo.getFileName()))
				.forEach(p -> fileListPaths.add(p));
		
		log.warn("======================================");
		
		fileListPaths.forEach(p -> log.warn(p));
		
		File targetDir = Paths.get("C:\\upload", getFolderYesterDay()).toFile();
		
		File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath()) == false);
		
		log.warn("=============================================");
		
		for (File file : removeFiles) {
			log.warn(file.getAbsolutePath());
			
			file.delete();
		}
	}
	
	
	/**
	 * 어제 날짜의 폴더명을 반환
	 * @return 어제 날짜의 폴더명
	 */
	private String getFolderYesterDay() {
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1);
		
		String str = sdf.format(cal.getTime());
		
		return str.replace("-", File.separator);
	}
}
