package com.example.config;

import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

import javax.servlet.Filter;
import javax.servlet.MultipartConfigElement;
import javax.servlet.ServletRegistration;

public class WebConfig extends AbstractAnnotationConfigDispatcherServletInitializer {
    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class[]{RootConfig.class};
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        return new Class[]{ServletConfig.class};
    }

    @Override
    protected String[] getServletMappings() {
        return new String[]{"/"};
    }

    // 웹 애플리케이션에서 문자 인코딩 처리해주는 서블릿 필터
    @Override
    protected Filter[] getServletFilters() {
        CharacterEncodingFilter characterEncodingFilter = new CharacterEncodingFilter();
        characterEncodingFilter.setEncoding("UTF-8");
        characterEncodingFilter.setForceEncoding(true);
        return new Filter[] { characterEncodingFilter };
    }

    // 파일 업로드를 위한 MultipartConfig 설정
    @Override
    protected void customizeRegistration(ServletRegistration.Dynamic registration) {

        registration.setInitParameter("throwExceptionIfNoHandlerFound", "true");

        // 업로드되는 파일 저장 공간, 업로드 파일의 최대 크기, 한번에 올릴 수 있는 최대 크기
        MultipartConfigElement multipartConfig = new MultipartConfigElement("/Users/joooonh/Documents/upload/temp", 20971520, 41943040, 20971520);
        registration.setMultipartConfig(multipartConfig);
    }
}
