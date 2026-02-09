# Revenue Forecasting Model

## Problem Statement

As the business expands across products and stores, forecasting future revenue becomes critical for planning inventory, cash flow, and operational priorities. Manual forecasting based on historical averages fails to capture seasonality, product-specific behavior, and revenue momentum.

Revenue dynamics are influenced by:
- Product characteristics
- Store-level demand patterns
- Seasonal effects
- Historical sales momentum

### Business Question
How can we **predict monthly revenue per product and store** in a consistent, explainable way while identifying products that structurally drive higher revenue?

---

## Methodology

### 1. Data Preparation
Data was sourced from multiple relational tables including:
- Sales transactions
- Product pricing (UNIT_PRICE_USD)
- Store metadata
- Customer information
- Exchange rates

All revenue values were normalized to USD to ensure consistency across markets.

Monthly aggregation was performed to align the data with business planning cycles.

---

### 2. SQL Feature Engineering (Core DS Value)
SQL was used to construct a modeling-ready dataset at the **product–store–month** level.

Key engineered features include:
- Monthly revenue per product per store
- Total units sold per month
- Lagged revenue features (1-month and 3-month lags)
- Time-based features (month and quarter)

These features allow the model to capture:
- Revenue momentum from historical performance
- Seasonal revenue patterns
- Structural differences between products

---

### 3. Machine Learning Modeling
- **Model type:** Linear Regression
- **Target variable:** Monthly revenue (USD)
- **Features:** Product identity, store identity, seasonality, and lagged revenue
- **Preprocessing:** One-hot encoding of categorical variables using a pipeline

The modeling approach prioritizes:
- Interpretability over black-box accuracy
- Stable revenue forecasting
- Clear business explanations

---

### 4. Model Evaluation
The model was evaluated using:
- R² (explained variance)
- Mean Absolute Error (MAE)
- Actual vs Predicted revenue visualization
- Residual diagnostics

Evaluation focused on understanding **where the model performs well** and **where uncertainty increases**, rather than optimizing a single metric.

---

## Insights Summary

### Model Performance Overview
- **R² ≈ 0.59** — the model explains ~59% of monthly revenue variance
- **MAE ≈ $458** — average monthly prediction error

The model performs strongly for low-to-mid revenue ranges, with higher variance observed for high-revenue months.

---

### Product-Level Insights
Product coefficients represent the **average relative monthly revenue uplift** of each product compared to a baseline product, after controlling for:
- Store effects
- Seasonality
- Historical revenue trends

Key observations:
- Certain products consistently generate higher revenue than others
- These effects are structural, not driven by short-term fluctuations
- Coefficients reflect revenue impact, not profitability

---

### Residual Analysis Findings
- Residuals are centered around zero, indicating minimal systematic bias
- Error variance increases at higher revenue levels (heteroscedasticity)
- High-revenue months are inherently more volatile and harder to predict

This behavior is expected in real-world revenue forecasting scenarios.

---

## Business Recommendations

### 1. Product Prioritization
- Focus inventory, marketing, and visibility on products with strong positive revenue effects
- Use product coefficients to guide strategic attention, not as profit indicators

---

### 2. Revenue Planning Strategy
- Use model predictions for monthly forecasting and operational planning
- Apply scenario-based planning or buffers for high-revenue products

---

### 3. Decision Support, Not Automation
- Treat predictions as decision-support signals
- Combine forecasts with domain knowledge and operational constraints

---

### 4. Risk Awareness
- Avoid overconfidence in point estimates for extreme revenue cases
- Monitor prediction errors for high-impact products regularly

---

## Limitations
- Profit and margin are not modeled (no cost data)
- External drivers such as promotions or market shocks are not explicitly included
- New products without historical data cannot be forecast reliably

---

## Future Enhancements
- Incorporate cost data to forecast profit instead of revenue
- Add confidence intervals around predictions
- Compare against non-linear models (e.g., tree-based methods)
- Deploy an interactive forecasting dashboard

---

## Strategic Value
This revenue forecasting framework provides an **interpretable, scalable, and business-aligned** approach to predicting monthly revenue while identifying products that consistently drive performance. It bridges SQL-based feature engineering with machine learning insights to support data-driven business decision-making.

