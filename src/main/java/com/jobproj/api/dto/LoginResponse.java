package com.jobproj.api.dto;

public class LoginResponse {
  private Long userId;
  private String name;
  private String role;

  public LoginResponse(Long id, String n, String r) {
    this.userId = id;
    this.name = n;
    this.role = r;
  }

  public Long getUserId() {
    return userId;
  }

  public String getName() {
    return name;
  }

  public String getRole() {
    return role;
  }
}
