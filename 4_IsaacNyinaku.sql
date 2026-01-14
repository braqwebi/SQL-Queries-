# =============================================================
# ALY6030 - Data Warehousing and SQL
# MODULE 4 ASSIGNMENT: Dimension and Fact Table Techniques
# AUTHOR: NYINAKU, ISAAC
# DATE: OCTOBER 13, 2025
# =============================================================

# -------------------------------------------------------------
# STEP 0: Configure SQL Mode
# -------------------------------------------------------------
# Disable ONLY_FULL_GROUP_BY to allow grouping with non-aggregated columns
SELECT @@sql_mode;
SET @@sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));


# -------------------------------------------------------------
# STEP 1: Create Database Schema
# -------------------------------------------------------------
DROP DATABASE IF EXISTS brfss;
CREATE SCHEMA brfss;
USE brfss;


# -------------------------------------------------------------
# STEP 2: Import Source Tables
# -------------------------------------------------------------
# Use MySQL Workbench Import Wizard to load data from the following CSVs:
#   - brfss_ok-3.csv  (from BRFSS_OK.xlsx)
#   - demographics-1.csv
#   - demographics_ok.csv
# Ensure ZipCode field is stored as VARCHAR for accurate joins.

# -------------------------------------------------------------
# STEP 3: Merge Demographic Tables Into One Unified Table
# -------------------------------------------------------------
-- Using UNION to remove all duplicates within the unified table

CREATE TABLE demographics_final AS
SELECT 
    ZipCode,
    City,
    County
FROM `demographics-1`
UNION
SELECT 
    ZipCode,
    City,
    County
FROM demographics_ok;



# Validate merged records
SELECT COUNT(*) AS total_records FROM demographics_final;

# -------------------------------------------------------------
# STEP 4: Explore BRFSS Data For Adolescent Alcohol Responses
# -------------------------------------------------------------
# Verify total number of 18-24 age group responses
SELECT 
    COUNT(*) AS adolescent_responses
FROM `brfss_ok-3`
WHERE Break_Out = '18-24'
  AND Break_Out_Category = 'Age Group';

# Preview filtered adolescent responses
SELECT 
    Break_Out,
    Break_Out_Category,
    Sample_Size,
    Data_Value,
    Response,
    ZipCode
FROM `brfss_ok-3`
WHERE Break_Out = '18-24'
  AND Break_Out_Category = 'Age Group';
 
# Highest and Lowest Adolescent responses by City
SELECT 
    Break_Out,
    Break_Out_Category,
    Sample_Size ,
    Data_Value AS Respondents,
    Response,
    a.ZipCode,
    City   
FROM `brfss_ok-3`a
INNER JOIN demographics_final b
ON a.ZipCode = b.ZipCode
WHERE Break_Out = '18-24'
  AND Break_Out_Category = 'Age Group'
GROUP BY Break_Out,
    Break_Out_Category,
    Sample_Size,
    Data_Value,
    Response,
    City,
    ZipCode
ORDER BY Data_Value 
LIMIT 5;

 SELECT 
    Break_Out,
    Break_Out_Category,
    Sample_Size ,
    Data_Value AS Respondents,
    Response,
    a.ZipCode,
    City   
FROM `brfss_ok-3`a
INNER JOIN demographics_final b
ON a.ZipCode = b.ZipCode
WHERE Break_Out = '18-24'
  AND Break_Out_Category = 'Age Group'
GROUP BY Break_Out,
    Break_Out_Category,
    Sample_Size,
    Data_Value,
    Response,
    City,
    ZipCode
ORDER BY Data_Value ASC
LIMIT 5;

# -------------------------------------------------------------
# STEP 5: Join BRFSS Data With Demographics by City
# -------------------------------------------------------------
CREATE TABLE adolescent_alcohol_city AS
SELECT 
    b.Break_Out,
    b.Break_Out_Category,
    b.Sample_Size,
    b.Data_Value,
    d.ZipCode,
    d.City
FROM `brfss_ok-3` b
INNER JOIN demographics_final d ON b.ZipCode = d.ZipCode
WHERE b.Break_Out = '18-24'
  AND b.Break_Out_Category = 'Age Group';

# Display summarized city-level data
SELECT 
    City,
    SUM(Data_Value) AS total_yes_responses,
    SUM(Sample_Size) AS total_respondents,
    ROUND(SUM(Data_Value)/SUM(Sample_Size)*100, 2) AS alcohol_use_rate
FROM adolescent_alcohol_city
GROUP BY City
ORDER BY alcohol_use_rate DESC;


# -------------------------------------------------------------
# STEP 6: Join BRFSS Data With Demographics by County
# -------------------------------------------------------------
CREATE TABLE adolescent_alcohol_county AS
SELECT 
    b.Break_Out,
    b.Break_Out_Category,
    b.Sample_Size,
    b.Data_Value,
    d.ZipCode,
    d.County
FROM `brfss_ok-3` b
INNER JOIN demographics_final d ON b.ZipCode = d.ZipCode
WHERE b.Break_Out = '18-24'
  AND b.Break_Out_Category = 'Age Group';

# County-level aggregation
SELECT 
    County,
    SUM(Data_Value) AS total_yes_responses,
    SUM(Sample_Size) AS total_respondents,
    ROUND(SUM(Data_Value)/SUM(Sample_Size)*100, 2) AS alcohol_use_rate
FROM adolescent_alcohol_county
GROUP BY County
ORDER BY alcohol_use_rate DESC;


# -------------------------------------------------------------
# STEP 7: Identify Anonymous Risk Groups
# -------------------------------------------------------------
# Assign risk categories based on alcohol use rate thresholds
SELECT 
    ZipCode,
    ROUND(SUM(Data_Value)/SUM(Sample_Size)*100, 2) AS alcohol_use_rate,
    CASE
        WHEN ROUND(SUM(Data_Value)/SUM(Sample_Size)*100, 2) >= 60 THEN 'High Risk'
        WHEN ROUND(SUM(Data_Value)/SUM(Sample_Size)*100, 2) BETWEEN 20 AND 59.99 THEN 'Moderate Risk'
        ELSE 'Low Risk'
    END AS risk_group
FROM adolescent_alcohol_city
GROUP BY ZipCode
ORDER BY alcohol_use_rate DESC;


# -------------------------------------------------------------
# STEP 8: Rank Areas by Alcohol Risk Level
# -------------------------------------------------------------
# Using window functions to rank cities by alcohol use rate
SELECT
    ZipCode,
    ROUND(SUM(Data_Value)/SUM(Sample_Size)*100, 2) AS alcohol_use_rate,
    DENSE_RANK() OVER (ORDER BY ROUND(SUM(Data_Value)/SUM(Sample_Size)*100, 2) DESC) AS risk_rank
FROM adolescent_alcohol_city
GROUP BY Zipcode
ORDER BY risk_rank ASC
LIMIT 10;


