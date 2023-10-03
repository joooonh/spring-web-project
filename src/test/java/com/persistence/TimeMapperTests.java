package com.persistence;

import com.config.RootConfig;
import com.mapper.TimeMapper;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {RootConfig.class})
@Log4j
public class TimeMapperTests {

    @Setter(onMethod_ = @Autowired)
    private TimeMapper timeMapper;  // TimeMapper 타입의 객체가 스프링 빈으로 존재한다는 의미

    @Test
    public void testGetTime() {
        // TimeMapper 인터페이스만 만들었는데, 내부적으로 적당한 클래스 만들어짐
        log.info(timeMapper.getClass().getName());
        log.info(timeMapper.getTime());
    }

    @Test
    public void testGetTime2() {
        log.info("getTime2 결과 : " + timeMapper.getTime2());
    }
}
