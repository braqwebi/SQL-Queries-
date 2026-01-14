  
#NYINAKU, ISAAC
#OCTOBER 7, 2025
### Updated Script - Follows Script 2 Naming and Structure ###

# -------------------------------------------------------------
# STEP 0: Configure SQL Mode
# -------------------------------------------------------------
SELECT @@sql_mode;
SET @@sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

# -------------------------------------------------------------
# STEP 1: Create Schema for Hospital Analysis
# -------------------------------------------------------------
#DROP DATABASE IF EXISTS hospital;
CREATE SCHEMA hospital;
USE hospital;


# -------------------------------------------------------------
# STEP 2: #Importing Tables Into The Schema Using Import tool
# -------------------------------------------------------------

-- bed_fact-1
-- bed_type-1
-- business-1

# -------------------------------------------------------------
# STEP 3: Create SICU Hospital Table
# -------------------------------------------------------------
-- Extract SICU bed data from bed_fact and bed_type tables
CREATE TABLE sicu_hospital_beds AS
SELECT 
    a.ims_org_id,
    a.license_beds AS sicu_beds_licenced,
    a.census_beds AS sicu_beds_counted,
    a.staffed_beds AS sicu_beds_staff,
    b.bed_desc,
    a.bed_id
FROM `bed_fact-1` a
INNER JOIN `bed_type-1` b ON a.bed_id = b.bed_id
WHERE b.bed_desc = 'SICU';

-- Displaying output from SICU Beds extraction 

SELECT * FROM sicu_hospital_beds;

# -------------------------------------------------------------
# STEP 4: Create ICU Hospital Table
# -------------------------------------------------------------
-- Extract ICU bed data from bed_fact and bed_type tables
CREATE TABLE icu_hospital_beds AS
SELECT 
    a.ims_org_id,
    a.license_beds AS icu_beds_licenced,
    a.census_beds AS icu_beds_counted,
    a.staffed_beds AS icu_beds_staff,
    b.bed_desc,
    a.bed_id
FROM `bed_fact-1` a
INNER JOIN `bed_type-1` b ON a.bed_id = b.bed_id
WHERE b.bed_desc = 'ICU';

SELECT * FROM icu_hospital_beds;

# -------------------------------------------------------------
# STEP 5: Combine ICU and SICU Tables
# -------------------------------------------------------------
CREATE TABLE icu_sicu_hospital_beds AS
SELECT 
    a.ims_org_id,
    a.icu_beds_licenced + b.sicu_beds_licenced AS licensed_beds_icu_sicu,
    a.icu_beds_counted + b.sicu_beds_counted AS counted_beds_icu_sicu,
    a.icu_beds_staff + b.sicu_beds_staff AS staffed_beds_icu_sicu
FROM icu_hospital_beds a
INNER JOIN sicu_hospital_beds b ON a.ims_org_id = b.ims_org_id;

SELECT * FROM icu_sicu_hospital_beds;

# -------------------------------------------------------------
# STEP 6: Top 10 Hospitals by Licensed Beds
# -------------------------------------------------------------
SELECT 
    b.business_name AS hospital_name,
    a.licensed_beds_icu_sicu
FROM icu_sicu_hospital_beds a
INNER JOIN `business-1` b ON a.ims_org_id = b.ims_org_id
ORDER BY a.licensed_beds_icu_sicu DESC
LIMIT 10;

# -------------------------------------------------------------
# STEP 7: Top 10 Hospitals by Census Beds
# -------------------------------------------------------------
SELECT 
    b.business_name AS Hospital_Name,
    a.counted_beds_icu_sicu AS Beds_Counted
FROM icu_sicu_hospital_beds a
INNER JOIN `business-1` b ON a.ims_org_id = b.ims_org_id
ORDER BY a.counted_beds_icu_sicu DESC
LIMIT 10;

# -------------------------------------------------------------
# STEP 8: Top 10 Hospitals by Staffed Beds
# -------------------------------------------------------------
SELECT 
    b.business_name AS Hospital_Name,
    a.staffed_beds_icu_sicu AS Staffed_beds
FROM icu_sicu_hospital_beds a
INNER JOIN `business-1` b ON a.ims_org_id = b.ims_org_id
ORDER BY a.staffed_beds_icu_sicu DESC
LIMIT 10;

# -------------------------------------------------------------
# STEP 9: Combined Hospital Layout (All Bed Categories)
# -------------------------------------------------------------
SELECT 
    d.ims_org_id,
    d.business_name AS hospital_name,
    c.icu_beds_staff,
    e.sicu_beds_staff,
    c.icu_beds_licenced,
    e.sicu_beds_licenced,
    c.icu_beds_counted,
    e.sicu_beds_counted,
    (c.icu_beds_staff + e.sicu_beds_staff +
     c.icu_beds_licenced + e.sicu_beds_licenced +
     c.icu_beds_counted + e.sicu_beds_counted) AS Total_beds
FROM icu_hospital_beds c
INNER JOIN `business-1` d ON c.ims_org_id = d.ims_org_id
INNER JOIN sicu_hospital_beds e ON e.ims_org_id = c.ims_org_id
ORDER BY total_beds DESC
LIMIT 10;


# -------------------------------------------------------------
# STEP 10: Combined Hospital Layout (All Bed Categories )
# -------------------------------------------------------------
WITH base AS (
    SELECT
        d.ims_org_id,
        d.business_name AS hospital_name,

        COALESCE(c.icu_beds_staff, 0)     AS icu_beds_staff,
        COALESCE(e.sicu_beds_staff, 0)    AS sicu_beds_staff,

        COALESCE(c.icu_beds_licenced, 0)  AS icu_beds_licenced,
        COALESCE(e.sicu_beds_licenced, 0) AS sicu_beds_licenced,

        COALESCE(c.icu_beds_counted, 0)   AS icu_beds_counted,
        COALESCE(e.sicu_beds_counted, 0)  AS sicu_beds_counted
    FROM icu_hospital_beds c
    INNER JOIN `business-1` d
        ON d.ims_org_id = c.ims_org_id
    LEFT JOIN sicu_hospital_beds e
        ON e.ims_org_id = c.ims_org_id
),
scored AS (
    SELECT
        ims_org_id,
        hospital_name,
        icu_beds_staff,
        sicu_beds_staff,
        icu_beds_licenced,
        sicu_beds_licenced,
        icu_beds_counted,
        sicu_beds_counted,
        (icu_beds_staff + sicu_beds_staff +
         icu_beds_licenced + sicu_beds_licenced +
         icu_beds_counted + sicu_beds_counted) AS total_beds
    FROM base
),
ranked AS (
    SELECT
        *,
        DENSE_RANK() OVER (ORDER BY total_beds DESC) AS bed_rank
    FROM scored
)
SELECT
    ims_org_id,
    hospital_name,
    icu_beds_staff,
    sicu_beds_staff,
    icu_beds_licenced,
    sicu_beds_licenced,
    icu_beds_counted,
    sicu_beds_counted,
    total_beds,
    bed_rank
FROM ranked
WHERE bed_rank <= 10
ORDER BY bed_rank, hospital_name;
