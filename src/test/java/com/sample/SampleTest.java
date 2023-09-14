package com.sample;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import static org.junit.Assert.assertNotNull;

@WebAppConfiguration
@RunWith(SpringJUnit4ClassRunner.class)     // 이 테스트 코드가 스프링 실행할 거다 -> @Autowired에 해당하는 것만 로딩
@ContextConfiguration("file:src/main/webapp/WEB-INF/applicationContext.xml")  // 스프링 빈으로 등록
@Log4j
public class SampleTest {

    @Setter(onMethod_ = {@Autowired})
    private Restaurant restaurant;

    @Test
    public void testExist() {

        assertNotNull(restaurant);  // restaurant가 null이 아니어야 테스트 성공

        log.info(restaurant);
        log.info("--------------------------");
        log.info(restaurant.getChef());
    }

}