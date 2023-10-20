package com.example.security;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {com.example.config.RootConfig.class, com.example.config.SecurityConfig.class})
@Log4j
public class PasswordEncoderTests {

    @Setter(onMethod_ = {@Autowired})
    private PasswordEncoder pwEncoder;

    @Test
    public void testEncoder() {

        String str = "member";

        String enStr = pwEncoder.encode(str);

        log.info("encoded password: " + enStr);
    }
}
