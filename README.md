# SQL E-commerce Analysis (PostgreSQL)

> PostgreSQL analysis of **138,116 orders** across **4 tables** — 35 SQL queries covering aggregations, JOINs, window functions, and advanced analytics (RFM, Cohort, CLV) with actionable business insights.

---

## 📊 Dataset Overview

| Table | Rows | Description |
|-------|------|-------------|
| `orders` | 138,116 | Order-level transactions |
| `order_items` | 397,569 | Line-item detail per order |
| `productcatalog` | 1,175 | Product master data |
| `customers` | 25,000 | Customer master data |

**Period:** January 2021 – December 2025 (5 years)

---

## 🎯 Executive Summary

| KPI | Value |
|-----|-------|
| Total Revenue | **$177,134,263.74** |
| Total Profit | **$76,146,395.76** |
| Profit Margin | **42.99%** |
| Total Orders | **138,116** |
| Total Customers | **24,911** |
| Average Order Value | **$1,282.50** |

---

## 🛠️ Technical Skills Demonstrated

| Category | Techniques |
|----------|-----------|
| **Aggregations** | `GROUP BY`, `HAVING`, `SUM`, `AVG`, `COUNT`, `FILTER` |
| **Joins** | Multi-table chained JOINs (3-4 tables), self-joins |
| **CTEs** | Multi-level `WITH` clauses for readability |
| **Window Functions** | `LAG`, `RANK`, `ROW_NUMBER`, `NTILE`, running totals |
| **Subqueries** | Correlated subqueries for category-level comparisons |
| **Date Functions** | `EXTRACT`, `TO_CHAR`, `DATE_TRUNC`, `INTERVAL` |
| **Advanced Analytics** | RFM Segmentation, Cohort Retention, CLV, Market Basket |

---

## 📈 Key Business Insights

### 1️⃣ Overall Business Health
- **Revenue:** $177.13M | **Profit:** $76.15M | **Margin:** 42.99%
- Business is highly profitable at scale with a healthy e-commerce margin.
- **Action:** Maintain profitability while scaling; target 45%+ margin via cost optimization.

### 2️⃣ Order Status Distribution
- Completed: **82.22%** | Returned: **6.85%** | Cancelled: **6.08%** | Pending: **4.85%**
- 82% completion rate indicates healthy operations; 13% combined return+cancel is improvable.
- **Action:** Investigate top return reasons; tighten cancellation funnel.

### 3️⃣ Top Customers by Revenue
- #1: **John Smith — $124,395.88** | #10: **Robert Smith — $66,170.37**
- Top 10 customers contribute ~$832K combined.
- **Action:** Launch VIP loyalty program for top spenders.

### 4️⃣ Segment-Wise Average Order Value
- Business: **$1,289.13** | Consumer: **$1,285.12** | VIP: **$1,282.74** | Premium: **$1,274.10**
- AOV is nearly identical across all segments (~$1,280).
- **Action:** Re-evaluate segmentation criteria — current segments have no behavioral difference.

### 5️⃣ Monthly Revenue Trend (2021–2025)
- **Peak:** November–December every year ($4.2M–$4.9M)
- **Lowest:** February every year ($1.9M–$2.1M)
- Strong, repeatable seasonality pattern.
- **Action:** Pre-position inventory and campaigns before October; boost February promotions.

### 6️⃣ Year-over-Year Revenue Growth
- 2022: **-1.11%** | 2023: **+0.57%** | 2024: **-0.17%** | 2025: **-1.06%**
- Revenue is flat-to-declining YoY with no growth momentum.
- **Action:** Urgent growth strategy — new markets, category expansion, or retention focus.

### 7️⃣ RFM Segmentation
- Significant **Champions (555)** cohort with $10K–$25K spend each.
- Long tail of **At Risk** and **Lost** customers.
- **Action:** Reward champions; run win-back campaigns for at-risk cohorts.

### 8️⃣ Customer Churn Analysis
- **13,247 customers churned** (6+ months inactive)
- **$83.3M revenue at risk** (47% of total)
- **Action:** Churn prediction model + automated win-back campaigns.

### 9️⃣ Warehouse Performance Scorecard
- **Top performers:** WH-003, WH-019 (score: 15/20)
- **Bottom performer:** WH-012 (score: 6/20)
- Performance variance across revenue, margin, speed, and return rate.
- **Action:** Share top-performer playbooks; audit bottom-tier warehouses.

### 🔟 Customer Lifetime Value
- **Top CLV:** $30,268 (CUST-012869)
- 600+ customers are one-time buyers (lifespan ≈ 0)
- **Action:** Focus on 2nd purchase activation; design onboarding + follow-up sequences.

---

## 📁 Repository Structure
## 👤 Author

**Saklain Alam**

- **Name:** Saklain Alam
- **GitHub:** [@saklain23](https://github.com/saklain23)
- **LinkedIn:** [saklain-alam-0342ab408](https://www.linkedin.com/in/saklain-alam-0342ab408)

---
