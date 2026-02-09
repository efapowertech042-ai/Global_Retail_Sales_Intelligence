# Store Performance Classification

## Problem Statement

As the business scales across multiple stores, it becomes increasingly difficult to
objectively assess store performance using manual analysis alone.

Revenue patterns vary by:
- Store size
- Product mix
- Seasonality
- Market conditions

Relying on raw revenue figures can lead to biased or inconsistent decisions.

### Business Question
How can we **consistently and objectively classify store performance** using historical revenue data to support operational and strategic decisions?

---

## Methodology

### 1. Data Preparation
Data was sourced from multiple relational tables including:
- Sales transactions
- Product pricing (UNIT_PRICE_USD)
- Store metadata
- Exchange rates

All revenue values were standardized to USD for consistency.

---

### 2. SQL Feature Engineering
SQL was used to perform the following:

- Aggregate monthly revenue per store
- Calculate historical revenue trends
- Rank stores by revenue distribution
- Assign performance labels using quartile-based logic

#### Performance Labeling Logic
- **Top Quartile (Q4)** → HIGH_PERFORMANCE  
- **Bottom Quartile (Q1)** → LOW_PERFORMANCE  

This approach ensures:
- Objective labeling
- Scalability
- Consistency across time periods

---

### 3. Machine Learning Modeling
- Performance labels were encoded using `LabelEncoder`
- Dataset split into training and testing sets
- A supervised classification model was trained to predict store performance
- Evaluation focused on business-relevant metrics rather than accuracy alone

---

### 4. Model Evaluation
Evaluation metrics used:
- Precision
- Recall
- F1-score
- Confusion Matrix

The model was intentionally optimized to **prioritize precision for HIGH_PERFORMANCE predictions**.

---

## Insights Summary

### Model Performance Overview

| Metric | HIGH_PERFORMANCE | LOW_PERFORMANCE |
|------|------------------|-----------------|
| Precision | 0.88 | 0.77 |
| Recall | 0.51 | 0.96 |
| Overall Accuracy | **80%** | |

---

### Key Observations

- When the model predicts **HIGH_PERFORMANCE**, it is correct **88% of the time**
- The model successfully identifies **most low-performing stores**
- Some high-performing stores are intentionally missed to reduce false positives

---

### Business Interpretation

The model is **conservative by design**:
- It avoids incorrectly labeling low-performing stores as high-performing
- It favors decision reliability over aggressive expansion

This trade-off aligns with real-world business priorities where incorrect investment decisions are costly.

---

## Business Recommendations

### 1. High-Confidence Investment Strategy
- Prioritize investment, expansion, and promotions for stores labeled as HIGH_PERFORMANCE
- Use predictions as a **decision-support tool**, not an absolute rule

---

### 2. Early Intervention for Low-Performance Stores
- LOW_PERFORMANCE predictions have high recall (96%)
- Use results to trigger:
  - Operational reviews
  - Inventory optimization
  - Management support

---

### 3. Monitoring & Review Strategy
- Re-evaluate borderline stores on a quarterly basis
- Track performance changes over time rather than single-month snapshots

---

### 4. Future Enhancements
- Tune model thresholds when business goals shift toward aggressive growth
- Incorporate additional features such as:
  - Seasonality indicators
  - Product mix diversity
  - Regional performance benchmarks

---

### Strategic Value
This classification framework provides a **repeatable, scalable, and explainable system** for store performance assessment, enabling data-driven operational decision-making.