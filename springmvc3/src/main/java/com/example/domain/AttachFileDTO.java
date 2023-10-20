package com.example.domain;

import lombok.Data;

@Data
public class AttachFileDTO {

    // 브라우저로 전송해야 하는 파일 이름, 경로, uuid값, 이미지인지 여부를 객체로 묶어서 전달
    private String fileName;
    private String uploadPath;
    private String uuid;
    private boolean image;

}
