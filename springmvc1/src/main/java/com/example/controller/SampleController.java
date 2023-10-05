package com.example.controller;

import com.example.domain.SampleDto;
import com.example.domain.SampleDtoList;
import com.example.domain.TodoDTO;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.text.SimpleDateFormat;
import java.util.ArrayList;

@Controller
@RequestMapping("/sample/*")
@Log4j
public class SampleController {

//    // '2020-01-01' 형식으로 들어오는 데이터를 Date 타입으로 파라미터 변환 바인딩
//    @InitBinder
//    public void initBinder(WebDataBinder binder) {
//        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
//        binder.registerCustomEditor(java.util.Date.class, new CustomDateEditor(dateFormat, false));
//    }

    // 기본
    @GetMapping("/ex01")
    public String ex01(SampleDto dto) {

        log.info("" + dto);

        return "ex01";
    }

    // @RequestParam 기본
    @GetMapping("/ex02")
    public String ex02(@RequestParam("name") String name,
                       @RequestParam("age") int age) {

        log.info("name: " + name);
        log.info("age: " + age);

        return "ex02";
    }

    // 리스트
    @GetMapping("/ex02List")
    public String ex02List(@RequestParam("ids") ArrayList<String> ids) {

        log.info("ids: " + ids);

        return "ex02List";
    }

    // 배열
    @GetMapping("/ex02Array")
    public String ex02Array(@RequestParam("ids") String[] ids) {

        log.info("ids: " + ids);

        return "ex02Array";
    }

    // 객체 리스트
    @GetMapping("/ex02Bean")
    public String ex02Bean(SampleDtoList list) {

        log.info("list dtos: " + list);

        return "ex02Bean";
    }

    // 날짜 형식을 Date 타입으로 변환
    @GetMapping("/ex03")
    public String ex03(TodoDTO todo) {

        log.info("todo: " + todo);

        return "ex03";
    }

    // view로 데이터 전달
    @GetMapping("/ex04")
    public String ex04(SampleDto dto, @ModelAttribute("page") int page) {

        log.info("dto: " + dto);
        log.info("page: " + page);

        return "/sample/ex04";
    }

    // Controller의 리턴 타입 - void
    @GetMapping("/ex05")
    public void ex05() {
        log.info("/ex05.......");
    }

    // Controller의 리턴 타입 - VO, DTO 객체
    @GetMapping("/ex06")
    public @ResponseBody SampleDto ex06() {
        log.info("/ex06......");
        SampleDto dto = new SampleDto();
        dto.setAge(10);
        dto.setName("홍길동");

        return dto;
    }

    // ResponseEntity 타입
    @GetMapping("/ex07")
    public ResponseEntity<String> ex07() {
        log.info("/ex07........");

        // {"name" : "홍길동"}
        String msg = "{\"name\" : \"홍길동\"}";

        HttpHeaders header = new HttpHeaders();
        header.add("Content-Type", "application/json;charset=UTF-8");

        return new ResponseEntity<>(msg, header, HttpStatus.OK);
    }

    // 파일 업로드
    @GetMapping("/exUpload")
    public String exUpload() {
        log.info("/exUpload......");

        return "/sample/exUpload";
    }

    // 파일 업로드 동작
    @PostMapping("/exUploadPost")
    public void exUploadPost(ArrayList<MultipartFile> files) {

        files.forEach(file -> {
            log.info("-----------------------");
            log.info("name:" + file.getOriginalFilename());
            log.info("size:" + file.getSize());
        });
    }

}
