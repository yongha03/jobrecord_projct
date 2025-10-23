package com.jobproj.api.repo;

import com.jobproj.api.domain.Role;
import java.sql.*;
import java.util.Optional;
import org.springframework.jdbc.core.*;
import org.springframework.stereotype.Repository;

@Repository
public class UserRepo {
  private final JdbcTemplate jdbc;

  public UserRepo(JdbcTemplate j) {
    this.jdbc = j;
  }

  // DB 조회 결과를 담을 객체
  public static class UserRow implements RowMapper<UserRow> {
    public Long id;
    public String email;
    public String pwdHash; // DB의 password_hash
    public String name;
    public Role role;

    @Override
    public UserRow mapRow(ResultSet rs, int n) throws SQLException {
      UserRow u = new UserRow();
      u.id = rs.getLong("users_id");
      u.email = rs.getString("users_email");
      u.pwdHash = rs.getString("users_password_hash");
      u.name = rs.getString("users_name");
      u.role = Role.fromString(rs.getString("users_role"));
      return u;
    }
  }

  // 이메일로 사용자 찾기 (로그인 시 사용)
  public Optional<UserRow> findByEmail(String email) {
    String sql =
            "SELECT users_id, users_email, users_password_hash, "
                    + "users_name, users_role FROM jobproject_users WHERE users_email=?";
    return jdbc.query(sql, new UserRow(), email).stream().findFirst();
  }
  // 이메일 중복 확인 (회원가입 시 사용)
  public boolean existsByEmail(String email) {
    String sql = "SELECT COUNT(*) FROM jobproject_users WHERE users_email=?";
    Integer count = jdbc.queryForObject(sql, Integer.class, email);
    return count != null && count > 0;
  }

  public void save(String email, String encodedPassword, String name, Role role) {
    String sql = "INSERT INTO jobproject_users (users_email, users_password_hash, users_name, users_role) " +
            "VALUES (?, ?, ?, ?)";

    jdbc.update(sql, email, encodedPassword, name, role.name());
  }
}