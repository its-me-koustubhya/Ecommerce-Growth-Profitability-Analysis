# End-to-End Ecommerce Growth & Profitability Analysis | Azure Lakehouse BI Project

## Project Overview

This project analyzes a multi-year ecommerce dataset (470K+ sessions, 32K+ orders) to identify revenue drivers, conversion performance, retention impact, SKU-level profitability, and strategic growth opportunities.

The analysis was implemented using an **Azure Lakehouse architecture (Bronze–Silver–Gold)** with Azure Synapse Serverless SQL and dimensional modeling techniques.

The objective was to diagnose short-term profit levers and long-term scalable growth strategies using structured business intelligence analysis.

---

## Business Objective

To answer:

- What is driving revenue growth?
- Is growth traffic-driven or conversion-driven?
- Are repeat customers strengthening the business?
- Which products truly drive profit?
- How much profit leakage occurs due to refunds?
- What is the financial impact of improving retention or reducing refunds?

---

## Architecture Overview

### 🔹 Bronze Layer

Raw CSV data stored in Azure Data Lake Storage.

### 🔹 Silver Layer

Data cleaned and standardized using CETAS:

- Proper datatype casting
- Structured Parquet storage
- Schema consistency

### 🔹 Gold Layer

Dimensional model created for business analysis:

**Fact Tables**

- `gold_fact_orders`
- `gold_fact_sessions`
- `gold_fact_order_items`
- `gold_fact_refunds`

**Dimension Tables**

- `gold_dim_products`

This structure enabled scalable and reusable business analysis.

---

## 📊 Key Analytical Findings

### 1️⃣ Revenue Growth Drivers

- Revenue increased consistently from 2012–2015.
- Growth driven by:
  - Traffic expansion
  - Conversion rate improvement (~3% → ~8%)
  - AOV increase (~$50 → ~$63)
- Strong Q4 seasonality (holiday impact).

### 2️⃣ Conversion & Device Performance

- Desktop conversion significantly outperformed mobile.
- Mobile underperformance indicates a potential UX optimization opportunity.
- Conversion improvement over time indicates improving product-market fit and brand strength.

### 3️⃣ Retention Impact

- Repeat customers convert ~1.2 percentage points higher than new customers.
- Repeat revenue share increased over time.
- Growth is gradually shifting from acquisition-driven to loyalty-supported.

### 4️⃣ SKU-Level Profitability

- Strong margins (55–67% across major SKUs).
- Profit concentrated in _"The Original Mr. Fuzzy"_.
- _"Hudson River Mini Bear"_ identified as highest-efficiency SKU:
  - Highest margin
  - Lowest refund rate
  - Stable across traffic sources

### 5️⃣ Refund Leakage Analysis

- Refund rates ranged between 1%–6%.
- Refund issues were SKU-driven, not device-driven.
- Some search traffic showed elevated refund rates for emotional-purchase SKUs.

---

## 📈 Business Simulations

### 🔹 Scenario 1: 1% Refund Rate Reduction

> **Estimated incremental profit impact: ~$10K**

### 🔹 Scenario 2: 5% Increase in Repeat Share

> **Estimated incremental profit impact: ~$10.7K**

Retention-driven growth provides scalable long-term value.

---

## 🧠 Strategic Recommendations

1. Scale traffic selectively on high-margin, low-refund SKUs.
2. Improve operational quality for refund-heavy products.
3. Strengthen loyalty initiatives to increase repeat share.
4. Investigate mobile UX friction before aggressively scaling mobile traffic.

---

## 🛠 Tech Stack

| Tool / Technology              | Role                                            |
| ------------------------------ | ----------------------------------------------- |
| Azure Data Lake Storage        | Bronze / Silver / Gold storage layers           |
| Azure Synapse Analytics        | Serverless SQL engine                           |
| CETAS                          | Data transformation and external table creation |
| Dimensional Modeling           | Fact & dimension table design                   |
| T-SQL                          | Query and analysis language                     |
| Scenario-Based Profit Modeling | Financial impact simulations                    |
