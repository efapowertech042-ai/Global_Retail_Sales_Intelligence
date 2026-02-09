-- Use ds_sales_performance database --
USE ds_sales_performance;

-- Drop monthly_sales table if exists --
DROP TABLE IF EXISTS store_monthly_revenue;

-- Monthly Store Revenue (Ground Truth) --
CREATE TABLE store_monthly_revenue AS
SELECT
    s.STOREKEY,
    DATE_FORMAT(s.ORDER_DATE, '%Y-%m-01') AS MONTH_DATE,
    SUM(s.QUANTITY * p.UNIT_PRICE_USD) AS MONTHLY_REVENUE
FROM sales_clean s
LEFT JOIN products_clean p
    ON s.PRODUCTKEY = p.PRODUCTKEY
GROUP BY
    s.STOREKEY,
    MONTH_DATE;
    
-- Lag & Growth Features (Window Functions) --
CREATE TABLE store_features AS
SELECT
    STOREKEY,
    MONTH_DATE,
    MONTHLY_REVENUE,
    LAG(MONTHLY_REVENUE) OVER (
        PARTITION BY STOREKEY
        ORDER BY MONTH_DATE
    ) AS PREV_MONTH_REVENUE,

    (monthly_revenue - LAG(MONTHLY_REVENUE) OVER (
        PARTITION BY STOREKEY
        ORDER BY MONTH_DATE
    )) / NULLIF(
        LAG(MONTHLY_REVENUE) OVER (
            PARTITION BY STOREKEY
            ORDER BY MONTH_DATE
        ), 0
    ) AS MOM_GROWTH
FROM store_monthly_revenue;

-- Add Rolling Averages (Stability Indicator) --
CREATE TABLE store_features_enriched AS
SELECT
    *,
    AVG(MONTHLY_REVENUE) OVER (
        PARTITION BY STOREKEY
        ORDER BY MONTH_DATE
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS ROLLING_3M_REVENUE
FROM store_features;

-- Rank revenue per month --
CREATE TABLE store_ranked AS
SELECT
    *,
    NTILE(4) OVER (
        PARTITION BY MONTH_DATE
        ORDER BY MONTHLY_REVENUE
    ) AS REVENUE_QUARTILE
FROM store_monthly_revenue;

-- Operational Risk Label (Binary)--
CREATE TABLE store_labeled AS
SELECT
    *,
    CASE
        WHEN REVENUE_QUARTILE = 1 THEN 'RISK'
        ELSE 'NON_RISK'
    END AS STORE_RISK_LABEL
FROM store_ranked;

-- Assign performance labels --
CREATE TABLE store_labeled_2 AS
SELECT
    *,
    CASE
        WHEN REVENUE_QUARTILE = 4 THEN 'HIGH_PERFORMANCE'
        ELSE 'LOW_PERFORMANCE'
    END AS STORE_PERFORMANCE_LABEL
FROM store_ranked;