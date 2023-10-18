package com.example.domain;

import lombok.Data;

@Data
public class BoardAttachVO {

    // 게시물에 추가되는 첨부파일 정보
    private String uuid;
    private String uploadPath;
    private String fileName;
    private boolean fileType;

    private Long bno;

}
