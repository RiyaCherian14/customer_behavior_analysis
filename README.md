# Customer Shopping Behavior Analysis

**An End-to-End Data Analytics Project using Python, MySQL, Power BI, and Gamma**

Table of Contents
Project Overview
Dataset Summary
Exploratory Data Analysis using Python (Jupyter)
Data Analysis using SQL (MySQL)
Data Visualization using Power BI
Key Insights
Business Recommendations
Repository Structure & How to Run
Skills Demonstrated
Limitations & Next Steps
1. 🎯 Project Overview
What is this project about?

A retail company sells clothing, footwear, accessories and outerwear. It has data on 3,900 customers: who they are (age, gender, location), what they bought, how much they paid, whether they used a discount, whether they have a subscription, and how often they shop.

The company's leadership wants to know how its customers behave so they can decide where to spend marketing money, which products to promote, and how to improve loyalty. This project analyses that data to answer their questions.

Business questions I set out to answer
Who spends the most: which gender and which age group?
Do subscribers spend more than non-subscribers?
Which products have the best ratings?
Which products depend most on discounts?
How loyal are the customers (new, returning, or loyal)?
Which products sell the most in each category?
Does the shipping type change how much customers spend?
What I did, in three steps
Step	Tool	What I did
1. Clean & explore	Python (Pandas) in Jupyter Notebook	Checked the data, fixed missing values, renamed columns, created new useful columns, removed a duplicate column, and loaded the clean data into MySQL
2. Analyse	MySQL	Wrote 10 SQL queries (aggregations, subqueries, CTEs, window functions) to answer the business questions
3. Visualise	Power BI	Built an interactive dashboard with KPI cards, charts, and slicers so anyone can explore the data without writing code
Headline results
Total revenue: $233,081 from 3,900 customers, average purchase $59.76.
Men bring 68% of revenue, but only because there are more male customers. Spend per customer is almost the same for men and women.
Subscribers do not spend more per purchase than non-subscribers.
80% of customers are loyal, but only 2% are new, so the business needs to attract new customers.
2. 📂 Dataset Summary

File: customer_shopping_behavior.csv | Size: 3,900 rows × 18 columns | Customer ID runs from 1 to 3,900, so each row is one customer.

Column guide
Column	Type	Meaning
Customer ID	Number	Unique ID of the customer (1–3,900)
Age	Number	Customer age (18–70)
Gender	Text	Male / Female
Item Purchased	Text	Product bought (25 different items, e.g. Blouse, Sandals, Jacket)
Category	Text	Clothing, Footwear, Accessories, Outerwear
Purchase Amount (USD)	Number	Amount paid, from $20 to $100
Location	Text	US state (50 states)
Size / Color	Text	Size (S, M, L, XL) and colour (25 colours) of the item
Season	Text	Season of purchase (Spring, Summer, Fall, Winter)
Review Rating	Number	Customer rating of the product (2.5–5.0)
Subscription Status	Text	Yes / No
Shipping Type	Text	Free Shipping, Standard, Express, Next Day Air, 2-Day Shipping, Store Pickup
Discount Applied	Text	Yes / No
Promo Code Used	Text	Yes / No (identical to Discount Applied, so removed later)
Previous Purchases	Number	How many times the customer bought before (1–50)
Payment Method	Text	PayPal, Credit Card, Venmo, Cash, etc. (6 methods)
Frequency of Purchases	Text	How often they shop (Weekly, Fortnightly, Monthly, Quarterly, Annually, etc.)
Columns I created
New column	How it was made	Why
age_group	Customers split into 4 equal-sized age bands	Makes it easy to compare age groups
purchase_frequency_days	"Weekly" turned into 7, "Monthly" into 30, etc.	Lets us do maths with shopping frequency
3. 🔍 Exploratory Data Analysis using Python (Jupyter)

Notebook: customer_shopping_behavior_analysis.ipynb | Libraries: Pandas, SQLAlchemy, PyMySQL

EDA means looking carefully at the data before analysing it, to understand it and find problems. Here is everything I did, in order.

Step 1: Load and look at the data
python
import pandas as pd
df = pd.read_csv('customer_shopping_behavior.csv')
df.head()        # first 5 rows
df.info()        # column types and non-null counts
df.describe(include='all')   # summary statistics for every column

What I learned: 3,900 rows and 18 columns. Every column was complete except Review Rating, which had only 3,863 values.

Step 2: Summary statistics

Numbers

Column	Average	Minimum	Median	Maximum
Age	44.1	18	44	70
Purchase Amount (USD)	$59.76	$20	$60	$100
Review Rating	3.75	2.5	3.8	5.0
Previous Purchases	25.4	1	25	50

Because the average and the median are very close for each column, the values are fairly balanced and not skewed by extreme outliers.

Categories

Gender: 2,652 male (68%) and 1,248 female (32%), so the customer base is male-heavy.
Category: Clothing is the biggest at 1,737 purchases (44.5%).
Items: 25 different items. Blouse is the most common (171 purchases).
Subscription: 2,847 customers (73%) have no subscription, and 1,053 (27%) do.
Shipping: 6 types, and Free Shipping is the most common (675).
Discounts: 2,223 purchases (57%) had no discount, so 1,677 (43%) had one.
Location: 50 states, and Montana appears most often (96).
Step 3: Check for missing values
python
df.isnull().sum()

Only Review Rating had missing values: 37 out of 3,900 (about 1%).

Step 4: Fix the missing ratings
python
df['review_rating'] = df.groupby('category')['review_rating'].transform(
    lambda x: x.fillna(x.median())
)

Each missing rating was filled with the median rating of its own category. I used the median because it is not affected by unusually high or low ratings, and I grouped by category so that, for example, a missing Footwear rating is filled using Footwear ratings and not Clothing ratings. After this, df.isnull().sum() showed 0 missing values.

Step 5: Clean the column names
python
df.columns = df.columns.str.lower()
df.columns = df.columns.str.replace(' ', '_')
df = df.rename(columns={'purchase_amount_(usd)': 'purchase_amount'})

Names like Purchase Amount (USD) are awkward in SQL. They now look like purchase_amount, so queries are shorter and cleaner.

Step 6: Feature engineering (creating useful new columns)

Age groups. Customers were split into 4 equal-sized groups using quartiles (pd.qcut):

Age group	Age range
Young Adult	18–31
Adult	32–44
Middle-aged	45–57
Senior	58–70
python
labels = ['Young Adult', 'Adult', 'Middle-aged', 'Senior']
df['age_group'] = pd.qcut(df['age'], q=4, labels=labels)

Each group has roughly the same number of customers, so comparing their revenue is fair.

Purchase frequency in days. The text column "Frequency of Purchases" was converted to numbers so it can be averaged and compared:

python
frequency_mapping = {'Weekly': 7, 'Fortnightly': 14, 'Bi-Weekly': 14, 'Monthly': 30,
                     'Quarterly': 90, 'Every 3 Months': 90, 'Annually': 365}
df['purchase_frequency_days'] = df['frequency_of_purchases'].map(frequency_mapping)
Step 7: Remove a redundant column

I suspected that promo_code_used and discount_applied carry the same information, so I tested it:

python
(df['discount_applied'] == df['promo_code_used']).all()   # → True
df = df.drop('promo_code_used', axis=1)

They matched in every row, so keeping both added nothing. I dropped promo_code_used.

Step 8: Load the clean data into MySQL
python
from sqlalchemy import create_engine
engine = create_engine("mysql+pymysql://USER:PASSWORD@localhost:3306/customer_behavior")
df.to_sql("customer_shopping_behavior", engine, if_exists="replace", index=False)

I then ran DESCRIBE customer_shopping_behavior; in MySQL to confirm the table had 19 columns with the right data types.

Result of the Python stage
	Before	After
Rows	3,900	3,900
Columns	18	19 (removed 1, added 2)
Missing values	37	0
Column names	Inconsistent	snake_case
4. 🗄️ Data Analysis using SQL (MySQL)

Database: customer_behavior | Table: customer_shopping_behavior | File: analysis_queries.sql

For each question below: the business question, the SQL technique, the result, and what it means.

Q1. How much revenue does each gender generate?

Technique: GROUP BY with SUM

sql
SELECT gender, SUM(purchase_amount) AS revenue
FROM customer_shopping_behavior
GROUP BY gender;
Gender	Revenue
Male	$157,890
Female	$75,191

Meaning: Men generate 68% of revenue. This is mainly because there are more male customers (2,652 vs 1,248). Per customer, men spend about $59.54 and women about $60.25, which is almost the same.

Q2. Which discounted purchases were above the average purchase amount?

Technique: subquery

sql
SELECT customer_id, purchase_amount
FROM customer_shopping_behavior
WHERE discount_applied = 'Yes'
  AND purchase_amount >= (SELECT AVG(purchase_amount) FROM customer_shopping_behavior);

Result: 839 purchases. Meaning: Out of 1,677 discounted purchases, about half (839) were at or above the average spend. Discounts are not only used on small orders.

Q3. Which 5 products have the highest average rating?

Technique: AVG, ORDER BY, LIMIT

sql
SELECT item_purchased, AVG(review_rating) AS average_product_rating
FROM customer_shopping_behavior
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5;
Product	Average rating
Gloves	3.86
Sandals	3.84
Boots	3.82
Hat	3.80
Skirt	3.78

Meaning: The ratings are very close together (3.78–3.86), so no product is a clear winner. Gloves, Sandals and Boots are the best-received.

Q4. Do Express shipping customers spend more than Standard?

Technique: WHERE ... IN, ROUND

sql
SELECT shipping_type, ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount
FROM customer_shopping_behavior
WHERE shipping_type IN ('Standard', 'Express')
GROUP BY shipping_type;
Shipping	Average purchase
Express	$60.48
Standard	$58.46

Meaning: Express customers spend about $2 (3.5%) more per purchase. It is a small gap.

Q5. How do subscribers compare with non-subscribers?

Technique: multiple aggregates in one query

sql
SELECT subscription_status,
       COUNT(customer_id) AS total_customers,
       ROUND(AVG(purchase_amount), 2) AS avg_spend,
       ROUND(SUM(purchase_amount), 2) AS total_revenue
FROM customer_shopping_behavior
GROUP BY subscription_status
ORDER BY total_revenue, avg_spend DESC;
Subscribed?	Customers	Avg spend	Total revenue
Yes	1,053	$59.49	$62,645
No	2,847	$59.87	$170,436

Meaning: Subscribers spend slightly less per purchase ($59.49 vs $59.87). Only 27% of customers are subscribers, and they bring 27% of revenue. The subscription does not yet increase spending.

Q6. Which 5 products are discounted most often?

Technique: CASE WHEN inside an aggregate

sql
SELECT item_purchased,
       ROUND(100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS discount_rate
FROM customer_shopping_behavior
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;
Product	Discount rate
Hat	50.00%
Sneakers	49.66%
Coat	49.07%
Sweater	48.17%
Pants	47.37%

Meaning: Around half of the orders for these products are discounted. That may be cutting profit margins.

Q7. How many customers are New, Returning, and Loyal?

Technique: CTE (a named temporary result) with CASE WHEN

sql
WITH customer_type AS (
    SELECT customer_id, previous_purchases,
           CASE
               WHEN previous_purchases = 1 THEN 'New'
               WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
               ELSE 'Loyal'
           END AS customer_segment
    FROM customer_shopping_behavior
)
SELECT customer_segment, COUNT(*) AS number_of_customers
FROM customer_type
GROUP BY customer_segment;
Segment	Rule	Customers	Share
Loyal	more than 10 previous purchases	3,116	80%
Returning	2 to 10 previous purchases	701	18%
New	1 previous purchase	83	2%

Meaning: The business keeps its customers well but is not attracting many new ones.

🐞 Debugging note: My first attempt wrote previous_purchases=1 BETWEEN 2 AND 10, which is wrong, and it made the "Returning" group disappear (all of them became "Loyal"). I spotted it because the three groups did not look right, and fixed it by testing previous_purchases BETWEEN 2 AND 10.

Q8. What are the top 3 most-ordered items in each category?

Technique: window function ROW_NUMBER() OVER (PARTITION BY ...)

sql
WITH item_counts AS (
    SELECT category, item_purchased,
           COUNT(customer_id) AS total_orders,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
    FROM customer_shopping_behavior
    GROUP BY category, item_purchased
)
SELECT item_rank, category, item_purchased, total_orders
FROM item_counts
WHERE item_rank <= 3;
Category	#1	#2	#3
Accessories	Jewelry (171)	Sunglasses (161)	Belt (161)
Clothing	Blouse (171)	Pants (171)	Shirt (169)
Footwear	Sandals (160)	Shoes (150)	Sneakers (145)
Outerwear	Jacket (163)	Coat (161)	(only 2 items)

Meaning: The best sellers are very close in order counts. (PARTITION BY category restarts the ranking for each category.)

Q9. Are subscribers more likely to be repeat buyers?

Technique: WHERE + GROUP BY (repeat buyer = more than 5 previous purchases)

sql
SELECT subscription_status, COUNT(customer_id) AS repeat_buyers
FROM customer_shopping_behavior
WHERE previous_purchases > 5
GROUP BY subscription_status;
Subscribed?	Repeat buyers	Out of	Share
Yes	958	1,053	91.0%
No	2,518	2,847	88.4%

Meaning: Subscribers are slightly more likely to be repeat buyers, but the difference is small.

Q10. Which age group generates the most revenue?

Technique: GROUP BY, ORDER BY

sql
SELECT age_group, SUM(purchase_amount) AS total_revenue
FROM customer_shopping_behavior
GROUP BY age_group
ORDER BY total_revenue DESC;
Age group	Revenue	Share
Young Adult (18–31)	$62,143	26.7%
Middle-aged (45–57)	$59,197	25.4%
Adult (32–44)	$55,978	24.0%
Senior (58–70)	$55,763	23.9%

Meaning: Revenue is spread fairly evenly. Young Adults lead, but only by about 3 percentage points over Seniors.

5. 📊 Data Visualization using Power BI

File: customer_behavior_dashboard.pbix | Source: the customer_shopping_behavior table in MySQL

What the dashboard contains
Element	What it shows	Why it is useful
KPI card: Number of Customers	Count of customers in the current selection	Shows the size of any segment
KPI card: Average Purchase Amount	Average of purchase_amount	Shows typical spending
KPI card: Average Review Rating	Average of review_rating	Shows customer satisfaction
Donut chart: % of Customers by Subscription Status	Share of subscribers vs non-subscribers	Shows how much of the base is subscribed
Revenue by Category and Sales by Category	Performance of Clothing, Footwear, Accessories, Outerwear	Shows which categories matter most
Revenue by Age Group and Sales by Age Group	Performance of the four age groups	Shows which age groups drive revenue
Slicers (filters): Subscription Status, Gender, Category, Shipping Type	Filters that update all visuals together	Lets a manager explore any segment
What the dashboard shows (no filters applied)
3.9K customers, an average purchase of $59.76, and an average review rating of 3.75.
73% of customers have no subscription and 27% do.
Clothing is the top category by revenue (roughly $104K), followed by Accessories (about $74K), Footwear (about $36K) and Outerwear (about $18K). These values are read from the chart, so they are approximate.
Young Adults generate the most revenue, and revenue is fairly even across the four age groups.
How to use it

Click a slicer (for example Gender = Female and Category = Footwear) and every KPI and chart updates. A manager can answer questions like "How much do female subscribers spend on footwear?" in two clicks, without writing SQL.

Design choices
KPI cards at the top give the headline numbers first.
The charts compare categories and age groups side by side.
The slicers sit on the left so they are always visible.
6. 💡 Key Insights
#	Insight	Evidence
1	Men bring 68% of revenue, but because there are more of them, not because they spend more.	2,652 male vs 1,248 female customers; spend per customer is $59.54 vs $60.25
2	Subscribers do not spend more per purchase.	$59.49 (subscribers) vs $59.87 (non-subscribers)
3	Subscribers are slightly more loyal.	91.0% vs 88.4% have more than 5 previous purchases
4	The customer base is very loyal but hardly growing.	80% Loyal, 18% Returning, only 2% New
5	Discounts are everywhere.	43% of all purchases used a discount; Hats, Sneakers and Coats are discounted about half the time
6	Revenue is balanced across age groups.	Young Adults 26.7% down to Seniors 23.9%
7	Express shipping customers spend a little more.	$60.48 vs $58.46 (+3.5%)
8	Product ratings are tightly clustered.	Top 5 products range from 3.78 to 3.86
9	Clothing is the core category.	44.5% of all purchases
7. ✅ Business Recommendations

These come from descriptive analysis (patterns in the data). They show where to look, not proof of cause, so test them before making large changes.

Finding	Recommendation	Expected benefit
Subscribers spend no more than others	Redesign subscription benefits (such as early access or free shipping above a spend threshold)	Higher spend per order from members
Only 2% of customers are new	Run acquisition campaigns, and use the loyal 80% for referral rewards	Customer growth
Women make up only 32% of customers but spend as much per person	Target women with marketing in the best-selling categories	New revenue from an under-served group
Hats, Sneakers and Coats are discounted about 50% of the time	A/B test smaller or fewer discounts on these items	Better profit margins
Express shippers spend slightly more	Promote Express shipping at checkout	Small increase in order value
Gloves, Sandals and Boots are rated highest	Feature them in campaigns and bundle them with best sellers	Higher sales on well-liked products
Young Adults generate the most revenue	Keep them as a priority segment, with social media promotion	Protect the largest revenue group
📎 Project Documents
Document	What it contains
Full report (Word)	Methodology, SQL analysis, dashboard, insights and recommendations
Presentation (PowerPoint)	7-slide summary of the project
EDA document (PDF)	Every Python EDA step with code and output
SQL queries	The 10 MySQL queries
8. 📁 Repository Structure & How to Run
customer_behavior_analysis/
├── customer_shopping_behavior.csv                      # dataset
├── customer_shopping_behavior_analysis.ipynb           # Python cleaning and EDA
├── analysis_queries.sql                                # 10 MySQL business queries
├── customer_behavior_dashboard.pbix                    # Power BI dashboard
├── dashboard.png                                       # dashboard screenshot
├── Customer_Behavior_Analysis_Report.docx              # full project report
├── Customer_Behavior_Analysis_Presentation.pptx        # project presentation
├── Exploratory Data Analysis using Python - Customer Shopping Behavior.pdf
├── LICENSE
└── README.md

To run it yourself

Clone the repo: git clone https://github.com/RiyaCherian14/customer_behavior_analysis.git cd customer_behavior_analysis
Install libraries: pip install pandas sqlalchemy pymysql
Store your MySQL password in an environment variable (never write it in code):
Windows: setx MYSQL_PASSWORD "your_password"
Mac/Linux: export MYSQL_PASSWORD="your_password"
Run customer_shopping_behavior_analysis.ipynb. It creates the clean table in MySQL using:
python
import os
from sqlalchemy import create_engine
password = os.environ["MYSQL_PASSWORD"]
engine = create_engine(f"mysql+pymysql://root:{password}@localhost:3306/customer_behavior")
Run the queries in analysis_queries.sql using MySQL Workbench or the MySQL command line.
Open the .pbix file in Power BI Desktop (Windows).
9. 🧠 Skills Demonstrated
Python: Pandas, data cleaning, missing-value handling, feature engineering, SQLAlchemy
SQL (MySQL): aggregations, subqueries, CASE WHEN, CTEs, window functions
Power BI: connecting to a database, DAX measures, interactive dashboard design, slicers
Analytical thinking: turning business questions into queries, telling the difference between "more customers" and "higher spend", and writing clear recommendations
10. 🔭 Limitations & Next Steps

Limitations

The analysis is descriptive: it shows what happened, not why.
Each customer appears once, so I could not study how one customer's behaviour changes over time.
The dataset is male-heavy (68%), which affects the totals.

Next steps

Add K-Means clustering to find natural customer groups.
Build a machine learning model to predict whether a customer is likely to subscribe.
Use RANK or DENSE_RANK instead of ROW_NUMBER in Q8 so ties (like Sunglasses and Belt at 161) are treated fairly.
Run statistical tests to check whether the differences (subscribers vs non-subscribers, Express vs Standard) are statistically significant.
👩‍💻 Author

Riya Cherian | Data Science Graduate | Bengaluru, India 📧 helloriya004@gmail.com | 💻 GitHub

📄 License: MIT
