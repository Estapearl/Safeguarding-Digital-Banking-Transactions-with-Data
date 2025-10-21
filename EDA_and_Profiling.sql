/*===============================================================
    PROJECT: Fraud Risk Monitoring System – EuroTrust Bank
    FILE: EDA_and_Profiling.sql
    AUTHOR: [Kasham Esther Bature]
    DESCRIPTION:
        This script performs exploratory data analysis (EDA)
        and structural profiling on the core transaction dataset
        (eurotrust_transactions) to understand data quality,
        transaction coverage, and basic behavioral distributions.
================================================================*/

USE EuroTrust_FraudDB;
GO

/*---------------------------------------------------------------
  1. QUICK DATA SAMPLE
  Purpose: View the first few records to understand table structure
----------------------------------------------------------------*/
SELECT TOP 20 *
FROM eurotrust_transactions;


/*---------------------------------------------------------------
  2. TABLE STRUCTURE INSPECTION
  Purpose: Retrieve column names, data types, max lengths, and nullability
----------------------------------------------------------------*/
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH, 
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'eurotrust_transactions';


/*---------------------------------------------------------------
  3. EXPLORATORY DATA UNDERSTANDING
  Purpose: Check overall dataset size, time coverage, and unique accounts
----------------------------------------------------------------*/
SELECT 
    COUNT(*) AS Total_Rows,
    MIN(Timestamp) AS Start_Date,
    MAX(Timestamp) AS End_Date,
    COUNT(DISTINCT Account_ID) AS Unique_Accounts
FROM eurotrust_transactions;


/*---------------------------------------------------------------
  4. MISSING VALUE ASSESSMENT
  Purpose: Identify null or missing values across major columns
----------------------------------------------------------------*/
SELECT 
    SUM(CASE WHEN AmountEUR IS NULL THEN 1 ELSE 0 END) AS Null_Amount,
    SUM(CASE WHEN Channel IS NULL THEN 1 ELSE 0 END) AS Null_Channel,
    SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS Null_Country,
    SUM(CASE WHEN Device_ID IS NULL THEN 1 ELSE 0 END) AS Null_Device,
    SUM(CASE WHEN Transaction_Type IS NULL THEN 1 ELSE 0 END) AS Null_TransactionType,
    SUM(CASE WHEN Status IS NULL THEN 1 ELSE 0 END) AS Null_Status,
    SUM(CASE WHEN Is_New_Beneficiary IS NULL THEN 1 ELSE 0 END) AS Null_NewBeneficiary,
    SUM(CASE WHEN FraudLabel IS NULL THEN 1 ELSE 0 END) AS Null_FraudLabel
FROM eurotrust_transactions;


/*---------------------------------------------------------------
  5. TRANSACTION CHANNEL DISTRIBUTION
  Purpose: Identify the most frequently used transaction channels
----------------------------------------------------------------*/
SELECT 
    Channel, 
    COUNT(*) AS Transaction_Count
FROM eurotrust_transactions
GROUP BY Channel
ORDER BY Transaction_Count DESC;


/*---------------------------------------------------------------
  6. COUNTRY DISTRIBUTION
  Purpose: Review transaction activity by country
----------------------------------------------------------------*/
SELECT 
    Country, 
    COUNT(*) AS Transactions
FROM eurotrust_transactions
GROUP BY Country
ORDER BY Transactions DESC;


/*---------------------------------------------------------------
  7. FRAUD FREQUENCY OVERVIEW
  Purpose: Summarize distribution of fraudulent vs non-fraudulent transactions
----------------------------------------------------------------*/
SELECT 
    FraudLabel, 
    COUNT(*) AS Transaction_Count
FROM eurotrust_transactions
GROUP BY FraudLabel;


/*---------------------------------------------------------------
  8. TRANSACTION AMOUNT RANGE ANALYSIS
  Purpose: Review minimum, maximum, and average transaction values
----------------------------------------------------------------*/
SELECT 
    ROUND(MIN(AmountEUR), 2) AS Min_Amount,
    ROUND(MAX(AmountEUR), 2) AS Max_Amount,
    ROUND(AVG(AmountEUR), 2) AS Avg_Amount
FROM eurotrust_transactions;


/*---------------------------------------------------------------
  9. ACCOUNT ACTIVITY DISTRIBUTION
  Purpose: Assess how active different accounts are based on transaction count
----------------------------------------------------------------*/
SELECT 
    COUNT(Transaction_ID) AS Transactions_Per_Account
FROM eurotrust_transactions
GROUP BY Account_ID
ORDER BY Transactions_Per_Account DESC;
