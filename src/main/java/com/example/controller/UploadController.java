package com.example.controller;

import com.example.domain.AttachFileDTO;
import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Controller
@Log4j
public class UploadController {

    // 연/월/일 폴더 생성
    private String getFolder() {

        // 날짜를 문자열로 변환
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String str = sdf.format(date);

        // 날짜 문자열에서 "-" 문자를 파일 시스템의 디렉토리 구분 문자 "/" or "\" 로 대체
        return str.replace("-", File.separator);
    }

    // 서버에서 특정 파일이 이미지 파일인지 검사 필요
    private boolean checkImageType(File file) {

        try {
            String contentType = Files.probeContentType(file.toPath());
            return contentType.startsWith("image");
        } catch (IOException e) {
            e.printStackTrace();
        }
        return false;
    }

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
    // ajax 요청에 대해 브라우저로 다시 전송
    @PostMapping(value = "/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {

        // 브라우저로 보내기 위한 파일 정보들은 담은 객체
        List<AttachFileDTO> list = new ArrayList<>();

        String uploadFolder = "/Users/joooonh/Documents/upload";
        String uploadFolderPath = getFolder();

        // 연/월/일 폴더 생성
        File uploadPath = new File(uploadFolder, uploadFolderPath);

        if (uploadPath.exists() == false) {
            uploadPath.mkdirs();    // 필요한 상위 폴더까지 한번에 생성
        }

        // uploadFile 배열 중 각 MultipartFile 객체에 대한 처리
        for (MultipartFile multipartFile : uploadFile) {

            // 브라우저로 전송할 파일 정보를 담고 있는 객체
            AttachFileDTO attachDTO = new AttachFileDTO();

            String uploadFileName = multipartFile.getOriginalFilename();

            // 브라우저 전송 객체에 파일 이름 저장
            attachDTO.setFileName(uploadFileName);

            // 중복 방지를 위한 UUID 적용 (예: bbabb4ee-7e2e-47c2-b35b-bbc1ebc89467_연락망_230901.pdf)
            UUID uuid = UUID.randomUUID();
            uploadFileName = uuid.toString() + "_" + uploadFileName;

            try {

                // 연/월/일 폴더에 저장
                File saveFile = new File(uploadPath, uploadFileName);

                // 업로드 된 파일(multipartFile)이 특정 위치(saveFile)로 복사됨
                multipartFile.transferTo(saveFile);

                // 브라우저 전송 객체에 uuid, 파일 경로 저장
                attachDTO.setUuid(uuid.toString());
                attachDTO.setUploadPath(uploadFolderPath);

                // 이미지 파일이라면 섬네일 생성
                if (checkImageType(saveFile)) {

                    // 브라우저 전송 객체에 이미지 파일 여부 저장
                    attachDTO.setImage(true);

                    FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));
                    Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);
                    thumbnail.close();
                }

                // 브라우저로 보낼 AttachDTO 리스트에 AttachDTO 객체 추가
                list.add(attachDTO);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // ResponseEntity 반환
        return new ResponseEntity<>(list, HttpStatus.OK);
    }





}
