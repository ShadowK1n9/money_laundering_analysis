CREATE database Capital_Watch;
USE capital_Watch;
CREATE TABLE transactions(
    Transaction_ID VARCHAR(20) PRIMARY KEY,
    Country VARCHAR(30),
    Amount DECIMAL(10,2),
    Transaction_Type VARCHAR(30),
    Transaction_Date DATE,
    Transaction_Time TIME,
    Person_Involved VARCHAR(20),
    Industry VARCHAR(20),
    Destination_Country VARCHAR(30),
    Reported_by_Authority VARCHAR(5),
    Source_of_Money VARCHAR(8),
    Money_Laundering_Risk_Score INT,
    Shell_Company_Involved INT,
    Financial_Institution VARCHAR(20),
    Tax_Haven_Country VARCHAR(30)
);


LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Big_Black_Money_Dataset.csv"
INTO TABLE transactions
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- checking for duplicates

WITH Duplicate_rows as (
    SELECT *, 
    ROW_NUMBER() OVER(PARTITION BY transaction_id, country, amount, transaction_type, transaction_date, transaction_time, person_involved,
    industry, destination_country, reported_by_authority, source_of_money, money_laundering_risk_score, shell_company_involved,
     financial_institution, tax_haven_country ORDER BY transaction_id) as row_num
FROM transactions
) 
SELECT count(*) as duplicates from duplicate_rows WHERE row_num > 1;


SELECT * FROM transactions
ORDER BY RAND()
LIMIT 10;

-- Modeling the data: Normalization (lookup tables)
-- Creating the transaction type table to store unique transaction types
CREATE TABLE transaction_type(
    Transaction_Type_ID INT AUTO_INCREMENT PRIMARY KEY,
    Transaction_Type VARCHAR(30) NOT NULL UNIQUE
);

INSERT INTO transaction_type (Transaction_Type)
SELECT DISTINCT Transaction_Type FROM transactions;

-- Adding foreign key to the transactions table
ALTER TABLE transactions
ADD COLUMN Transaction_Type_ID INT AFTER Amount,
ADD FOREIGN KEY (Transaction_Type_ID) REFERENCES transaction_type(Transaction_Type_ID);

-- Updating the transactions table with the transaction type IDs
UPDATE transactions t
JOIN transaction_type tt ON t.Transaction_Type = tt.Transaction_Type
SET t.Transaction_Type_ID = tt.Transaction_Type_ID;

-- Creating the countries and industry tables to store unique countries
/* 
I'm not storing all the countries in one table despite the fact that the same country can be used in different columms
because I am going to visualize this data using power BI and I want to avoid complex dax calculations because of
relationships ambiguity among the tables and columns. I'm choosing simplicity.
*/
-- Creating the country, destination country, tax haven country and industry tables to store unique countries and industries
CREATE TABLE country(
    Country_ID INT AUTO_INCREMENT PRIMARY KEY,
    Country_Name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE destination_country(
    Destination_Country_ID INT AUTO_INCREMENT PRIMARY KEY,
    Destination_Country_Name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE tax_haven_country(
    Tax_Haven_Country_ID INT AUTO_INCREMENT PRIMARY KEY,
    Tax_Haven_Country_Name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE industry(
    Industry_ID INT AUTO_INCREMENT PRIMARY KEY,
    Industry_Name VARCHAR(20) NOT NULL UNIQUE
);
-- Populating the country table with unique countries
INSERT INTO country (Country_Name)
SELECT DISTINCT Country FROM transactions WHERE country IS NOT NULL;

-- populating the destination country table with unique destination countries
INSERT INTO destination_country (Destination_Country_Name)
SELECT DISTINCT Destination_Country FROM transactions WHERE destination_country IS NOT NULL;

-- populating the tax haven country table with unique tax haven countries
INSERT INTO tax_haven_country (Tax_Haven_Country_Name)
SELECT DISTINCT Tax_Haven_Country FROM transactions WHERE tax_haven_country IS NOT NULL;

-- populating the industry table with unique industries
INSERT INTO industry (Industry_Name)
SELECT DISTINCT Industry FROM transactions WHERE industry IS NOT NULL;

-- Adding foreign country and industry key to the transactions table
ALTER TABLE transactions
ADD COLUMN Country_ID INT AFTER Country,
ADD COLUMN Destination_Country_ID INT AFTER Destination_Country,
ADD COLUMN Tax_Haven_Country_ID INT AFTER Tax_Haven_Country,
ADD COLUMN Industry_ID INT AFTER Industry,
ADD FOREIGN KEY (Country_ID) REFERENCES country(Country_ID),
ADD FOREIGN KEY (Destination_Country_ID) REFERENCES destination_country(Destination_Country_ID),
ADD FOREIGN KEY (Tax_Haven_Country_ID) REFERENCES tax_haven_country(Tax_Haven_Country_ID),
ADD FOREIGN KEY (Industry_ID) REFERENCES industry(Industry_ID);


-- updating IDs in the transactions table
-- Mapping Industry IDs
UPDATE transactions t
JOIN industry i ON t.Industry = i.Industry_Name
SET t.Industry_ID = i.Industry_ID;

-- Mapping country IDs
UPDATE transactions t
JOIN country c ON t.Country = c.Country_Name
SET t.Country_ID = c.Country_ID;

-- Mapping destination country IDs
UPDATE transactions t
JOIN destination_country dt ON t.destination_country = dt.destination_country_name
SET t.destination_country_ID = dt.destination_country_ID;


-- Map tax haven country IDs
UPDATE transactions t
JOIN tax_haven_country th ON t.tax_haven_country = th.Tax_Haven_Country_Name
SET t.tax_haven_country_ID = th.tax_haven_country_ID;

-- Dropping original columns
ALTER TABLE transactions
DROP COLUMN Country,
DROP COLUMN Destination_Country,
DROP COLUMN Tax_Haven_Country,
DROP COLUMN Industry,
DROP COLUMN Transaction_Type;



SELECT * FROM transactions LIMIT 10;







