package com.jobproj.api.ctrl;

import com.jobproj.api.dto.LoginRequest;
import com.jobproj.api.dto.LoginResponse;
import com.jobproj.api.repo.UserRepo;
import jakarta.validation.Valid;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AuthCtrl {
  private final UserRepo users;

  public AuthCtrl(UserRepo users) {
    this.users = users;
  }

  @PostMapping("/auth/login")
  public LoginResponse login(@Valid @RequestBody LoginRequest req) {
    return users
        .findByEmail(req.getEmail())
        .filter(u -> BCrypt.checkpw(req.getPassword(), u.pwdHash))
        .map(u -> new LoginResponse(u.id, u.name, u.role))
        .orElseThrow(() -> new RuntimeException("Invalid credentials"));
  }
}
