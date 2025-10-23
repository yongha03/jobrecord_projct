package com.jobproj.api.ctrl;


import com.jobproj.api.dto.LoginRequest;
import com.jobproj.api.dto.LoginResponse;
import com.jobproj.api.dto.SignupRequest; // 회원가입(signup) DTO
import com.jobproj.api.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity; // 회원가입(signup) 응답
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor // final 필드 생성자를 자동으로 만듭니다.
public class AuthCtrl {

  // 1. 서비스 주입 (한 번만)
  private final UserService userService;
  @PostMapping("/auth/login")
  public LoginResponse login(@Valid @RequestBody LoginRequest req) {
    return userService.login(req.getEmail(), req.getPassword());
  }
  @PostMapping("/auth/signup")
  public ResponseEntity<String> signup(@Valid @RequestBody SignupRequest req) {

    // UserService의 signup 메서드 호출
    userService.signup(req.getEmail(), req.getPassword(), req.getName());
    // 성공 시 201 Created 응답 반환
    return ResponseEntity.status(201).body("회원가입 성공");
  }
}