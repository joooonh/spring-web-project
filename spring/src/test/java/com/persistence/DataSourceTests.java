package com.persistence;

import com.config.RootConfig;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.sql.DataSource;
import java.sql.Connection;

import static org.junit.Assert.fail;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {RootConfig.class})
@Log4j
public class DataSourceTests {

    @Setter(onMethod_ = {@Autowired})
    private DataSource dataSource;
    @Setter(onMethod_ = {@Autowired})
    private SqlSessionFactory sqlSessionFactory;

    // DataSource 이용한 데이터베이스 연결 테스트
    @Test
    public void testConnection() {

        try (Connection con = dataSource.getConnection()){
            log.info("con : " + con);
        } catch(Exception e) {
            fail(e.getMessage());
        }
    }

    // SqlSessionFactoryBean 이용해서 SqlSession 테스트
    @Test
    public void testMyBatis() {

        try (SqlSession session = sqlSessionFactory.openSession();
             Connection con = session.getConnection();
        ) {

            log.info("session : " + session);
            log.info("con : " + con);

        } catch (Exception e) {
            fail(e.getMessage());
        }
    }

}
