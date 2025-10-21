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
- [Account Profiling & Feature Engineering](https://github.com/Estapearl/Safeguarding-Digital-Banking-Transactions-with-Data/blob/main/Account_Profile_Build.sql)
