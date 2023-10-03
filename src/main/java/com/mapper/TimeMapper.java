package com.mapper;

import org.apache.ibatis.annotations.Select;

public interface TimeMapper {

    @Select("SELECT sysdate FROM dual")
    public String getTime();

    // mapper 인터페이스와 xml 같이 이용하기 위한 메소드
    public String getTime2();
}
