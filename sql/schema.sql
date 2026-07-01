-- ============================================================
-- EduTrack — School Management System
-- MySQL Schema (mirrors the Django models in this project)
-- ============================================================

CREATE DATABASE IF NOT EXISTS edutrack_db;
USE edutrack_db;

-- ---------- USERS ----------
CREATE TABLE users (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    username      VARCHAR(150) NOT NULL UNIQUE,
    first_name    VARCHAR(150) NOT NULL,
    last_name     VARCHAR(150) NOT NULL,
    email         VARCHAR(254) NOT NULL UNIQUE,
    password      VARCHAR(255) NOT NULL,
    role          ENUM('ADMIN', 'TEACHER', 'STUDENT') NOT NULL DEFAULT 'STUDENT',
    phone         VARCHAR(15),
    is_active     BOOLEAN NOT NULL DEFAULT TRUE,
    date_joined   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ---------- SCHOOL CLASSES ----------
CREATE TABLE school_classes (
    id      INT AUTO_INCREMENT PRIMARY KEY,
    name    VARCHAR(50) NOT NULL UNIQUE,
    section VARCHAR(10)
);

-- ---------- STUDENTS ----------
CREATE TABLE students (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT NOT NULL UNIQUE,
    school_class_id INT,
    roll_number     VARCHAR(20) NOT NULL UNIQUE,
    date_of_birth   DATE,
    guardian_name   VARCHAR(100),
    guardian_phone  VARCHAR(15),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (school_class_id) REFERENCES school_classes(id) ON DELETE SET NULL
);

-- ---------- TEACHERS ----------
CREATE TABLE teachers (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    user_id  INT NOT NULL UNIQUE,
    subject  VARCHAR(100) NOT NULL,
    phone    VARCHAR(15),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ---------- TEACHER <-> CLASS (many-to-many) ----------
CREATE TABLE teacher_classes (
    teacher_id      INT NOT NULL,
    school_class_id INT NOT NULL,
    PRIMARY KEY (teacher_id, school_class_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE CASCADE,
    FOREIGN KEY (school_class_id) REFERENCES school_classes(id) ON DELETE CASCADE
);

-- ---------- ATTENDANCE ----------
CREATE TABLE attendance (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    student_id    INT NOT NULL,
    date          DATE NOT NULL,
    status        ENUM('PRESENT', 'ABSENT', 'LATE') NOT NULL DEFAULT 'PRESENT',
    marked_by_id  INT,
    UNIQUE KEY unique_student_date (student_id, date),
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (marked_by_id) REFERENCES teachers(id) ON DELETE SET NULL
);

-- ---------- EXAMS ----------
CREATE TABLE exams (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    date        DATE NOT NULL,
    full_marks  INT NOT NULL DEFAULT 100
);

-- ---------- RESULTS ----------
CREATE TABLE results (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    exam_id         INT NOT NULL,
    student_id      INT NOT NULL,
    marks_obtained  DECIMAL(5,2) NOT NULL,
    UNIQUE KEY unique_exam_student (exam_id, student_id),
    FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);
