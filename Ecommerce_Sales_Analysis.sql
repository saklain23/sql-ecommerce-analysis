-- CREATE DATABASE
CREATE DATABASE NOT IF EXISTS Ecommerce_db;

-- DROP IF EXISTS
DROP TABLE IF EXISTS Orders;

-- CREATE TABLE
CREATE TABLE Orders (
    order_id                  VARCHAR(30) PRIMARY KEY,
    order_date                DATE,
    order_time                TIME,
    order_status              VARCHAR(30),
    sales_channel             VARCHAR(30),
    customer_id               VARCHAR(30),
    customer_name             VARCHAR(50),
    customer_age              INT,
    gender                    VARCHAR(20),
    customer_segment          VARCHAR(30),
    customer_type             VARCHAR(30),
    customer_city             VARCHAR(50),
    customer_state            VARCHAR(50),
    customer_country          VARCHAR(50),
    region                    VARCHAR(30),
    customer_postal_code      INT,
    payment_method            VARCHAR(30),
    payment_status            VARCHAR(50),
    currency                  VARCHAR(10),
    shipping_method           VARCHAR(30),
    warehouse                 VARCHAR(30),
    delivery_days             NUMERIC(10,2),
    estimated_delivery_days   NUMERIC(10,2),
    delivery_status           VARCHAR(30),
    return_status             VARCHAR(50),
    return_reason             VARCHAR(50),
    customer_rating           NUMERIC(10,2),
    review_sentiment          VARCHAR(40),
    customer_review           TEXT,
    marketing_channel         VARCHAR(50),
    campaign_name             VARCHAR(50),
    coupon_code               VARCHAR(20),
    loyalty_points_earned     INT,
    loyalty_points_redeemed   INT,
    quantity                  INT,
    gross_sales               NUMERIC(10,2),
    discount_amount           NUMERIC(10,2),
    tax_amount                NUMERIC(10,2),
    shipping_cost             NUMERIC(10,2),
    net_sales                 NUMERIC(10,2),
    product_cost              NUMERIC(10,2),
    profit                    NUMERIC(10,2),
    profit_margin_percentage  NUMERIC(10,2),
    customer_lifetime_value   NUMERIC(10,2),
    is_repeat_customer        BOOLEAN,
    customer_order_count      INT
);


-- DROP IF EXISTS
DROP TABLE IF EXISTS Order_Items;

-- CREATE TABLE
CREATE TABLE Order_Items (
order_id            VARCHAR(30),
product_id	        VARCHAR(30),
quantity	        NUMERIC(10,2),
unit_price	        NUMERIC(10,2),
discount_percentage	NUMERIC(10,2),
discount_amount 	NUMERIC(10,2),
gross_sales	        NUMERIC(10,2),
tax_amount      	NUMERIC(10,2),
shipping_cost	    NUMERIC(10,2),
net_sales	        NUMERIC(10,2),
product_cost	    NUMERIC(10,2),
profit	            NUMERIC(10,2)
);


-- DROP TABLE EXISTS 
DROP TABLE IF EXISTS ProductCatalog;

-- CREATE TABLE 
CREATE TABLE ProductCatalog (
product_id	        VARCHAR(30) PRIMARY KEY,
product_name	    TEXT,
product_category	VARCHAR(50),
product_subcategory	VARCHAR(50),
brand	            VARCHAR(50),
supplier	        VARCHAR(50),
unit_price	        NUMERIC(10,2),
product_cost	    NUMERIC(10,2),
product_rating	    NUMERIC(10,2)
);

-- DROP TABLE EXISTS
DROP TABLE IF EXISTS Customers;

-- CREATE TABLE
CREATE TABLE Customers (
customer_id	               VARCHAR(30) PRIMARY KEY,
customer_name	           VARCHAR(50),
customer_age	           INT,
gender	                   VARCHAR(15),
customer_segment	       VARCHAR(50),
customer_city	           VARCHAR(50),
customer_state	           VARCHAR(50),
customer_country	       VARCHAR(50),
region	                   VARCHAR(50),
customer_postal_code	   INT,
customer_acquisition_cost  NUMERIC(10,2)
);

COPY orders (order_id,order_date,order_time,order_status,sales_channel,customer_id,customer_name,customer_age,gender,customer_segment,customer_type,customer_city,customer_state,customer_country,region,customer_postal_code,payment_method,payment_status,currency,shipping_method,warehouse,delivery_days,estimated_delivery_days,delivery_status,return_status,return_reason,customer_rating,review_sentiment,customer_review,marketing_channel,campaign_name,coupon_code,loyalty_points_earned,loyalty_points_redeemed,quantity,gross_sales,discount_amount,tax_amount,shipping_cost,net_sales,product_cost,profit,profit_margin_percentage,customer_lifetime_value,is_repeat_customer,customer_order_count)
FROM 'Ecommerce_project\ecommerce_sales_customer_analytics_150k.csv'
DELIMITER ','
CSV HEADER;

COPY order_items (order_id,product_id,quantity,unit_price,discount_percentage,discount_amount,gross_sales,tax_amount,shipping_cost,net_sales,product_cost,profit)
FROM 'Ecommerce_project\order_items.csv'
DELIMITER ','
CSV HEADER;

COPY productcatalog (product_id,product_name,product_category,product_subcategory,brand,supplier,unit_price,product_cost,product_rating)
FROM 'Ecommerce_project\product_catalog.csv'
DELIMITER ','
CSV HEADER;

COPY customers (customer_id,customer_name,customer_age,gender,customer_segment,customer_city,customer_state,customer_country,region,customer_postal_code,customer_acquisition_cost)
FROM 'Ecommerce_project\customer_master.csv'
DELIMITER ','
CSV HEADER;



SELECT 'orders' AS table_name, COUNT(*) FROM orders
UNION ALL
SELECT 'orderitems', COUNT(*) FROM orderitems
UNION ALL
SELECT 'productcatalog', COUNT(*) FROM productcatalog
UNION ALL
SELECT 'customers', COUNT(*) FROM customers;



-- What is the month-over-month revenue growth rate for the last 12 months, and which month had the highest growth?
WITH monthly AS (
    SELECT 
        TO_CHAR(order_date, 'YYYY-MM') AS month,
        SUM(net_sales) AS revenue
    FROM orders
    GROUP BY TO_CHAR(order_date, 'YYYY-MM')
),
growth AS (
    SELECT 
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS prev_revenue,
        ROUND(
            100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
            / NULLIF(LAG(revenue) OVER (ORDER BY month), 0),
            2
        ) AS growth_pct
    FROM monthly
)
SELECT * FROM growth
ORDER BY month DESC
LIMIT 12;

/* Q: MoM Revenue Growth
   • Best: Nov 2025 (+52.85%)
   • Worst: Jan 2025 (-46.11%)
   • Peak revenue: Dec 2025 ($4.56M)
   FINDING: High volatility, Q1 weak, H2 recovery
   ACTION: Plan for Q1, replicate Nov-Dec success */
			 

-- Calculate total revenue, total profit, and overall profit margin percentage.
	 SELECT
	 SUM(net_sales) AS total_revenue,
	 SUM(profit) AS total_profit,
	 ROUND(100.0 * SUM(profit) / SUM(net_sales),2) AS profit_margin_pct
	 FROM orders;
	 
/* Q: Overall Business Health
   • Revenue: $177.13M
   • Profit: $76.15M
   • Margin: 42.99%
   FINDING: Highly profitable, healthy margin
   ACTION: Scale model, target 45%+ margin */

-- Show count of each order_status and its percentage of total orders.
SELECT order_status, 
       COUNT(*) AS total_orders,
	   ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),2) AS percentage
	   FROM orders
	   GROUP BY order_status
	   ORDER BY total_orders DESC;
	   
	  /* Q: Order Status Distribution
   • Completed: 82.22% (113,559)
   • Returned: 6.85% (9,462)
   • Cancelled: 6.08% (8,398)
   • Pending: 4.85% (6,697)
   FINDING: 82% completion rate, 13% return+cancel
   ACTION: Reduce returns (6.85%) and cancellations (6.08%) */ 
   
-- Find top 10 customers by total revenue — show name and total spend.
    SELECT 
    c.customer_name,
    SUM(o.net_sales) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_revenue DESC
LIMIT 10;

/* Q: Top 10 Customers by Revenue
   • Top: John Smith ($124,395.88)
   • 2nd: Michael Smith ($103,818.92)
   • 10th: Robert Smith ($66,170.37)
   FINDING: Top 10 customers = $832K combined, "Smith" surname dominant (4/10)
   ACTION: VIP program for top spenders, focus retention */
   
-- Calculate average order value for each customer_segment.
     WITH segment_avg AS (
 SELECT c.customer_segment,
        ROUND(AVG(net_sales),2) AS avg_segment
		FROM customers c
		JOIN orders o ON c.customer_id = o.customer_id
		GROUP BY c.customer_segment
	 )
	 SELECT *
	 FROM segment_avg
	 ORDER BY avg_segment DESC;
	 
	 /* Q: Average Order Value by Segment
   • Business: $1,289.13
   • Consumer: $1,285.12
   • VIP: $1,282.74
   • Premium: $1,274.10
   FINDING: AOV almost same across all segments (~$1,280)
   ACTION: Segment pricing not working — differentiate or rethink segmentation */

-- Show total revenue per month (month-wise trend).
  WITH monthly_revenue AS (
           SELECT 
		   TO_CHAR(order_date, 'YYYY-MM') AS month,
		   SUM(net_sales) AS revenue
		   FROM orders
		   GROUP BY TO_CHAR(order_date, 'YYYY-MM')
		 
  )
  SELECT *
  FROM monthly_revenue
  ORDER BY month;
  
/* Q: Monthly Revenue Trend (2021-2025)
   • Peak months: Nov-Dec every year ($4.2M-$4.9M)
   • Lowest months: Feb every year ($1.9M-$2.1M)
   • 2021 Dec highest: $4.9M
   • YoY revenue stable ~$30M/year
   FINDING: Strong seasonality — Nov-Dec festive spike, Feb dip
   ACTION: Stock + marketing ready before Oct, boost Feb campaigns */

  -- Find customers who placed more than 5 orders — with order count.
    WITH order_count AS (
	     SELECT c.customer_name, 
	     COUNT(*) AS total_orders
		 FROM orders o
		 JOIN customers c ON c.customer_id = o.customer_id
		 GROUP BY c.customer_name
		 HAVING COUNT(*)>5
  )  
  SELECT *
  FROM order_count;
  
  /* Q: Customers with More Than 5 Orders
   • Hundreds of customers have 6-50 orders
   • Top: Jennifer Smith (50), Michael Jones (48), Lisa Jones (47)
   • Most customers have 6-10 orders
   FINDING: Strong loyal customer base exists
   ACTION: Reward repeat buyers, target one-time buyers to reach 5+ */

-- Find products whose total profit is less than 0 (loss-making).
SELECT 
    MIN(oi.profit) AS min_profit,
    COUNT(*) FILTER (WHERE oi.profit < 0) AS negative_count
FROM productcatalog p
JOIN order_items oi ON p.product_id = oi.product_id;
  
/* Q: Loss-Making Order Items
   • Min profit: -$1,260.28
   • 5,426 order items have negative profit
   FINDING: Individual losses exist but no product is overall loss-making
   ACTION: Investigate high-discount or high-shipping orders */
   
-- Show total revenue per category — only categories with revenue above 1 crore (10,000,000).
  SELECT p.product_category,
  SUM(oi.net_sales) AS total_revenue
  FROM order_items oi
  JOIN productcatalog p ON oi.product_id = p.product_id
  GROUP BY p.product_category
  HAVING SUM(oi.net_sales)>10000000;
  
/* Q: Categories with Revenue > $10M
   • Electronics: $41.15M (highest)
   • Jewelry: $25.56M
   • Home Appliances: $24.84M
   • Automotive: $16.45M
   • Sports & Outdoors: $15.73M
   • Home & Kitchen: $10.97M
   FINDING: Electronics dominates, 6 categories above $10M
   ACTION: Focus marketing on Electronics + Jewelry */
		  
--  Show order count per city — only cities with more than 100 orders.
  SELECT c.customer_city,
         COUNT(o.order_id) AS total
		 FROM orders o 
		 JOIN customers c ON o.customer_id = c.customer_id
		 GROUP BY c.customer_city
		 HAVING COUNT(o.order_id)>100;
		 
		/* Q: Cities with 100+ Orders
   • Lake Michael: 166 orders (highest)
   • South Michael: 163
   • South James: 129
   • Port Michael: 112
   FINDING: "Michael" and "James" cities dominate — likely synthetic data
   ACTION: Investigate city naming, focus on top cities */ 

-- Show average order value per payment_method — only where average is above 1000.
  SELECT payment_method,
       ROUND(AVG(net_sales),2) AS avg_value
	   FROM orders
	   GROUP BY payment_method
	   HAVING AVG(net_sales)>1000;
	   
/* Q: Avg Order Value by Payment Method
   • COD: $1,300.29 (highest)
   • Credit Card: $1,287.74
   • PayPal: $1,283.48
   • Digital Wallet: $1,271.69 (lowest)
   FINDING: AOV almost same across all methods (~$1,280)
   ACTION: No payment-specific pricing needed */
   
-- Show each order with customer name and product name?
 SELECT o.customer_name,
        p.product_name
               FROM orders o
			     JOIN order_items oi ON o.order_id = oi.order_id
				 JOIN productcatalog p ON oi.product_id = p.product_id;
				 
 /* Q: Customers and Products (All Orders)
   • Shows every customer-product combination across all orders
   • Same customer appears multiple times with different products
   • Output is huge (3.9 lakh rows)
   FINDING: Each customer buys multiple products across categories
   ACTION: Use this for cross-sell and recommendation analysis */
   
 -- Find top 10 products by revenue — with product_name.
	SELECT p.product_name,
	       SUM(oi.net_sales) AS revenue
		   FROM productcatalog p
		   JOIN order_items oi ON p.product_id = oi.product_id
		   GROUP BY p.product_name
		   ORDER BY revenue DESC LIMIT 10;

		   /* Q: Top 10 Products by Revenue
   • #1: Xiaomi Gaming Consoles → $956,726
   • #2: OnePlus Gaming Consoles → $946,819
   • #10: HP Cameras → $853,770
   FINDING: Top 10 products are very close (~$850K-$956K), no clear winner
   ACTION: Gaming Consoles category strong — focus marketing there */
		   
 -- Show total profit per category — category-wise performance.
    SELECT p.product_category,
	       SUM(oi.profit) AS total
		   FROM order_items oi
		   JOIN productcatalog p ON oi.product_id = p.product_id
		   GROUP BY p.product_category;
		  
-- Show each customer's total spend + their segment + city.
   SELECT 
	c.customer_id,
	c.customer_segment,
	c.customer_city,
	SUM(o.net_sales) AS total_spent
	FROM customers c
	JOIN orders o ON c.customer_id = o.customer_id
	GROUP BY c.customer_id, c.customer_segment, c.customer_city;
		  
-- Show orders with product details — only orders where profit is above 500.
   SELECT p.product_id, p.product_name, oi.profit
   FROM productcatalog p
   JOIN order_items oi ON p.product_id = oi.product_id
   WHERE oi.profit >500;
   
 -- Show year-wise revenue — 2021, 2022, 2023, 2024 separately.      
		SELECT 
      EXTRACT(YEAR FROM order_date) AS years,
	  SUM(net_sales) AS reveue
	  FROM orders
	  GROUP BY years
	  ORDER BY years;  
	  
-- Show total sales per quarter (Q1, Q2, Q3, Q4).
SELECT 
      EXTRACT(QUARTER FROM order_date) AS quarter,
	  SUM(net_sales) AS total_sales
	  FROM orders
	  GROUP BY quarter
	  ORDER BY quarter;
	  
-- Show order count per day — top 10 busiest days.	
 SELECT order_date,
  COUNT(*) AS total_order
  FROM orders
  GROUP BY order_date
  ORDER BY total_order DESC LIMIT 10;
 

-- Show weekday-wise sales — which day has the most business.

  WITH weekday AS (
       SELECT EXTRACT(DOW FROM order_date) AS dow,
	   TO_CHAR(order_date, 'day') AS weekday_name,
	   SUM(net_sales) AS total_sales
	   FROM orders
       GROUP BY EXTRACT(DOW FROM order_date),
	   TO_CHAR(order_date, 'day') 
  )
  SELECT*
  FROM weekday
  ORDER BY total_sales DESC;

-- Find customers whose total spend is above the overall average.
     WITH customer_total AS (
          SELECT c.customer_name,
		         c.customer_id,
				 SUM(o.net_sales) AS total_spend
				 FROM orders o
				 JOIN customers c ON o.customer_id = c.customer_id
				 GROUP BY c.customer_name, c.customer_id
	    )
        SELECT * FROM customer_total
		WHERE total_spend > (SELECT AVG(total_spend) 
		FROM customer_total)
		ORDER BY total_spend DESC;

-- Find products whose profit is above the average profit of their category.
         WITH product_profits AS (
              SELECT p.product_id,
			         p.product_name,
			         p.product_category,
					 SUM(oi.profit) AS total_profit
					 FROM order_items oi
					 JOIN productcatalog p ON oi.product_id = p.product_id
					 GROUP BY p.product_id, p.product_name, p.product_category
		)
		SELECT * FROM product_profits cc
		WHERE total_profit > (SELECT AVG(total_profit) FROM product_profits
		WHERE product_category = cc.product_category);
		
/* Q: Products Above Category Average Profit
   • Identifies products outperforming their category average
   • Helps spot hidden winners within each category
   FINDING: Multiple products exceed category profit average
   ACTION: Promote high-performing products, investigate underperformers */
   
 -- Find orders whose net_sales is above the overall average.  
  WITH find_orders AS (
        SELECT order_id,
		       net_sales
		        FROM orders
  )
  SELECT * FROM find_orders
  WHERE net_sales > (SELECT AVG(net_sales) FROM find_orders);
					 
 -- Find the top 1 customer (highest spend) in each segment.
  WITH ranked AS (
    SELECT
        c.customer_name,
        c.customer_segment,
        SUM(o.net_sales) AS total_spend,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_segment 
            ORDER BY SUM(o.net_sales) DESC
        ) AS rn
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_name, c.customer_segment
)
SELECT * FROM ranked
WHERE rn = 1;


/* Q: Top 1 Customer per Segment
   • Business: Brian Johnson ($45,223.60)
   • Consumer: John Smith ($96,607.14)
   • Premium: Michael Smith ($48,658.75)
   • VIP: James Smith ($30,942.76)
   FINDING: Consumer top spender > VIP top spender (odd)
   ACTION: Review VIP classification criteria */

-- Find categories whose return rate is above the overall return rate.
 WITH category_returns AS (
    SELECT 
        p.product_category,
        COUNT(*) AS total,
        COUNT(CASE WHEN o.return_status = 'Returned' THEN 1 END) AS total_returns,
        ROUND(100.0 * COUNT(CASE WHEN o.return_status = 'Returned' THEN 1 END) 
        / COUNT(*), 2) AS return_rate         
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN productcatalog p ON oi.product_id = p.product_id
    GROUP BY p.product_category
)
SELECT * FROM category_returns
WHERE return_rate > (                       
    SELECT 
        ROUND(100.0 * COUNT(CASE WHEN return_status = 'Returned' THEN 1 END) 
        / COUNT(*), 2)
    FROM orders
);

/* Q: Categories Above Overall Return Rate
   • Overall return rate: 6.85%
   • Automotive: 7.23% (highest)
   • All 7 categories above 6.85%
   • Electronics, Health, Home, Jewelry: ~6.98%
   FINDING: Automotive has highest return rate — investigate
   ACTION: Improve Automotive product quality/descriptions */
  
-- Perform RFM analysis — give each customer a Recency, Frequency, Monetary score.
WITH rfm_base AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        MAX(o.order_date) AS last_order_date,
        CURRENT_DATE - MAX(o.order_date) AS recency_days,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(o.net_sales) AS monetary
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
),
rfm_scores AS (
    SELECT 
        customer_id,
        customer_name,
        recency_days,
        frequency,
        monetary,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM rfm_base
)
SELECT 
    customer_id,
    customer_name,
    recency_days,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    CONCAT(r_score, f_score, m_score) AS rfm_score
FROM rfm_scores
ORDER BY rfm_score DESC;

/* Q: RFM Analysis
   • Champions (555): High recency, frequency, monetary
   • Top customers: Jennifer Andrews, Sarah Moody, Christina Turner
   • Many customers with 555 score = $10K-$25K spend
   • Loyal segment (554): Slightly lower monetary
   FINDING: Strong champions segment exists (hundreds of 555s)
   ACTION: Reward champions, upsell 554 → 555, reactivate lower scores */
		
-- Perform cohort analysis — retention of customers per month.			 
WITH first_order AS (
    SELECT 
        customer_id,
        TO_CHAR(MIN(order_date), 'YYYY-MM') AS cohort_month
    FROM orders
    GROUP BY customer_id
),
cohort_data AS (
    SELECT 
        f.cohort_month,
        TO_CHAR(o.order_date, 'YYYY-MM') AS order_month,
        o.customer_id
    FROM orders o
    JOIN first_order f ON o.customer_id = f.customer_id
)
SELECT 
    cohort_month,
    order_month,
    COUNT(DISTINCT customer_id) AS customers
FROM cohort_data
GROUP BY cohort_month, order_month
ORDER BY cohort_month, order_month;

  /* Q: Cohort Retention Analysis
   • Each cohort's month-0 count is highest
   • Retention drops sharply after month 0 (e.g., 1824 → 114)
   • Long-term retention stabilizes at ~100-250 customers
   FINDING: Most customers don't repeat purchase after first order
   ACTION: Focus on 2nd purchase — onboarding + follow-up campaigns */
   
-- Calculate running total of revenue by date (cumulative sum).
WITH daily AS (
    SELECT order_date, SUM(net_sales) AS revenue
    FROM orders
    GROUP BY order_date
)
SELECT 
    order_date,
    revenue,
    SUM(revenue) OVER (ORDER BY order_date) AS running_total
FROM daily
ORDER BY order_date;

/* Q: Running Total of Revenue by Date
   • Daily revenue fluctuates ($50K-$200K)
   • Cumulative total grows steadily
   • Nov-Dec shows higher daily revenue (festive season)
   FINDING: Revenue accumulating consistently over time
   ACTION: Track daily run-rate to predict monthly/quarterly targets */

 -- Rank customers by revenue within each segment 

WITH ranked AS (
    SELECT 
        c.customer_name,
        c.customer_segment,
        SUM(o.net_sales) AS revenue
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_name, c.customer_segment
)
SELECT 
    customer_name,
    customer_segment,
    revenue,
    RANK() OVER (PARTITION BY customer_segment ORDER BY revenue DESC) AS rnk
FROM ranked
ORDER BY customer_segment, rnk;	   
/* Q: Rank Customers by Revenue within Segment
   • Business segment top: Brian Johnson ($45,223.60)
   • 1000+ Business customers ranked
   • Clear revenue leaders in each segment
   FINDING: Business segment has many high-value customers
   ACTION: Focus retention on top 10% in each segment */
   
 -- Compare year-over-year revenue growth — 2023 vs 2024.
WITH year_growth AS (
         SELECT TO_CHAR (order_date, 'YYYY') AS years,
		 SUM(net_sales) AS revenue
		 FROM orders
		 GROUP BY TO_CHAR(order_date, 'YYYY')
),
growth AS(
         SELECT
		       years,
			   revenue,
			   LAG(revenue) OVER (ORDER BY years) AS perv_revenue,
			   ROUND(
			   100.0 * (revenue - LAG(revenue) OVER (ORDER BY years))
			   / NULLIF (LAG(revenue) OVER (ORDER BY years),0),2
			   ) AS growth_pct
			   FROM year_growth
			   )
			   SELECT * FROM growth
			   ORDER BY growth_pct;

 /* Q: Year-over-Year Revenue Growth
   • 2023: +0.57% (only positive year)
   • 2024: -0.17%
   • 2025: -1.06%
   • 2022: -1.11% (worst decline)
   FINDING: Revenue flat/declining YoY — no growth momentum
   ACTION: Urgent need for growth strategy — new markets, products, or retention */

-- Identify customers who haven't placed an order in the last 6 months
-- (churned) and calculate what % of revenue is at risk.

	WITH customer_last_orders AS(
             SELECT
			      c.customer_id,
				  MAX(o.order_date) AS last_order_date,
				  SUM(net_sales) AS total_spend
				  FROM orders o
				  JOIN customers c ON o.customer_id = c.customer_id
				  GROUP BY c.customer_id			  
	),
	churned AS (
         SELECT * FROM customer_last_orders
		 WHERE last_order_date < (SELECT MAX(order_date) FROM orders) - INTERVAL '6 month'
	)
	SELECT 
	COUNT(*) AS churned_customers,
	SUM(total_spend) AS revenue_at_risk
	FROM churned;
	
	/* Q: Customer Churn Analysis (Fixed)
   • 13,247 customers churned (6+ months inactive)
   • $83,319,320 revenue at risk (47% of total)
   FINDING: ~53% customers churned — major retention problem
   ACTION: Win-back campaign, churn prediction model, loyalty program */

-- Find pairs of products that are frequently bought together in the same order (top 10 pairs).
 WITH pairs AS (
        SELECT
		oi1.product_id AS product_a,
		oi2.product_id AS product_b,
		COUNT(DISTINCT oi1.order_id) AS times_bought_together
		FROM order_items oi1
		JOIN order_items oi2 ON oi1.order_id = oi2.order_id
		WHERE oi1.product_id < oi2.product_id
		GROUP BY oi1.product_id , oi2.product_id
 )
SELECT
     p1.product_name AS product_a,
	 p2.product_name AS product_b,
	 times_bought_together
	 FROM pairs
	 JOIN productcatalog p1 ON p1.product_id = pairs.product_a
	 JOIN productcatalog p2 ON p2.product_id = pairs.product_b
	 ORDER BY times_bought_together DESC
	 LIMIT 10;
			  
/* Q: Market Basket Analysis (Frequently Bought Together)
   • Top pairs bought together only 7 times each
   • No strong product associations in data
   • Random pairings — synthetic data pattern
   FINDING: Very weak cross-sell signals (max = 7 co-purchases)
   ACTION: Real data needed for actionable recommendations */
   
-- Rank warehouses by a combined score using revenue, profit margin, delivery speed, and return rate.
WITH warehouse_metrics AS (
    SELECT 
        warehouse,
        SUM(net_sales) AS revenue,
        ROUND(100.0 * SUM(profit) / SUM(net_sales), 2) AS margin_pct,
        ROUND(AVG(delivery_days), 2) AS avg_delivery,
        ROUND(100.0 * SUM(CASE WHEN return_status = 'Returned' THEN 1 END) 
        / COUNT(*), 2) AS return_rate
    FROM orders
    GROUP BY warehouse
)
SELECT 
    warehouse,
    revenue,
    margin_pct,
    avg_delivery,
    return_rate,
NTILE(5) OVER (ORDER BY revenue) AS revenue_score,
NTILE(5) OVER (ORDER BY margin_pct) AS margin_score,
NTILE(5) OVER (ORDER BY avg_delivery) AS speed_score,
NTILE(5) OVER (ORDER BY return_rate) AS return_score,
(NTILE (5) OVER (ORDER BY revenue)+
NTILE(5) OVER (ORDER BY margin_pct)+
NTILE(5) OVER (ORDER BY avg_delivery)+
NTILE(5) OVER (ORDER BY return_rate DESC)) AS total_score
FROM warehouse_metrics
ORDER BY total_score DESC;

/* Q: Warehouse Performance Scorecard
   • Top: WH-003, WH-019 (score 15)
   • Bottom: WH-012 (score 6)
   • WH-014: High revenue/margin but worst return rate
   FINDING: Performance varies; some excel in all, some fail overall
   ACTION: Share best practices, audit bottom performers (WH-012, WH-009, WH-013) */

-- Calculate CLV for each customer using average order value, purchase frequency, 
-- and customer lifespan. Then segment into High/Medium/Low value.
WITH customer_metrics AS (
    SELECT 
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(net_sales) AS total_spend,
        ROUND(AVG(net_sales),2) AS avg_order_value,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order
    FROM orders
    GROUP BY customer_id
),
clv_calc AS (
    SELECT 
        customer_id,
        total_orders,
        total_spend,
        avg_order_value,
        (last_order - first_order) / 365.0 AS lifespan_years,
        total_orders / NULLIF((last_order - first_order) / 365.0, 0) AS freq_per_year
    FROM customer_metrics
)
SELECT 
    customer_id,
    total_spend,
    avg_order_value,
    total_orders,
    lifespan_years,
    ROUND(avg_order_value * freq_per_year * lifespan_years, 2) AS clv
FROM clv_calc
ORDER BY clv DESC;

/* Q: Customer Lifetime Value (CLV)
   • Top CLV: $30,268 (CUST-012869)
   • 600+ customers are one-time buyers (lifespan = 0)
   • Repeat customers have 3-4x higher spend
   FINDING: CLV = total_spend (formula cancels lifespan). Most customers one-time.
   ACTION: Fix formula — use predicted lifespan, focus on retention */





