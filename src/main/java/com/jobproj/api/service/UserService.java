package com.jobproj.api.service;

import com.jobproj.api.domain.Role;
import com.jobproj.api.dto.LoginResponse;
import com.jobproj.api.repo.UserRepo;
import com.jobproj.api.repo.UserRepo.UserRow;
import com.jobproj.api.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor // final 필드에 대한 생성자를 자동으로 만들어줍니다.
public class UserService {

  private final UserRepo userRepo;
  private final PasswordEncoder passwordEncoder;
  private final JwtTokenProvider jwtTokenProvider;

  /**
   * 1. 로그인 로직
   */
  public LoginResponse login(String email, String password) {

    // 1. 이메일로 사용자를 찾습니다.
    UserRow user = userRepo.findByEmail(email)
            .orElseThrow(() -> new RuntimeException("가입되지 않은 이메일입니다."));

    // 2. 비밀번호를 검증합니다.
    if (!passwordEncoder.matches(password, user.pwdHash)) {
      throw new RuntimeException("비밀번호가 일치하지 않습니다.");
    }

    // 3. (성공) JWT 토큰을 생성합니다.
    String token = jwtTokenProvider.createToken(user);

    // 4. LoginResponse DTO에 담아 반환합니다.
    return new LoginResponse(token, user.id, user.name, user.role);
  }

  /**
   * 2. [신규] 회원가입 로직
   */
  public void signup(String email, String rawPassword, String name) {

    // 1. 이메일 중복 확인 (12단계 UserRepo.save() 사용)
    if (userRepo.existsByEmail(email)) {
      throw new RuntimeException("이미 사용 중인 이메일입니다.");
    }

    // 2. 비밀번호 암호화 (SecurityConfig의 BCrypt)
    String encodedPassword = passwordEncoder.encode(rawPassword);

    // 3. 기본 역할은 'ROLE_USER'로 설정
    Role role = Role.USER;

    // 4. UserRepo를 호출하여 DB에 저장 (12단계에서 만든 save 메서드)
    userRepo.save(email, encodedPassword, name, role);
  }
}