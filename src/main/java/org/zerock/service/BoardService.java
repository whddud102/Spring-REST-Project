package org.zerock.service;

import java.util.List;

import org.zerock.domain.AttachFileDTO;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

public interface BoardService {
	
	//게시물 등록
	public void register(BoardVO board);
	
	//게시물 가져오기
	public BoardVO get(Long bno);
	
	//게시물 수정
	public boolean modify(BoardVO board);
	
	//게시물 제거
	public boolean remove(Long bno);
	
	//모든 게시물 가져오기
	//public List<BoardVO> getList();
	
	//모든 게시물 가져오기 - Criteria 객체를 전달 받도록 수정
	public List<BoardVO> getList(Criteria cri);
	
	// 전체 데이터 개수 가져오기
	public int getTotal(Criteria cri);
	
	// 게시글 번호를 통해 등록된 첨부파일 목록을 가져옴
	public List<BoardAttachVO> getAttachList(Long bno);
}
