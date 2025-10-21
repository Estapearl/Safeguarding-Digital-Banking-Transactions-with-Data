USE EuroTrust_FraudDB;
GO

/********************************************************************************************
    PROJECT: Fraud Risk Monitoring System — EuroTrust Bank
    SECTION: Fraud Detection & Alert Automation Queries
    PURPOSE:
        - To integrate transaction data with account-level behavior profiles.
        - To identify suspicious transactions using simple, explainable business rules.
        - To log and automate alerts for fraud risk monitoring.
********************************************************************************************/

------------------------------------------------------------
-- STEP 1: Check Table Structure
-- PURPOSE: Confirm that the necessary source tables exist and contain expected columns.
------------------------------------------------------------
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME IN ('eurotrust_transactions', 'Account_Profile');

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Account_Profile';

------------------------------------------------------------
-- STEP 2: Create FRAUD_ALERTS View
-- PURPOSE: Identify transactions that deviate from normal behavior or meet fraud risk signals.
-- NOTE: Thresholds (e.g. 3x average spend) are conservative and can be fine-tuned later.
------------------------------------------------------------

DROP VIEW IF EXISTS Fraud_Alerts;
GO

CREATE VIEW Fraud_Alerts AS
SELECT 
    t.Transaction_ID,
    t.Account_ID,
    t.Timestamp,
    t.AmountEUR,
    t.Channel,
    t.Country,
    t.Device_ID,
    t.Is_New_Beneficiary,
    a.Avg_Transaction_EUR,
    a.Fraud_Rate_Percent,
    CASE
        WHEN t.AmountEUR > a.Avg_Transaction_EUR * 3 THEN 'Unusually_Large_Transaction'
        WHEN t.Is_New_Beneficiary = 1 THEN 'New_Beneficiary_Transaction'
        WHEN a.Fraud_Rate_Percent > 5 THEN 'High_Risk_Account'
        ELSE NULL
    END AS Alert_Type
FROM eurotrust_transactions t
JOIN Account_Profile a
    ON t.Account_ID = a.Account_ID
WHERE 
    t.AmountEUR > a.Avg_Transaction_EUR * 3
    OR t.Is_New_Beneficiary = 1
    OR a.Fraud_Rate_Percent > 5;
GO

-- Preview first few alerts
SELECT TOP 10 * FROM Fraud_Alerts;

------------------------------------------------------------
-- STEP 3: Create FRAUD_ALERT_LOG Table
-- PURPOSE: Persist alerts for investigation and Power BI reporting.
------------------------------------------------------------
DROP TABLE IF EXISTS Fraud_Alert_Log;
GO

CREATE TABLE Fraud_Alert_Log (
    Transaction_ID NVARCHAR(50),
    Account_ID NVARCHAR(50),
    Timestamp DATETIME2,
    AmountEUR FLOAT,
    Channel NVARCHAR(50),
    Country NVARCHAR(50),
    Device_ID NVARCHAR(100),
    Is_New_Beneficiary BIT,
    Avg_Transaction_EUR FLOAT,
    Fraud_Rate_Percent NUMERIC(5,2),
    Alert_Type NVARCHAR(100),
    Logged_At DATETIME2 DEFAULT SYSDATETIME()
);
GO

-- Quick validation of structure
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Fraud_Alert_Log';

------------------------------------------------------------
-- STEP 4: Insert Alerts into FRAUD_ALERT_LOG
-- PURPOSE: Store current detected alerts into permanent log table.
------------------------------------------------------------

INSERT INTO Fraud_Alert_Log (
    Transaction_ID,
    Account_ID,
    Timestamp,
    AmountEUR,
    Channel,
    Country,
    Device_ID,
    Is_New_Beneficiary,
    Avg_Transaction_EUR,
    Fraud_Rate_Percent,
    Alert_Type
)
SELECT 
    Transaction_ID,
    Account_ID,
    Timestamp,
    AmountEUR,
    Channel,
    Country,
    Device_ID,
    Is_New_Beneficiary,
    Avg_Transaction_EUR,
    Fraud_Rate_Percent,
    Alert_Type
FROM Fraud_Alerts
WHERE Alert_Type IS NOT NULL;

-- Verify inserted records
SELECT TOP 10 *
FROM Fraud_Alert_Log
ORDER BY Logged_At DESC;

------------------------------------------------------------
-- STEP 5: Create Stored Procedure for Automated Fraud Checks
-- PURPOSE: Re-run alert detection and log only new transactions.
------------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_RunFraudCheck
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Fraud_Alert_Log (
        Transaction_ID,
        Account_ID,
        Timestamp,
        AmountEUR,
        Channel,
        Country,
        Device_ID,
        Is_New_Beneficiary,
        Avg_Transaction_EUR,
        Fraud_Rate_Percent,
        Alert_Type
    )
    SELECT 
        fa.Transaction_ID,
        fa.Account_ID,
        fa.Timestamp,
        fa.AmountEUR,
        fa.Channel,
        fa.Countr
