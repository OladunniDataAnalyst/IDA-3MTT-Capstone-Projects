# 🛍️ ShopEase Nigeria — Retail Sales Performance Analysis
### Capstone Project 1 | IDA / 3MTT Data Analysis Bootcamp

---

## 📌 Business Background

ShopEase Nigeria is a mid-sized retail company operating across **8 major commercial cities in Nigeria** — Lagos, Abuja, Kano, Port Harcourt, Ibadan, Enugu, Kaduna, and Benin City. The company sells products across **8 product categories** (Electronics, Home & Kitchen, Sports, Clothing, Toys, Health & Beauty, Books, and Food & Beverage) through both physical stores and an online platform.

The business serves over **18,000 unique customers** and is managed by a team of **50 salespersons**. Despite strong national coverage, the business faces challenges around customer retention, seasonal revenue dips, category concentration risk, and a persistent return rate that cuts into profitability.

This project was commissioned to analyse three years of transaction data (2021–2023) across all regions, categories, and sales channels to uncover performance patterns, identify inefficiencies, and recommend data-driven strategies to drive growth.

---

## 🎯 Objectives

1. Analyse total revenue performance across regions, categories, products, and salespersons
2. Identify seasonal trends and month-over-month revenue patterns
3. Investigate return rates across all product categories
4. Evaluate delivery performance across payment methods
5. Identify top-spending customers and assess customer loyalty
6. Rank salesperson performance using advanced SQL window functions
7. Build an interactive Power BI dashboard for executive decision-making
8. Produce actionable business recommendations backed by data

---

## 📂 Project Structure

```
project1-retail-sales-analysis/
│
├── retail_sales_eda.ipynb            # Python EDA Notebook
├── retail_sales_analysis.sql         # MySQL queries
├── retail_sales_analysis.xlsx        # Excel analysis
├── retail_sales_dashboard.pbix       # Power BI dashboard
├── shopease_dashboard.png            # Dashboard screenshot
├── project1_retail_sales_summary.docx      # Full written report
└── README.md                         # This file
```

---

## 📊 Dataset

| Attribute | Detail |
|-----------|--------|
| **File** | retail_sales.csv |
| **Rows** | 80,000 |
| **Columns** | 17 |
| **Period** | January 2021 – December 2023 |
| **Source** | IDA / 3MTT Bootcamp Capstone |

### Column Dictionary
| Column | Type | Description |
|--------|------|-------------|
| order_id | Text | Unique order identifier |
| customer_id | Text | Unique customer identifier |
| customer_name | Text | Full name of customer |
| customer_email | Text | Customer email address |
| product_name | Text | Name of product purchased |
| category | Text | Product category (8 categories) |
| region | Text | City/region of purchase |
| state | Text | State (mirrors region — see data note below) |
| quantity | Integer | Units purchased per order |
| unit_price | Decimal | Price per unit (₦) |
| discount_rate | Decimal | Discount applied (0–20%) |
| net_revenue | Decimal | Revenue after discount (₦) |
| payment_method | Text | Payment channel (6 methods) |
| order_date | Date | Date of order (YYYY-MM-DD) |
| delivery_days | Integer | Days taken to deliver |
| returned | Text | Whether order was returned (Yes/No) |
| salesperson_id | Text | Assigned salesperson identifier |

> ⚠️ **Data Anomaly:** Although the stated period is 2021–2023, the dataset contains 69 records dated January 1, 2024 (0.09% of data). These were retained and documented rather than deleted. The 2024 entry was excluded from the Power BI Year slicer for dashboard consistency.

> ⚠️ **Data Quality Note:** The `region` and `state` columns both contain city-level values rather than a proper geographic hierarchy. The `region` column was used as the primary geographic dimension consistently across all four tools.

---

## 🛠️ Tools & Techniques Used

The analysis was conducted end-to-end using four industry-standard tools, each applied to a different layer of the analytical workflow:

| Tool | Role in Project |
|------|----------------|
| **Python** | Data cleaning, feature engineering, and exploratory data analysis with 10 visualisations |
| **SQL (MySQL)** | Business query analysis using 11 queries covering aggregations, window functions, and CTEs |
| **Microsoft Excel** | Pivot table analysis, formula-based summaries, conditional formatting, and KPI reporting |
| **Power BI** | Interactive dashboard with DAX measures, Date Table, slicers, and cross-filtering visuals |

**Key techniques applied across the project include:**
- Data cleaning and null value handling
- Date feature extraction (year, month, quarter)
- Gross revenue and discount analysis
- Percentage and ratio calculations (return rate, revenue share)
- Window functions: `RANK()`, `LAG()`, `SUM() OVER()`
- Common Table Expressions (CTEs) for multi-step queries
- Pivot table cross-tabulation (region × category)
- SUMIF, COUNTIF, COUNTIFS, INDEX/MATCH formulas
- DAX measures for KPI cards in Power BI
- Correlation analysis (Pearson r — delivery days vs return rate)
- Conditional formatting to highlight top performers
- Interactive slicers and page-level filters in Power BI

---

## 📈 KPI Summary

| KPI | Value |
|-----|-------|
| **Total Net Revenue** | ₦15.99 Billion |
| **Total Gross Revenue** | ₦17.19 Billion |
| **Total Discounts Given** | ₦1.21 Billion (7% revenue erosion) |
| **Total Orders** | 80,000 |
| **Average Order Value** | ₦199,849 |
| **Overall Return Rate** | 8.06% |
| **Average Delivery Days** | 7.51 days |
| **Unique Customers** | 18,716 |
| **Unique Products** | 64 |
| **Top Region** | Lagos (₦2.07B) |
| **Top Category** | Electronics (48.72% of revenue) |
| **Top Salesperson** | SP-049 (₦351.8M) |
| **Best Month** | March 2023 (₦502.3M · +21.39% MoM) |
| **Worst Month** | February 2021 (₦383.1M · -15.70% MoM) |

---

## 🔍 Key Findings

### 📈 Finding 1 — Electronics Is Nearly Half the Entire Business
Electronics accounts for **48.72% of total net revenue (₦7.79B)** — nearly half the business on its own. The remaining 7 categories share only 51.28%. This extreme concentration creates significant strategic risk: any supply disruption or pricing pressure in Electronics directly threatens overall performance. Electronics also carries the second-highest return rate (8.24%).

### 🏙️ Finding 2 — Regional Revenue Is Remarkably Balanced
Lagos leads all 8 regions at ₦2.07B but the gap to last-placed Benin City (₦1.96B) is only **₦115.6M — just 5.9%** across ₦16B total revenue. This near-uniform distribution confirms strong national multi-city infrastructure. Benin City, Enugu, and Kaduna consistently lag and represent the greatest opportunity for targeted promotional investment.

### 🔄 Finding 3 — Returns Are Systemic, Not Category-Specific
Return rates span only **1.14 percentage points across all 8 categories (7.38%–8.52%)**. This tight clustering confirms the return problem is driven by systemic factors — delivery damage, misleading product descriptions, and quality control gaps — rather than specific categories. Reducing the overall 8.06% rate by just 2pp would recover significant revenue at scale.

### 📅 Finding 4 — February Is a Persistent Revenue Black Hole
February showed the steepest month-over-month revenue decline in **all three consecutive years: -15.70% (2021), -13.82% (2022), -4.57% (2023)**. No other month shows this level of consistent underperformance. March rebounds strongly every year, confirming pent-up demand that could be unlocked earlier with proactive February campaigns.

### 👥 Finding 5 — No Loyal Repeat Customers — Retention Is Critical
SQL analysis confirmed that **no customer placed more than 5 orders across the full 3-year period**. With 18,716 customers averaging only 4.27 orders each, the business is almost entirely dependent on continuous new customer acquisition. Top spenders each placed exactly 1 order — high-value bulk buyers, not recurring loyalists.

---

## 💡 Recommendations

| # | Recommendation | Priority |
|---|---------------|----------|
| 1 | Launch a dedicated February campaign: Valentine's Day promotions, bundle deals, clearance sales | 🔴 High |
| 2 | Implement a customer loyalty programme to convert one-time buyers into repeat customers | 🔴 High |
| 3 | Diversify revenue beyond Electronics into Home & Kitchen and Sports categories | 🟡 Medium |
| 4 | Conduct return root-cause analysis: improve product descriptions, quality control, and size guides | 🟡 Medium |
| 5 | Target Benin City, Enugu & Kaduna with localised marketing and logistics investment | 🟡 Medium |
| 6 | Optimise discount strategy: apply discounts selectively to slow-moving SKUs only | 🟢 Low |

---

## 🖼️ Dashboard Preview
See Project1_Retail_Sales_Dashboard.pdf for the full Power BI dashboard featuring:

4 KPI Cards (Total Revenue, Total Orders, AOV, Return Rate)
Bar Chart: Revenue by Region
Donut Chart: Revenue by Category
Line Chart: Monthly Revenue Trend 2021–2023
Matrix: Region × Category Revenue Breakdown
Slicers: Year, Region, Category, Payment Method

---

### 👤 Author
Raji Raliat Oladuuni  
###Connect with me

* 👔 **LinkedIn:** [Oladunn Raji](https://www.://linkedin.com/in/Oladunni-Raji)
* 📧 **Email:** [dunnestherry@gmail.com](dunnestherry@gmail.com)
* 💻 **GitHub:** [OLadunniDataAnalyst](https://github.com/OladunniDataAnalyst)
---
This project was completed as part of the IDA/3MTT Data Analysis Bootcamp Capstone (2026)
