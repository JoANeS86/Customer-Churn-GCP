--------------------------------------
/* Create the Cleaned Staging Table */
--------------------------------------


CREATE OR REPLACE TABLE `churn_staging.customers_clean` AS
SELECT
  customer_id,
  -- Demographics
  gender,
  CAST(senior_citizen AS INT64) AS senior_citizen,
  partner,
  dependents,
  -- Tenure
  CAST(tenure AS INT64) AS tenure,
  -- Services
  phone_service,
  multiple_lines,
  internet_service,
  online_security,
  online_backup,
  device_protection,
  tech_support,
  streaming_tv,
  streaming_movies,
  -- Contract & billing
  contract,
  paperless_billing,
  payment_method,
  -- Charges
  CAST(monthly_charges AS FLOAT64) AS monthly_charges,
  SAFE_CAST(NULLIF(NULLIF(total_charges, ''), ' ') AS FLOAT64) AS total_charges,
  -- Target
  churn
FROM `churn_raw.telco_customers`;

-- Validate the Staging Table

SELECT COUNT(*) AS row_count
FROM `churn_staging.customers_clean`;

-- NULL checks on key fields

SELECT
  COUNTIF(total_charges IS NULL) AS missing_total_charges,
  COUNTIF(monthly_charges IS NULL) AS missing_monthly_charges
FROM `churn_staging.customers_clean`;

-- Churn distribution

SELECT
  churn,
  COUNT(*) AS customers
FROM `churn_staging.customers_clean`
GROUP BY churn;
