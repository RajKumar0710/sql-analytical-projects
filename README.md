# sql-analytical-projects
# Advanced SQL & Analytical Projects (PostgreSQL)

Welcome to my SQL Analytical Projects repository. This collection contains production-grade PostgreSQL scripts designed to solve complex data modeling, business intelligence, and user analytics problems.

## 📁 Repository Directory

| File Name | Focus Area | Key SQL Techniques |
| :--- | :--- | :--- |
| **[icc_world_cup_points_table.sql](./icc_world_cup_points_table.sql)** | Tournament Points Table Calculation | `CROSS JOIN LATERAL`, Unpivoting Data, Conditional Aggregation |
| **[ipl_toss_and_match_analytics.sql](./ipl_toss_and_match_analytics.sql)** | IPL 2026 Toss & Match Conversion Analytics | CTEs (`WITH`), `CROSS JOIN LATERAL`, Safe Division (`NULLIF`), Percentage Rounding |
| **[customer_orders_new_and_repeat_count.sql](./customer_orders_new_and_repeat_count.sql)** | Daily New vs. Repeat Customer Metrics | CTEs (`WITH`), Subqueries, Conditional Aggregation (`SUM(CASE)`), Self-Joins (`INNER JOIN`) |
| **[entries_floor_and_resources.sql](./entries_floor_and_resources.sql)** | Visitor Floor & Resource Usage Analysis | CTEs (`WITH`), Window Functions (`RANK()`), String Aggregation (`STRING_AGG`), Aggregations (`COUNT`) |
| **[all_products_contributing_80_percent_of_company_sales.sql](./all_products_contributing_80_percent_of_company_sales.sql)**|parero principle| CTEs('WITH'), Window Functions ('OVER()'), running totals
| **[cancelled_trips_and_cancellation_rate.sql](/.cancelled_trips_and_cancellation_rate.sql)**|Trip Cancellation Metrics & Rate Analysis | CTEs (WITH), Double INNER JOIN, Conditional Aggregation (SUM(CASE)), Precision Division (1.0 *) |
| **[tournament_highest_score_per_group.sql](tournament_highest_score_per_group.sql)**| Group Highest Scorer with Tie-Breaking Logic | `WITH` (CTEs), `CROSS JOIN LATERAL`, `VALUES` Unpivoting, `ROW_NUMBER()`, Deterministic Tie-Breaking |
---

## 📊 Sample Datasets & DDL Setup

To reproduce these results locally in PostgreSQL, run the following schema creation and insert statements:

### 1. ICC World Cup Table Setup
```sql
CREATE TABLE icc_world_cup (
    team_1 VARCHAR(20),
    team_2 VARCHAR(20),
    winner VARCHAR(20)
);

INSERT INTO icc_world_cup (team_1, team_2, winner) VALUES
('India', 'SL', 'India'),
('SL', 'Aus', 'Aus'),
('SA', 'Eng', 'Eng'),
('Eng', 'NZ', 'NZ'),
('Aus', 'India', 'India');
```

### 2. IPL 2026 dataset setup
```sql
CREATE TABLE ipl_2026_matches (
    team1 VARCHAR(50),
    team2 VARCHAR(50),
    winner VARCHAR(50),
    toss_won_by VARCHAR(50),
    batting_first VARCHAR(50)
);
INSERT INTO ipl_2026_matches (team1, team2, winner, toss_won_by, batting_first) VALUES
('Sunrisers Hyderabad','Royal Challengers Bengaluru','Royal Challengers Bengaluru','Royal Challengers Bengaluru','Sunrisers Hyderabad'),
('Kolkata Knight Riders','Mumbai Indians','Mumbai Indians','Mumbai Indians','Kolkata Knight Riders'),
('Chennai Super Kings','Rajasthan Royals','Rajasthan Royals','Rajasthan Royals','Chennai Super Kings'),
('Gujarat Titans','Punjab Kings','Punjab Kings','Punjab Kings','Gujarat Titans'),
('Lucknow Super Giants','Delhi Capitals','Delhi Capitals','Delhi Capitals','Lucknow Super Giants'),
('Sunrisers Hyderabad','Kolkata Knight Riders','Sunrisers Hyderabad','Kolkata Knight Riders','Sunrisers Hyderabad'),
('Chennai Super Kings','Punjab Kings','Punjab Kings','Punjab Kings','Chennai Super Kings'),
('Mumbai Indians','Delhi Capitals','Delhi Capitals','Delhi Capitals','Mumbai Indians'),
('Rajasthan Royals','Gujarat Titans','Rajasthan Royals','Rajasthan Royals','Rajasthan Royals'),
('Royal Challengers Bengaluru','Chennai Super Kings','Royal Challengers Bengaluru','Chennai Super Kings','Royal Challengers Bengaluru'),
('Sunrisers Hyderabad','Lucknow Super Giants','Lucknow Super Giants','Lucknow Super Giants','Sunrisers Hyderabad'),
('Kolkata Knight Riders','Punjab Kings','-','Kolkata Knight Riders','Kolkata Knight Riders'),
('Rajasthan Royals','Mumbai Indians','Rajasthan Royals','Mumbai Indians','Rajasthan Royals'),
('Gujarat Titans','Delhi Capitals','Gujarat Titans','Delhi Capitals','Gujarat Titans'),
('Kolkata Knight Riders','Lucknow Super Giants','Lucknow Super Giants','Lucknow Super Giants','Kolkata Knight Riders'),
('Royal Challengers Bengaluru','Rajasthan Royals','Rajasthan Royals','Rajasthan Royals','Royal Challengers Bengaluru'),
('Chennai Super Kings','Delhi Capitals','Chennai Super Kings','Delhi Capitals','Chennai Super Kings'),
('Sunrisers Hyderabad','Punjab Kings','Punjab Kings','Punjab Kings','Sunrisers Hyderabad'),
('Lucknow Super Giants','Gujarat Titans','Gujarat Titans','Gujarat Titans','Lucknow Super Giants'),
('Royal Challengers Bengaluru','Mumbai Indians','Royal Challengers Bengaluru','Mumbai Indians','Royal Challengers Bengaluru'),
('Sunrisers Hyderabad','Rajasthan Royals','Sunrisers Hyderabad','Rajasthan Royals','Sunrisers Hyderabad'),
('Chennai Super Kings','Kolkata Knight Riders','Chennai Super Kings','Kolkata Knight Riders','Chennai Super Kings'),
('Lucknow Super Giants','Royal Challengers Bengaluru','Royal Challengers Bengaluru','Royal Challengers Bengaluru','Lucknow Super Giants'),
('Mumbai Indians','Punjab Kings','Punjab Kings','Punjab Kings','Mumbai Indians'),
('Kolkata Knight Riders','Gujarat Titans','Gujarat Titans','Kolkata Knight Riders','Kolkata Knight Riders'),
('Royal Challengers Bengaluru','Delhi Capitals','Delhi Capitals','Delhi Capitals','Royal Challengers Bengaluru'),
('Sunrisers Hyderabad','Chennai Super Kings','Sunrisers Hyderabad','Chennai Super Kings','Sunrisers Hyderabad'),
('Punjab Kings','Lucknow Super Giants','Punjab Kings','Lucknow Super Giants','Punjab Kings'),
('Rajasthan Royals','Kolkata Knight Riders','Kolkata Knight Riders','Rajasthan Royals','Rajasthan Royals'),
('Mumbai Indians','Gujarat Titans','Mumbai Indians','Gujarat Titans','Mumbai Indians'),
('Sunrisers Hyderabad','Delhi Capitals','Sunrisers Hyderabad','Delhi Capitals','Sunrisers Hyderabad'),
('Rajasthan Royals','Lucknow Super Giants','Rajasthan Royals','Lucknow Super Giants','Rajasthan Royals'),
('Chennai Super Kings','Mumbai Indians','Chennai Super Kings','Mumbai Indians','Chennai Super Kings'),
('Gujarat Titans','Royal Challengers Bengaluru','Royal Challengers Bengaluru','Royal Challengers Bengaluru','Gujarat Titans'),
('Delhi Capitals','Punjab Kings','Punjab Kings','Delhi Capitals','Delhi Capitals'),
('Rajasthan Royals','Sunrisers Hyderabad','Sunrisers Hyderabad','Sunrisers Hyderabad','Rajasthan Royals'),
('Chennai Super Kings','Gujarat Titans','Gujarat Titans','Gujarat Titans','Chennai Super Kings'),
('Kolkata Knight Riders','Lucknow Super Giants','-','Lucknow Super Giants','Kolkata Knight Riders'),
('Delhi Capitals','Royal Challengers Bengaluru','Royal Challengers Bengaluru','Royal Challengers Bengaluru','Delhi Capitals'),
('Punjab Kings','Rajasthan Royals','Rajasthan Royals','Rajasthan Royals','Punjab Kings'),
('Mumbai Indians','Sunrisers Hyderabad','Sunrisers Hyderabad','Mumbai Indians','Mumbai Indians'),
('Royal Challengers Bengaluru','Gujarat Titans','Gujarat Titans','Gujarat Titans','Royal Challengers Bengaluru'),
('Rajasthan Royals','Delhi Capitals','Delhi Capitals','Rajasthan Royals','Rajasthan Royals'),
('Mumbai Indians','Chennai Super Kings','Chennai Super Kings','Mumbai Indians','Mumbai Indians'),
('Punjab Kings','Gujarat Titans','Gujarat Titans','Gujarat Titans','Punjab Kings'),
('Sunrisers Hyderabad','Kolkata Knight Riders','Kolkata Knight Riders','Sunrisers Hyderabad','Sunrisers Hyderabad'),
('Lucknow Super Giants','Mumbai Indians','Mumbai Indians','Mumbai Indians','Lucknow Super Giants'),
('Delhi Capitals','Chennai Super Kings','Chennai Super Kings','Delhi Capitals','Delhi Capitals'),
('Sunrisers Hyderabad','Punjab Kings','Sunrisers Hyderabad','Punjab Kings','Sunrisers Hyderabad'),
('Lucknow Super Giants','Royal Challengers Bengaluru','Lucknow Super Giants','Royal Challengers Bengaluru','Lucknow Super Giants'),
('Delhi Capitals','Kolkata Knight Riders','Kolkata Knight Riders','Kolkata Knight Riders','Delhi Capitals'),
('Gujarat Titans','Rajasthan Royals','Gujarat Titans','Rajasthan Royals','Gujarat Titans'),
('Lucknow Super Giants','Chennai Super Kings','Chennai Super Kings','Chennai Super Kings','Lucknow Super Giants'),
('Mumbai Indians','Royal Challengers Bengaluru','Royal Challengers Bengaluru','Royal Challengers Bengaluru','Mumbai Indians'),
('Punjab Kings','Delhi Capitals','Delhi Capitals','Delhi Capitals','Punjab Kings'),
('Gujarat Titans','Sunrisers Hyderabad','Gujarat Titans','Sunrisers Hyderabad','Gujarat Titans'),
('Kolkata Knight Riders','Royal Challengers Bengaluru','Royal Challengers Bengaluru','Royal Challengers Bengaluru','Kolkata Knight Riders'),
('Punjab Kings','Mumbai Indians','Mumbai Indians','Mumbai Indians','Punjab Kings'),
('Chennai Super Kings','Lucknow Super Giants','Lucknow Super Giants','Lucknow Super Giants','Chennai Super Kings'),
('Kolkata Knight Riders','Gujarat Titans','Kolkata Knight Riders','Gujarat Titans','Kolkata Knight Riders'),
('Rajasthan Royals','Delhi Capitals','Delhi Capitals','Delhi Capitals','Rajasthan Royals'),
('Royal Challengers Bengaluru','Punjab Kings','Royal Challengers Bengaluru','Punjab Kings','Royal Challengers Bengaluru'),
('Chennai Super Kings','Sunrisers Hyderabad','Sunrisers Hyderabad','Chennai Super Kings','Chennai Super Kings'),
('Lucknow Super Giants','Rajasthan Royals','Rajasthan Royals','Rajasthan Royals','Lucknow Super Giants'),
('Mumbai Indians','Kolkata Knight Riders','Kolkata Knight Riders','Kolkata Knight Riders','Mumbai Indians'),
('Gujarat Titans','Chennai Super Kings','Gujarat Titans','Chennai Super Kings','Gujarat Titans'),
('Sunrisers Hyderabad','Royal Challengers Bengaluru','Sunrisers Hyderabad','Sunrisers Hyderabad','Sunrisers Hyderabad'),
('Lucknow Super Giants','Punjab Kings','Punjab Kings','Punjab Kings','Lucknow Super Giants'),
('Delhi Capitals','Kolkata Knight Riders','Delhi Capitals','Kolkata Knight Riders','Delhi Capitals'),
('Rajasthan Royals','Mumbai Indians','Rajasthan Royals','Mumbai Indians','Rajasthan Royals'),
('Royal Challengers Bengaluru','Gujarat Titans','Royal Challengers Bengaluru','Gujarat Titans','Royal Challengers Bengaluru'),
('Rajasthan Royals','Sunrisers Hyderabad','Rajasthan Royals','Sunrisers Hyderabad','Rajasthan Royals'),
('Rajasthan Royals','Gujarat Titans','Gujarat Titans','Rajasthan Royals','Rajasthan Royals'),
('Gujarat Titans','Royal Challengers Bengaluru','Royal Challengers Bengaluru','Royal Challengers Bengaluru','Gujarat Titans');
```

### 3.customer_orders_new_and_repeat_count
```sql

-- 1. Create the customer_orders table
CREATE TABLE customer_orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_amount NUMERIC(10, 2) NOT NULL
);

-- 2. Insert sample data
INSERT INTO customer_orders (order_id, customer_id, order_date, order_amount) 
VALUES
    (1, 100, '2022-01-01', 2000.00),
    (2, 200, '2022-01-01', 2500.00),
    (3, 300, '2022-01-01', 2100.00),
    (4, 100, '2022-01-02', 2000.00),
    (5, 400, '2022-01-02', 2200.00),
    (6, 500, '2022-01-02', 2700.00),
    (7, 100, '2022-01-03', 3000.00),
    (8, 400, '2022-01-03', 1000.00),
    (9, 600, '2022-01-03', 3000.00);
```

### 4. most visited floor data setup 

```sql
-- Create table with exact data types from screenshot
CREATE TABLE entries (
    name VARCHAR(20),
    address VARCHAR(20),
    email VARCHAR(20),
    floor INT,
    resources VARCHAR(10)
);

-- Insert sample data
INSERT INTO entries (name, address, email, floor, resources) 
VALUES
    ('A', 'Bangalore', 'A@gmail.com', 1, 'CPU'),
    ('A', 'Bangalore', 'A1@gmail.com', 1, 'CPU'),
    ('A', 'Bangalore', 'A2@gmail.com', 2, 'DESKTOP'),
    ('B', 'Bangalore', 'B@gmail.com', 2, 'DESKTOP'),
    ('B', 'Bangalore', 'B1@gmail.com', 2, 'DESKTOP'),
    ('B', 'Bangalore', 'B2@gmail.com', 1, 'MONITOR');
```
### 5. cancelled_trips_by_the_unbanned_users

```sql

-- Create Trips table
CREATE TABLE trips (
    id INT PRIMARY KEY,
    client_id INT,
    driver_id INT,
    city_id INT,
    status VARCHAR(50),
    request_at VARCHAR(50)
);

-- Insert data into Trips table
INSERT INTO trips (id, client_id, driver_id, city_id, status, request_at) VALUES
(1, 1, 10, 1, 'completed', '2013-10-01'),
(2, 2, 11, 1, 'cancelled_by_driver', '2013-10-01'),
(3, 3, 12, 6, 'completed', '2013-10-01'),
(4, 4, 13, 6, 'cancelled_by_client', '2013-10-01'),
(5, 1, 10, 1, 'completed', '2013-10-02'),
(6, 2, 11, 6, 'completed', '2013-10-02'),
(7, 3, 12, 6, 'completed', '2013-10-02'),
(8, 2, 12, 12, 'completed', '2013-10-03'),
(9, 3, 10, 12, 'completed', '2013-10-03'),
(10, 4, 13, 12, 'cancelled_by_driver', '2013-10-03');

-- Create Users table
CREATE TABLE users (
    users_id INT PRIMARY KEY,
    banned VARCHAR(50),
    role VARCHAR(50)
);

-- Insert data into Users table
INSERT INTO users (users_id, banned, role) VALUES
(1, 'No', 'client'),
(2, 'Yes', 'client'),
(3, 'No', 'client'),
(4, 'No', 'client'),
(10, 'No', 'driver'),
(11, 'No', 'driver'),
(12, 'No', 'driver'),
(13, 'No', 'driver');

```


