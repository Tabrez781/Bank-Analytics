use principal;
select * from finance_2;
select * from finance_1;
SELECT STR_TO_DATE(issue_d, '%Y-%m-%d %H:%i:%s') AS converted_datetime from finance_1;
SELECT year(ISSUE_D) AS ISSUE_YEARS from finance1;
SELECT STR_TO_DATE(issue_d, '%d %M %Y') AS converted_date from finance_1;
SELECT YEAR(STR_TO_DATE(issue_d, '%d-%m-%Y')) AS year_value FROM finance_1;


# KPI 1 - YEAR WISE LOAN AMOUNT STATUS
SELECT YEAR(STR_TO_DATE(issue_d, '%d-%m-%Y')) AS year_value, 
SUM(LOAN_AMNT) AS TOTAL_AMOUNT 
FROM finance_1 
group by year_value
ORDER BY TOTAL_AMOUNT DESC;

# WITH ALL YEAR TOTAL 
SELECT issue_years, SUM(total_amount) AS total_amount
FROM (
    SELECT Year(issue_d) AS issue_years, SUM(loan_amnt) AS total_amount
    FROM finance_1
    GROUP BY issue_years
    UNION ALL
    SELECT 'All Years' AS issue_years, SUM(loan_amnt) AS total_amount
    FROM finance_1
) combined
GROUP BY issue_years
ORDER BY issue_years;


# KPI 2 - GRADE & SUB GRADE WISE REVOL_BALANCE
ALTER TABLE finance_2 
RENAME COLUMN ï»¿id TO ID;
SELECT F1.GRADE, F1.SUB_GRADE, SUM(F2.REVOL_BAL) AS REVOLVING_BAL
FROM finance_1 AS F1 INNER JOIN finance_2 AS F2
ON F1.ID = F2.ID
GROUP BY F1.GRADE, F1.sub_grade 
ORDER BY F1.GRADE;


#KPI 3 - TOTAL PAYMENT FOR VERIFIED VS NON VERIFIED STATUS
select f1.verification_status, sum(f2.total_pymnt) as total_payment
from finance_1 as f1 inner join finance_2 as f2
on f1.id = f2.id
group by f1.verification_status;


# KPI 4 - STATEWISE & MONTHWISE LOAN STATUS
SELECT FN1.ADDR_STATE AS STATE, FN2.LAST_PYMNT_D, FN1.LOAN_STATUS AS LOAN_STATUS,
COUNT(*) AS LOANCOUNT 
FROM finance_1 AS FN1
JOIN finance_2 AS FN2
ON FN1.ID = FN2.ID
GROUP BY FN1.ADDR_STATE, FN2.last_pymnt_d, FN1.loan_status
ORDER BY FN1.ADDR_STATE, FN2.last_pymnt_d, FN1.loan_status;


# KPI 5 - HOME OWNERSHIP VS LAST PAYMENT DATE STATS
SELECT YEAR(STR_TO_DATE(issue_d, '%d-%m-%Y')) AS PAYMENT_YEAR,
MONTHNAME(STR_TO_DATE(issue_d, '%d-%m-%Y')) AS PAYMENT_MONTH,
F1.HOME_OWNERSHIP, COUNT(F1.HOME_OWNERSHIP) AS HOME_OWNERSHIP FROM FINANCE_1 
AS F1 INNER JOIN FINANCE_2 AS F2
ON F1.ID = F2.ID
WHERE HOME_OWNERSHIP IN ('RENT', 'MORTGAGE', 'OWN', 'OTHERS')
GROUP BY PAYMENT_YEAR, PAYMENT_MONTH, F1.HOME_OWNERSHIP
ORDER BY PAYMENT_YEAR, HOME_OWNERSHIP DESC;









