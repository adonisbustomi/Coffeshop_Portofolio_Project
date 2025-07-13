# SQL_Coffeshop_Portofolio_Project
This SQL code serves as both a learning resource and a personal portfolio to demonstrate my growing skills in data analysis and business intelligence.
# 📊 Marketing Performance Analytics – SQL + Power BI

This project analyzes customer engagement and conversion across various product campaigns. Using SQL for data wrangling and Power BI for visualization, it identifies key trends in marketing effectiveness.

---

## 🔍 Business Questions

- Are we converting views into purchases efficiently?
- Which content types (Video, Social Media, Blog) drive the highest engagement?
- What products have the highest/lowest conversion rates?
- Is marketing effort translating into better customer sentiment?

---

## 🧰 Tools Used

- **SQL (MySQL):** Data cleaning, deduplication, transformation, exploration  
- **Power BI:** Dashboard visualization (conversion, rating, engagement)  
- **Excel (for CSV management)**

---

## 📁 Database Schema

Tables used:
- `customers`, `products`, `customer_reviews`, `customer_journey`, `engagement_data`

📌 *See `marketing.sql` for all cleaning & exploration queries.*

---

## 🧹 Data Preparation Highlights

- Removed duplicate rows using `ROW_NUMBER() OVER (...)`
- Standardized `ContentType` values (`'video' → 'Video'`, `'socialmedia' → 'Social Media'`)
- Split combined column `ViewsClicksCombined` into separate `views` and `clicks`
- Merged customer data with `geography` into a single `customers2` table

---

## 📈 Key Insights

### 1. 📉 Engagement naik, tapi conversion turun
Despite high visibility (9M+ views), **average conversion rate is only 9.57%**, with a **noticeable drop in Q3**.

### 2. 📱 Content performance
- **Social Media** and **Video** contribute 80%+ of engagement
- Blog posts generate steady interest but lower click rates

### 3. 🛍 Product with highest conversion
- `Hockey Stick` and `Ski Boots` reach **>14% conversion**
- `Swim Goggles` and `Yoga Mat` perform below average

### 4. ⭐ Customer sentiment
- Average rating across all products: **3.69**
- Highest-rated: **Climbing Rope (3.91)**  
- Lowest-rated: **Golf Clubs (3.48)**

### 5. 🧪 Specific Query Insight
> Customers who gave low ratings (<3) still made **multiple purchases**, indicating room for **product improvement** despite existing loyalty.

---

## 📊 Dashboard Preview

![dashboard](visuals/conversion_rate_by_product.png)  
🔗 [See Live Dashboard (Power BI)](https://your-powerbi-link-here)

---

## 📂 Folder Structure

