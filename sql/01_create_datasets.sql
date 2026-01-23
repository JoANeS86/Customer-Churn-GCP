-------------------------------------------------------------------------------------------------
/* Create BigQuery datasets (in BigQuery, databases and schemas are both the same as datasets) */
-------------------------------------------------------------------------------------------------


CREATE SCHEMA IF NOT EXISTS `optimum-entity-484512-v0.churn_raw`;
CREATE SCHEMA IF NOT EXISTS `optimum-entity-484512-v0.churn_staging`;
CREATE SCHEMA IF NOT EXISTS `optimum-entity-484512-v0.churn_analytics`;


--------------------------
/* Create the Raw Table */
--------------------------


CREATE OR REPLACE TABLE `churn_raw.telco_customers` (
  customer_id STRING,
  gender STRING,
  senior_citizen INT64,
  partner STRING,
  dependents STRING,
  tenure INT64,
  phone_service STRING,
  multiple_lines STRING,
  internet_service STRING,
  online_security STRING,
  online_backup STRING,
  device_protection STRING,
  tech_support STRING,
  streaming_tv STRING,
  streaming_movies STRING,
  contract STRING,
  paperless_billing STRING,
  payment_method STRING,
  monthly_charges FLOAT64,
  total_charges STRING,
  churn STRING
);

-- Validate Raw Data

SELECT
  COUNT(*) AS row_count,
  COUNTIF(churn = 'Yes') AS churn_yes,
  COUNTIF(churn = 'No') AS churn_no
FROM `churn_raw.telco_customers`;

-- Data Quality Check

SELECT
  COUNTIF(total_charges IS NULL OR total_charges = '' OR total_charges = ' ') AS missing_total_charges
FROM `churn_raw.telco_customers`;
