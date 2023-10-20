package com.example.domain;

import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class BoardVO {

    private Long bno;
    private String title;
    private String content;
    private String writer;
    private Date regDate;
    private Date updateDate;

    private int replyCnt;                       // 댓글수
    private List<BoardAttachVO> attachList;     // 첨부파일
}
