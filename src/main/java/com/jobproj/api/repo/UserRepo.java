package com.jobproj.api.repo;

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

  public static class UserRow implements RowMapper<UserRow> {
    public Long id;
    public String email;
    public String pwdHash;
    public String name;
    public String role;

    @Override
    public UserRow mapRow(ResultSet rs, int n) throws SQLException {
      UserRow u = new UserRow();
      u.id = rs.getLong("users_id");
      u.email = rs.getString("users_email");
      u.pwdHash = rs.getString("users_password_hash");
      u.name = rs.getString("users_name");
      u.role = rs.getString("users_role");
      return u;
    }
  }

  public Optional<UserRow> findByEmail(String email) {
    String sql =
        "SELECT users_id, users_email, users_password_hash, "
            + "users_name, users_role FROM jobpoject_users WHERE users_email=?";
    return jdbc.query(sql, new UserRow(), email).stream().findFirst();
  }
}
