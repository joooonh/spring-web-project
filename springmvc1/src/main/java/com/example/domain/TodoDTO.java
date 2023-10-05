package com.example.domain;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@Data
public class TodoDTO {

    private String title;

    @DateTimeFormat(pattern = "yyyy/MM/dd") // @InitBinder 대신 이 어노테이션으로 날짜 형식을 Date 타입으로 변환
    private Date dueDate;   // 2020-01-01 같은 데이터를 Date 형식으로 변환해야 함

}
