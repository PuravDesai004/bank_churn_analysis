-- bank credit card customer analysis
-- using the bank_crcard dataset i cleaned and imported from kaggle

SELECT * FROM bank_crcard;

-- total customers
SELECT COUNT(*) as total_customers
FROM bank_crcard;

-- customers with and without credit card
SELECT hascrcard, COUNT(*) as total
FROM bank_crcard
GROUP BY hascrcard;

-- percentage split
SELECT hascrcard, COUNT(*) as total,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bank_crcard), 2) as percentage
FROM bank_crcard
GROUP BY hascrcard;

-- customers who exited
SELECT exited, COUNT(*) as total,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bank_crcard), 2) as percentage
FROM bank_crcard
GROUP BY exited;

-- active vs inactive members
SELECT isactivemember, COUNT(*) as total,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bank_crcard), 2) as percentage
FROM bank_crcard
GROUP BY isactivemember;

-- customers by country
SELECT geography, COUNT(*) as total
FROM bank_crcard
GROUP BY geography
ORDER BY total DESC;

-- customers with above average credit score
SELECT customerid, creditscore
FROM bank_crcard
WHERE creditscore > (SELECT AVG(creditscore) FROM bank_crcard);

-- avg balance, credit score and salary by geography
SELECT geography,
ROUND(AVG(balance), 2) as avg_balance,
ROUND(AVG(creditscore), 2) as avg_creditscore,
ROUND(AVG(estimatedsalary), 2) as avg_salary
FROM bank_crcard
GROUP BY geography;

-- exited customers by gender
SELECT gender, exited, COUNT(*) as total
FROM bank_crcard
GROUP BY gender, exited
ORDER BY gender;

-- customers by number of products
SELECT numofproducts, COUNT(*) as total
FROM bank_crcard
GROUP BY numofproducts
ORDER BY numofproducts;

-- age group distribution
SELECT CASE
    WHEN age < 30 THEN 'Under 30'
    WHEN age BETWEEN 30 AND 40 THEN 'BTW 30 & 40'
    WHEN age BETWEEN 41 AND 50 THEN 'BTW 41 & 50'
    WHEN age BETWEEN 51 AND 60 THEN 'BTW 51 & 60'
    ELSE 'Above 60' END AS age_grp,
COUNT(*) as total
FROM bank_crcard
GROUP BY age_grp
ORDER BY age_grp;

-- customers with zero balance
SELECT COUNT(*) as zero_balance_customers,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bank_crcard), 2) as percentage
FROM bank_crcard
WHERE balance = 0;

-- top 10 customers by highest balance
SELECT customerid, surname, geography, balance
FROM bank_crcard
ORDER BY balance DESC
LIMIT 10;

-- churn rate by geography
SELECT geography,
COUNT(*) as total_customers,
SUM(CASE WHEN exited = 'Yes' THEN 1 ELSE 0 END) as exited,
ROUND(SUM(CASE WHEN exited = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as churn_rate_pct
FROM bank_crcard
GROUP BY geography;

-- churn rate by number of products
SELECT numofproducts,
COUNT(*) as total_customers,
SUM(CASE WHEN exited = 'Yes' THEN 1 ELSE 0 END) as exited,
ROUND(SUM(CASE WHEN exited = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as churn_rate_pct
FROM bank_crcard
GROUP BY numofproducts;

-- average tenure and balance: exited vs retained
SELECT exited,
ROUND(AVG(tenure), 2) as avg_tenure,
ROUND(AVG(balance), 2) as avg_balance
FROM bank_crcard
GROUP BY exited;

-- credit score buckets and churn rate
SELECT CASE
    WHEN creditscore < 500 THEN 'Poor'
    WHEN creditscore BETWEEN 500 AND 599 THEN 'Fair'
    WHEN creditscore BETWEEN 600 AND 699 THEN 'Good'
    WHEN creditscore BETWEEN 700 AND 799 THEN 'Very Good'
    ELSE 'Excellent' END AS credit_score_range,
COUNT(*) as total_customers,
SUM(CASE WHEN exited = 'Yes' THEN 1 ELSE 0 END) as exited,
ROUND(SUM(CASE WHEN exited = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as churn_rate_pct
FROM bank_crcard
GROUP BY credit_score_range
ORDER BY credit_score_range;