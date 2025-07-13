# ☕ Coffee Shop Sales Dashboard – SQL & Power BI

This project analyzes coffee shop sales transactions to identify revenue patterns, peak hours, top-performing products, and category contribution. SQL was used for data transformation and analysis, while Power BI was used to build a fully interactive dashboard.

---

## 📊 Business Objectives

- Understand **monthly revenue trends**
- Identify **best-selling products** and **highest-earning categories**
- Analyze **sales by time of day** to find peak hours
- Evaluate **product-level performance** within each category
- Track **monthly growth** and **daily revenue movement**

---

## 🛠 Tools Used

- **SQL (MySQL)** – for data cleaning, wrangling, aggregations  
- **Power BI** – for dashboard visualization  
- **Excel (CSV)** – for source file management

---

## 📁 Dataset Structure

Main table: `transactions`  
Columns:
- `transaction_id`, `transaction_date`, `transaction_time`
- `transaction_qty`, `unit_price`
- `store_id`, `store_location`
- `product_id`, `product_category`, `product_type`, `product_detail`

---

## 🧹 Data Cleaning & Preparation

- Converted `transaction_date` from text to date format using `STR_TO_DATE`
- Created revenue field using: `transaction_qty * unit_price`
- Created time-based intervals: `07:00–10:00`, `11:00–14:00`, etc.
- Calculated daily and monthly revenue
- Calculated revenue share by product category
- Removed duplicates and anomalies from timestamp data

---

## 📈 Key Insights

### 1. 💵 Revenue Trend
- Highest monthly revenue observed in **March and May**
- Positive growth month-to-month until Q3

### 2. ☕ Product Performance
- **Latte**, **Dark Chocolate**, and **Chai** contributed most to total revenue
- Product detail `"Dark chocolate Lg"` was the top-selling item (Rp 4,428K)

### 3. ⏰ Peak Hours
- **18:00 – 21:00** and **15:00 – 17:00** were the busiest time slots
- Strong correlation between late-evening transactions and higher revenue

### 4. 🏪 Store Revenue Share
- Hell's Kitchen: **34.29%**  
- Astoria: **33.20%**  
- Lower Manhattan: **32.52%**

---

## 📊 Dashboard Preview

![dashboard](![Coffeeshop Dashboard_page-0001](https://github.com/user-attachments/assets/8db623bf-79a6-4490-aebd-751f6bb9040f)
)
