# Superstore Sales Analysis (2015-2018)

An end-to-end data analysis of a US retail store's sales: data cleaning and exploration in Python, business questions answered with SQL, and an interactive two-page Power BI dashboard.

**Tools:** Python (pandas, matplotlib), SQL (SQLite), Power BI, Google Colab

---

## Problem statement

A sales manager wants to understand how the business is performing and where to act. This project answers:

1. Which months have the highest and lowest sales, and is the pattern consistent every year?
2. Which categories, sub-categories and products drive the most sales?
3. In which states does Technology lead?
4. Which category do customers buy again and again?
5. Does the product category affect shipping time?
6. How has the business grown year over year, and which regions drive it?
7. Who are the best customers, and which customers are at risk of being lost?

## Dataset

- **Source:** Superstore Sales Dataset (Kaggle, by Rohit Sahoo)
- **Size:** 9,800 order lines, 18 columns, 793 customers, 4,922 orders, 2015 to 2018
- **Total sales:** about 2.26 million

**Limitations:** the dataset has no Profit, Discount, Quantity or delivery-date columns. So the analysis covers sales, orders and time to ship, not profitability or delivery time.

## Project structure

```
Superstore_project/
├── data/
│   ├── raw/          original dataset (untouched)
│   └── cleaned/      cleaned data and RFM segments
├── notebooks/        Python cleaning and EDA notebook
├── sql/              superstore_queries.sql (8 queries)
├── dashboard/        Power BI file and screenshots
└── README.md
```

## Approach

### 1. Data cleaning (Python)

| Issue | Action | Reason |
|---|---|---|
| 0 duplicate rows | None needed | Checked with `duplicated()` |
| 11 missing Postal Codes, all in Burlington, Vermont | Filled with 05401 | Dropping rows would remove real sales; all were one city |
| Postal Code stored as a number | Converted to 5-digit text | ZIP codes are labels, and leading zeros must be kept |
| Dates stored as text (day-month-year) | Converted to datetime with an explicit format | Verified no day/month swap and no order shipped before it was placed |
| 1,849 product names vs 1,861 product IDs | Checked duplicates stay in one category; grouped by Product Name | Avoids splitting a product's sales |

New columns: `Order Year`, `Order Month`, `Month Name`, `Shipping Days`.

### 2. Exploratory analysis (Python)

Sales trends, category and product rankings, regional and state analysis, repeat-buying and shipping analysis, and **RFM customer segmentation** (Recency, Frequency, Monetary scored in quartiles).

### 3. SQL analysis

Eight queries in `sql/superstore_queries.sql`, including a year-over-year growth query with `LAG()` and a top-3-products-per-category query with `ROW_NUMBER()` and a subquery. SQL results were checked against the pandas results and matched exactly.

### 4. Power BI dashboard

- **Page 1, Executive Overview:** KPI cards, monthly sales trend, sales by category and region, slicers for Year, Region and Category
- **Page 2, Deep Dive:** top 10 products, customers and states; customers by RFM segment; average shipping days by ship mode

![Executive Overview](dashboard/page1_overview.png)
![Deep Dive](dashboard/page2_deepdive.png)

---

## Key findings and recommendations

### 1. Sales are strongly seasonal
- **Evidence:** September, November and December were the top 3 months in every year. November is the highest month overall (350,162) and February the lowest (59,371), a gap of nearly 6x. January or February was the lowest month each year.
- **Recommendation:** plan stock, staffing and marketing budget around September to December.

### 2. The business grew about 50% from 2015 to 2018, with a dip in 2016
- **Evidence:** sales were 479,856 (2015), 459,436 (2016, -4.3%), 600,193 (2017, +30.6%) and 722,052 (2018, +20.3%). Growth is still strong but slowing.
- **Recommendation:** keep investing in growth, and watch whether the slowing rate continues.

### 3. The 2016 dip came mainly from the South region
- **Evidence:** South fell from 103,375 to 70,076 (about -32%) while East grew about 20%. Central was the only region to decline in 2018. West (710,220) and East (669,519) bring about 61% of sales.
- **Recommendation:** investigate what happened in the South in 2016 and why Central slowed in 2018.

### 4. Technology earns the most; Office Supplies is bought most often
- **Evidence:** Technology is 36.6% of sales (Furniture 32.2%, Office Supplies 31.2%). Phones and Chairs are the top sub-categories. Office Supplies has the most orders (3,676), and 95.6% of its buyers ordered it in 2 or more separate orders, versus 64.6% for Technology.
- **Recommendation:** use Office Supplies (bundles, reorder reminders) to keep customers returning, and use Technology promotions to raise spend per order.

### 5. Revenue is not dependent on a few customers or products
- **Evidence:** the top customer is about 1% of sales and the top 10% of customers bring 30.9%. California and New York together are about a third of sales. One product, the Canon imageCLASS 2200 Copier (61,600), stands out.
- **Recommendation:** protect California and New York, and check that large states like Texas and Florida are not under-served.

### 6. Shipping time depends on ship mode, not category
- **Evidence:** average days are 0.04 (Same Day), 2.18 (First Class), 3.25 (Second Class) and 5.01 (Standard Class). Categories differ by less than 0.1 day within each mode. Standard Class is 59.8% of order lines.
- **Recommendation:** to speed up delivery, focus on Standard Class processing.

### 7. A quarter of customers have gone quiet
- **Evidence:** RFM segmentation of 793 customers gave Champions 201, Loyal 212, Potential 183, At Risk 140 and Lost 57. Champions average 9 orders and about 4,700 in spend, compared with 3 orders and about 479 for Lost customers. At Risk and Lost customers (197) last ordered 256 to 489 days ago on average.
- **Recommendation:** reward Champions, cross-sell Technology to Loyal customers, nudge Potential customers toward bigger baskets, and run a win-back offer for At Risk customers before the September to December peak.

### Technology by state
Among the 28 states with 30 or more orders, Technology leads in 14, Furniture in 7 and Office Supplies in 7. Smaller states were excluded because one or two purchases could decide their leading category.

---

## Limitations and next steps

- Add Profit and Discount data to find out which sales are actually profitable.
- Investigate the cause of the 2016 South dip with additional data (stock, staffing, key accounts).
- RFM segment thresholds are an analyst choice, not a standard. Testing other cutoffs would check how stable the segments are.
- Delivery date is not available, so only time to ship was measured.

## How to run

1. Open `notebooks/` in Google Colab or Jupyter and upload `data/raw/superstore_sales.csv`.
2. Run the notebook to reproduce the cleaning and analysis.
3. Run the queries in `sql/superstore_queries.sql` against a table named `sales` (the cleaned data with lowercase, underscore column names).
4. Open the Power BI file in `dashboard/` with Power BI Desktop (Windows).

## Author

**Poonam Rout** | https://www.linkedin.com/in/poonam-rout-0a743831a/ | Poonamrout7786@gmail.com
