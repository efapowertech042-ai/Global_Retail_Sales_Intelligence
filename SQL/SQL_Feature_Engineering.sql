-- Use ds_sales_performance database --
USE ds_sales_performance;

-- Calculate Revenue --
SELECT
    s.ORDER_DATE,
    s.PRODUCTKEY,
    s.STOREKEY,
    s.QUANTITY,
    p.UNIT_PRICE_USD,
    (s.QUANTITY * p.UNIT_PRICE_USD) AS REVENUE_USD
FROM sales_clean s
LEFT JOIN products_clean p
    ON s.PRODUCTKEY = p.PRODUCTKEY;
    

-- Drop monthly_sales table if exists --
DROP TABLE IF EXISTS monthly_sales;

-- create monthly_sales table --
CREATE TABLE monthly_sales (
    YEAR_AND_MONTH VARCHAR(7),  -- 'YYYY-MM'
    PRODUCTKEY INT,
    STOREKEY INT,
    TOTAL_UNITS_SOLD INT,
    REVENUE_USD DECIMAL(12,2),
    PRIMARY KEY (YEAR_AND_MONTH, PRODUCTKEY, STOREKEY)
);

-- Time-Based Aggregation --
INSERT INTO monthly_sales (YEAR_AND_MONTH, PRODUCTKEY, STOREKEY, TOTAL_UNITS_SOLD, REVENUE_USD)
SELECT
	date_format(s.ORDER_DATE, '%Y-%m') AS YEAR_AND_MONTH,
    s.PRODUCTKEY,
    s.STOREKEY,
    SUM(s.QUANTITY) AS TOTAL_UNITS_SOLD,
    SUM(s.QUANTITY * p.UNIT_PRICE_USD) AS REVENUE_USD
FROM sales_clean s
LEFT JOIN products_clean p
ON s.PRODUCTKEY = p.PRODUCTKEY
GROUP BY YEAR_AND_MONTH, s.PRODUCTKEY, s.STOREKEY;

-- feature engineering for time-series prediction --
SELECT
    YEAR_AND_MONTH,
    PRODUCTKEY,
    STOREKEY,
    TOTAL_UNITS_SOLD,
    REVENUE_LAST_MONTH,
    REVENUE_3_LAST_MONTH,
    MONTH(YEAR_MONTH_DATE)    AS MONTH,
    QUARTER(YEAR_MONTH_DATE)  AS QUARTER,
    REVENUE_USD AS TARGET_REVENUE_USD
FROM (
    SELECT
        ms.*,
        STR_TO_DATE(CONCAT(YEAR_AND_MONTH, '-01'), '%Y-%m-%d') AS YEAR_MONTH_DATE,

        LAG(REVENUE_USD, 1) OVER (
            PARTITION BY PRODUCTKEY, STOREKEY
            ORDER BY STR_TO_DATE(CONCAT(YEAR_AND_MONTH, '-01'), '%Y-%m-%d')
        ) AS REVENUE_LAST_MONTH,

        LAG(REVENUE_USD, 3) OVER (
            PARTITION BY PRODUCTKEY, STOREKEY
            ORDER BY STR_TO_DATE(CONCAT(YEAR_AND_MONTH, '-01'), '%Y-%m-%d')
        ) AS REVENUE_3_LAST_MONTH

    FROM monthly_sales ms
) t
WHERE REVENUE_LAST_MONTH IS NOT NULL
  AND REVENUE_3_LAST_MONTH IS NOT NULL
ORDER BY
    YEAR_MONTH_DATE,
    PRODUCTKEY,
    STOREKEY;


























































































































































































































































