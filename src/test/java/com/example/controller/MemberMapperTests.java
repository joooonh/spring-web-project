package com.example.controller;

import com.example.domain.MemberVO;
import com.example.mapper.MemberMapper;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {com.example.config.RootConfig.class})
@Log4j
public class MemberMapperTests {

    @Setter(onMethod_ = @Autowired)
    private MemberMapper mapper;

    @Test
    public void testRead() {
        MemberVO vo = mapper.read("admin90");
        log.info(vo);
        vo.getAuthList().forEach(authVO -> log.info(authVO));
    }
}
