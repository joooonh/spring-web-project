package com.example.controller;

import com.example.domain.AttachFileDTO;
import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
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
    }

    // Ajax를 이용하는 파일 업로드 - 업로드되는 파일 저장
    // ajax 요청에 대해 브라우저로 다시 전송
    @PreAuthorize("isAuthenticated()")      // 로그인한 사용자만 첨부파일 등록
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

    // 섬네일 이미지 보여주기
    // 문자열로 파일 경로가 포함된 fileName을 파라미터로 받고, byte[] 전송
    @GetMapping("/display")
    @ResponseBody
    public ResponseEntity<byte[]> getFile(String fileName) {
        log.info("fileName: " + fileName);

        File file = new File("/Users/joooonh/Documents/upload/" + fileName);
        log.info("file: " + file);

        ResponseEntity<byte[]> result = null;

        try {
            HttpHeaders header = new HttpHeaders();
            // 적절한 MIME 타입 데이터를 Http 헤더 메시지에 포함
            header.add("Content-Type", Files.probeContentType(file.toPath()));
            result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }

    // 첨부파일 다운로드 (다운로드 할 수 있는 MIME 타입 - application/octet-stream)
    @GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
    @ResponseBody
    public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, String fileName) {

        Resource resource = new FileSystemResource("/Users/joooonh/Documents/upload/" + fileName);

        if (resource.exists() == false) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }

        String resourceName = resource.getFilename();

        // UUID 제거 (예: UUID_파일명.jpg -> 파일명.jpg)
        String resourceOriginalName = resourceName.substring(resourceName.indexOf("_") + 1);

        HttpHeaders headers = new HttpHeaders();

        try {

            String downloadName = null;

            if (userAgent.contains("Trident")) {
                log.info("IE browser");
                downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8").replaceAll("\\+", " ");
            } else if (userAgent.contains("Edge")) {
                log.info("Edge browser");
                downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8");
            } else {
                log.info("Chrome browser"); // safari
                // chrome : new String(resourceOriginalName.getBytes("UTF_8"), "ISO_8859_1");
                downloadName = new String(resourceOriginalName.getBytes(StandardCharsets.UTF_8), StandardCharsets.ISO_8859_1);
            }

            log.info("downloadName: " + downloadName);

            // 다운로드 시 저장되는 이름 지정 (Content-Disposition)
            headers.add("Content-Disposition", "attachment; filename=" + downloadName);

        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
    }

    // 첨부파일 삭제
    @PreAuthorize("isAuthenticated()")  // 로그인한 사용자만 첨부파일 삭제
    @PostMapping("/deleteFile")
    @ResponseBody
    public ResponseEntity<String> deleteFile(String fileName, String type) {
        log.info("deleteFile: " + fileName);

        File file;

        try {
            // 파일 이름을 디코딩하여 원래의 파일 이름 얻기
            // 자바스크립트에서 인코딩(%B8%EC%A7%80.jpg) -> 자바에서 디코딩(파일이름.jpg)
            file = new File("/Users/joooonh/Documents/upload/" + URLDecoder.decode(fileName, "UTF-8"));

            // 일반 파일인 경우 파일만 삭제
            file.delete();

            // 이미지 파일인 경우 섬네일 파일의 's_'를 지우고, 원본 파일과 함께 삭제되도록 처리
            if (type.equals("image")) {
                String largeFileName = file.getAbsolutePath().replace("s_", "");
                log.info("largeFileName: " + largeFileName);
                file = new File(largeFileName);
                file.delete();
            }
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<String>("deleted", HttpStatus.OK);
    }

}
