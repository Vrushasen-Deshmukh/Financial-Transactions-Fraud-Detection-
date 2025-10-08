SELECT * FROM transactions

EXEC sp_rename 'Transactions', 'transactions';

/*
Detecting Recursive Fraudulent Transactions

Q.1] Use a recursive CTE to identify potential money laundering chains
where money is transferred from one account to another across
multiple steps, with all transactions flagged as fraudulent.
*/

-- creating a CTE for fraud_chain
WITH fraud_chain AS (
SELECT 
	nameOrig AS initial_account,
	nameDest AS next_account,
	step,
	amount,
	newbalanceOrig
FROM transactions
WHERE isFraud = 1 AND type = 'TRANSFER'

UNION ALL

SELECT FC.initial_account,
T.nameOrig, T.step, T.amount, T.newbalanceOrig
FROM fraud_chain AS FC
JOIN transactions AS T
	ON FC.next_account = T.nameOrig 
   AND FC.step < T.step
WHERE T.isFraud = 1 AND T.type = 'TRANSFER'
)
SELECT * FROM fraud_chain


/*
Analyzing Fraudulent Activity over Time

Q.2] Use a CTE to calculate the rolling sum of fraudulent transactions for
each account over the last 5 steps.
*/

-- creating a CTE for rolling_fraud
WITH rolling_fraud AS (
	SELECT nameOrig, step, SUM(CAST(isFraud AS INT))
	OVER (PARTITION BY nameOrig ORDER BY step ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS fraud_rolling
	FROM transactions)
SELECT * FROM rolling_fraud
WHERE fraud_rolling > 0


/*
Complex Fraud Detection Using Multiple CTEs

Q.3] Use multiple CTEs to identify accounts with suspicious activity,
including large transfers, consecutive transactions without balance change, and
flagged transactions.
*/
-- creating a CTE for large_transactions
WITH large_transactions AS (
	SELECT nameOrig, step, amount
	FROM transactions
	WHERE amount > 500000 AND type = 'TRANSFER'
),
-- creating another CTE for consecutive transactions without balance change
no_balance_change AS (
	SELECT nameOrig, step, oldbalanceOrg
	FROM transactions
	WHERE oldbalanceOrg = newbalanceOrig
),
-- creating another CTE for flagged_transactions
flagged_transactions AS (
	SELECT nameOrig, step
	FROM transactions
	WHERE isFlaggedFraud = 1
)
SELECT LT.nameOrig
FROM large_transactions AS LT
JOIN no_balance_change AS NBC
	 ON LT.nameOrig = NBC.nameOrig AND LT.step = NBC.step
JOIN flagged_transactions FT
	 ON LT.nameOrig = FT.nameOrig AND LT.step = FT.step


/*
Q.4] Write me a query that checks if the computed new_updated_Balance
is the same as the actual newbalanceDest in the table. 
If they are equal, it returns those rows.
*/
-- Basically we have to check Amount + oldbalanceDest should be = newbalanceDest.
WITH NUB AS ( 
	SELECT amount, nameOrig, oldbalancedest, newbalanceDest,
	       (amount + oldbalanceDest) AS new_updated_balance
FROM transactions
)
SELECT * FROM NUB where new_updated_balance = newbalanceDest


/*
Detect Transactions with Zero Balance Before or After
Q.5] Find transactions where the destination account had a zero balance before or after the transaction.
Write a query to list transactions where oldbalanceDest or newbalanceDest is zero.
*/
SELECT * FROM transactions
WHERE oldbalanceDest = 0 OR newbalanceDest = 0
