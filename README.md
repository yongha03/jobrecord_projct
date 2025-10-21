# JobProj Backend (Spring Boot + JDBC)

## Quick Start
1) Start MySQL via your `docker-compose.yml`:
```
docker compose up -d
```
Place `01_schema.sql` into `./db/` so tables are created.
(Optional) Then run `sql/02_sample_data.sql` to add demo rows.

2) Import this folder into IntelliJ (Gradle project). JDK 17.

3) Run main class: `Application`.

### Endpoints
- GET /health
- POST /auth/login {"email","password"}
- GET /job-postings/active?limit=10&offset=0
- GET /resumes?userId=1
- POST /resumes
- PUT /resumes/{id}
- DELETE /resumes/{id}

Demo login after seeding: test@example.com / test1234
