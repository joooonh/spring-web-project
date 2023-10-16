package com.example.service;

import com.example.config.RootConfig;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@Log4j
@ContextConfiguration(classes = {RootConfig.class})
public class SampleServiceTests {

    @Setter(onMethod_ = @Autowired)
    private AOPSampleService service;

    @Test
    public void testClass() {
        log.info(service);                      // ServiceImple 인스턴스인 것 처럼 보임
        log.info(service.getClass().getName()); // 세밀한 결과 - proxy 객체 출력
    }

    @Test
    public void testAdd() throws Exception {
        log.info(service.doAdd("123", "456"));
    }

    @Test
    public void testAddError() throws Exception {
        log.info(service.doAdd("123", "ABC"));  // 고의적 예외 발생
    }
}
