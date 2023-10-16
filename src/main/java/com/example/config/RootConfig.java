package com.example.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;

@Configuration
@ComponentScan(basePackages = {"com.example.service"})
@ComponentScan(basePackages = "com.example.aop")
@EnableAspectJAutoProxy         // 스프링에 AOP 설정 - 자동으로 proxy 객체 생성해주는 설정
@EnableTransactionManagement    // 스프링에 트랜잭션 매니저 설정
@MapperScan(basePackages = {"com.example.mapper"})
public class RootConfig {

    // HikariDataSource를 스프링 빈으로 등록
    @Bean
    public DataSource dataSource() {
        HikariConfig hikariConfig = new HikariConfig();
        hikariConfig.setDriverClassName("net.sf.log4jdbc.sql.jdbcapi.DriverSpy");
        hikariConfig.setJdbcUrl("jdbc:log4jdbc:oracle:thin:@localhost:1521:XE");

        hikariConfig.setUsername("book_ex");
        hikariConfig.setPassword("book_ex");

        HikariDataSource dataSource = new HikariDataSource(hikariConfig);

        return dataSource;
    }

    // SqlSessionFactory를 스프링 빈으로 등록
    @Bean
    public SqlSessionFactory sqlSessionFactory() throws Exception {
        SqlSessionFactoryBean sqlSessionFactory = new SqlSessionFactoryBean();
        sqlSessionFactory.setDataSource(dataSource());
        return sqlSessionFactory.getObject();
    }

    // 트랜잭션 매니저를 스프링 빈으로 등록
    @Bean
    public DataSourceTransactionManager txManager() {
        return new DataSourceTransactionManager(dataSource());
    }
}
