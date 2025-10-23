CREATE TABLE `jobproject_users` (
                                    `users_id` bigint(20) NOT NULL AUTO_INCREMENT,
                                    `users_email` varchar(255) NOT NULL,
                                    `users_password_hash` varchar(255) NOT NULL,
                                    `users_name` varchar(100) NOT NULL,
                                    `users_phone` varchar(30) DEFAULT NULL,
                                    `users_created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                    `users_updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                    `users_role` enum('USER','ADMIN') NOT NULL DEFAULT 'USER',
                                    `users_status` enum('ACTIVE','SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
                                    `users_last_login` datetime DEFAULT NULL,
                                    PRIMARY KEY (`users_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `jobproject_resume` (
                                     `resume_id` bigint(20) NOT NULL AUTO_INCREMENT,
                                     `users_id` bigint(20) NOT NULL,
                                     `title` varchar(200) NOT NULL,
                                     `summary` text,
                                     `is_public` tinyint DEFAULT 0,
                                     `resume_created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                     `resume_updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                     PRIMARY KEY (`resume_id`),

                                     CONSTRAINT `fk_resume_to_users`
                                         FOREIGN KEY (`users_id`)
                                             REFERENCES `jobproject_users` (`users_id`)
                                             ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `jobproject_company` (
                                      `company_id` bigint NOT NULL AUTO_INCREMENT,
                                      `company_name` varchar(200) NOT NULL,
                                      `company_domain` varchar(255) DEFAULT NULL,
                                      `company_description` varchar(255) DEFAULT NULL,
                                      `company_homepage_url` varchar(255) DEFAULT NULL,
                                      `company_created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                      `company_updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                      PRIMARY KEY (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `jobproject_job_posting` (
                                          `job_posting_id` bigint NOT NULL AUTO_INCREMENT,
                                          `company_id` bigint NOT NULL,
                                          `job_posting_title` varchar(200) DEFAULT NULL,
                                          `job_posting_employment_type` enum('FULL_TIME','PART_TIME','CONTRACT','TEMPORARY','OTHER') DEFAULT 'FULL_TIME',
                                          `job_posting_location` varchar(200) DEFAULT NULL,
                                          `job_posting_description` mediumtext NOT NULL,
                                          `job_posting_is_active` tinyint NOT NULL DEFAULT '1',
                                          `job_posting_posted_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                          `job_posting_closed_at` datetime DEFAULT NULL,
                                          `job_posting_created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                          `job_posting_updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                          PRIMARY KEY (`job_posting_id`),

                                          CONSTRAINT `fk_job_posting_to_company`
                                              FOREIGN KEY (`company_id`)
                                                  REFERENCES `jobproject_company` (`company_id`)
                                                  ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `jobproject_education` (
                                        `education_id` bigint NOT NULL AUTO_INCREMENT,
                                        `resume_id` bigint NOT NULL,
                                        `education_school_name` varchar(200) NOT NULL,
                                        `education_major` varchar(200) DEFAULT NULL,
                                        `education_degree` varchar(100) DEFAULT NULL,
                                        `education_start_date` date DEFAULT NULL,
                                        `education_end_date` date DEFAULT NULL,
                                        `education_is_current` tinyint NOT NULL DEFAULT '0',
                                        `education_created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                        `education_updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                        PRIMARY KEY (`education_id`),

                                        CONSTRAINT `fk_education_to_resume`
                                            FOREIGN KEY (`resume_id`)
                                                REFERENCES `jobproject_resume` (`resume_id`)
                                                ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `jobproject_experience` (
                                         `experience_id` bigint NOT NULL AUTO_INCREMENT,
                                         `resume_id` bigint NOT NULL,
                                         `experience_company_name` varchar(200) NOT NULL,
                                         `experience_position_title` varchar(200) DEFAULT NULL,
                                         `experience_start_date` date DEFAULT NULL,
                                         `experience_end_date` date DEFAULT NULL,
                                         `experience_is_current` tinyint NOT NULL DEFAULT '0',
                                         `experience_description` mediumtext,
                                         `experience_created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                         `experience_updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                         PRIMARY KEY (`experience_id`),

                                         CONSTRAINT `fk_experience_to_resume`
                                             FOREIGN KEY (`resume_id`)
                                                 REFERENCES `jobproject_resume` (`resume_id`)
                                                 ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `jobproject_skill` (
                                    `skill_id` bigint NOT NULL AUTO_INCREMENT,
                                    `skill_name` varchar(100) NOT NULL,
                                    `skill_created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                    `skill_updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                    PRIMARY KEY (`skill_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `jobproject_resume_skill` (
                                           `resume_id` bigint NOT NULL,
                                           `skill_id` bigint NOT NULL,
                                           `proficiency` tinyint DEFAULT NULL,
                                           `resume_skill_created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                           `resume_skill_updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                           PRIMARY KEY (`resume_id`,`skill_id`),

                                           CONSTRAINT `fk_resume_skill_to_resume`
                                               FOREIGN KEY (`resume_id`)
                                                   REFERENCES `jobproject_resume` (`resume_id`)
                                                   ON DELETE CASCADE,

                                           CONSTRAINT `fk_resume_skill_to_skill`
                                               FOREIGN KEY (`skill_id`)
                                                   REFERENCES `jobproject_skill` (`skill_id`)
                                                   ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `jobproject_application` (
                                          `application_id` bigint NOT NULL AUTO_INCREMENT,
                                          `users_id` bigint NOT NULL,
                                          `job_posting_id` bigint NOT NULL,
                                          `status` enum('APPLIED','UNDER_REVIEW','INTERVIEW','OFFER','REJECTED','WITHDRAWN') NOT NULL DEFAULT 'APPLIED',
                                          `application_created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                          `application_updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                          PRIMARY KEY (`application_id`),

                                          CONSTRAINT `fk_application_to_users`
                                              FOREIGN KEY (`users_id`)
                                                  REFERENCES `jobproject_users` (`users_id`)
                                                  ON DELETE CASCADE,

                                          CONSTRAINT `fk_application_to_job_posting`
                                              FOREIGN KEY (`job_posting_id`)
                                                  REFERENCES `jobproject_job_posting` (`job_posting_id`)
                                                  ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `jobproject_job_bookmark` (
                                           `users_id` bigint NOT NULL,
                                           `job_posting_id` bigint NOT NULL,
                                           `job_bookmark_created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                           PRIMARY KEY (`users_id`,`job_posting_id`),

                                           CONSTRAINT `fk_job_bookmark_to_users`
                                               FOREIGN KEY (`users_id`)
                                                   REFERENCES `jobproject_users` (`users_id`)
                                                   ON DELETE CASCADE,

                                           CONSTRAINT `fk_job_bookmark_to_job_posting`
                                               FOREIGN KEY (`job_posting_id`)
                                                   REFERENCES `jobproject_job_posting` (`job_posting_id`)
                                                   ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 1) ENUM 표기 일관화 (application.status)
ALTER TABLE jobproject_application
    MODIFY `status` ENUM('APPLIED','UNDER_REVIEW','INTERVIEW','OFFER','REJECTED','WITHDRAWN')
    NOT NULL DEFAULT 'APPLIED';

-- 2) *_updated_at 자동 갱신
ALTER TABLE jobproject_users            MODIFY `users_updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE jobproject_resume           MODIFY `resume_updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE jobproject_company          MODIFY `company_updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE jobproject_job_posting      MODIFY `job_posting_updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE jobproject_education        MODIFY `education_updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE jobproject_experience       MODIFY `experience_updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE jobproject_skill            MODIFY `skill_updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE jobproject_resume_skill     MODIFY `resume_skill_updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE jobproject_application      MODIFY `application_updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- 3) Boolean/TINYINT(1) 명확화
ALTER TABLE jobproject_resume      MODIFY `is_public` TINYINT(1) NOT NULL DEFAULT 0;
ALTER TABLE jobproject_education   MODIFY `education_is_current` TINYINT(1) NOT NULL DEFAULT 0;
ALTER TABLE jobproject_experience  MODIFY `experience_is_current` TINYINT(1) NOT NULL DEFAULT 0;
ALTER TABLE jobproject_job_posting MODIFY `job_posting_is_active` TINYINT(1) NOT NULL DEFAULT 1;

-- 4) UNIQUE 제약
ALTER TABLE jobproject_users ADD CONSTRAINT `uq_users_email` UNIQUE (`users_email`);
ALTER TABLE jobproject_skill ADD CONSTRAINT `uq_skill_name` UNIQUE (`skill_name`);

-- 5) FK 인덱스 (성능)
CREATE INDEX `ix_resume_users`   ON jobproject_resume(`users_id`);
CREATE INDEX `ix_posting_company` ON jobproject_job_posting(`company_id`);
CREATE INDEX `ix_edu_resume`     ON jobproject_education(`resume_id`);
CREATE INDEX `ix_exp_resume`     ON jobproject_experience(`resume_id`);
CREATE INDEX `ix_rs_skill`       ON jobproject_resume_skill(`skill_id`);
CREATE INDEX `ix_app_users`      ON jobproject_application(`users_id`);
CREATE INDEX `ix_app_posting`    ON jobproject_application(`job_posting_id`);
CREATE INDEX `ix_jb_users`       ON jobproject_job_bookmark(`users_id`);
CREATE INDEX `ix_jb_posting`     ON jobproject_job_bookmark(`job_posting_id`);

-- 6) 숙련도 범위 체크(선택: MySQL 8.0.16+)
ALTER TABLE jobproject_resume_skill
    ADD CONSTRAINT `ck_rs_proficiency` CHECK (`proficiency` BETWEEN 0 AND 100);

-- 7) 고용형태 NOT NULL 보강
ALTER TABLE jobproject_job_posting
    MODIFY `job_posting_employment_type`
    ENUM('FULL_TIME','PART_TIME','CONTRACT','TEMPORARY','OTHER') NOT NULL DEFAULT 'FULL_TIME';

SELECT users_email, COUNT(*) AS c
FROM jobproject_users
GROUP BY users_email
HAVING c > 1;

SELECT skill_name, COUNT(*) AS c
FROM jobproject_skill
GROUP BY skill_name
HAVING c > 1;