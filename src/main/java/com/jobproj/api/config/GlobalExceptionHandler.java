package com.jobproj.api.config;

import java.time.Instant;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

  private Map<String, Object> body(String code, String msg, int status) {
    return Map.of(
        "errorCode", code,
        "message", msg,
        "status", status,
        "timestamp", Instant.now().toString());
  }

  // Bean Validation(@Valid) 실패
  @ExceptionHandler(MethodArgumentNotValidException.class)
  public ResponseEntity<Map<String, Object>> handleBadRequest(MethodArgumentNotValidException e) {
    String msg = "invalid_request";
    FieldError fe = e.getBindingResult().getFieldError();
    if (fe != null) msg = fe.getField() + ": " + fe.getDefaultMessage();
    return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body("INVALID_REQUEST", msg, 400));
  }

  // 잘못된 파라미터 등 클라이언트 오류
  @ExceptionHandler(IllegalArgumentException.class)
  public ResponseEntity<Map<String, Object>> handleIllegalArgument(IllegalArgumentException e) {
    return ResponseEntity.status(HttpStatus.BAD_REQUEST)
        .body(body("INVALID_ARGUMENT", e.getMessage(), 400));
  }

  // 런타임 예외(필요 시 유지)
  @ExceptionHandler(RuntimeException.class)
  public ResponseEntity<Map<String, Object>> handleRuntime(RuntimeException e) {
    return ResponseEntity.status(HttpStatus.BAD_REQUEST)
        .body(body("BAD_REQUEST", e.getMessage(), 400));
  }

  // 그 밖의 모든 예외
  @ExceptionHandler(Exception.class)
  public ResponseEntity<Map<String, Object>> handleAny(Exception e) {
    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
        .body(body("SERVER_ERROR", "unexpected_error", 500));
  }
}
