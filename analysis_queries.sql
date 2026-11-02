-- Customer Shopping Behavior Analysis | MySQL
USE customer_behavior;

-- Q1. Revenue by gender
SELECT gender, SUM(purchase_amount) AS revenue
FROM customer_shopping_behavior
GROUP BY gender;

-- Q2. Discounted purchases at or above the average purchase amount
SELECT customer_id, purchase_amount
FROM customer_shopping_behavior
WHERE discount_applied = 'Yes'
  AND purchase_amount >= (SELECT AVG(purchase_amount) FROM customer_shopping_behavior);

-- Q3. Top 5 products by average review rating
SELECT item_purchased, AVG(review_rating) AS average_product_rating
FROM customer_shopping_behavior
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5;

-- Q4. Average purchase amount: Standard vs Express shipping
SELECT shipping_type, ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount
FROM customer_shopping_behavior
WHERE shipping_type IN ('Standard', 'Express')
GROUP BY shipping_type;

-- Q5. Subscribers vs non-subscribers
SELECT subscription_status,
       COUNT(customer_id) AS total_customers,
       ROUND(AVG(purchase_amount), 2) AS avg_spend,
       ROUND(SUM(purchase_amount), 2) AS total_revenue
FROM customer_shopping_behavior
GROUP BY subscription_status
ORDER BY total_revenue, avg_spend DESC;

-- Q6. Top 5 products by discount rate
SELECT item_purchased,
       ROUND(100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS discount_rate
FROM customer_shopping_behavior
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;

-- Q7. Customer segments: New / Returning / Loyal
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

-- Q8. Top 3 most ordered items in each category
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

-- Q9. Repeat buyers (more than 5 previous purchases) by subscription status
SELECT subscription_status, COUNT(customer_id) AS repeat_buyers
FROM customer_shopping_behavior
WHERE previous_purchases > 5
GROUP BY subscription_status;

-- Q10. Revenue by age group
SELECT age_group, SUM(purchase_amount) AS total_revenue
FROM customer_shopping_behavior
GROUP BY age_group
ORDER BY total_revenue DESC;
