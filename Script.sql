CREATE TABLE credit_card_clients (
	CLIENTNUM INT,
    Attrition_Flag VARCHAR(50),
    Customer_Age INT,
    Gender VARCHAR(10),
    Dependent_count INT,
    Education_Level VARCHAR(50),
    Marital_Status VARCHAR(50),
    Income_Category VARCHAR(50),
    Card_Category VARCHAR(50),
    Months_on_book INT,
    Total_Relationship_Count INT,
    Months_Inactive_12_mon INT,
    Contacts_Count_12_mon INT,
    Credit_Limit FLOAT,
    Total_Revolving_Bal INT,
    Avg_Open_To_Buy FLOAT,
    Total_Amt_Chng_Q4_Q1 FLOAT,
    Total_Trans_Amt INT,
    Total_Trans_Ct INT,
    Total_Ct_Chng_Q4_Q1 FLOAT,
    Avg_Utilization_Ratio FLOAT
    )
    
-- Средний кредитный лимит по возрасту:
select
	Customer_Age, 
	ROUND(AVG(Credit_Limit)::numeric,2) as AVG_Credit_Limit
from credit_card_clients
group by Customer_Age
ORDER BY AVG_Credit_Limit DESC

-- Распределение клиентов по уровню дохода и активности:
select
	Income_Category,
	COUNT(clientnum) as Total_Clients,
	ROUND(AVG(months_inactive_12_mon)::numeric, 2) as avg_inactive
from
	credit_card_clients
group by
	Income_Category

	
--Топ категорий карт по числу транзакций: 
select 
	card_category,
	SUM(total_trans_ct) as  SUM_total_trans
from credit_card_clients
group by card_category 
order by SUM_total_trans desc


-- Анализ оттока клиентов
select
	COUNT(clientnum) as Total_Clients,
	ROUND((SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 2) AS Churn_Rate_Percent
FROM credit_card_clients


-- Зависимость кредитного лимита от дохода и семейного положения
select
	marital_status,
	Income_Category,
	ROUND(AVG(credit_limit)::numeric, 2) as avg_credit_limit
from credit_card_clients
group by marital_status, Income_Category
order by avg_credit_limit DESC


-- Анализ утилизации кредитного лимита
SELECT 
  ROUND(Avg_Utilization_Ratio * 100) AS Utilization_Percent,
  COUNT(*) AS Clients,
  ROUND(AVG(Total_Trans_Amt)::numeric, 2) AS Avg_Spending
FROM credit_card_clients
GROUP BY Utilization_Percent
ORDER BY Utilization_Percent

-- Сравнение оттока о полу и возросту
SELECT 
	gender,
    CASE 
        WHEN customer_age < 35 THEN '18-34'
        WHEN customer_age BETWEEN 35 AND 50 THEN '35-50'
        ELSE '50+'
    END AS Age_Group,
    ROUND(SUM(CASE WHEN attrition_flag = 'Attrited Customer' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM 
    credit_card_clients
GROUP BY gender, Age_Group
ORDER BY Churn_Rate DESC