package com.jobproj.api.dto;

import com.jobproj.api.domain.Role;
import lombok.Getter;

@Getter
public class LoginResponse {

  private final String accessToken; // JWT 토큰
  private final Long userId;
  private final String name;
  private final Role role; // String이 아닌 Role Enum 타입

  // 생성자
  public LoginResponse(String accessToken, Long userId, String name, Role role) {
    this.accessToken = accessToken;
    this.userId = userId;
    this.name = name;
    this.role = role;
  }
}