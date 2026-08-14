CREATE DATABASE IF NOT EXISTS student_performance_db;
   USE student_performance_db;
   -- Create the table
CREATE TABLE student_performance (
    student_id              VARCHAR(20),        -- Unique student identifier e.g. STU-400000
    school_id               VARCHAR(20),        -- Unique school identifier e.g. School_063
    lga                     VARCHAR(50),        -- Local Government Area of the school
    gender                  VARCHAR(10),        -- Male or Female
    age                     INT,                -- Student age
    course                  VARCHAR(50),        -- Subject name (10 subjects)
    term                    VARCHAR(10),        -- Term 1, 2, or 3
    academic_year           VARCHAR(10),        -- Academic year e.g. 2022/2023
    attendance_pct          DECIMAL(5, 2),      -- Attendance percentage (0–100)
    ca_score                DECIMAL(5, 2),      -- Continuous assessment score
    exam_score              DECIMAL(5, 2),      -- Examination score
    total_score             DECIMAL(5, 2),      -- Combined total score (0–100)
    grade                   VARCHAR(2),         -- Letter grade: A, B, C, D, or F
    passed                  VARCHAR(3),         -- Yes if total_score >= 45
    study_hours_per_week    DECIMAL(5, 2),      -- Self-reported weekly study hours
    parent_education        VARCHAR(50),        -- Highest parental education level
    school_type             VARCHAR(10),        -- Public or Private
    internet_access         VARCHAR(3)          -- Yes or No
);
-- Preview first 5 rows
SELECT * FROM student_performance LIMIT 5;
-- Check row count (should be 50,000)
SELECT COUNT(*) AS total_rows FROM student_performance;

-- Query 1: Pass rate by subject ordered from lowest to highest
SELECT 
    course,
    COUNT(*) AS total_students,
    SUM(CASE WHEN passed = 'Yes' THEN 1 ELSE 0 END) AS total_passed,
    ROUND(
        (SUM(CASE WHEN passed = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2
    ) AS pass_rate_pct
FROM student_performance
GROUP BY course
ORDER BY pass_rate_pct ASC;
USE student_performance_db;
-- Query 2: Average score by school_type and gender (cross-tab)
SELECT 
    school_type,
    gender,
    COUNT(*) AS total_students,
    ROUND(AVG(total_score), 2) AS avg_total_score,
    ROUND(AVG(ca_score), 2) AS avg_ca_score,
    ROUND(AVG(exam_score), 2) AS avg_exam_score
FROM student_performance
GROUP BY school_type, gender
ORDER BY school_type, gender;

-- Query 3: Schools with pass rate below 50% for Mathematics
SELECT 
    school_id,
    COUNT(*) AS total_students,
    SUM(CASE WHEN passed = 'Yes' THEN 1 ELSE 0 END) AS total_passed,
    ROUND(
        (SUM(CASE WHEN passed = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2
    ) AS pass_rate_pct
FROM student_performance
WHERE course = 'Mathematics'
GROUP BY school_id
HAVING pass_rate_pct < 50
ORDER BY pass_rate_pct ASC;

-- NOTE: Query returned no results because no school recorded a Maths 
-- pass rate below 50%. The lowest was 75.56% (School_055 & School_090).
-- This indicates a consistently strong Mathematics performance across all schools.
SELECT 
    school_id,
    COUNT(*) AS total_students,
    SUM(CASE WHEN passed = 'Yes' THEN 1 ELSE 0 END) AS total_passed,
    ROUND(
        (SUM(CASE WHEN passed = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2
    ) AS pass_rate_pct
FROM student_performance
WHERE course = 'Mathematics'
GROUP BY school_id
ORDER BY pass_rate_pct ASC;

-- Query 4: Top 10 schools by overall pass rate
-- ============================================================
SELECT 
    school_id,
    COUNT(*) AS total_students,
    SUM(CASE WHEN passed = 'Yes' THEN 1 ELSE 0 END) AS total_passed,
    ROUND(
        (SUM(CASE WHEN passed = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2
    ) AS pass_rate_pct
FROM student_performance
GROUP BY school_id
ORDER BY pass_rate_pct DESC
LIMIT 10;

-- Query 5: Subjects where female students outperform male students
-- ============================================================
SELECT 
    course,
    ROUND(AVG(CASE WHEN gender = 'Female' THEN total_score END), 2) AS avg_score_female,
    ROUND(AVG(CASE WHEN gender = 'Male' THEN total_score END), 2) AS avg_score_male,
    ROUND(
        AVG(CASE WHEN gender = 'Female' THEN total_score END) -
        AVG(CASE WHEN gender = 'Male' THEN total_score END), 2
    ) AS female_advantage
FROM student_performance
GROUP BY course
HAVING avg_score_female > avg_score_male
ORDER BY female_advantage DESC;

-- Query 6: Attendance impact — avg total score by attendance buckets
-- ============================================================
SELECT 
    CASE 
        WHEN attendance_pct BETWEEN 0  AND 40  THEN '0–40%'
        WHEN attendance_pct BETWEEN 41 AND 60  THEN '41–60%'
        WHEN attendance_pct BETWEEN 61 AND 80  THEN '61–80%'
        WHEN attendance_pct BETWEEN 81 AND 100 THEN '81–100%'
    END AS attendance_bucket,
    COUNT(*) AS total_students,
    ROUND(AVG(total_score), 2) AS avg_total_score,
    ROUND(AVG(ca_score), 2) AS avg_ca_score,
    ROUND(AVG(exam_score), 2) AS avg_exam_score,
    ROUND(
        (SUM(CASE WHEN passed = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2
    ) AS pass_rate_pct
FROM student_performance
GROUP BY attendance_bucket
ORDER BY attendance_bucket;

-- Query 7: Students who passed all subjects in a given academic year
-- ============================================================
SELECT 
    student_id,
    academic_year,
    COUNT(DISTINCT course) AS subjects_taken,
    SUM(CASE WHEN passed = 'Yes' THEN 1 ELSE 0 END) AS subjects_passed,
    ROUND(AVG(total_score), 2) AS avg_score
FROM student_performance
GROUP BY student_id, academic_year
HAVING subjects_taken = subjects_passed
ORDER BY academic_year, avg_score DESC;

-- Check how many subjects a typical student takes per academic year
SELECT 
    student_id,
    academic_year,
    COUNT(DISTINCT course) AS subjects_taken
FROM student_performance
GROUP BY student_id, academic_year
ORDER BY subjects_taken DESC
LIMIT 20;

-- Query 7 (Fixed): Students who passed all subjects in a given academic year
SELECT 
    student_id,
    academic_year,
    COUNT(DISTINCT course) AS subjects_taken,
    SUM(CASE WHEN passed = 'Yes' THEN 1 ELSE 0 END) AS subjects_passed,
    ROUND(AVG(total_score), 2) AS avg_score
FROM student_performance
GROUP BY student_id, academic_year
HAVING COUNT(DISTINCT course) > 1
   AND COUNT(DISTINCT course) = SUM(CASE WHEN passed = 'Yes' THEN 1 ELSE 0 END)
ORDER BY academic_year, avg_score DESC;

-- Check max subjects per student per year
SELECT 
    student_id,
    academic_year,
    COUNT(DISTINCT course) AS subjects_taken
FROM student_performance
GROUP BY student_id, academic_year
ORDER BY subjects_taken DESC
LIMIT 10;

-- Query 7: Students who passed all subjects in a given academic year
-- NOTE: This query could not be executed as intended because the dataset
-- is structured at the individual student-subject level, meaning each 
-- student_id appears only once per course and is not reused across subjects.
-- Therefore, it is not possible to identify students who passed ALL subjects
-- in a given year. Instead, below is the pass count by academic year as
-- an alternative insight:

SELECT 
    academic_year,
    COUNT(*) AS total_records,
    SUM(CASE WHEN passed = 'Yes' THEN 1 ELSE 0 END) AS total_passed,
    ROUND(
        (SUM(CASE WHEN passed = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2
    ) AS pass_rate_pct
FROM student_performance
GROUP BY academic_year
ORDER BY academic_year;

-- Query 8: LGA performance ranking using RANK()
-- ============================================================
SELECT 
    lga,
    COUNT(*) AS total_students,
    ROUND(AVG(total_score), 2) AS avg_total_score,
    ROUND(
        (SUM(CASE WHEN passed = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2
    ) AS pass_rate_pct,
    RANK() OVER (ORDER BY AVG(total_score) DESC) AS performance_rank
FROM student_performance
GROUP BY lga
ORDER BY performance_rank;

-- Query 9: Improvement trend — avg score per subject comparing
--          first academic year (2021/2022) vs last (2023/2024)
-- ============================================================
SELECT 
    course,
    ROUND(AVG(CASE WHEN academic_year = '2021/2022' THEN total_score END), 2) AS avg_score_2021_2022,
    ROUND(AVG(CASE WHEN academic_year = '2023/2024' THEN total_score END), 2) AS avg_score_2023_2024,
    ROUND(
        AVG(CASE WHEN academic_year = '2023/2024' THEN total_score END) -
        AVG(CASE WHEN academic_year = '2021/2022' THEN total_score END), 2
    ) AS score_change
FROM student_performance
GROUP BY course
ORDER BY score_change DESC;

-- Query 10: CTE — Identify bottom 10% of students by average score
-- ============================================================
WITH student_avg AS (
    SELECT 
        student_id,
        ROUND(AVG(total_score), 2) AS avg_score
    FROM student_performance
    GROUP BY student_id
),
ranked AS (
    SELECT 
        student_id,
        avg_score,
        NTILE(10) OVER (ORDER BY avg_score ASC) AS decile
    FROM student_avg
)
SELECT 
    student_id,
    avg_score,
    decile
FROM ranked
WHERE decile = 1
ORDER BY avg_score ASC;

SELECT 
    SUM(CASE WHEN student_id IS NULL THEN 1 ELSE 0 END) AS student_id_nulls,
    SUM(CASE WHEN school_id IS NULL THEN 1 ELSE 0 END) AS school_id_nulls,
    SUM(CASE WHEN lga IS NULL THEN 1 ELSE 0 END) AS lga_nulls,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS gender_nulls,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS age_nulls,
    SUM(CASE WHEN course IS NULL THEN 1 ELSE 0 END) AS course_nulls,
    SUM(CASE WHEN attendance_pct IS NULL THEN 1 ELSE 0 END) AS attendance_nulls,
    SUM(CASE WHEN ca_score IS NULL THEN 1 ELSE 0 END) AS ca_score_nulls,
    SUM(CASE WHEN exam_score IS NULL THEN 1 ELSE 0 END) AS exam_score_nulls,
    SUM(CASE WHEN total_score IS NULL THEN 1 ELSE 0 END) AS total_score_nulls,
    SUM(CASE WHEN grade IS NULL THEN 1 ELSE 0 END) AS grade_nulls,
    SUM(CASE WHEN passed IS NULL THEN 1 ELSE 0 END) AS passed_nulls,
    SUM(CASE WHEN study_hours_per_week IS NULL THEN 1 ELSE 0 END) AS study_hours_nulls,
    SUM(CASE WHEN parent_education IS NULL THEN 1 ELSE 0 END) AS parent_edu_nulls,
    SUM(CASE WHEN school_type IS NULL THEN 1 ELSE 0 END) AS school_type_nulls,
    SUM(CASE WHEN internet_access IS NULL THEN 1 ELSE 0 END) AS internet_nulls
FROM student_performance;
SELECT DISTINCT parent_education 
FROM student_performance;

 
 
 

 






 