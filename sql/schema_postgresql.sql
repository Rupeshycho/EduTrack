-- ============================================================
-- EduTrack — School Management System
-- PostgreSQL Schema (use this version if managing the DB via pgAdmin)
-- Run this in pgAdmin's Query Tool after creating the edutrack_db database.
-- ============================================================

-- Run once, before connecting to edutrack_db:
-- CREATE DATABASE edutrack_db;

-- Custom ENUM types (Postgres requires types to be created separately)
CREATE TYPE user_role AS ENUM ('ADMIN', 'TEACHER', 'STUDENT');
CREATE TYPE attendance_status AS ENUM ('PRESENT', 'ABSENT', 'LATE');

-- ---------- USERS ----------
CREATE TABLE users (
    id            SERIAL PRIMARY KEY,
    username      VARCHAR(150) NOT NULL UNIQUE,
    first_name    VARCHAR(150) NOT NULL,
    last_name     VARCHAR(150) NOT NULL,
    email         VARCHAR(254) NOT NULL UNIQUE,
    password      VARCHAR(255) NOT NULL,
    role          user_role NOT NULL DEFAULT 'STUDENT',
    phone         VARCHAR(15),
    is_active     BOOLEAN NOT NULL DEFAULT TRUE,
    date_joined   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ---------- SCHOOL CLASSES ----------
CREATE TABLE school_classes (
    id      SERIAL PRIMARY KEY,
    name    VARCHAR(50) NOT NULL UNIQUE,
    section VARCHAR(10)
);

-- ---------- STUDENTS ----------
CREATE TABLE students (
    id              SERIAL PRIMARY KEY,
    user_id         INTEGER NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    school_class_id INTEGER REFERENCES school_classes(id) ON DELETE SET NULL,
    roll_number     VARCHAR(20) NOT NULL UNIQUE,
    date_of_birth   DATE,
    guardian_name   VARCHAR(100),
    guardian_phone  VARCHAR(15)
);

-- ---------- TEACHERS ----------
CREATE TABLE teachers (
    id       SERIAL PRIMARY KEY,
    user_id  INTEGER NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    subject  VARCHAR(100) NOT NULL,
    phone    VARCHAR(15)
);

-- ---------- TEACHER <-> CLASS (many-to-many) ----------
CREATE TABLE teacher_classes (
    teacher_id      INTEGER NOT NULL REFERENCES teachers(id) ON DELETE CASCADE,
    school_class_id INTEGER NOT NULL REFERENCES school_classes(id) ON DELETE CASCADE,
    PRIMARY KEY (teacher_id, school_class_id)
);

-- ---------- ATTENDANCE ----------
CREATE TABLE attendance (
    id            SERIAL PRIMARY KEY,
    student_id    INTEGER NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    date          DATE NOT NULL,
    status        attendance_status NOT NULL DEFAULT 'PRESENT',
    marked_by_id  INTEGER REFERENCES teachers(id) ON DELETE SET NULL,
    UNIQUE (student_id, date)
);

-- ---------- EXAMS ----------
CREATE TABLE exams (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    date        DATE NOT NULL,
    full_marks  INTEGER NOT NULL DEFAULT 100
);

-- ---------- RESULTS ----------
CREATE TABLE results (
    id              SERIAL PRIMARY KEY,
    exam_id         INTEGER NOT NULL REFERENCES exams(id) ON DELETE CASCADE,
    student_id      INTEGER NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    marks_obtained  DECIMAL(5,2) NOT NULL,
    UNIQUE (exam_id, student_id)
);
