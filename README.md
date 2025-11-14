# online_store_customer_behaviour_analysis_sql
This project has SQL queries to derive insights on customer behavior, staff performance, inventory management, and store operations.


## 📌 Table of Contents

- <a href="#overview">Overview</a>
- <a href="#Business_Challange">Business Challange</a>
- <a href="#Dataset">Dataset</a>
- <a href="#Tools & Technologies">Tools & Technologies</a>
- <a href="#Key_Findings">Key Findings</a>
- <a href="#Suggestion">Suggestion</a>
- <a href="#Sales_Dashboard">Sales Dashboard</a>


<br><br>



<h2><a class="anchor" id="overview"></a>🏨 Overview</h2> 

Using the Jenson USA retail dataset, this project explores customer behavior, staff performance, inventory flow, and overall store operations. Through a series of advanced SQL queries, the analysis uncovers meaningful patterns in product sales, customer spending, and order trends. These insights help support smarter decision-making, improve customer experience, and strengthen day-to-day operational efficiency.


<br><br>


<h2><a class="anchor" id="business_Challange"></a>🧩 Business Challenge</h2>

This project uses a series of SQL queries to understand how the business is performing. These queries help break down sales, customer activity, and store operations so we can clearly see what's working well and what needs improvement. These queries addresses below key questions.


- Find the total number of products sold by each store along with the store name.
- Calculate the cumulative sum of quantities sold for each product over time.
- Find the product with the highest total sales (quantity * price) for each category.
- Find the customer who spent the most money on orders.
- Find the highest-priced product for each category name.
- Find the total number of orders placed by each customer per store.
- Find the names of staff members who have not made any sales.
- Find the top 3 most sold products in terms of quantity.
- Find the median value of the price list. 
- List all products that have never been ordered.(use Exists)
- List the names of staff members who have made more sales than the average number of sales by all staff members.
- Identify the customers who have ordered all types of products (i.e., from every category).



<br><br>

<h2><a class="anchor" id="dataset"></a>🗂️ Dataset</h2>

This project uses multiple CSV files stored in the /data/ folder.


<br><br>


<h2><a class="anchor" id="tools_technologies"></a>⚙️ Tools & Technologies</h2>

### MySQL
##### The following MySQL features were utilized to execute the queries:
---
- SELECT Statement: To retrieve specific columns and data from the database.
- JOIN Operations: To combine rows from different tables based on related columns for comprehensive analysis.
- GROUP BY: To aggregate data for calculations like totals and averages.
- HAVING Clause: To filter groups based on aggregate functions, ensuring accurate analysis.
- COUNT() Function: To count the number of records or rows that meet specified criteria.
- SUM() Function: To calculate the total sales and quantities.
- CROSS JOIN and EXISTS: To handle queries that require checking for conditions across multiple tables.
- MEDIAN Calculation: To determine the middle value in a set of prices.
- Subqueries: To execute complex queries that depend on results from other queries.

### Github: For version control and collaboration.

<br><br>

<h2><a class="anchor" id="suggestion"></a>🧭 Suggestions & Recommendations</h2>

[👉 🛢️ View Queries here ](https://github.com/Abhishek-77/online_store_customer_behaviour_analysis_sql/blob/main/jensons_sql/jensons_analysis.sql)

<br><br>





