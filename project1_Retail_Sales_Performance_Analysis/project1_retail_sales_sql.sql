-- Project 1 — RETAIL SALES PERFORMANCE ANALYSIS
-- SHOPEASE NIGERIA | SQL BUSINESS QUERIES
-- DATASET: retail_sales.csv | 80,000 ROWS | PERIOD: 2021–2023
-- Capstone: IDA/3MTT DATA ANALYSIS

-- QUERY 1 — CREATE TABLE & IMPORT DATASET
DROP TABLE IF EXISTS retail_sales;

-- Create the retail_sales table 
CREATE TABLE retail_sales (
    order_id        TEXT,
    customer_id     TEXT,
    customer_name   TEXT,
    customer_email  TEXT,
    product_name    TEXT,
    category        TEXT,
    region          TEXT,
    state           TEXT,
    quantity        INTEGER,
    unit_price      REAL,
    discount_rate   REAL,
    net_revenue     REAL,
    payment_method  TEXT,
    order_date      TEXT,       
    delivery_days   INTEGER,
    returned        TEXT,      
    salesperson_id  TEXT
);
SELECT COUNT(*) FROM retail_db.retail_sales;
USE retail_db;
SELECT * FROM retail_sales LIMIT 5;

-- QUERY 2 — TOTAL REVENUE BY REGION
SELECT
    region,
    ROUND(SUM(net_revenue), 2)  AS total_revenue,
    COUNT(*)                    AS total_orders,
    ROUND(AVG(net_revenue), 2)  AS avg_order_value
FROM   retail_sales
GROUP  BY region
ORDER  BY total_revenue DESC;
-- SUMMARY: Lagos leads with ₦2.07B, followed by Ibadan and Port Harcourt.
-- Revenue is evenly spread across all 8 regions within a ₦115M range,
-- confirming strong national coverage with no region significantly left behind.

-- QUERY 3 — TOP 5 CUSTOMERS BY TOTAL SPENDING
SELECT
    customer_id,
    customer_name,
    ROUND(SUM(net_revenue), 2)  AS total_spending,
    COUNT(*)                    AS total_orders,
    ROUND(AVG(net_revenue), 2)  AS avg_order_value
FROM   retail_sales
GROUP  BY customer_id, customer_name
ORDER  BY total_spending DESC
LIMIT  5;
-- SUMMARY: Top 5 customers each spent between ₦2.4M and ₦2.5M, all concentrated
-- in Electronics, suggesting a high-value bulk-purchase segment. These customers
-- warrant dedicated loyalty programmes or account management to retain their business.

-- QUERY 4 — MONTHLY REVENUE TREND
SELECT
    YEAR(order_date)            AS year,
    MONTH(order_date)           AS month,
    ROUND(SUM(net_revenue), 2)  AS total_revenue,
    COUNT(*)                    AS total_orders,
    ROUND(AVG(net_revenue), 2)  AS avg_order_value
FROM   retail_sales
GROUP  BY year, month
ORDER  BY year, month;
-- SUMMARY: Revenue ranged from ₦383M (Feb 2021) to ₦502M (Mar 2023).
-- February consistently underperforms every year while August and March
-- show the strongest rebounds. January 2024 contains only 1 day of data.

-- QUERY 5 — RETURN RATE BY CATEGORY
SELECT
    category,
    COUNT(*)                                                        AS total_orders,
    SUM(CASE WHEN returned = 'Yes' THEN 1 ELSE 0 END)              AS returned_orders,
    ROUND(
        SUM(CASE WHEN returned = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
    2)                                                              AS return_rate_pct
FROM   retail_sales
GROUP  BY category
ORDER  BY return_rate_pct DESC;
-- SUMMARY: Clothing has the highest return rate at 8.52% while Home & Kitchen
-- is the lowest at 7.38%. The narrow 1.14pp spread across all 8 categories
-- suggests returns are driven by systemic factors, not category-specific issues.

-- QUERY 6 — AVERAGE DELIVERY DAYS BY PAYMENT METHOD
SELECT
    payment_method,
    ROUND(AVG(delivery_days), 2)  AS avg_delivery_days,
    MIN(delivery_days)            AS min_delivery_days,
    MAX(delivery_days)            AS max_delivery_days,
    COUNT(*)                      AS total_orders
FROM   retail_sales
GROUP  BY payment_method
ORDER  BY avg_delivery_days ASC;
-- SUMMARY: Delivery days are remarkably uniform across all 6 payment methods,
-- ranging from 7.49 to 7.57 days. Payment channel has no meaningful impact
-- on delivery speed. Transfer is marginally slower due to payment confirmation delays.

-- QUERY 7 — REVENUE CONTRIBUTION BY CATEGORY
SELECT
    category,
    ROUND(SUM(net_revenue), 2)                                           AS total_revenue,
    ROUND(
        SUM(net_revenue) * 100.0 / SUM(SUM(net_revenue)) OVER (),
    2)                                                                   AS revenue_pct,
    COUNT(*)                                                             AS total_orders,
    ROUND(AVG(net_revenue), 2)                                           AS avg_order_value
FROM   retail_sales
GROUP  BY category
ORDER  BY total_revenue DESC;
-- SUMMARY: Electronics dominates at 48.72% of total revenue (₦7.79B), nearly
-- half the entire business. Home & Kitchen (14.54%) and Sports (11.81%) are
-- distant second and third. Food & Beverage (2.90%) and Books (3.46%) are smallest.

-- QUERY 8 — CUSTOMERS WITH MORE THAN 5 ORDERS
SELECT
    customer_id,
    customer_name,
    COUNT(*)                    AS order_count,
    ROUND(SUM(net_revenue), 2)  AS total_spending,
    ROUND(AVG(net_revenue), 2)  AS avg_order_value,
    MIN(order_date)             AS first_order_date,
    MAX(order_date)             AS last_order_date
FROM   retail_sales
GROUP  BY customer_id, customer_name
HAVING COUNT(*) > 5
ORDER  BY order_count DESC;
-- SUMMARY: No customer placed more than 5 orders across the full 3-year period.
-- With 80,000 orders across 18,716 unique customers averaging only 4.3 orders each,
-- this confirms high churn and a critical need for loyalty and retention programmes.


SELECT
    customer_id,
    customer_name,
    COUNT(*) AS order_count
FROM retail_sales
GROUP BY customer_id, customer_name
ORDER BY order_count DESC
LIMIT 5;

-- QUERY 9 — MONTH-OVER-MONTH REVENUE GROWTH (LAG)
WITH monthly_revenue AS (
    SELECT
        YEAR(order_date)            AS year,
        MONTH(order_date)           AS month,
        ROUND(SUM(net_revenue), 2)  AS total_revenue
    FROM   retail_sales
    GROUP  BY year, month
)
SELECT
    year,
    month,
    total_revenue,
    LAG(total_revenue)  OVER (ORDER BY year, month)       AS prev_month_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY year, month))
        * 100.0
        / LAG(total_revenue) OVER (ORDER BY year, month),
    2)                                                     AS mom_growth_pct
FROM   monthly_revenue
ORDER  BY year, month;
-- SUMMARY: Strongest MoM growth was +21.39% (Mar 2023), steepest decline was
-- -15.70% (Feb 2021). February underperforms consistently every year making it
-- the most predictable seasonal pattern. January 2024 shows NULL as expected.

-- QUERY 10 — PRODUCTS WITH ABOVE-AVERAGE REVENUE PER UNIT
WITH product_stats AS (
    SELECT
        product_name,
        category,
        ROUND(SUM(net_revenue), 2)                      AS total_revenue,
        SUM(quantity)                                    AS total_units_sold,
        ROUND(SUM(net_revenue) / SUM(quantity), 2)       AS revenue_per_unit
    FROM   retail_sales
    GROUP  BY product_name, category
),
dataset_avg AS (
    SELECT ROUND(AVG(revenue_per_unit), 2) AS avg_rev_per_unit
    FROM   product_stats
)
SELECT
    p.product_name,
    p.category,
    p.total_revenue,
    p.total_units_sold,
    p.revenue_per_unit,
    a.avg_rev_per_unit,
    ROUND(p.revenue_per_unit - a.avg_rev_per_unit, 2)  AS above_avg_by
FROM   product_stats  p
CROSS  JOIN dataset_avg a
WHERE  p.revenue_per_unit > a.avg_rev_per_unit
ORDER  BY p.revenue_per_unit DESC;
-- SUMMARY: 22 products exceed the dataset average of ₦19,057 revenue per unit.
-- All 8 Electronics products lead at ₦73,000–₦75,000 per unit, joined by premium
-- Home & Kitchen items like Refrigerator, Microwave and Blender.

-- QUERY 11 — RANK SALESPERSONS BY TOTAL REVENUE
SELECT
    salesperson_id,
    ROUND(SUM(net_revenue), 2)                             AS total_revenue,
    COUNT(*)                                               AS total_orders,
    ROUND(AVG(net_revenue), 2)                             AS avg_order_value,
    SUM(CASE WHEN returned = 'Yes' THEN 1 ELSE 0 END)      AS orders_returned,
    ROUND(
        SUM(CASE WHEN returned = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
    2)                                                     AS personal_return_rate_pct,
    RANK()  OVER (ORDER BY SUM(net_revenue) DESC)          AS revenue_rank
FROM   retail_sales
GROUP  BY salesperson_id
ORDER  BY revenue_rank;
-- SUMMARY: SP-049 is the top performer at ₦351.8M, followed by SP-019 (₦351.4M)
-- and SP-035 (₦344.9M). The gap between rank 1 and rank 10 is only ~₦20M,
-- suggesting a highly competitive and evenly matched sales team of 50 salespersons.







