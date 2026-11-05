# Customer Shopping Behavior Analysis

**An End-to-End Data Analytics Project using Python, MySQL, Power BI, and Gamma**

## 1. Overview

This project analyzes customer shopping behavior to identify purchasing patterns, customer preferences, sales trends, and opportunities to improve customer retention.

Using Python for data cleaning and exploratory data analysis (EDA), MySQL for querying and analysis, and Power BI for interactive visualization, the project transforms raw customer data into actionable business insights.

The analysis focuses on customer spending, product ratings, discount usage, subscription status, customer loyalty, and category-wise sales performance.

**Key Objectives**
- Understand customer purchasing patterns and spending behavior.
- Identify top-performing products and categories.
- Compare subscribers and non-subscribers.
- Analyze customer loyalty and discount usage.
- Build an interactive dashboard to support data-driven decisions.

## 2. Dataset

- **Dataset:** Customer Shopping Behavior
- **File:** `customer_shopping_behavior.csv`
- **Records:** 3,900 rows
- **Original Features:** 18 columns
- **Data Type:** Customer demographics, purchase details, product ratings, and shopping preferences.

### Key Features
- Customer ID, Age, Gender, and Location
- Item Purchased and Category
- Purchase Amount (USD)
- Review Rating
- Subscription Status
- Shipping Type
- Discount Applied
- Previous Purchases
- Frequency of Purchases
- Payment Method, Season, Size, and Color

**Data Preparation:** Missing review ratings were handled using category-wise median imputation. Column names were standardized, redundant columns were removed, and new features such as age groups and purchase frequency in days were created.

## 3. Tools & Technologies

| Tool | Purpose |
|---|---|
| Python | Data processing and exploratory data analysis |
| Pandas | Data cleaning, transformation, and feature engineering |
| Jupyter Notebook | Writing and executing Python code |
| SQLAlchemy & PyMySQL | Connecting Python to MySQL |
| MySQL | Data querying and business analysis |
| Power BI | Interactive dashboard development and visualization |
| DAX | Creating dashboard measures |
| Microsoft Word | Preparing the project report |
| Gamma | Creating the project presentation |

## 4. Project Workflow

### Step 1: Data Loading and Exploratory Data Analysis (Python)

Loaded the dataset into Python using Pandas and explored its structure and characteristics.

**Activities:**
- Inspected records, data types, and summary statistics.
- Identified missing values and checked data quality.
- Analyzed customer demographics, purchases, and spending patterns.
- Explored product categories, subscriptions, and discount usage.

### Step 2: Data Cleaning and Feature Engineering

Prepared the dataset for further analysis.

**Activities:**
- Handled missing review ratings using category-wise median imputation.
- Standardized column names using snake_case.
- Removed the redundant `promo_code_used` column.
- Created age groups using quartiles.
- Converted purchase frequency into numerical day values.
- Loaded the cleaned dataset into MySQL.

**Outcome:** The dataset retained all 3,900 records, with missing values resolved and features prepared for analysis.

### Step 3: SQL Analysis Using MySQL

Connected to the MySQL database and executed 10 SQL queries to answer business questions.

**SQL Concepts Used:**
- Aggregate functions: `SUM()`, `AVG()`, and `COUNT()`
- Filtering and sorting using `WHERE` and `ORDER BY`
- Grouping using `GROUP BY`
- Subqueries
- Conditional logic using `CASE WHEN`
- Common Table Expressions (CTEs)
- Window functions using `ROW_NUMBER()`

**Key Analysis Areas:**
- Revenue by gender and age group
- Spending patterns of subscribers and non-subscribers
- Top-rated products
- Products with the highest discount rates
- Customer segmentation into New, Returning, and Loyal
- Best-selling products within each category
- Average spending by shipping type

### Step 4: Power BI Dashboard

Connected Power BI to the MySQL database and developed an interactive dashboard.

**Dashboard Components:**
- KPI cards for customer count, average purchase amount, and average review rating
- Donut chart showing subscription status
- Revenue by product category
- Sales by product category
- Revenue by age group
- Sales by age group
- Interactive slicers for gender, category, subscription status, and shipping type

The dashboard allows users to filter customer segments and explore changes in key metrics without writing SQL queries.

### Step 5: Report and Presentation

Prepared a project report documenting the methodology, SQL analysis, key findings, business recommendations, and limitations.

Created a presentation using Gamma to communicate the project objectives, workflow, dashboard, and major insights in a clear and visually engaging format.

## 5. Dashboard

The Power BI dashboard provides an interactive overview of customer purchasing behavior and business performance.

**Dashboard Highlights:**
- Monitor customer count, average spending, and review ratings.
- Compare revenue across product categories and age groups.
- Explore subscriber and non-subscriber behavior.
- Filter results using interactive slicers.
- Identify trends that can support marketing and customer-retention decisions.

**Dashboard File:** `customer_behavior_dashboard.pbix`

*To display the dashboard preview on GitHub, add a dashboard screenshot to your repository and insert it below.*

```markdown
![Customer Shopping Behavior Dashboard](images/customer_behavior_dashboard.png)
```

## 6. Key Results and Business Insights

The analysis of 3,900 customer records produced the following findings:

| Metric | Result |
|---|---:|
| Total Revenue | $233,081 |
| Total Customers | 3,900 |
| Average Purchase Amount | $59.76 |
| Average Review Rating | 3.75 |
| Revenue Contribution from Male Customers | 68% |
| Customers Without a Subscription | 73% |
| Loyal Customers | 80% |
| New Customers | 2% |
| Purchases Using Discounts | 43% |

### Major Insights

**1. Customer Spending**
Male customers contribute approximately 68% of total revenue because they represent a larger share of the customer base. Average spending per customer is similar across genders.

**2. Subscription Performance**
Subscribers do not spend more per purchase than non-subscribers. Reviewing subscription benefits could help improve their value.

**3. Customer Loyalty**
Approximately 80% of customers fall into the Loyal segment, while only 2% are classified as New. This highlights an opportunity to focus on customer acquisition.

**4. Discount Usage**
Approximately 43% of purchases used discounts. Hats, Sneakers, and Coats had particularly high discount rates, making them potential candidates for further pricing analysis.

**5. Category Performance**
Clothing is the leading category by purchase volume and revenue, making it an important area for sales and marketing strategies.

**6. Age Group Analysis**
Young Adults contribute the largest share of revenue, although revenue is distributed relatively evenly across all four age groups.

### Business Recommendations

- Develop targeted campaigns to attract new customers.
- Review subscription benefits to encourage higher spending.
- Evaluate discount strategies for frequently discounted products.
- Use customer preferences to improve product promotions.
- Explore opportunities to increase sales among underrepresented customer segments.

*Note: These findings describe patterns in the available dataset and do not establish causal relationships.*

## 7. How to Run

Follow these steps to reproduce the project.

### Prerequisites

Install or set up the following:

- Python 3
- Jupyter Notebook
- MySQL Server
- Power BI Desktop

### Step 1: Clone the Repository

```bash
git clone <your-repository-url>
cd Customer-Shopping-Behavior-Analysis
```

Replace `<your-repository-url>` with your GitHub repository URL.

### Step 2: Install Dependencies

```bash
pip install pandas sqlalchemy pymysql jupyter
```

### Step 3: Load and Clean the Dataset

Place `customer_shopping_behavior.csv` in the project directory.

Launch Jupyter Notebook:

```bash
jupyter notebook
```

Open `data_cleaning.ipynb` and execute the cells in order to perform EDA, clean the data, create features, and load the processed data into MySQL.

### Step 4: Set Up MySQL

Create the database:

```sql
CREATE DATABASE customer_behavior;
```

Configure your MySQL connection in the notebook using your own credentials:

```python
from sqlalchemy import create_engine

engine = create_engine(
    "mysql+pymysql://USER:PASSWORD@localhost:3306/customer_behavior"
)
```

Replace `USER` and `PASSWORD` with your MySQL credentials.

Execute the notebook's data-loading step to create the `customer_shopping_behavior` table.

### Step 5: Execute SQL Queries

Open `analysis_queries.sql` in MySQL Workbench or another MySQL client.

Select the `customer_behavior` database and execute the queries to reproduce the business analysis.

### Step 6: Open the Power BI Dashboard

1. Open `customer_behavior_dashboard.pbix` in Power BI Desktop.
2. Configure the MySQL connection if prompted.
3. Refresh the data.
4. Explore the dashboard using the available slicers and visualizations.

### Step 7: Review the Report and Presentation

Open the project report to review the methodology, SQL findings, and recommendations.

Review the Gamma presentation for a summarized visual overview of the project.

## Project Structure

```text
Customer-Shopping-Behavior-Analysis/
│
├── customer_shopping_behavior.csv
├── data_cleaning.ipynb
├── analysis_queries.sql
├── customer_behavior_dashboard.pbix
├── Customer_Shopping_Behavior_Analysis_Report.docx
├── presentation/
│   └── project_presentation.pdf
├── images/
│   └── customer_behavior_dashboard.png
└── README.md
```

*Note: This is a suggested repository structure. Include only files you have added to your repository, and update the presentation filename or format to match your actual Gamma export.*

---

### Skills Demonstrated

- Exploratory Data Analysis (EDA)
- Data Cleaning and Feature Engineering
- Python and Pandas
- SQL Querying and Data Analysis
- MySQL Database Integration
- Power BI Dashboard Development
- Data Visualization and Business Intelligence
- Business Reporting and Presentation
- Analytical Thinking and Insight Generation

### Future Improvements

- Apply customer segmentation using K-Means clustering.
- Develop a machine learning model to predict subscription likelihood.
- Perform statistical tests to evaluate differences between customer segments.
- Improve product ranking analysis to handle tied sales counts fairly.

### Author

**Riya Cherian**  
Data Science Graduate | Python | SQL | Power BI



---

*This project demonstrates an end-to-end data analytics workflow, from raw data preparation to SQL-based analysis, interactive visualization, and business recommendations.*
