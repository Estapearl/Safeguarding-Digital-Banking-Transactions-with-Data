/*===============================================================
    PROJECT: Fraud Risk Monitoring System – EuroTrust Bank
    FILE: Account_Profile_Build.sql
    AUTHOR: Kasham Esther Bature
    DESCRIPTION:
        This script builds the Account_Profile table by aggregating
        customer transaction data to create behavioral and risk-based
        insights. It also includes segmentation logic to categorize
        accounts based on activity, spending, and fraud exposure.
================================================================*/

USE EuroTrust_FraudDB;
GO


/*---------------------------------------------------------------
  SECTION 1: BEHAVIORAL INSIGHTS BY CHANNEL
  Purpose:
    Analyze customer transaction behavior across different channels.
    Identify usage trends, average spending, and fraud rates.
----------------------------------------------------------------*/
SELECT 
    Channel,  -- Transaction access method (e.g., Mobile, Web, ATM, POS)
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(AmountEUR), 2) AS Total_Amount,
    ROUND(AVG(AmountEUR), 2) AS Avg_Amount,
    SUM(CASE WHEN FraudLabel = 1 THEN 1 ELSE 0 END) AS Fraud_Transactions,
    ROUND(100.0 * SUM(CASE WHEN FraudLabel = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS Fraud_Rate_Percent
FROM dbo.eurotrust_transactions
GROUP BY Channel
ORDER BY Total_Transactions DESC;


/*---------------------------------------------------------------
  SECTION 2: BUILD ACCOUNT PROFILE TABLE
  Purpose:
    Aggregate transactions by Account_ID to capture each customer’s
    behavioral baseline and risk summary.

  Output:
    - Total transaction count, value, and average
    - Spending variability (standard deviation)
    - Diversity of countries, devices, and beneficiaries
    - Fraud count and fraud rate percentage
----------------------------------------------------------------*/

-- Drop if exists (safe to re-run)
IF OBJECT_ID('dbo.Account_Profile','U') IS NOT NULL
    DROP TABLE dbo.Account_Profile;
GO

SELECT
    Account_ID,
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(AmountEUR), 2) AS Total_AmountEUR,
    ROUND(AVG(AmountEUR), 2) AS Avg_Transaction_EUR,
    ROUND(STDEV(AmountEUR), 2) AS Amount_StdDev,
    COUNT(DISTINCT Country) AS Countries_Used,
    COUNT(DISTINCT Device_ID) AS Devices_Used,
    COUNT(DISTINCT Beneficiary_Account) AS Beneficiaries_Used,
    SUM(CASE WHEN FraudLabel = 1 THEN 1 ELSE 0 END) AS Fraud_Transactions,
    ROUND(100.0 * SUM(CASE WHEN FraudLabel = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS Fraud_Rate_Percent
INTO dbo.Account_Profile
FROM dbo.eurotrust_transactions
GROUP BY Account_ID;
GO

-- Quick validation check
SELECT TOP 10 * 
FROM dbo.Account_Profile 
ORDER BY Total_AmountEUR DESC;


/*---------------------------------------------------------------
  SECTION 3: BEHAVIORAL RISK CATEGORIZATION
  Purpose:
    Assign a human-readable Risk_Category to each account based on
    fraud rate, transaction volume, and spending thresholds.

  Rules:
    - Fraud_Rate_Percent > 20  → High Fraud Risk
    - Total_AmountEUR > 100000 → High Spending Account
    - Total_Transactions > 15  → Unusually Active Account
    - Otherwise                → Normal
----------------------------------------------------------------*/

-- View categorization results
SELECT
    Account_ID,
    Total_Transactions,
    Total_AmountEUR,
    Avg_Transaction_EUR,
    Fraud_Transactions,
    Fraud_Rate_Percent,
    CASE 
        WHEN Fraud_Rate_Percent > 20 THEN 'High Fraud Risk'
        WHEN Total_AmountEUR > 100000 THEN 'High Spending Account'
        WHEN Total_Transactions > 15 THEN 'Unusually Active Account'
        ELSE 'Normal'
    END AS Risk_Category
FROM dbo.Account_Profile;


-- Summary distribution by Risk Category
SELECT
    Risk_Category,
    COUNT(*) AS Account_Count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM dbo.Account_Profile), 2) AS Percent_of_Accounts
FROM (
    SELECT
        Account_ID,
        CASE 
            WHEN Fraud_Rate_Percent > 20 THEN 'High Fraud Risk'
            WHEN Total_AmountEUR > 100000 THEN 'High Spending Account'
            WHEN Total_Transactions > 15 THEN 'Unusually Active Account'
            ELSE 'Normal'
        END AS Risk_Category
    FROM dbo.Account_Profile
) t
GROUP BY Risk_Category
ORDER BY Account_Count DESC;


/*---------------------------------------------------------------
  SECTION 4: FRAUD BEHAVIOR BY CHANNEL AND COUNTRY
  Purpose:
    Explore fraud distribution across transaction channels and
    countries to identify hotspots and high-risk combinations.
----------------------------------------------------------------*/

-- Fraud Rate by Transaction Channel
SELECT 
    Channel,
    COUNT(*) AS Total_Transactions,
    SUM(CASE WHEN FraudLabel = 1 THEN 1 ELSE 0 END) AS Fraud_Transactions,
    ROUND(100.0 * SUM(CASE WHEN FraudLabel = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS Fraud_Rate_Percent
FROM dbo.eurotrust_transactions
GROUP BY Channel
ORDER BY Fraud_Rate_Percent DESC;


-- Fraud Rate by Country
SELECT 
    Country,
    COUNT(*) AS Total_Transactions,
    SUM(CASE WHEN FraudLabel = 1 THEN 1 ELSE 0 END) AS Fraud_Transactions,
    ROUND(100.0 * SUM(CASE WHEN FraudLabel = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS Fraud_Rate_Percent
FROM dbo.eurotrust_transactions
GROUP BY Country
ORDER BY Fraud_Rate_Percent DESC;


-- Combined Channel + Country Fraud Hotspots
SELECT 
    Country,
    Channel,
    COUNT(*) AS Total_Transactions,
    SUM(CASE WHEN FraudLabel = 1 THEN 1 ELSE 0 END) AS Fraud_Transactions,
    ROUND(100.0 * SUM(CASE WHEN FraudLabel = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS Fraud_Rate_Percent
FROM dbo.eurotrust_transactions
GROUP BY Country, Channel
HAVING COUNT(*) > 100  -- Filter out rare combinations
ORDER BY Fraud_Rate_Percent DESC;
