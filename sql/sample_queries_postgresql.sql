-- ============================================================
-- EduTrack — Sample SQL Queries (PostgreSQL version)
-- Run against schema_postgresql.sql in pgAdmin's Query Tool.
-- ============================================================

-- 1. List every student with their name, class, and roll number
SELECT
    s.roll_number,
    u.first_name,
    u.last_name,
    c.name AS class_name
FROM students s
JOIN users u ON s.user_id = u.id
LEFT JOIN school_classes c ON s.school_class_id = c.id
ORDER BY c.name, s.roll_number;


-- 2. Attendance percentage per student (aggregate + join)
SELECT
    s.roll_number,
    u.first_name || ' ' || u.last_name AS student_name,
    COUNT(a.id) AS total_days,
    SUM(CASE WHEN a.status = 'PRESENT' THEN 1 ELSE 0 END) AS days_present,
    ROUND(
        SUM(CASE WHEN a.status = 'PRESENT' THEN 1 ELSE 0 END) * 100.0 / COUNT(a.id),
        1
    ) AS attendance_percent
FROM students s
JOIN users u ON s.user_id = u.id
JOIN attendance a ON a.student_id = s.id
GROUP BY s.id, u.first_name, u.last_name
ORDER BY attendance_percent DESC;


-- 3. Students who were absent more than 3 times this month
SELECT
    s.roll_number,
    u.first_name || ' ' || u.last_name AS student_name,
    COUNT(*) AS absent_days
FROM attendance a
JOIN students s ON a.student_id = s.id
JOIN users u ON s.user_id = u.id
WHERE a.status = 'ABSENT'
  AND EXTRACT(MONTH FROM a.date) = EXTRACT(MONTH FROM CURRENT_DATE)
  AND EXTRACT(YEAR FROM a.date) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY s.id, u.first_name, u.last_name
HAVING COUNT(*) > 3
ORDER BY absent_days DESC;


-- 4. Exam results with percentage, joined across exams + students
SELECT
    e.name AS exam_name,
    s.roll_number,
    u.first_name || ' ' || u.last_name AS student_name,
    r.marks_obtained,
    e.full_marks,
    ROUND(r.marks_obtained * 100.0 / e.full_marks, 1) AS percentage
FROM results r
JOIN exams e ON r.exam_id = e.id
JOIN students s ON r.student_id = s.id
JOIN users u ON s.user_id = u.id
ORDER BY e.date DESC, percentage DESC;


-- 5. Class-wise average score for each exam
SELECT
    c.name AS class_name,
    e.name AS exam_name,
    ROUND(AVG(r.marks_obtained), 2) AS average_marks,
    COUNT(r.id) AS students_appeared
FROM results r
JOIN exams e ON r.exam_id = e.id
JOIN students s ON r.student_id = s.id
JOIN school_classes c ON s.school_class_id = c.id
GROUP BY c.id, c.name, e.id, e.name
ORDER BY average_marks DESC;


-- 6. Top 5 students by average percentage across all exams
SELECT
    s.roll_number,
    u.first_name || ' ' || u.last_name AS student_name,
    ROUND(AVG(r.marks_obtained * 100.0 / e.full_marks), 1) AS avg_percentage
FROM results r
JOIN exams e ON r.exam_id = e.id
JOIN students s ON r.student_id = s.id
JOIN users u ON s.user_id = u.id
GROUP BY s.id, u.first_name, u.last_name
ORDER BY avg_percentage DESC
LIMIT 5;


-- 7. Teachers and the classes they teach (many-to-many join)
SELECT
    u.first_name || ' ' || u.last_name AS teacher_name,
    t.subject,
    STRING_AGG(c.name, ', ') AS classes_taught
FROM teachers t
JOIN users u ON t.user_id = u.id
LEFT JOIN teacher_classes tc ON tc.teacher_id = t.id
LEFT JOIN school_classes c ON tc.school_class_id = c.id
GROUP BY t.id, u.first_name, u.last_name, t.subject;


-- 8. Number of students per class
SELECT
    c.name AS class_name,
    COUNT(s.id) AS student_count
FROM school_classes c
LEFT JOIN students s ON s.school_class_id = c.id
GROUP BY c.id, c.name
ORDER BY student_count DESC;
