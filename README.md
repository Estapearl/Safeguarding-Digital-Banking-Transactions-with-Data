# Safeguarding-Digital-Banking-Transactions-with-Data
## Enhancing Fraud Risk Detection in Digital Banking Using SQL and Power BI

## Project Background

EuroTrust Bank, a fast-growing digital financial institution headquartered in **Frankfurt, Germany, provides online banking and payment services to both retail and SME customers across France, the Netherlands, Spain, and Italy.**

As EuroTrust expanded its digital footprint, the volume of online and mobile transactions surged but so did cases of **fraudulent transfers, identity theft, and money-mule activities.** Over a two-year period (2023–2024), the bank’s fraud team noticed a consistent rise in suspicious transaction behaviors, especially involving new beneficiaries and high-value transfers across borders.

These challenges were creating significant financial losses and operational strain on the compliance and risk management teams. Manual monitoring processes were too slow to detect fast-moving fraud rings, and existing rule-based systems lacked the behavioral intelligence needed to identify new or evolving threats.

To address this, the bank’s data analytics unit was tasked with building a **Fraud Risk Monitoring System** capable of profiling customer behavior, detecting anomalies, and generating fraud alerts automatically.

Using SQL for data modeling and Power BI for visualization, transaction data was analyzed to uncover key risk patterns, design rule-based fraud checks, and visualize potential red flags for continuous monitoring.

## Key Analytical Focus Areas

- **Customer Behavior Profiling:** Each account’s transaction history was summarized to uncover normal spending patterns, activity frequency, and past fraud rates. This allowed the team to segment accounts into High Fraud Risk, High Spending, or Unusually Active categories.

- **Anomaly and Pattern Detection:** Transaction data was analyzed across channels, countries, and devices to spot trends such as abnormal spikes in spending, multiple beneficiaries added in a short time, or sudden changes in transaction location.

- **Rule-Based Fraud Flagging:** Business-driven SQL rules were designed to automatically flag transactions that breached behavioral norms — for example, high-value transfers from risky accounts or large payments to new beneficiaries.

- **Operational Monitoring and Risk Reporting:** Power BI dashboards were built to visualize fraud risk distribution by country, channel, and account category. These dashboards provided real-time visibility for compliance teams to monitor alerts and identify emerging threats.

The SQL scripts used for data preparation, profiling, and fraud detection are available in the project repository:
- [Data Cleaning & Exploration](EDA_and_Profiling.sql)
- [Account Profiling & Feature Engineering](Account_Profile_Build.sql)
- [Fraud Detection Rules & Alert Logging](Fraud_Alert_Log_System.sql)

## Executive Summary

## Fraud Intelligence System Design
As part of building a practical fraud detection system, two key analytical layers were developed in SQL **Account Risk Profiling and Fraud Alert Monitoring.**
These layers formed the foundation for understanding customer behavior and automatically flagging suspicious transactions before they could escalate into losses.

### Account Risk Profiling

The Account_Profile table was created to summarize customer behavior at the account level. Rather than viewing transactions individually, this layer aggregates each customer’s history; total transactions, average amounts, fraud frequency and activity across countries, devices, and beneficiaries. This provides the **Compliance and Fraud Investigation units** with a clearer picture of customer patterns and potential anomalies.

By profiling accounts this way, the team can easily identify customers with unusual or high-risk activity, such as excessive cross-border usage or recurring fraudulent transactions. It also supports risk segmentation, helping management prioritize monitoring resources where they are most needed.

### Fraud Alert Monitoring System

The Fraud_Alert_Log serves as an automated surveillance layer that records transactions showing suspicious or high-risk characteristics.
This view and table work together to flag unusual behaviors — for example, large transactions far above normal averages, new beneficiary accounts, or activity linked to accounts with elevated fraud rates.

These alerts are automatically logged and time-stamped, creating a continuous feedback loop for the Risk and Compliance teams to review, investigate, and take timely action.
The result is a system that supports proactive fraud monitoring, reduces manual workload, and ensures that no high-risk pattern goes unnoticed.

### Why This Matters 
In banking or payment operations, time is everything when it comes to fraud. By engineering these SQL-based systems, a scalable analytical foundation that could support real-time fraud monitoring, customer risk scoring, and automated alerting was created, all using data-driven logic built directly from the organization’s transaction system.

## Overview of Findings

The analysis showed that most fraud happened through digital channels, especially on mobile and web platforms. This means the bank needs stronger checks and security in these areas.

I also found that a few customer accounts had repeated high fraud activity, which points to patterns that the compliance team should watch closely.
Finally, the new fraud alert system proved that automated checks can save time and make it easier to spot and respond to suspicious transactions quickly.
### Insights Deep Dive

#### Dashboard 1: Executive Fraud Overview

The Executive Dashboard provides a snapshot of EuroTrust’s overall fraud exposure across digital and physical channels. Out of **80,000** total transactions, **3,649** were flagged representing a **4.6%** fraud rate.

Fraud was concentrated in **mobile (1,782) and web (925) transactions,** highlighting increased vulnerability in online channels.
Although 95% of flagged transactions were completed, only a small proportion were stopped or reversed, suggesting that most fraudulent activity slips through before detection.

Across countries, **Germany, France, and the Netherlands** recorded the highest fraud volumes, while monthly trends remained consistent throughout the year reinforcing that fraud risk is continuous and not seasonal.

<img src="https://github.com/Estapearl/Safeguarding-Digital-Banking-Transactions-with-Data/blob/main/EuroTrust%20Executive%20Dashboard.png" width="800"> 

#### Dashboard 2: Account Risk Insight

This dashboard explores how individual customer accounts behave and how those behaviors relate to fraud risk. Using features engineered in SQL such as each account’s total transactions, average transaction size, and historical fraud rate. This dashboard highlights where the highest risks lie across EuroTrust’s customer base.

Out of all analyzed accounts, **2,043 were classified as high-risk,** showing patterns of unusually frequent or large transactions. The average transaction amount was **€464,** and the overall account-level fraud rate stood at **4.74%.**

A deeper look revealed that while most customers (around 80%) maintained a low-risk profile, a small fraction showed extreme behaviors for example, **accounts EUACCT14631 and EUACCT15552** had a 100% fraud rate across five transactions each, a strong indicator of potential misuse or compromised accounts.

From a business standpoint, this dashboard allows Compliance and Risk teams to:

- Identify the small group of customers driving most of the fraud exposure,

- Prioritize investigations using data-backed risk categories (low, moderate, high, critical), and

- Strengthen monitoring rules around transaction frequency and size for early detection.


### Dashboard View:
[🔗 Click here to view the Account Risk Insight Dashboard](https://github.com/Estapearl/Safeguarding-Digital-Banking-Transactions-with-Data/blob/main/EuroTrust%20Account%20Risk%20Insight.png)

#### Dashboard 3: Fraud Alert Monitoring

This dashboard focuses on real-time fraud detection and alert tracking, summarizing how many transactions were flagged by the system and which risk categories triggered those alerts. It provides an operational view for the Risk and Compliance teams to monitor live threats and review alert trends.

Across all transactions analyzed, the system generated **36,000 alerts,** of which **12,000** were classified as high-risk. The most recent alert was logged on **December 31, 2024, at 11:35:56 PM,** showing that the fraud monitoring process remains active through year-end.

In terms of distribution, mobile transactions accounted for nearly half **(49.5%)** of all alerts, followed by web channels (25.5%), confirming that digital channels remain the primary targets for fraud attempts. The majority of alerts **(62.6%)** were triggered by new beneficiary transactions, followed by high-risk amount alerts **(34.3%)** and unusually large transactions **(3.1%)** indicating that fraudsters often exploit beneficiary changes more than transaction size alone.

From a business perspective, this dashboard enables teams to:

- Monitor fraud activity in near real time,

- Track which alert rules generate the most cases, and

- Quickly prioritize high-risk alerts for investigation before financial losses occur.
  
  ### Dashboard View
[🔗 Click here to view the Fraud Alert Monitoring Dashboard](https://github.com/Estapearl/Safeguarding-Digital-Banking-Transactions-with-Data/blob/main/EuroTrust%20Fraud%20Alert%20Monitoring.png)


