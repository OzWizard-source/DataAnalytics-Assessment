# Data Analytics SQL Assessment

This repository contains SQL scripts for solving a set of analytical business questions using SQL. Each file corresponds to a specific question (Q1–Q4) and includes queries for extracting and analyzing customer and transaction data.

---

## ✅ Q1: Customer Summary View

**Objective:**  
Provide a summary of customers with active savings and investment plans, showing total deposit value.

**Approach:**  
- Joined `users_customer`, `savings_savingsaccount`, and `plans_plan`.
- Filtered out deleted plans and inactive users.
- Calculated total confirmed savings and investment plan counts per customer.

**Challenge:**  
Ensuring duplicates were removed and aggregations grouped correctly.

---

## ✅ Q2: Transaction Frequency Analysis

**Objective:**  
Categorize customers based on their monthly transaction frequency.

**Approach:**  
- Counted transactions per user per month.
- Calculated average monthly frequency.
- Used CASE WHEN logic to classify users into "High", "Medium", or "Low" frequency.

**Challenge:**  
`DATE_TRUNC()` is not supported in MySQL, so I used `YEAR()` and `MONTH()` instead to group by month.

---

## ✅ Q3: Account Inactivity Alert

**Objective:**  
Identify accounts with no inflow in over a year.

**Approach:**  
- Queried both savings and investment accounts.
- Used `MAX(transaction_date)` per account to identify last activity.
- Calculated inactivity period using `DATEDIFF()`.

**Challenge:**  
Aligning the schema for savings vs investment transactions and excluding deleted plans.

---

## ✅ Q4: Customer Lifetime Value (CLV)

**Objective:**  
Estimate CLV using transaction volume and tenure.

**Approach:**  
- Calculated tenure in months using `TIMESTAMPDIFF()`.
- Aggregated confirmed amounts and estimated CLV using the provided formula.
- Used `ROUND()` for formatting.

**Challenge:**  
Handling division by zero when tenure is 0, solved using `NULLIF()`.

---

## 📂 Repository Structure

