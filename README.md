# Enterprise Sales Analytics Platform

## Overview

The Enterprise Sales Analytics Platform is an end-to-end analytics solution designed to transform raw CRM and ERP data into actionable business insights.

The project leverages Snowflake's Medallion Architecture (Bronze, Silver, and Gold layers) to build a scalable cloud data warehouse, connects the curated datasets to Python for analytics, and delivers executive-level reporting through Power BI dashboards.

The solution demonstrates modern data engineering, analytics, and business intelligence practices using:

- Snowflake
- SQL
- Python
- Jupyter Notebook
- Pandas
- Matplotlib
- Power BI

---

## Business Problem

Organizations often store customer, product, and sales information across multiple operational systems, making it difficult to create a unified view of business performance.

This project addresses that challenge by:

- Integrating CRM and ERP datasets
- Building a centralized Snowflake data warehouse
- Creating a single source of truth
- Supporting executive reporting and analytics
- Providing a foundation for future forecasting and machine learning initiatives

---

# Solution Architecture

```text
CRM Data              ERP Data
    |                    |
    +--------+-----------+
             |
             v
      Bronze Layer
       (Raw Data)
             |
             v
      Silver Layer
 (Cleaned & Integrated)
             |
             v
       Gold Layer
 (Business-Ready Data)
             |
      +------+------+
      |             |
      v             v
 Python        Power BI
 Analytics     Dashboards
```

---

# Technology Stack

## Data Warehouse

- Snowflake
- SQL

## Analytics

- Python
- Pandas
- NumPy
- Matplotlib

## Business Intelligence

- Power BI

## Version Control

- Git
- GitHub

---

# Snowflake Data Warehouse

## Bronze Layer

The Bronze Layer stores raw source-system data exactly as received.

### CRM Tables

- CRM_CUSTOMERS_RAW
- CRM_PRODUCTS_RAW
- CRM_SALES_RAW

### ERP Tables

- ERP_CUSTOMERS_RAW
- ERP_PRODUCTS_RAW
- ERP_LOCATIONS_RAW

### Responsibilities

- Data ingestion
- Data preservation
- Source system auditability

---

## Silver Layer

The Silver Layer standardizes and cleans raw data before integration.

### Customer Models

- DIM_CUSTOMER_STG
- ERP_CUSTOMER_STG

### Product Models

- DIM_PRODUCT_STG
- ERP_PRODUCT_STG

### Fact Models

- FACT_SALES_STG

### Transformations Performed

- Gender standardization
- Marital status standardization
- Field renaming
- Data cleansing
- Business rule implementation

---

## Gold Layer

The Gold Layer provides reporting-ready business datasets.

### Dimensions

- DIM_CUSTOMER_CLEAN
- DIM_PRODUCT_PBI_CLEAN

### Fact Tables

- FACT_SALES

---

# Data Model

The project follows a Star Schema design.

```text
      DIM_CUSTOMER_CLEAN
               |
               |
               |
          FACT_SALES
               |
               |
               |
      DIM_PRODUCT_PBI_CLEAN
```

### Fact Table

**FACT_SALES**

Contains:

- Order Number
- Customer ID
- Product Key
- Order Date
- Ship Date
- Due Date
- Quantity
- Unit Price
- Sales Amount

### Customer Dimension

**DIM_CUSTOMER_CLEAN**

Contains:

- Customer Information
- Customer Demographics
- Gender
- Marital Status
- Birth Date

### Product Dimension

**DIM_PRODUCT_PBI_CLEAN**

Contains:

- Product Information
- Product Attributes
- Product Classification

---

# Data Quality Management

Several data quality challenges were identified and resolved during implementation.

## Customer Dimension

### Issues Identified

- Duplicate Customer IDs
- Null Customer IDs

### Solution

- Created DIM_CUSTOMER_CLEAN
- Applied ROW_NUMBER() based deduplication
- Removed null customer records

---

## Product Dimension

### Issues Identified

- Duplicate Product Keys

### Solution

- Created DIM_PRODUCT_PBI_CLEAN
- Applied deduplication rules
- Created Power BI optimized dimension tables

---

# Python Analytics

The Gold Layer was connected to Jupyter Notebook to support analytical workflows.

## Libraries Used

```python
pandas
numpy
matplotlib
snowflake-connector-python
```

## Data Extraction

The following datasets were loaded into Pandas DataFrames:

- FACT_SALES
- DIM_CUSTOMER_CLEAN
- DIM_PRODUCT_PBI_CLEAN

---

# Exploratory Data Analysis (EDA)

## Monthly Sales Trend

### Business Question

How has revenue changed over time?

### Insights

- Revenue increased significantly over the analysis period.
- Sales growth accelerated during 2013.
- Strong overall positive trend was observed.

### Monthly Sales Trend

images/monthly_sales_trend.png

---

## Trend Analysis

A trend line was developed to evaluate long-term sales growth.

### Actual vs Trend

images/actual_vs_trend.png

### Observations

- Revenue demonstrates sustained growth.
- The actual sales pattern outperforms the baseline trend in later periods.
- Business performance shows increasing momentum across the observed timeline.

---

# Power BI Executive Dashboard

An interactive executive dashboard was developed using the Snowflake Gold Layer.

## Dashboard Objectives

Provide decision-makers with visibility into:

- Revenue Performance
- Customer Activity
- Order Volumes
- Customer Segmentation
- Sales Trends

---

## Executive Dashboard

images/executive_dashboard.png

---

## KPI Summary

| Metric | Value |
|----------|----------|
| Total Revenue | $29M |
| Total Orders | 28K |
| Total Customers | 18K |
| Total Quantity Sold | 60.42K |
| Revenue Per Customer | $1.59K |

---

## Dashboard Features

### Revenue Trend Analysis

Tracks organizational revenue performance over time.

### Top Customers

Identifies the highest revenue-generating customers.

### Revenue by Gender

Analyzes revenue contribution by customer demographics.

### Revenue by Marital Status

Provides insight into customer purchasing behavior.

### Interactive Filters

Users can filter dashboard results by:

- Order Date
- Gender
- Marital Status

---

# Key Business Insights

## Revenue Performance

The organization generated approximately:

```text
$29 Million
```

in revenue over the analysis period.

---

## Customer Activity

The platform analyzed:

```text
18,000 Customers
```

and

```text
28,000 Orders
```

providing extensive visibility into customer purchasing behavior.

---

## Revenue Growth

Sales performance increased substantially during the later periods of the analysis, indicating positive business growth.

---

## Customer Segmentation

The dashboard revealed meaningful differences in revenue contribution across:

- Gender groups
- Marital status segments
- High-value customer segments

---

## Top Customer Analysis

High-value customers were successfully identified, supporting:

- Customer retention strategies
- Loyalty programs
- Personalized marketing initiatives

---

# Repository Structure

```text
Enterprise-Sales-Analytics-Platform
│
├── sql
│   └── NewDatawareHouse.sql
│
├── notebooks
│   └── Datawarehouse_and_analytic.ipynb
│
├── powerbi
│   └── Enterprise_Sales_analytics.pbix
│
├── reports
│   └── Project Documentation.pdf
│
├── images
│   ├── executive_dashboard.png
│   ├── monthly_sales_trend.png
│   └── actual_vs_trend.png
│
└── README.md
```

---

# Future Enhancements

Planned enhancements include:

- Customer Analytics Dashboard
- Product Performance Dashboard
- Sales Forecasting Models
- Demand Forecasting
- Random Forest Models
- XGBoost Forecasting Models
- Power BI Forecast Dashboard
- Microsoft Fabric Integration

---

# Project Outcomes

✅ Snowflake Data Warehouse

✅ Bronze-Silver-Gold Architecture

✅ CRM and ERP Integration

✅ Data Quality Validation

✅ Python Analytics

✅ Exploratory Data Analysis

✅ Power BI Executive Dashboard

✅ Customer Analytics

✅ Interactive Business Intelligence Reporting

---

# Author

**Solomon Mensah**

Data Analytics | Data Engineering | Business Intelligence

[GitHub Repository](https://github.com/Godsbrain/Enterprise-Sales-Analytics-Platform)
