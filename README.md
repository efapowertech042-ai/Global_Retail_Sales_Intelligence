# Business Operations Revenue Forecasting Project

## 📌 Project Overview

This project applies **data science and machine learning** to analyze and predict monthly revenue across products and stores using historical sales data. The goal is not only to build a predictive model, but also to extract **interpretable business insights** that support better decision-making around product prioritization, inventory planning, and revenue forecasting.

The project demonstrates an end-to-end workflow combining **SQL feature engineering**, **Python modeling**, **model diagnostics**, and **business interpretation**.

---

## 🎯 Business Problem

> *Can we predict future monthly revenue per product and store, and identify which products consistently drive higher revenue?*

Key questions addressed:

* Which products structurally generate higher revenue than others?
* How reliable are monthly revenue predictions across different revenue ranges?
* How can these predictions support planning and prioritization decisions?

---

## 🧾 Datasets Used

The analysis is based on five datasets:

* **Sales** – transactional sales records
* **Products** – product metadata
* **Stores** – store information
* **Customers** – customer-level data
* **Exchange Rates** – currency normalization

All datasets are cleaned, joined, and aggregated into a **monthly product–store revenue table** used for modeling.

---

## 🛠️ Feature Engineering (SQL)

Feature engineering is performed in SQL to prepare a modeling-ready dataset.

Key engineered features include:

* Monthly revenue per product per store
* Total units sold per month
* Lagged revenue features (1-month and 3-month lags)
* Time-based features (month and quarter)

These features capture:

* **Revenue momentum** (past performance)
* **Seasonality** (month / quarter effects)
* **Product identity effects** (structural differences between products)

---

## 🤖 Modeling Approach

* **Model type:** Linear Regression (with regularization-ready pipeline)
* **Target variable:** Monthly revenue (USD)
* **Features:** Product, store, time features, and lagged revenue
* **Preprocessing:** One-hot encoding for categorical variables using a pipeline

This modeling choice prioritizes:

* Interpretability
* Stability
* Business explainability

---

## 📊 Model Performance Summary On Store Pefprmance
| Metric | HIGH_PERFORMANCE | LOW_PERFORMANCE |
|------|------------------|-----------------|
| Precision | 0.88 | 0.77 |
| Recall | 0.51 | 0.96 |
| Accuracy | **80%** | |


## 🔍 Key Takeaway
The model is **precision-focused**, ensuring that when a store is classified as HIGH_PERFORMANCE, the prediction is highly reliable.

---

## 🚀 Next Steps
- Threshold tuning to balance precision vs recall
- Feature expansion (seasonality, product mix)
- Deployment for real-time monitoring

---

## 📊 Model Performance

### Actual vs Predicted Revenue

* **R²:** ~0.59 (explains ~59% of revenue variance)
* **MAE:** ~$458 average monthly prediction error

The model performs well for low-to-mid revenue ranges, with increased uncertainty at higher revenue levels—an expected pattern in sales data.

---

## 🔍 Residual Analysis

Residual diagnostics show:

* Errors centered around zero (no strong systematic bias)
* Increasing variance at higher revenue levels (heteroscedasticity)

This confirms:

* Stable predictions for most product–store combinations
* Higher uncertainty for extreme revenue months

---

## 📈 Model Interpretability (Product Effects)

Product-level coefficients represent the **average relative monthly revenue uplift** of each product compared to a baseline product, after controlling for:

* Store effects
* Seasonality
* Historical revenue trends

These coefficients:

* Do **not** represent total or average revenue
* Do **not** represent profitability
* **Do** identify structurally strong revenue-driving products

---

## 💡 Business Insights

Key insights from the model:

* Certain products consistently outperform others in revenue contribution
* Revenue forecasts are reliable for operational planning at scale
* High-revenue products require scenario-based forecasting rather than point estimates

### Recommended Actions:

* Prioritize high-impact products for inventory and visibility
* Use predictions for monthly planning and revenue forecasting
* Apply buffers when planning for top-revenue products

---

## ⚠️ Limitations

* Profitability is not modeled (no cost or margin data)
* New products with no history cannot be forecast reliably
* External drivers (promotions, market shocks) are not explicitly modeled

---

## 🚀 Next Steps

Potential extensions of this work:

* Add cost data to model profit instead of revenue
* Introduce confidence intervals for predictions
* Build a Streamlit dashboard for interactive forecasting
* Explore non-linear models (e.g., tree-based) for comparison

---

## 🧠 Key Takeaway

This project demonstrates how **interpretable machine learning**, combined with thoughtful feature engineering and diagnostics, can deliver actionable insights for real-world business decision-making—beyond just predictive accuracy.
