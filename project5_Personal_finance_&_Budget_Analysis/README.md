# 💰 Project 5: Personal Finance & Budget Analysis Tool

> **IDA/3MTT Data Analysis Bootcamp — Capstone Project**
> Domain: Consumer Finance | Dataset: personal_finance.csv | Period: 2021–2023

---

## 📋 Business Background

**FinTrack** is a Nigerian fintech startup building a personal finance app. Before launch, the product team wants to analyse three years of synthetic transaction data from **5,000 test users** to understand spending patterns, savings behaviour and budgetary pressures. The findings inform in-app budget recommendations, alert features and marketing segmentation.

---

## 🗂️ Project Structure

```
Project5_Personal_Finance/
├── Project5_PartA_Python.ipynb      # Python EDA (8 visualisations)
├── Project5_PartB_SQL.sql           # 11 SQL queries
├── Project5_Excel.xlsx              # Pivots, 50/30/20 budget model, KPI sheet
├── Project5_Dashboard.pbix          # Power BI dashboard
├── Project5_Dashboard.pdf           # Dashboard export
├── Project5_Summary_Final.docx      # Written summary report
└── README.md
```

---

## 🎯 Objectives

- Aggregate and analyse financial transactions across users and time
- Build a multi-user SQL database with meaningful queries
- Create a personal budget model in Excel using the 50/30/20 rule
- Design a consumer-facing finance dashboard in Power BI

---

## 📊 Dataset

| Attribute | Details |
|-----------|---------|
| File | personal_finance.csv |
| Raw rows | 75,000 |
| Rows analysed | **74,922** (after removing 2024 records) |
| Users | 5,000 |
| Period | 2021–2023 |
| Key columns | transaction_id, user_id, transaction_date, month, year, transaction_type, category, amount_ngn, payment_method, bank, savings_goal_met, budget_category, notes |

**Data preparation**
- **2024 records:** 78 records dated 1 January 2024 (0.1% of the data) fell outside the 2021–2023 project period and were removed across all four tools.
- **notes:** 21,618 blanks replaced with `Not Specified`.
- **savings_goal_met:** `N/A` retained; it is valid for non-savings transactions.
- **Income vs expense split:** 11,436 income records vs 63,486 expense records. Some users logged no income at all, so their income and savings-rate cells are blank.

---

## 🛠️ Tools & Techniques Used

| Tool | Techniques |
|------|-----------|
| 🐍 Python | pandas, matplotlib, seaborn; income/expense split, net savings per user per month, income brackets, over-spender flagging |
| 🗄️ SQL (MySQL) | CASE WHEN, NULLIF, subqueries, CTEs, RANK(), NTILE(10), SUM() OVER |
| 📊 Excel | PivotTables, SUMIF/SUMIFS, dynamic 50/30/20 budget model, conditional formatting, KPI sheet |
| 📈 Power BI | DAX measures, calculated columns, donut/line/bar visuals, user-level table, slicers |

---

## 🗄️ SQL Queries

| # | Query | Technique |
|---|-------|-----------|
| 1 | Create and populate transactions table | CREATE TABLE, import |
| 2 | Income vs expense per user (net position) | CASE WHEN, GROUP BY |
| 3 | Average monthly spending by category | Aggregation |
| 4 | Users with savings rate above 20% | NULLIF, HAVING |
| 5 | Top spending category per month | Subquery + RANK() |
| 6 | Bank popularity by count and volume | GROUP BY |
| 7 | Monthly net savings trend | CASE WHEN |
| 8 | Users who never saved | NOT IN subquery |
| 9 | Cumulative spending per user | SUM() OVER |
| 10 | Month with highest average expense per user | CTE + RANK() |
| 11 | Top 10% of spenders | CTE + NTILE(10) |

---

## 📈 Power BI Dashboard

**DAX measures**
```dax
Total Income   = CALCULATE(SUM(personal_finance[amount_ngn]), personal_finance[transaction_type] = "Income")
Total Expenses = CALCULATE(SUM(personal_finance[amount_ngn]), personal_finance[transaction_type] = "Expense")
Net Savings    = [Total Income] - [Total Expenses]
Savings Rate   = DIVIDE([Net Savings], [Total Income])
```

**Visuals:** 4 KPI cards, donut chart with category table, monthly income vs expense line chart, top 10 spending categories bar chart, user-level financial summary table, and 5 slicers (year, month, transaction type, category, bank).

---

## 📌 Key Findings

1. **Savings rate is 16.80%**, below the 20% target of the 50/30/20 rule.
2. **99.6% of users (4,982 of 5,000)** spent more than they earned in more than three months.
3. **Spending is spread evenly across categories.** Savings (₦325M), Utilities (₦322M) and Entertainment (₦309M) lead, with no single dominant category.
4. **Bank volumes are close:** GTBank (9,482), UBA (9,450) and First Bank (9,412) lead transaction counts.
5. **Expense records outnumber income records about 5.5 to 1**, suggesting users log spending far more consistently than earnings.

---

## 📊 KPI Summary

| KPI | Value |
|-----|-------|
| Total income | ₦4.40 billion |
| Total expenses | ₦3.66 billion |
| Net savings | ₦739.2 million |
| Savings rate | 16.80% |
| Average monthly income (all users combined) | ₦122.2 million |
| Over-spenders (>3 months) | 4,982 users (99.6%) |
| Records analysed | 74,922 |

---

## 💡 Recommendations

1. **Real-time budget alerts** when users approach category limits; almost the whole user base over-spends.
2. **Automated savings** (round-ups or auto-debit) to close the 3.2-point gap to the 20% target.
3. **Income logging prompts** so net position and budgets are reliable.
4. **Integrate all major banks** in the first release, since volumes are evenly spread.
5. **In-app 50/30/20 budget calculator** giving personalised category limits.

---

## 👤 Author

**Oladunni Raji** — Computer Science Graduate | Data Analyst
Connect with me
* 👔 **LinkedIn:** [Oladunni Raji](https://www.://linkedin.com/in/Oladunni-Raji)
* 📧 **Email:** [dunnestherry@gmail.com](dunnestherry@gmail.com)
* 💻 **GitHub:** [OLadunniDataAnalyst](https://github.com/OladunniDataAnalyst)
---

*Completed as part of the IDA/3MTT Data Analysis Bootcamp Capstone Project Compendium.*

