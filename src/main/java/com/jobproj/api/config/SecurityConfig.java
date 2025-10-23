package com.jobproj.api.config;

import com.jobproj.api.security.JwtAuthenticationFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor //final 필드 생성자를 자동으로 만듭니다.
public class SecurityConfig {
    private final JwtAuthenticationFilter jwtAuthenticationFilter;
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();}
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .formLogin(form -> form.disable())
                .httpBasic(basic -> basic.disable())
                .sessionManagement(session ->
                        session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                )
                .authorizeHttpRequests(authz -> authz// [허용] /auth/login, /auth/signup (회원가입) 주소는 인증 없이 허용
                        .requestMatchers("/auth/login", "/auth/signup").permitAll()// [차단] 그 외 나머지 모든 주소는 반드시 인증이 필요함
                        .anyRequest().authenticated()
                );
        // Spring Security의 기본 로그인 필터(UsernamePasswordAuthenticationFilter)
        http.addFilterBefore(
                jwtAuthenticationFilter,
                UsernamePasswordAuthenticationFilter.class
        );
        return http.build();
    }
}