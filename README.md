# Sentinel Capital Watch (SCW)  
**GFCC Risk Analytics Report: Global Black Money Transaction Analysis**  
*Prepared for: Dr. Helena Mwangi, Director of Risk Analytics & Compliance Intelligence*  
*Date: April 24, 2025*  

---
## Background and Overview    
The Global Financial Crime & Compliance (GFCC) team at SCW is tasked with identifying patterns of illicit financial activity across 10,000 synthetic global transactions. This analysis focuses on high-risk transactions (Risk Score ≥ 7), tax haven flows, and industries disproportionately linked to black money.  

**Goals**  
1. Identify geographic and sectoral hotspots for money laundering risks.  
2. Evaluate correlations between shell companies, transaction types, and risk scores.  
3. Support enforcement partners with actionable intelligence on emerging illicit corridors

## Data Structure Overview  
### Dataset Schema 
![Schema](Assets/Dataset%20Schema.png)

- **Core Table**: `transactions`  
  - **Key Fields**: `Money_Laundering_Risk_Score`, `Shell_Company_Involved`, `Tax_Haven_Country`.  
- **Normalized Tables**: `transaction_type`, `country`, `industry`, `tax_haven_country`. 

---

## Executive Summary  
This analysis identifies critical vulnerabilities in global financial flows, with **Brazil, South Africa, and Singapore** emerging as high-risk transaction hotspots. Key industries like **Finance** (avg. risk score: 6) and **Arms Trade** (avg. risk score: 6) disproportionately enable suspicious activities, while **20% of reported transactions** (avg. risk score: 6) highlight systemic underreporting. Tax havens like **Panama** ($4.35B total flow) and **Luxembourg** ($4.34B) dominate illicit movements, with **January 2013** showing alarming spikes in high-risk activity.  

**Visual Summary**  
![Overview](Assets/Exec%20Overview.png)  

---

# Insights
## Key Findings by Stakeholder Group  

### 🛑 Risk & Compliance Officers  
**1. High-Risk Transaction Hotspots**  
- **Top 3 Countries by Volume**: Brazil (634), South Africa (633), Singapore (629)  
- **Top 3 Countries by Total Money Transacted**: Panama ($4.35B), Luxembourg ($4.34B), Cayman Islands ($4.32B)  
- Risk Assessment by country: 

![risk assessment by country](Assets/Risk%20assessment%20by%20country.png)  

**2. Risk Score Variation**  
- **Highest-Risk Industries**: Finance (Avg. Score: 6), Arms Trade (Avg. Score: 6)  
- **Highest-Risk Transaction Types**: Cryptocurrency (Avg. Score: 6), Offshore Transfers (Avg. Score: 6)  

**3. Authority-Reported Transactions**  
- **Percentage Reported**: 20% | **Average Risk Score**: 6    

---

### 💼 Executive Leadership & Strategy  
**6. High-Risk Destination Countries**  
- **Top Destinations**: USA, India, Russia  
- **Insight**: 89% of tax haven transactions involve shell companies.  

**7. Tax Haven Trends**  
- **Dominant Corridors**: China → Bahamas ($505.6M), Brazil → Luxembourg ($498M) , South Africa → Luxembourg (486.9M)

![heatmap](Assets/Flow%20of%20money%20to%20tax%20havens.png)  

---

### 🔍 Investigations & Enforcement Partners  
**11. Temporal Spikes**  
- **Peak Periods**: January 2013 (334 high-risk transactions), December 2013 (294)  

![Transaction Volume vs. Risk Score Timeline](Assets/Monthly%20Transactions%20vs%20high%20risk%20transactions.png)  

**12. Transaction Type-to-Tax Haven High-Risk transaction Flows**  
- **Emerging Patterns**: Property Purchase (21%) Stocks Transfer (20%) dominate tax haven flows.  

![Transaction Flow](Assets/Transaction%20Type%20to%20Tax%20havens.png)  

---

## Data Visualizations 
### 1. Geographic Distribution  
![Total Transacions per country](Assets/Total%20Transactions%20per%20country.png)  

### 2. Industry Risk Analysis  
![Industry risk Analysis](Assets/Industry%20Risk%20Analysis.png)  
 

---
  
## Recommendations  

### Immediate Actions  
1. **Prioritize Monitoring**: Focus on **Property Purchases** (20.9%) and **Cryptocurrency** (19.7%) in tax havens.  
2. **Investigate Top Corridors**: Audit **China→Bahamas ($505.6M)** and **Brazil→Luxembourg ($498M)** for shell company abuse.  
3. **Update AI Models**: Flag high-risk property/crypto transactions in real time.  

### Strategic Initiatives  
4. **Audit High-Risk Sectors**: Target **casinos** (72% illegal funds) and **luxury goods** (71%).  
5. **Advocate for Transparency**: Push Panama and Luxembourg to disclose beneficiary ownership data.    

---

## Appendices    
- **Limitations**: Synthetic data constraints; limited Caribbean tax haven coverage and Sample bias toward 2013–2014 data. 
- **SQL Queries**:
  - Data Modeling: [Tables and Data Modeling](/tables_and_data_modeling/)
  - Analysis: [Risk_Analysis](/risk_analysis/) 
- **Power BI Files**: [Transaction Analysis](/Power_BI_Visualization/Transaction_Dashboard.pbix)  