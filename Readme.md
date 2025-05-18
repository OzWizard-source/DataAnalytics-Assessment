# Cowryrise Data Analytics SQL Assessment
This readme file contains explanations of my approach to each question and difficulties I encountered overall. 


## Question 1:  High-Value Customers with Multiple Products
This question asks us to provide a summary of customers with both active savings and investment plans, showing total deposit value.

Approach: 
Before starting anything, I cleaned the data which posed much challenge as I got confused on what to clean and what not to, particularly the columns.
Some users had blank or null names, and others had duplicates that needed to be handled to avoid inflating counts.

Once cleaned, I began by writing a query that joins the `users_customer`, `savings_savingsaccount`, and `plans_plan` tables. The goal was to ensure each customer in the result:

* Has at least one active savings account with a confirmed amount greater than 0.
* Has at least one investment plan (`plan_type_id = 2`) that is not marked as deleted (`is_deleted = 0`).
* Is marked as active in the users table.

I used `GROUP BY` on `user.id` and selected counts of both savings and investments using `COUNT(DISTINCT ...)`, as well as `SUM(s.confirmed_amount)` for total deposits. I also concatenated first and last names for a full customer name, and included the username for reference.

## Challenges
* Dealing with **null or blank names** was tricky, especially when trying to create a clean, readable customer name column.
* It was difficult at first to decide whether to group by `user.id` only or also include `name` and `username`, but I realized grouping by `id` was sufficient since it's unique.
* I encountered some customers with zero or deleted plans, which made me rethink my joins and add filters.
* I had to rewrite part of the query to avoid overcounting — I originally did multiple joins without ensuring they filtered correctly, so some counts were higher than expected due to row duplication.



## Question 2: Transaction Frequency Analysis
Objective is to categorize customers based on their monthly transaction frequency.

Approach:
At first, I wasn’t exactly sure how to define “transactions” — were they rows in the savings_savingsaccount table, or something more specific? After checking the schema, I assumed each row with a confirmed_amount > 0 represented a valid transaction.

I began by grouping the transactions by user and month using the DATE_FORMAT() function since DATE_TRUNC doesn’t work in MySQL (I initially tried it and got an error). I counted transactions per user per month, then averaged them using a subquery. Finally, I added a CASE statement to categorize the users.

## Challenges:
I first wrote the query using DATE_TRUNC, which I later found out to be PostgreSQL syntax. MySQL doesn't support it, so I had to switch to DATE_FORMAT(created_at, '%Y-%m') to extract the month and year. It was initially confusing to compute the average per customer per month — grouping by the right level (customer + month) helped. I also noticed that without DISTINCT, repeated entries caused inflation, especially if some rows were essentially duplicates with minor differences.


## Question 3: Account Inactivity Alert
I first filtered both savings and investment plans based on the presence of recent transactions. I used the created_on field and compared it with CURRENT_DATE - INTERVAL 365 DAY. I used UNION to combine both savings_savingsaccount and clean_plans_plan tables (I duplicated plans_plan in order not to tamper with the raw data incase I need to fall back to it), labeling each row with either “Savings” or “Investment” as type, then filtered where the last_transaction_date was more than a year old.

Challenges:
I had to ensure I was using the most accurate field to represent the “last transaction date”. Not all tables had this explicitly labeled, so assumptions had to be made based on the schema and naming. It wasn’t immediately obvious how to standardize data from both savings and plans in one query, but using UNION ALL helped streamline the logic.
Subtracting dates directly in MySQL was tricky until I settled on DATEDIFF() to calculate the number of inactive days.


## Question 4: Customer Lifetime Value (CLV)
This question aimed to estimate the CLV for each customer using a simplified model based on how long they’ve held an account and how frequently they transact. The idea was to get a sense of which users bring the most value, assuming a fixed profit margin per transaction.

To begin, I calculated each user’s account tenure in months by comparing their created_on signup date with the current date. This gave a clear view of how long each customer had been using the platform. I then counted all the savings transactions, operating under the assumption that each row with a confirmed_amount greater than zero represented a valid transaction. With this, I applied the CLV formula provided: (total_transactions / tenure_months) * 12 * profit_per_transaction. The fixed profit rate was 0.1% (0.001), so the values were scaled appropriately and rounded to two decimal places for clarity. I also concatenated the first and last names of users to display a full name and included their unique user ID for reference.

The process wasn’t without challenges. Initially, I was unsure whether to calculate tenure based on full calendar months or approximate it using days. I eventually settled on using the TIMESTAMPDIFF(MONTH, created_on, CURDATE()) function in MySQL, as it consistently provided the tenure in whole months. A subtle but important hurdle was the presence of users whose tenure calculated to zero months—likely users who had just signed up. I had to exclude them from the calculation to avoid division by zero errors.



