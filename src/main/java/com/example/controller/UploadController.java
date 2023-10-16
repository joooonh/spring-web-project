package com.example.controller;

import lombok.extern.log4j.Log4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;

@Controller
@Log4j
public class UploadController {

    // <form> 방식의 파일 업로드 - 페이지 이동
    @GetMapping("/uploadForm")
    public void uploadForm() {
        log.info("upload form");
    }

    // <form> 방식의 파일 업로드 - 업로드되는 파일 저장
    @PostMapping("/uploadFormAction")
    public void uploadFormPost(MultipartFile[] uploadFile, Model model) {
        // MultipartFile[] : 스프링에서 제공하는 MultipartFile 타입 이용 (첨부파일을 여러 개 선택할 수 있으므로 배열 타입으로 설정)

        String uploadFolder = "/Users/joooonh/Documents/upload";

        // uploadFile 배열 중 각 MultipartFile 객체에 대한 처리
        for (MultipartFile multipartFile : uploadFile) {

            log.info("-----------------------------");
            log.info("Upload File name: " + multipartFile.getOriginalFilename());
            log.info("Upload File Size: " + multipartFile.getSize());

            File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());

            try {
                // 업로드 된 파일(multipartFile)이 특정 위치(saveFile)로 복사됨
                multipartFile.transferTo(saveFile);
            } catch (Exception e) {
                log.error(e.getMessage());
            }

        }
    }

    // Ajax를 이용하는 파일 업로드 - 페이지 이동
    @GetMapping("/uploadAjax")
    public void uploadAjax() {
        log.info("upload ajax");
    }

    // Ajax를 이용하는 파일 업로드 - 업로드되는 파일 저장
    @PostMapping("/uploadAjaxAction")
    public void uploadAjaxPost(MultipartFile[] uploadFile) {
        log.info("update ajax post.....");

        String uploadFolder = "/Users/joooonh/Documents/upload";

        // uploadFile 배열 중 각 MultipartFile 객체에 대한 처리
        for (MultipartFile multipartFile : uploadFile) {

            log.info("-----------------------------");
            log.info("Upload File name: " + multipartFile.getOriginalFilename());
            log.info("Upload File Size: " + multipartFile.getSize());

            String uploadFileName = multipartFile.getOriginalFilename();

            File saveFile = new File(uploadFolder, uploadFileName);

            try {
                // 업로드 된 파일(multipartFile)이 특정 위치(saveFile)로 복사됨
                multipartFile.transferTo(saveFile);
            } catch (Exception e) {
                log.error(e.getMessage());
            }
        }
    }
}
