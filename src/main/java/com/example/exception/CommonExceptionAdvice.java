package com.example.exception;

import lombok.extern.log4j.Log4j;
import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.NoHandlerFoundException;

@ControllerAdvice   // 해당 객체가 스프링의 컨트롤러에서 발생하는 예외를 처리하는 존재임을 명시
@Log4j
public class CommonExceptionAdvice {

    // 해당 메소드가 ()에 들어가는 예외 타입을 처리함 의미
    // Exception -> 모든 예외가 except() 만을 이용해서 처리할 수 있음
    @ExceptionHandler(Exception.class)
    public String except(Exception ex, Model model) {
        log.error("Exception ....." + ex.getMessage());
        model.addAttribute("exception", ex);
        log.error(model);
        return "error_page";
    }

    // 404 에러 페이지 지정
    @ExceptionHandler(NoHandlerFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public String handle404(NoHandlerFoundException exception) {
        return "/sample/custom404";
    }
}
