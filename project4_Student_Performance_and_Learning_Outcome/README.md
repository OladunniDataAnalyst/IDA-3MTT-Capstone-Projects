# 🎓 Project 4: Student Performance & Learning Outcomes Tracker

> **IDA/3MTT Data Analysis Bootcamp — Capstone Project**  
> Domain: Education | Dataset: student_performance.csv (50,000 rows) | Period: 2021/2022 – 2023/2024

---

## 📋 Business Background

The **Lagos State Ministry of Education** wants to understand academic performance trends across **100 secondary schools** in the state. They are particularly concerned about:
- High failure rates in certain subjects
- Performance gaps between public and private schools
- The impact of attendance on exam outcomes

A data analyst was engaged to analyse three years of student assessment data, identify at-risk populations, and provide evidence-based recommendations for intervention.

---

## 🗂️ Project Structure

```
Project4_Student_Performance/
├── student_performance_eda.ipynb       # Python EDA notebook
├── student_performance_queries.sql     # All 11 SQL queries
├── student_performance_analysis.xlsx   # Excel pivot tables & KPI sheet
├── student_performance_dashboard.pbix  # Power BI dashboard
├── student_performance_dashboard.pdf   # Power BI dashboard export
└── summary_report.docx                 # Written findings report
```

---

## 🎯 Objectives

- Perform cohort analysis to identify at-risk student groups
- Use SQL to query complex educational data across multiple dimensions
- Build pivot-table summaries for school and subject performance
- Create a monitoring dashboard for education administrators
- Provide evidence-based policy recommendations

---

## 📊 Dataset

| Attribute | Details |
|-----------|---------|
| File | student_performance.csv |
| Rows | 50,000 records |
| Period | 2021/2022 to 2023/2024 (3 academic years) |
| Schools | 100 secondary schools |
| Subjects | 10 subjects |
| LGAs | 10 Local Government Areas in Lagos |

**Columns:** student_id, school_id, lga, gender, age, course, term, academic_year, attendance_pct, ca_score, exam_score, total_score, grade, passed, study_hours_per_week, parent_education, school_type, internet_access

**Data Quality:**
- 9,929 missing values found in `parent_education` column (19.86%) — replaced with **'Unknown'**
- All other columns had zero null values
- Dataset structured at individual student-subject level (one row per student per subject)

---

## 🛠️ Tools & Techniques Used

| Tool | Techniques Applied |
|------|--------------------|
| 🐍 Python | Pandas, Matplotlib, Seaborn, data cleaning, null handling, at-risk student flagging, 10 visualizations |
| 🗄️ SQL (MySQL) | CREATE TABLE, GROUP BY, HAVING, CASE WHEN, RANK() window function, NTILE(10), CTEs, year-over-year comparison |
| 📊 Excel | PivotTables, AVERAGEIF, COUNTIF, conditional formatting, helper column (passed_numeric), KPI summary sheet |
| 📈 Power BI | DAX measures, Power Query, calculated columns, bookmark navigation, scatter plot with trend line, 5 slicers |

---

## 🗄️ SQL Analysis — Key Queries

All 11 queries were written in MySQL against a database named `student_performance_db`:

| # | Query | Technique |
|---|-------|-----------|
| 1 | Pass rate by subject (lowest to highest) | CASE WHEN, GROUP BY |
| 2 | Avg score by school type and gender | Cross-tab GROUP BY |
| 3 | Schools with Maths pass rate below 50% | HAVING filter |
| 4 | Top 10 schools by overall pass rate | ORDER BY, LIMIT |
| 5 | Subjects where females outperform males | Conditional AVG, HAVING |
| 6 | Attendance impact by bucket (0–40, 41–60, 61–80, 81–100%) | CASE WHEN buckets |
| 7 | Pass rate by academic year (alternative to passed-all query) | GROUP BY, CASE WHEN |
| 8 | LGA performance ranking | RANK() window function |
| 9 | Score improvement: first vs last academic year | Year-over-year conditional AVG |
| 10 | Bottom 10% of students by average score | CTE + NTILE(10) window function |

---

## 📊 Excel Analysis

- **Pivot Table 1:** Pass rate by Subject and School Type using `passed_numeric` helper column (average of 1/0 = pass rate %)
- **Pivot Table 2:** Average total score by LGA and Gender
- **AVERAGEIF Formula:** Average score for students with attendance ≥ 80% → **71.06**
- **COUNTIF Formula:** F grade count per subject using draggable single formula
- **Conditional Formatting:** All F grades highlighted in red across grade column
- **KPI Summary Sheet:** Total students, overall pass rate, avg attendance, top performing subject

---

## 📈 Power BI Dashboard

Two-page interactive dashboard with bookmark navigation:

**Page 1 — Subject View:**
- 4 KPI Cards: Total Students, Overall Pass Rate, Avg Score, Avg Attendance
- Clustered Bar Chart: Pass Rate by Subject
- Matrix: School Performance by Term and Subject (with row/column averages)
- 5 List Slicers: academic_year, school_type, lga, gender, course

**Page 2 — School View:**
- 4 KPI Cards: Total Students, Overall Pass Rate, Avg Score, Avg Attendance
- Average Score by LGA (Clustered Bar Chart)
- Scatter Plot: Attendance vs Score
- 5 List Slicers: academic_year, school_type, lga, gender, course
- Toggle buttons linking between Subject View and School View via bookmarks

**DAX Measures:**
```dax
Total Students = COUNTROWS(student_performance)

Overall Pass Rate = DIVIDE(
    COUNTROWS(FILTER(student_performance, student_performance[passed] = "Yes")),
    COUNTROWS(student_performance)
)

Avg Score = AVERAGE(student_performance[total_score])

Avg Attendance = AVERAGE(student_performance[attendance_pct])
```

---

## 📌 Key Findings

### Overall Performance
- Overall pass rate: **86.15%** across all 50,000 records
- Pass rates are remarkably uniform across all 10 subjects (86.05% – 86.69%)
- **Computer Science** recorded the lowest pass rate at **86.05%**

### Subject Performance
| Subject | Pass Rate | F Grade Count | Trend (2021–2024) |
|---------|-----------|---------------|-------------------|
| Computer Science | 86.05% | 713 | Declining (-0.09) |
| Mathematics | 86.07% | 708 | Declining (-1.20) ⚠️ |
| Physics | 86.18% | 673 | Declining (-1.12) ⚠️ |
| Biology | 86.28% | 693 | Declining (-0.07) |
| Economics | 86.44% | 684 | Declining (-0.19) |
| Chemistry | 86.60% | 671 | Declining (-0.47) |
| English | 86.69% | 655 | Improving (+0.24) ✅ |
| Literature | — | 727 | Improving (+0.76) ✅ |

### LGA Performance Ranking
| Rank | LGA | Avg Score | Pass Rate |
|------|-----|-----------|-----------|
| 1 | Shomolu | 63.35 | 86.91% |
| 2 | Surulere | 63.31 | 86.41% |
| 3 | Apapa | 63.19 | 86.70% |
| 4 | Kosofe | 63.14 | 86.19% |
| 5 | Ojo | 63.02 | 86.30% |
| 6 | Mushin | 62.97 | 86.13% |
| 7 | Ikeja | 62.85 | 85.80% |
| 8 | Agege | 62.83 | 85.80% |
| 9 | Alimosho | 62.75 | 86.26% |
| 10 | Eti-Osa | 62.72 | 85.03% |

### Academic Year Trend
| Academic Year | Total Records | Total Passed | Pass Rate |
|---------------|--------------|--------------|-----------|
| 2021/2022 | 16,596 | 14,307 | 86.21% |
| 2022/2023 | 16,671 | 14,387 | 86.30% |
| 2023/2024 | 16,733 | 14,380 | 85.94% |

### Attendance Impact
- Students with **80%+ attendance** averaged **71.06** — nearly **8 points above** the overall average of 63.08
- Positive correlation confirmed by scatter plot trend line in Power BI

### School Type & Mathematics
- No school recorded a Mathematics pass rate below 50%
- Lowest school Mathematics pass rate: **75.56%** (School_055 & School_090)
- This suggests a strong performance floor across all 100 schools

---

## 📊 KPI Summary

| KPI | Value |
|-----|-------|
| Total Students | 50,000 |
| Overall Pass Rate | 86.15% |
| Average Total Score | 63.08 |
| Average Attendance | 69.82% |
| Top Performing LGA | Shomolu (63.35 avg) |
| Lowest Performing LGA | Eti-Osa (62.72 avg) |
| Subject with Most F Grades | Literature (727) |
| Subject with Fewest F Grades | English (655) |
| Most Improved Subject | Literature (+0.76) |
| Most Declined Subject | Mathematics (-1.20) |
| Students with Attendance ≥ 80% Avg Score | 71.06 |

---

## 💡 Recommendations

1. **Prioritise Mathematics and Physics intervention** — Both subjects recorded the steepest score declines (-1.20 and -1.12 respectively) between 2021/2022 and 2023/2024. The Ministry should deploy targeted STEM support programmes including additional teacher training and supplementary learning resources.

2. **Introduce mandatory attendance tracking** — Students with 80%+ attendance score nearly 8 points higher on average. Schools should implement attendance monitoring systems with early intervention for students falling below 60% attendance.

3. **Investigate Literature and Computer Science failure rates** — Literature (727 F grades) and Computer Science (713 F grades) have the highest failure counts despite acceptable pass rates. A curriculum review or additional support resources should be considered.

4. **Replicate Shomolu LGA best practices** — Shomolu ranked first in both average score (63.35) and pass rate (86.91%). The Ministry should study and replicate the teaching practices, resource allocation, and school management approaches of top-performing LGAs across lower-performing ones like Eti-Osa.

5. **Address parental education data gaps** — 9,929 records (19.86%) had missing parental education data. Completing this data in future surveys would enable robust socioeconomic impact analysis and better targeting of support programmes for disadvantaged students.

---

## 👤 Author

**Oladunni Raji**  
Computer Science Graduate | Data Analyst  
IDA/3MTT Data Analysis Bootcamp — 2024/2025  

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue)](your-linkedin-url)
[![Email](https://img.shields.io/badge/Email-Contact-red)](mailto:your-email)

---

*This project was completed as part of the IDA/3MTT Data Analysis Bootcamp Capstone Project Compendium.*
