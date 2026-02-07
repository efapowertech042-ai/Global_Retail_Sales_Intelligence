-- Use ds_sales_performance database --
USE ds_sales_performance;

-- Drop monthly_sales table if exists --
DROP TABLE IF EXISTS store_monthly_revenue;

-- Monthly Store Revenue --
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
SELECT
    *,
    AVG(MONTHLY_REVENUE) OVER (
        PARTITION BY STOREKEY
        ORDER BY MONTH_DATE
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS ROLLING_3M_REVENUE
FROM store_features;