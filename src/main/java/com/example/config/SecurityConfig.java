package com.example.config;

import com.example.security.CustomLoginSuccessHandler;
import com.example.security.CustomUserDetailsService;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.rememberme.JdbcTokenRepositoryImpl;
import org.springframework.security.web.authentication.rememberme.PersistentTokenRepository;

import javax.sql.DataSource;

@Configuration
@EnableWebSecurity      // SpringSecurityFilterChain 자동 적용
@Log4j
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Setter(onMethod_ = {@Autowired})
    private DataSource dataSource;

    @Bean
    public UserDetailsService customUserDetailsService() {
        return new CustomUserDetailsService();
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(customUserDetailsService())
                .passwordEncoder(passwordEncoder());
    }

    @Bean
    public AuthenticationSuccessHandler loginSuccessHandler() {
        return new CustomLoginSuccessHandler();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
                .authorizeRequests()
                .antMatchers("/sample/all").permitAll()
                .antMatchers("/sample/admin").access("hasRole('ROLE_ADMIN')")
                .antMatchers("/sample/member").access("hasRole('ROLE_MEMBER')");

        http
                .formLogin().loginPage("/customLogin").loginProcessingUrl("/login");

        http
                .logout().logoutUrl("/customLogout").invalidateHttpSession(true).deleteCookies("remember-me", "JSESSION_ID");

        http
                .rememberMe().key("zerock").tokenRepository(persistentTokenRepository()).tokenValiditySeconds(604800);

    }

    @Bean
    public PersistentTokenRepository persistentTokenRepository() {
        JdbcTokenRepositoryImpl repo = new JdbcTokenRepositoryImpl();
        repo.setDataSource(dataSource);
        return repo;
    }

}
