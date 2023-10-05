package com.example.domain;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class SampleDtoList {

    private List<SampleDto> list;

    public SampleDtoList() {
        list = new ArrayList<>();
    }
}
