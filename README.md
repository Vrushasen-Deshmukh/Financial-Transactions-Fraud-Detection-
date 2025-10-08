# SQL-Project-8-Financial-Transactions-Fraud-Detection

# Overview
Fraud Detection in Financial Transactions using SQL: Queries and CTEs to identify suspicious transfers, large transactions, zero-balance destinations, and rolling fraud patterns in transactional data.

# Key Findings:
1. Detecting Recursive Fraudulent Transactions.
    - Use a recursive CTE to identify potential money laundering chains where money is transferred from one account to another across multiple steps, with all transactions flagged as fraudulent.
2. Analyzing Fraudulent Activity over Time.
    - Use a CTE to calculate the rolling sum of fraudulent transactions for each account over the last 5 steps
3. Complex Fraud Detection Using Multiple CTEs.
    - Use multiple CTEs to identify accounts with suspicious activity, including large transfers, consecutive transactions without balance change, and flagged transactions.
4. Cross Checking New Balance After Transaction.
    - Write me a query that checks if the computed new_updated_Balance is the same as the actual newbalanceDest in the table.  If they are equal, it returns those rows.
5. Detect Transactions with Zero Balance Before or After Transaction.
    - Find transactions where the destination account had a zero balance before or after the transaction. Write a query to list transactions where oldbalanceDest or newbalanceDest is zero.
