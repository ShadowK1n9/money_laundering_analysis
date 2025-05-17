-- Top 10 countries by number of transactions
SELECT 
    c.country_name, 
    COUNT(*) AS Total_Transactions
FROM transactions t JOIN country c
ON t.country_id = c.country_id
GROUP BY Country_name
ORDER BY Total_Transactions DESC
LIMIT 10;
/*
    - China leads the list with the highest number of transactions, slightly above 1,000.
    - The rest of the countries — South Africa, UK, Brazil, Russia, Singapore, India, Switzerland, UAE, and USA — 
      have similar numbers of transactions, all close to 1,000, with the USA having the lowest among the top 10.
    - The distribution is quite balanced among the top 10, meaning that no single country dominates entirely, 
      though China stands out slightly.
    - These countries are likely hotspots for financial movements, potentially related to black money or 
      illegal financial activities, which could be driven by the size of their economies or the presence of financial hubs.
*/
-- Top 10 countries by total transaction value
SELECT 
    c.country_name,
    FORMAT(SUM(amount),0) AS Total_Transaction_Amount
FROM transactions t JOIN country c
ON t.country_id = c.country_id
GROUP BY country_name
ORDER BY Total_Transaction_Amount DESC
LIMIT 10;
/*
    - China, South Africa, and the UK appear at the top in both charts, indicating that these countries not only have a 
    high number of transactions but also large total transaction values. This suggests that significant financial activities are 
    occurring in these countries, both in terms of volume and monetary value.
    - The number of transactions is relatively consistent across the top 10 countries. 
        This indicates that these countries are likely to be major players in the global financial system, 
        with a high volume of transactions taking place. 
    - USA and UAE rank lower in both tables, meaning they have fewer transactions and lower total amounts 
    compared to the other countries in the top 10. 
    - This could be due to various factors, such as regulatory environments, economic conditions, 
    or the nature of financial activities in these countries.
*/


-- Which countries have the highest volume and total value of high-risk transactions (risk score >= 7)
SELECT
    c.Country_Name,
    Count(Money_Laundering_Risk_Score) AS High_risk_transactions
FROM
    transactions t JOIN country c
ON t.country_id = c.country_id
WHERE Money_Laundering_Risk_Score >= 7
GROUP BY Country_Name
ORDER BY High_risk_transactions DESC;

-- According to the results, the country with the highest volume of high-risk transactions was Brazil, 
-- followed closely by South Africa, Singapore, India and China.
-- This indicates that these countries are potentially more susceptible to money laundering activities,
-- and may require increased scrutiny and monitoring of financial transactions to prevent illicit activities.



-- How do risk scores vary by industry or transaction type?
SELECT
    i.Industry_Name,
    ROUND(AVG(Money_Laundering_Risk_Score),0) AS Average_Risk_Score
FROM transactions t JOIN industry i
ON t.industry_id = i.industry_id
GROUP BY Industry_Name
ORDER BY Average_Risk_Score DESC;

SELECT
    tt.transaction_type,
    ROUND(AVG(Money_Laundering_Risk_Score),0) AS Average_Risk_Score
FROM transactions t JOIN transaction_type tt
ON t.Transaction_Type_ID = tt.Transaction_Type_ID
GROUP BY transaction_type
ORDER BY Average_Risk_Score DESC;

-- Results showed that the average risk score for most of the industries were between 5 and 6, 
-- this indicates that the transactions in these industries are relatively medium risk.



-- What Percentage of trasactions were reported by authorities, and what's the average risk score among them?

SELECT 
  Reported_by_Authority,
  COUNT(*) AS Total_Transactions,
  ROUND(AVG(Money_Laundering_Risk_Score), 0) AS Average_Risk_Score,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS Percentage_Reported
FROM 
  transactions
GROUP BY 
  Reported_by_Authority
ORDER BY 
  Percentage_Reported DESC;


-- Result showed that out of the 10,000 transactions carried out, only 20% were reported by authorities,
-- and the average risk score of these transactions was 6. This indicates that a majority of the transactions were not reported,
-- and the ones that were reported had a relatively high risk score, suggesting that they were potentially suspicious or involved in money laundering activities.
-- This highlights the need for better reporting mechanisms and increased scrutiny of high-risk transactions to prevent money laundering and other financial crimes. 


-- Are there specific industries frequenltly involved in high-risk transactions?
SELECT 
    i.industry_name,
    COUNT(*) AS Total_Transactions
FROM transactions t JOIN industry i
ON t.Industry_ID = i.Industry_ID
WHERE Money_Laundering_Risk_Score >= 7
GROUP BY Industry_name
ORDER BY Total_Transactions DESC;

-- finance leads with the highest number of high-risk transactions, slightly above 630 transactiosn.
-- followed closely by arms trade, and construction with 612 and 611 transactions respectiely.
-- The rest of the industries - real estate, luxury goods, casinos, oil and gas
-- have similar number of high-risk transactions, all below 600, with Oil and gas having the lowest number of transactions at 532.
-- This indicates that these industries are potentially more susceptible to money laundering activities,
-- and may require increased scrutiny and monitoring of financial transactions to prevent illicit activities.

-- What destination countries are most commonly involved in high-risk or reported transactions?
SELECT 
    dc.destination_country_name,
    COUNT(*) AS Total_Transactions
FROM transactions t JOIN destination_country dc
ON t.Destination_Country_ID = dc.Destination_Country_ID
WHERE 
Money_Laundering_Risk_Score >= 7
OR Reported_by_Authority = 'True'
OR source_of_money = 'Illegal'
GROUP BY Destination_Country_Name
ORDER BY Total_Transactions DESC;

/*
    - Based on the results, the United States leads, followed closely by India and Russia. Other nations like South Africa, Singapore,
    UAE also appear among the top destinations. This pattern shows that these countries are central hubs in the flow of transactions 
    tagged as high risk, this indicates where significant attention may be warranted.

    - To address this findings, it is recommended to enhance monitoring efforts specificially for transactions routed to these countries.
    Further investigation into the nature of the activities within these juridictions is crucial to understand the undelying reason for their
    prominence. 

*/

-- Are there observable trends in black money flow across tax haven countries over time?

SELECT
    th.tax_haven_country_name,
    YEAR(transaction_date) AS Transact_Year,
    MONTH(transaction_date) as Transact_month,
    COUNT(*) AS Total_Transactions
FROM transactions t JOIN tax_haven_country th
ON t.Tax_Haven_Country_ID = th.Tax_Haven_Country_ID
GROUP BY Tax_Haven_Country_Name, transact_year, Transact_month
ORDER BY  transact_year, transact_month, Total_Transactions DESC;

-- What industries or sectors are disproportionately involved in suspicious transactions globally?
-- To answer this question, I will break it down into three parts:
-- 1. industries with transactions as reported by authorities
SELECT 
    i.industry_name,
    COUNT(*) AS Total_transactions,
    ROUND(AVG(money_laundering_risk_score),0) AS Average_Risk_Score
FROM transactions t JOIN industry i
ON t.Industry_ID = i.Industry_ID
WHERE Reported_by_Authority = 'True'
GROUP BY Industry_name
ORDER BY Total_transactions DESC;
/*
    - Luxury goods and casinos lead the list with the highest number of transactions reported by authorities,
      slightly above 300 transactions each and with an average risk score of 6 and 5 respectively.
    - The rest of the industries - finance, real estate, arms trade, oil and gas, and construction
      have similar number of transactions, all ranging between 268 and 284, with construction having the lowest
      number of transactions at 268. The average risk score for these industries is also similar, all between 5 and 6.
    - This indicates that the transactions in these industries are relatively medium risk.
    - Recognizing these industries as high-risk sectors is crucial for regulatory authorities and 
      financial institutions to implement effective monitoring and compliance measures.
    - This can help in identifying and mitigating potential money laundering activities,
      and ensuring that the financial system is not exploited for illicit purposes.
*/
-- 2. Inustries with transactions involving more than one shell companies
SELECT 
    i.industry_name,
    COUNT(*) AS Total_transactions,
    ROUND(AVG(shell_company_involved)) Avg_num_of_Shell_Companies
FROM transactions t JOIN industry i
ON t.industry_id = i.industry_id
WHERE Shell_Company_Involved > 0
GROUP BY Industry_name
ORDER BY Total_transactions DESC;
/*
    - Finance lead the list with the highest number of transactions involving shell companies, with 1336 transactions.
    - This is followed by luxury goods and real estate with 1299 and 1297 transactions respectively.
    - The rest of the industries - construction arms trade, casinos, and oil and gas
      have similar number of transactions, all ranging between 1219 and 1295, 
      with oil and gas having the lowest number of transactions at 1219.
    - The average number of shell companies involved in these transactions is 5 for all the industries.
*/



-- 3. Industries with transactions involving illegal source of money
SELECT
    i.industry_name,
    count(*) AS Total_transactions,
    COUNT(CASE WHEN source_of_money = 'Illegal' THEN 1 END) AS Total_illegal_Money_Src_Transact,
    ROUND(COUNT(CASE WHEN source_of_money = 'Illegal' THEN 1 END)
    /COUNT(*) * 100,2) AS Pct_Illegal_Money_Src_Transact
FROM transactions t JOIN industry i
ON t.Industry_ID = i.Industry_ID
GROUP BY Industry_name
ORDER BY Total_transactions DESC;

/*
- Casinos have the highest percentage of transactions linked to illegal money sources (72.19%), 
  followed closely by luxury goods, arms trade, and oil & gas, each exceeding 70%. Finance, real estate, 
  and construction also show significant involvement in illicit financial activities, 
  likely due to their complex transaction structures.
- To combat illegal-money-source transactions, stricter regulations, 
  advanced fraud detection, and better cooperation between businesses 
  and law enforcement are essential. Companies should prioritize 
  transparency through audits, whistleblower programs, and ethical practices. 
- Public awareness and employee training can help spot suspicious activities, 
  while specialized financial crime units and predictive analytics strengthen enforcement. 
- A mix of regulation, technology, accountability, and vigilance is key to reducing illicit financial flows.
*/

-- Are specific transaction types more likely to be used in high-risk activities?
SELECT
    year(Transaction_Date) as transaction_year,
    month(transaction_date) as transaction_month,
    tt.transaction_type,
    COUNT(*) AS Total_Transactions
FROM transactions t join transaction_type tt
ON t.Transaction_Type_ID = tt.Transaction_Type_ID
WHERE Money_Laundering_Risk_Score >= 7
GROUP BY transaction_year, transaction_month, Transaction_Type
ORDER BY transaction_year, transaction_month, total_transactions DESC;

/*
The results reveals consistent monthly activity with notable peaks in 
June and December, suggesting seasonal spikes, possibly due to mid-year and 
year-end spending patterns. Cash withdrawals and POS payments dominate
transaction types, indicating heavy reliance on physical and in-person transactions. 
However, there is a gradual uptick in online transfers, reflecting a shift toward digital banking.
To optimize service delivery and security, financial institutions should strengthen digital infrastructure, 
especially during peak periods, promote secure digital transaction options, and tailor customer engagement 
strategies around high-activity months.
*/

-- Are there particular time periods (month, year) with spikes in flagged or high-risk transactions?
SELECT
    YEAR(transaction_date) AS transaction_year,
    MONTH(transaction_date) AS transaction_month,
    COUNT(*) AS Total_Transactions
FROM transactions
WHERE Money_Laundering_Risk_Score >= 7
GROUP BY transaction_year, transaction_month
ORDER BY transaction_year, transaction_month, Total_Transactions DESC;

/*
The results reveals that January 2013 experienced the highest volume of flagged or high-risk transactions (334), 
suggesting a possible surge in illicit financial activity at the start of the year, potentially linked to post-holiday laundering 
or fiscal year openings. Transaction volumes remained relatively stable throughout 2013, with slight increases observed in October and December, 
hinting at end-of-year financial manipulation. A notable drop occurred in February 2014 (182 transactions), which may reflect improved monitoring, 
seasonal variation, or a reporting anomaly. 
*/



-- Are there emerging patterns of black money movement from certain regions to known tax havens?
-- Transactions involving tax haven countries:
SELECT 
    COUNT(*) AS Total_Tax_Haven_Transactions,
    -- Count transactions with ≥1 shell company
    COUNT(CASE WHEN Shell_Company_Involved >= 1 THEN 1 END) AS Transactions_With_Shell_Companies,
    -- Calculate percentage
    ROUND(
        (COUNT(CASE WHEN Shell_Company_Involved >= 1 THEN 1 END) * 100.0 / COUNT(*)), 
        2
    ) AS Shell_Company_Percentage
FROM transactions
WHERE Tax_Haven_Country_ID IS NOT NULL;

/*
The results revealed that 89% of tax haven transactions involve shell companies.
*/
-- Number of transactions and total amount from each country to tax havens:
SELECT 
    c.country_name,
    th.tax_haven_country_name,
    COUNT(*) AS Total_Transactions,
    FORMAT(SUM(Amount),0) AS Total_Transaction_Amount,
    ROUND(AVG(Money_Laundering_Risk_Score),0) AS Average_Risk_Score
FROM transactions t JOIN country c 
ON t.Country_ID = c.country_id
JOIN tax_haven_country th 
ON t.Tax_Haven_Country_ID = th.Tax_Haven_Country_ID
WHERE Tax_Haven_Country_name IS NOT NULL
GROUP BY Country_Name, Tax_Haven_Country_Name
ORDER BY Total_Transaction_Amount DESC; 
/*
 - The analysis reveals a clear pattern of black money movements from specific countries to known tax havens. Countries like China, Brazil,
   South Africa, Singapore, and the UK consistently appear among the top sources of transactions to tax havens such as Panama, Luxembourg, 
   the Cayman Islands, Switzerland, the Bahamas, and Singapore. These destinations frequently receive high volumes and large amounts of suspicious transactions. 
 - Notably, China alone appears multiple times, sending funds to several tax havens with average risk scores between 5 and 6, suggesting repeated high-risk activity. 
 - This pattern points to a systemic use of certain tax havens by specific regions, likely facilitated by weak regulatory oversight and complex financial structuring.
*/

-- Top tax haven by total amount
SELECT 
    th.tax_haven_country_name,
    FORMAT(SUM(Amount),0) AS Total_Transaction_Amount
FROM transactions t JOIN tax_haven_country th
ON t.Tax_Haven_Country_ID = th.Tax_Haven_Country_ID
WHERE Tax_Haven_Country_Name IS NOT NULL
GROUP BY Tax_Haven_Country_Name
ORDER BY Total_Transaction_Amount DESC;

/*
- The analysis reveals that Panama is the top tax haven by total transaction amount, with over $4.35 billion, followed closely by Luxembourg, Cayman Islands, Singapore,
  Switzerland, and the Bahamas—all exceeding $4 billion each. This indicates a global distribution of black money transactions across well-known financial secrecy jurisdictions, 
  suggesting strategic use of these countries for concealing wealth and avoiding taxes. The narrow gap among the top havens highlights a diversified approach to offshore 
  financial activities, emphasizing the need for enhanced due diligence and monitoring in these high-risk jurisdictions.
*/

-- What industries are most frequently associated with tax havens?
SELECT 
    i.industry_name,
    th.tax_haven_country_name,
    COUNT(*) AS Total_Transactions,
    FORMAT(SUM(Amount),0) AS Total_Transaction_Amount
FROM transactions t JOIN industry i 
ON t.industry_id = i.Industry_id 
JOIN tax_haven_country th
ON t.Tax_Haven_Country_ID = th.Tax_Haven_Country_ID
WHERE Tax_Haven_Country_Name IS NOT NULL 
GROUP BY industry_name, Tax_Haven_Country_Name
ORDER BY 
Total_Transactions DESC, 
Total_Transaction_Amount DESC;

/*
The analysis shows that industries most frequently associated with tax havens include the Arms Trade, Casinos, Real Estate, Construction, 
Finance, Luxury Goods, and Oil & Gas. These industries appear consistently across multiple tax haven countries such as Panama, Luxembourg, 
Cayman Islands, Singapore, Switzerland, and the Bahamas, each recording high transaction volumes and values. This pattern suggests that 
high-risk or high-cash-flow sectors with opportunities for secrecy or regulatory avoidance are more likely to exploit offshore financial centers, 
underlining the need for stricter monitoring and transparency measures within these industries.
*/


-- What transaction types are most frequently associated with tax havens?
SELECT 
    tt.transaction_type,
    th.tax_haven_country_name,
    COUNT(*) AS Total_Transactions,
    FORMAT(SUM(Amount),0) AS Total_Transaction_Amount
FROM transactions t 
JOIN transaction_type tt
ON t.Transaction_Type_ID = tt.Transaction_Type_ID
JOIN tax_haven_country th
ON t.Tax_Haven_Country_ID = th.Tax_Haven_Country_ID
WHERE Tax_Haven_Country_name IS NOT NULL
GROUP BY transaction_type, Tax_Haven_Country_name
ORDER BY 
Total_Transactions DESC,
Total_Transaction_Amount DESC;

/*
The analysis reveals that Cryptocurrency, Stocks Transfers, Property Purchases, Cash Withdrawals, and Offshore Transfers are the most frequently 
associated transaction types with tax haven countries. Panama, Luxembourg, the Cayman Islands, Singapore, the Bahamas, and Switzerland consistently 
appear across these categories. Notably, Cryptocurrency transactions in Panama and the Cayman Islands lead in frequency and volume, indicating a high
preference for decentralized financial movements in these regions. Property purchases and stocks transfers are also commonly used, especially in
Luxembourg and Switzerland, suggesting asset relocation and investment strategies. Overall, these patterns highlight a strategic use of tax havens for 
digital assets, capital mobility, and asset shielding.
*/

-- Percentage of high-risk transactions by transaction type in tax havens
SELECT 
  tt.transaction_type,
  COUNT(*) AS Total_Transactions,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()) AS Percentage
FROM transactions t
JOIN transaction_type tt ON t.Transaction_Type_ID = tt.Transaction_Type_ID
JOIN tax_haven_country th ON t.Tax_Haven_Country_ID = th.Tax_Haven_Country_ID
WHERE th.Tax_Haven_Country_Name IS NOT NULL
AND Money_Laundering_Risk_Score >= 7
GROUP BY tt.transaction_type
ORDER BY Total_Transactions DESC;







