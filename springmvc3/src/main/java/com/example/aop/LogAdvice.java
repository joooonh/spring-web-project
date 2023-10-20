package com.example.aop;

import lombok.extern.log4j.Log4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import java.util.Arrays;

@Aspect     // Aspect를 구현한 객체임을 명시
@Log4j
@Component  // 스프링 빈으로 인식
public class LogAdvice {

    // @Before : 어떤 위치에 advice를 적용할 것인지 결정하는 pointcut
    //      BeforeAdvice를 구현한 메소드에 추가
    // AspectJ의 표현식
    //      execution : 접근제한자와 특정 클래스의 메소드 지정
    //      맨 앞의 * : 접근제한자, 맨 뒤의 * : 클래스 이름과 메소드 이름
    @Before("execution(* com.example.service.AOPSampleService*.*(..))")
    public void logBefore() {
        log.info("===================");
    }

    // doAdd() 메소드 명시 + 파라미터 타입 지정, 변수명 지정
    @Before("execution(* com.example.service.AOPSampleService*.doAdd(String, String)) && args(str1, str2)")
    public void logBeforeWithParam(String str1, String str2) {
        log.info("str1: " + str1);
        log.info("str2: " + str2);
    }

    // @AfterThrowing : 예외 발생 후 동작하면서 문제를 찾을 수 있음
    @AfterThrowing(pointcut = "execution(* com.example.service.AOPSampleService*.*(..))", throwing = "exception")
    public void logException(Exception exception) {
        log.info("Exception !!!");
        log.info("exception: " + exception);
    }

    // @Around : 직접 대상 메소드 실행, 메소드 실행 전후에 처리 가능
    // ProceedingJoinPoint : AOP의 대상이 되는 Target이나 파라미터 등을 파악, 직접 실행 결정
    @Around("execution(* com.example.service.AOPSampleService*.*(..))")
    public Object logTime(ProceedingJoinPoint pjp) {
        long start = System.currentTimeMillis();

        log.info("Target: " + pjp.getTarget());
        log.info("Param: " + Arrays.toString(pjp.getArgs()));

        // invoke method
        Object result = null;

        try {
            result = pjp.proceed();
        } catch (Throwable e) {
            e.printStackTrace();
        }

        long end = System.currentTimeMillis();
        log.info("TIME: " + (end - start));

        return result;
    }
}
