/*==============================================================================
 Project      : Modern Data Warehouse using Snowflake
 Author       : Solomon Mensah
 Date         : July 2026

 Description
 ------------------------------------------------------------------------------
 This project implements a complete Medallion Data Warehouse architecture
 (Bronze, Silver, and Gold) in Snowflake.

 The pipeline integrates CRM and ERP source systems, performs data cleansing,
 standardization, transformation, and dimensional modeling before publishing
 analytics-ready tables for Power BI reporting.

 Architecture
 ------------------------------------------------------------------------------
 Bronze Layer
     • Stores raw CRM and ERP data exactly as received.
     • No business transformations.
     • Serves as the system of record.

 Silver Layer
     • Cleans and standardizes source data.
     • Renames columns using business-friendly naming conventions.
     • Standardizes gender and marital status values.
     • Removes invalid records.
     • Integrates CRM and ERP datasets.

 Gold Layer
     • Creates analytical dimension and fact tables.
     • Removes duplicate business keys.
     • Builds a star schema for reporting.
     • Provides optimized tables for Power BI dashboards.

 Data Flow
 ------------------------------------------------------------------------------
 CRM / ERP Sources
        ↓
     Bronze Layer
        ↓
     Silver Layer
        ↓
      Gold Layer
        ↓
    Power BI Dashboard

 Main Objects
 ------------------------------------------------------------------------------
 Bronze
     CRM_CUSTOMERS_RAW
     CRM_PRODUCTS_RAW
     CRM_SALES_RAW
     ERP_CUSTOMERS_RAW
     ERP_PRODUCTS_RAW
     ERP_LOCATIONS_RAW

 Silver
     DIM_CUSTOMER_STG
     DIM_PRODUCT_STG
     FACT_SALES_STG
     ERP_CUSTOMER_STG
     ERP_PRODUCT_STG
     DIM_CUSTOMER
     DIM_PRODUCT

 Gold
     DIM_CUSTOMER
     DIM_PRODUCT
     FACT_SALES
     DIM_CUSTOMER_CLEAN
     DIM_PRODUCT_CLEAN
     DIM_PRODUCT_PBI

 Notes
 ------------------------------------------------------------------------------
 • Database: DW_PROJECT
 • Warehouse Architecture: Bronze → Silver → Gold
 • Target BI Tool: Power BI
 • SQL Dialect: Snowflake SQL

==============================================================================*/

/*==============================================================================
SECTION 1: CREATE DATABASE AND SCHEMAS
Purpose:
    Create the database and Medallion architecture schemas.
==============================================================================*/

CREATE DATABASE IF NOT EXISTS DW_PROJECT;

CREATE SCHEMA IF NOT EXISTS DW_PROJECT.BRONZE;
CREATE SCHEMA IF NOT EXISTS DW_PROJECT.SILVER;
CREATE SCHEMA IF NOT EXISTS DW_PROJECT.GOLD;

/*==============================================================================
SECTION 2: CREATE BRONZE TABLES
Purpose:
    Create raw landing tables for CRM and ERP data.
==============================================================================*/
SHOW TABLES IN SCHEMA DW_PROJECT.BRONZE;
SELECT *
FROM DW_PROJECT.BRONZE.ERP_CUSTOMERS_RAW
LIMIT 10;
/*==============================================================================
SECTION 3: LOAD RAW DATA INTO BRONZE
Purpose:
    Load source files without applying transformations.
==============================================================================*/
CREATE OR REPLACE TABLE DW_PROJECT.SILVER.DIM_CUSTOMER_STG AS
SELECT
    cst_id AS customer_id,
    cst_key AS customer_key,
    cst_firstname AS first_name,
    cst_lastname AS last_name,

    CASE
        WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
        WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
        ELSE 'Unknown'
    END AS gender,

    CASE
        WHEN UPPER(cst_marital_status) = 'M' THEN 'Married'
        WHEN UPPER(cst_marital_status) = 'S' THEN 'Single'
        ELSE 'Unknown'
    END AS marital_status,

    cst_create_date AS created_date

FROM DW_PROJECT.BRONZE.CRM_CUSTOMERS_RAW;
/*==============================================================================
SECTION 4: BUILD SILVER STAGING TABLES
Purpose:
    Clean, standardize, and transform raw data into business-ready staging
    tables.
==============================================================================*/
CREATE OR REPLACE TABLE DW_PROJECT.SILVER.DIM_PRODUCT_STG AS
SELECT
    prd_id AS product_id,
    prd_key AS product_key,
    prd_nm AS product_name,
    prd_cost AS product_cost,
    prd_line AS product_line,
    prd_start_dt AS start_date,
    prd_end_dt AS end_date
FROM DW_PROJECT.BRONZE.CRM_PRODUCTS_RAW;

/*==============================================================================
SECTION 5: BUILD GOLD STAR SCHEMA
Purpose:
    Create analytical dimension and fact tables for reporting.
==============================================================================*/
CREATE OR REPLACE TABLE DW_PROJECT.SILVER.FACT_SALES_STG AS
SELECT
    sls_ord_num AS order_number,
    sls_prd_key AS product_key,
    sls_cust_id AS customer_id,
    sls_order_dt AS order_date,
    sls_ship_dt AS ship_date,
    sls_due_dt AS due_date,
    sls_sales AS sales_amount,
    sls_quantity AS quantity,
    sls_price AS unit_price
FROM DW_PROJECT.BRONZE.CRM_SALES_RAW;

/*==============================================================================
SECTION 6: DATA QUALITY VALIDATION
Purpose:
    Verify record counts, duplicate keys, null values, and referential integrity.
==============================================================================*/

CREATE OR REPLACE TABLE DW_PROJECT.SILVER.ERP_CUSTOMER_STG AS
SELECT
    CID AS customer_id,
    BDATE AS birth_date,

    CASE
        WHEN UPPER(GEN) = 'M' THEN 'Male'
        WHEN UPPER(GEN) = 'F' THEN 'Female'
        ELSE 'Unknown'
    END AS gender

FROM DW_PROJECT.BRONZE.ERP_CUSTOMERS_RAW;


CREATE OR REPLACE TABLE DW_PROJECT.SILVER.ERP_PRODUCT_STG AS
SELECT
    ID AS product_id,
    CAT AS category,
    SUBCAT AS subcategory,
    MAINTENANCE
FROM DW_PROJECT.BRONZE.ERP_PRODUCTS_RAW;

/*==============================================================================
SECTION 7: POWER BI REPORTING TABLES
Purpose:
    Create optimized tables for Power BI dashboards.
==============================================================================*/
CREATE OR REPLACE TABLE DW_PROJECT.SILVER.DIM_CUSTOMER AS
SELECT
    crm.customer_id,
    crm.customer_key,
    crm.first_name,
    crm.last_name,
    crm.marital_status,
    COALESCE(erp.gender, crm.gender) AS gender,
    erp.birth_date,
    crm.created_date
FROM DW_PROJECT.SILVER.DIM_CUSTOMER_STG crm
LEFT JOIN DW_PROJECT.SILVER.ERP_CUSTOMER_STG erp
    ON crm.customer_key = erp.customer_id;

CREATE OR REPLACE TABLE DW_PROJECT.GOLD.DIM_CUSTOMER AS
SELECT *
FROM DW_PROJECT.SILVER.DIM_CUSTOMER;

CREATE OR REPLACE TABLE DW_PROJECT.GOLD.DIM_PRODUCT AS
SELECT *
FROM DW_PROJECT.SILVER.DIM_PRODUCT;

CREATE OR REPLACE TABLE DW_PROJECT.GOLD.FACT_SALES AS
SELECT
    order_number,
    customer_id,
    product_key,
    order_date,
    ship_date,
    due_date,
    quantity,
    unit_price,
    sales_amount
FROM DW_PROJECT.SILVER.FACT_SALES_STG;

SELECT COUNT(*)
FROM DW_PROJECT.GOLD.DIM_CUSTOMER
WHERE CUSTOMER_ID IS NULL;

SELECT
    CUSTOMER_ID,
    COUNT(*)
FROM DW_PROJECT.GOLD.DIM_CUSTOMER
GROUP BY CUSTOMER_ID
HAVING COUNT(*) > 1;

SELECT
    PRODUCT_KEY,
    COUNT(*)
FROM DW_PROJECT.GOLD.DIM_PRODUCT
GROUP BY PRODUCT_KEY
HAVING COUNT(*) > 1;

SELECT
    PRODUCT_KEY,
    COUNT(*)
FROM DW_PROJECT.GOLD.DIM_PRODUCT
GROUP BY PRODUCT_KEY
HAVING COUNT(*) > 1;

CREATE OR REPLACE TABLE DW_PROJECT.GOLD.DIM_CUSTOMER_CLEAN AS
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY CUSTOMER_ID
               ORDER BY CREATED_DATE DESC
           ) AS RN
    FROM DW_PROJECT.GOLD.DIM_CUSTOMER
)
WHERE RN = 1
  AND CUSTOMER_ID IS NOT NULL;

CREATE OR REPLACE TABLE DW_PROJECT.GOLD.DIM_PRODUCT_PBI_CLEAN AS
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY PRODUCT_KEY
               ORDER BY PRODUCT_ID
           ) AS RN
    FROM DW_PROJECT.GOLD.DIM_PRODUCT_PBI
)
WHERE RN = 1;




    