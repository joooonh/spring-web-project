package com.example.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.core.io.FileSystemResource;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

import java.io.IOException;

@EnableWebMvc
@ComponentScan(basePackages = {"com.example.controller", "com.example.exception"})
public class ServletConfig implements WebMvcConfigurer {

    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {

        InternalResourceViewResolver bean = new InternalResourceViewResolver();
        bean.setViewClass(JstlView.class);
        bean.setPrefix("/WEB-INF/views");
        bean.setSuffix(".jsp");
        registry.viewResolver(bean);
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/resources/**").addResourceLocations("/resources/");
    }

    @Bean(name = "multipartResolver")
    public CommonsMultipartResolver getResolver() throws IOException {
        CommonsMultipartResolver resolver = new CommonsMultipartResolver();

        // 한 번의 요청으로 전달될 수 있는 최대 크기 - 10MB
        resolver.setMaxUploadSize(1024 * 1024 * 10);

        // 한 파일의 최대 크기 - 2MB
        resolver.setMaxUploadSizePerFile(1024 * 1024 * 2);

        // 메모리 상에서 유지하는 최대 크기 - 1MB
        resolver.setMaxInMemorySize(1024 * 1024);

        // temp upload 경로
        resolver.setUploadTempDir(new FileSystemResource("/Users/joooonh/Documents/study"));

        // 업로드하는 파일 이름이 한글인 경우 깨지지 않게 하기 위함
        resolver.setDefaultEncoding("UTF-8");

        return resolver;
    }
}
