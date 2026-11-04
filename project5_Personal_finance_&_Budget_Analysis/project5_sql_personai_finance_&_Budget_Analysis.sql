-- Project 5: Personal Finance & Budget Analysis Tool
-- IDA/3MTT Data Analysis Bootcamp — Capstone Project
-- Part B — SQL Queries (All 11 Queries)
-- Database: personal_finance_db

CREATE DATABASE IF NOT EXISTS personal_finance_db;
USE personal_finance_db;

-- Query 1: Create and populate the transactions table
DROP TABLE IF EXISTS transactions;

CREATE TABLE transactions (
    transaction_id      VARCHAR(20),        -- Unique transaction identifier e.g. TXN-500000
    user_id             VARCHAR(20),        -- Unique user identifier e.g. USR-500752
    transaction_date    DATE,               -- Date of transaction (YYYY-MM-DD)
    month               VARCHAR(15),        -- Month name e.g. January
    year                INT,                -- Year of transaction
    transaction_type    VARCHAR(10),        -- Income or Expense
    category            VARCHAR(30),        -- Spending or income category
    amount_ngn          DECIMAL(15, 2),     -- Transaction amount in Naira
    description         TEXT,               -- Short transaction description
    payment_method      VARCHAR(20),        -- Payment method used
    bank                VARCHAR(30),        -- Bank or fintech platform
    savings_goal_met    VARCHAR(5),         -- Yes / No / N/A (nullable)
    budget_category     VARCHAR(30),        -- Budget classification
    notes               VARCHAR(50)         -- Optional notes (nullable)
);
-- Verify import
SELECT COUNT(*) AS total_rows FROM transactions;
SELECT * FROM transactions LIMIT 5;
DELETE FROM transactions WHERE year = 2024;
SELECT COUNT(*) FROM transactions;
-- Query 2: Total income vs total expense per user (net position)
SELECT
    user_id,
    ROUND(SUM(CASE WHEN transaction_type = 'Income'  THEN amount_ngn ELSE 0 END), 2) AS total_income,
    ROUND(SUM(CASE WHEN transaction_type = 'Expense' THEN amount_ngn ELSE 0 END), 2) AS total_expense,
    ROUND(
        SUM(CASE WHEN transaction_type = 'Income'  THEN amount_ngn ELSE 0 END) -
        SUM(CASE WHEN transaction_type = 'Expense' THEN amount_ngn ELSE 0 END), 2
    ) AS net_position,
    CASE
        WHEN SUM(CASE WHEN transaction_type = 'Income' THEN amount_ngn ELSE 0 END) -
             SUM(CASE WHEN transaction_type = 'Expense' THEN amount_ngn ELSE 0 END) >= 0
        THEN 'Surplus'
        ELSE 'Deficit'
    END AS financial_status
FROM transactions
GROUP BY user_id
ORDER BY net_position DESC;

-- Query 3: Average monthly spending by category

SELECT
    category,
    COUNT(*)                                                    AS total_transactions,
    ROUND(SUM(amount_ngn), 2)                                  AS total_spent,
    ROUND(AVG(amount_ngn), 2)                                  AS avg_per_transaction,
    ROUND(SUM(amount_ngn) / COUNT(DISTINCT DATE_FORMAT(transaction_date, '%Y-%m')), 2) AS avg_monthly_spend
FROM transactions
WHERE transaction_type = 'Expense'
GROUP BY category
ORDER BY avg_monthly_spend DESC;

-- Query 4: Users with a savings rate above 20%
--          savings rate = (income - expenses) / income
SELECT
    user_id,
    ROUND(SUM(CASE WHEN transaction_type = 'Income'  THEN amount_ngn ELSE 0 END), 2) AS total_income,
    ROUND(SUM(CASE WHEN transaction_type = 'Expense' THEN amount_ngn ELSE 0 END), 2) AS total_expense,
    ROUND(
        (SUM(CASE WHEN transaction_type = 'Income'  THEN amount_ngn ELSE 0 END) -
         SUM(CASE WHEN transaction_type = 'Expense' THEN amount_ngn ELSE 0 END)) /
         NULLIF(SUM(CASE WHEN transaction_type = 'Income' THEN amount_ngn ELSE 0 END), 0) * 100, 2
    ) AS savings_rate_pct
FROM transactions
GROUP BY user_id
HAVING savings_rate_pct > 20
ORDER BY savings_rate_pct DESC;

-- Query 5: Top spending category per month — using window function

SELECT VERSION();
USE personal_finance_db;
SHOW TABLES;
DESCRIBE transactions;

SELECT
    yr_month,
    category AS top_spending_category,
    total_spent
FROM (
    SELECT
        yr_month,
        category,
        total_spent,
        RANK() OVER (PARTITION BY yr_month ORDER BY total_spent DESC) AS spending_rank
    FROM (
        SELECT
            LEFT(transaction_date, 7) AS yr_month,
            category,
            ROUND(SUM(amount_ngn), 2) AS total_spent
        FROM transactions
        WHERE transaction_type = 'Expense'
        GROUP BY LEFT(transaction_date, 7), category
    ) AS monthly_category
) AS ranked
WHERE spending_rank = 1
ORDER BY yr_month;

-- Query 6: Bank popularity — transaction count and volume by bank
SELECT
    bank,
    COUNT(*)                            AS transaction_count,
    ROUND(SUM(amount_ngn), 2)          AS total_volume_ngn,
    ROUND(AVG(amount_ngn), 2)          AS avg_transaction_value,
    ROUND(SUM(amount_ngn) / 1000000, 2) AS total_volume_millions,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM transactions), 2) AS pct_of_total_transactions
FROM transactions
GROUP BY bank
ORDER BY transaction_count DESC;

-- Query 7: Monthly net savings trend (all users combined)

SELECT
    DATE_FORMAT(transaction_date, '%Y-%m')                                          AS yr_month,
    ROUND(SUM(CASE WHEN transaction_type = 'Income'  THEN amount_ngn ELSE 0 END), 2) AS total_income,
    ROUND(SUM(CASE WHEN transaction_type = 'Expense' THEN amount_ngn ELSE 0 END), 2) AS total_expense,
    ROUND(
        SUM(CASE WHEN transaction_type = 'Income'  THEN amount_ngn ELSE 0 END) -
        SUM(CASE WHEN transaction_type = 'Expense' THEN amount_ngn ELSE 0 END), 2
    ) AS net_savings,
    CASE
        WHEN SUM(CASE WHEN transaction_type = 'Income'  THEN amount_ngn ELSE 0 END) -
             SUM(CASE WHEN transaction_type = 'Expense' THEN amount_ngn ELSE 0 END) >= 0
        THEN 'Surplus'
        ELSE 'Deficit'
    END AS monthly_status
FROM transactions
GROUP BY yr_month
ORDER BY yr_month;

-- Query 8: Users who have never saved
--          (no record with category = 'Savings')
SELECT
    user_id,
    COUNT(*)                   AS total_transactions,
    ROUND(SUM(amount_ngn), 2) AS total_spent
FROM transactions
WHERE user_id NOT IN (
    SELECT DISTINCT user_id
    FROM transactions
    WHERE category = 'Savings'
)
GROUP BY user_id
ORDER BY total_spent DESC;

-- Query 9: Cumulative spending per user using SUM() OVER
SELECT
    user_id,
    transaction_date,
    category,
    amount_ngn,
    ROUND(
        SUM(amount_ngn) OVER (
            PARTITION BY user_id
            ORDER BY transaction_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ), 2
    ) AS cumulative_spending
FROM transactions
WHERE transaction_type = 'Expense'
ORDER BY user_id, transaction_date
LIMIT 100;
-- NOTE: LIMIT 100 is used for display purposes only.
-- Remove LIMIT to get full results for all users.

-- Query 10: Month with highest average expense per user
WITH monthly_user_expense AS (
    -- Step 1: Total expense per user per month
    SELECT
        DATE_FORMAT(transaction_date, '%Y-%m') AS yr_month,
        user_id,
        SUM(amount_ngn) AS monthly_expense
    FROM transactions
    WHERE transaction_type = 'Expense'
    GROUP BY yr_month, user_id
),
monthly_avg AS (
    -- Step 2: Average across all users per month
    SELECT
        yr_month,
        ROUND(AVG(monthly_expense), 2) AS avg_expense_per_user
    FROM monthly_user_expense
    GROUP BY yr_month
)
-- Step 3: Return all months sorted by highest average
SELECT
    yr_month,
    avg_expense_per_user,
    RANK() OVER (ORDER BY avg_expense_per_user DESC) AS expense_rank
FROM monthly_avg
ORDER BY avg_expense_per_user DESC;

-- Query 11: CTE — Identify users in the top 10% of spenders
WITH user_total_expense AS (
    -- Step 1: Total spending per user
    SELECT
        user_id,
        ROUND(SUM(amount_ngn), 2) AS total_spent
    FROM transactions
    WHERE transaction_type = 'Expense'
    GROUP BY user_id
),
decile_ranked AS (
    -- Step 2: Assign deciles using NTILE(10)
    SELECT
        user_id,
        total_spent,
        NTILE(10) OVER (ORDER BY total_spent DESC) AS spending_decile
    FROM user_total_expense
)
-- Step 3: Return only top 10% (decile = 1)
SELECT
    user_id,
    total_spent,
    spending_decile,
    ROUND(total_spent / 1000000, 2) AS total_spent_millions
FROM decile_ranked
WHERE spending_decile = 1
ORDER BY total_spent DESC;
 
   