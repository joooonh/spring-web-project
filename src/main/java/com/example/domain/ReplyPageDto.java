package com.example.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;

import java.util.List;

@Data
@AllArgsConstructor
@Getter
public class ReplyPageDto {

    private int replyCnt;
    private List<ReplyVO> list;
}
