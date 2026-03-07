# 🏦 Bank Credit Card Customer Analysis

## 📁 Project Overview

This project analyzes a bank's credit card customer dataset using **Python** for data cleaning, **MySQL** for querying, and **Power BI** for visualization. The goal is to uncover customer behavior patterns, churn drivers, and demographic insights.

---

## 📂 Files in This Project

| File | Description |
|------|-------------|
| `Churn_Modelling.csv` | Original raw dataset from Kaggle |
| `bankcrcard.ipynb` | Python notebook used for data cleaning |
| `bank_crcard_fixed.csv` | Cleaned dataset ready for MySQL & Power BI |
| `bank_churn.sql` | All SQL queries for analysis |
| `churn_analysis.pbix` | Power BI dashboard file |
| `churn_analysis.pdf` | Exported PDF of the Power BI dashboard |

---

## 🗄️ Dataset

- **Source:** [Kaggle – Churn Modelling Dataset](https://www.kaggle.com/)
- **Rows:** 10,000 customers
- **Columns:** 14

### Column Reference

| Column | Type | Description |
|--------|------|-------------|
| `rownumber` | INT | Row identifier |
| `customerid` | INT | Unique customer ID |
| `surname` | TEXT | Customer last name |
| `creditscore` | INT | Credit score (350–850) |
| `geography` | TEXT | Country: France, Spain, Germany |
| `gender` | TEXT | Male / Female |
| `age` | INT | Customer age |
| `tenure` | INT | Years with the bank (0–10) |
| `balance` | FLOAT | Account balance |
| `numofproducts` | INT | Number of bank products held (1–4) |
| `hascrcard` | TEXT | Has credit card: Yes / No |
| `isactivemember` | TEXT | Active member: Yes / No |
| `estimatedsalary` | FLOAT | Estimated annual salary |
| `exited` | TEXT | Churned: Yes / No |

---

## 🐍 Data Cleaning (Python Notebook)

The raw Kaggle file `Churn_Modelling.csv` had column names in PascalCase and binary values (0/1) in the `HasCrCard`, `IsActiveMember`, and `Exited` columns. I cleaned it using `bankcrcard.ipynb` before importing into MySQL.

### Steps Performed

**Step 1 — Load the raw dataset**
```python
import pandas as pd
df = pd.read_csv("Churn_Modelling.csv")
df.head()
```

**Step 2 — Check column names**
```python
df.columns
# Index(['RowNumber', 'CustomerId', 'Surname', 'CreditScore', 'Geography',
#        'Gender', 'Age', 'Tenure', 'Balance', 'NumOfProducts', 'HasCrCard',
#        'IsActiveMember', 'EstimatedSalary', 'Exited'])
```

**Step 3 — Lowercase all column names**
```python
df.columns = df.columns.str.lower()
```

**Step 4 — Convert 0/1 to Yes/No for readable columns**
```python
maps = ['hascrcard', 'isactivemember', 'exited']

for col in maps:
    df[col] = df[col].map({1: 'Yes', 0: 'No'})
```

**Step 5 — Export cleaned CSV**
```python
df.to_csv("bank_crcard_fixed.csv", index=False, encoding="utf-8")
```

### Before vs After

| Column | Before | After |
|--------|--------|-------|
| Column names | `HasCrCard`, `IsActiveMember` | `hascrcard`, `isactivemember` |
| HasCrCard values | `1`, `0` | `Yes`, `No` |
| IsActiveMember values | `1`, `0` | `Yes`, `No` |
| Exited values | `1`, `0` | `Yes`, `No` |

---

## 🛢️ MySQL Setup

```sql
-- Create the table
CREATE TABLE bank_crcard (
    rownumber       INT,
    customerid      INT,
    surname         VARCHAR(100),
    creditscore     INT,
    geography       VARCHAR(50),
    gender          VARCHAR(10),
    age             INT,
    tenure          INT,
    balance         FLOAT,
    numofproducts   INT,
    hascrcard       VARCHAR(5),
    isactivemember  VARCHAR(5),
    estimatedsalary FLOAT,
    exited          VARCHAR(5)
);

-- Import the cleaned CSV
LOAD DATA INFILE '/path/to/bank_crcard_fixed.csv'
INTO TABLE bank_crcard
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

---

## 📊 SQL Queries Summary

| # | Query | Purpose |
|---|-------|---------|
| Q1 | Total Customers | Overall count |
| Q2 | Credit Card Holders | Has/no credit card % |
| Q3 | Exited Customers | Churn count & % |
| Q4 | Active vs Inactive | Member activity split |
| Q5 | Customers by Geography | Country-wise count |
| Q6 | Above-Avg Credit Score | High credit score customers |
| Q7 | Avg Balance/Score/Salary by Geography | Regional financials |
| Q8 | Exited by Gender | Gender-wise churn |
| Q9 | Customers by No. of Products | Product distribution |
| Q10 | Age Group Distribution | Age segment breakdown |
| Q11 | Zero Balance Customers | Inactive balance holders |
| Q12 | Top 10 by Balance | Highest value customers |
| Q13 | Churn Rate by Geography | Regional churn % |
| Q14 | Churn Rate by No. of Products | Product-wise churn |
| Q15 | Avg Tenure & Balance (Exited vs Retained) | Retention comparison |
| Q16 | Credit Score Buckets & Churn | Score range vs churn rate |

---

## 📈 Power BI Dashboard

The dashboard is split across **2 pages**:

**Page 1 — Customer Overview**
- KPI Cards: Total Customers (10K), Churned (2K), Churn Rate (20.37%), Active Members (5K)
- Churn vs Retained donut chart
- Customers by Country bar chart
- Churn by Gender stacked bar

**Page 2 — Churn Deep Dive**
- Avg Balance over Tenure line chart
- Credit Card Holders pie chart
- Active vs Inactive Churn stacked bar
- KPI Cards: Avg Credit Score (649.12), Avg Balance (98.55K), Avg Tenure Churned (4.91), Avg Tenure Retained (5.00)
- Number of Products slicer

> 📄 See `churn_analysis.pdf` for a full exported preview of the dashboard.

---

## 🔍 Key Insights

- **20.37%** of customers churned
- **France** has the most customers (5K) but **Germany** has a higher churn rate
- **Females** churn more than males despite fewer total customers
- **Inactive members** are significantly more likely to exit
- Avg tenure is almost identical for churned (4.91) vs retained (5.00) — tenure alone doesn't predict churn

---

## 🛠️ Tools Used

| Tool | Purpose |
|------|---------|
| Python (pandas) | Data cleaning & CSV export |
| Jupyter Notebook | Running the cleaning script |
| MySQL Workbench | Data querying & analysis |
| Power BI Desktop | Dashboard & visualizations |
