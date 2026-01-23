------------------------------
/* Create the Feature Table */
------------------------------

CREATE OR REPLACE TABLE `churn_analytics.customer_features` AS
SELECT
  customer_id,
  -- Target
  CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END AS churn_flag,
  -- Demographics
  CASE WHEN gender = 'Male' THEN 1 ELSE 0 END AS is_male,
  senior_citizen,
  CASE WHEN partner = 'Yes' THEN 1 ELSE 0 END AS has_partner,
  CASE WHEN dependents = 'Yes' THEN 1 ELSE 0 END AS has_dependents,
  -- Tenure
  tenure,
  CASE
    WHEN tenure < 12 THEN '0-1_year'
    WHEN tenure < 24 THEN '1-2_years'
    WHEN tenure < 48 THEN '2-4_years'
    ELSE '4+_years'
  END AS tenure_group,
  -- Services (binary encoding)
  CASE WHEN phone_service = 'Yes' THEN 1 ELSE 0 END AS phone_service,
  CASE WHEN multiple_lines = 'Yes' THEN 1 ELSE 0 END AS multiple_lines,
  CASE WHEN internet_service <> 'No' THEN 1 ELSE 0 END AS internet_service,
  CASE WHEN online_security = 'Yes' THEN 1 ELSE 0 END AS online_security,
  CASE WHEN online_backup = 'Yes' THEN 1 ELSE 0 END AS online_backup,
  CASE WHEN device_protection = 'Yes' THEN 1 ELSE 0 END AS device_protection,
  CASE WHEN tech_support = 'Yes' THEN 1 ELSE 0 END AS tech_support,
  CASE WHEN streaming_tv = 'Yes' THEN 1 ELSE 0 END AS streaming_tv,
  CASE WHEN streaming_movies = 'Yes' THEN 1 ELSE 0 END AS streaming_movies,
  -- Service count (behavioral intensity)
  (
    CASE WHEN phone_service = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN multiple_lines = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN internet_service <> 'No' THEN 1 ELSE 0 END +
    CASE WHEN online_security = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN online_backup = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN device_protection = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN tech_support = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN streaming_tv = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN streaming_movies = 'Yes' THEN 1 ELSE 0 END
  ) AS service_count,
  -- Contract & billing
  contract,
  CASE WHEN paperless_billing = 'Yes' THEN 1 ELSE 0 END AS paperless_billing,
  payment_method,
  -- Charges
  monthly_charges,
  total_charges,
  -- Financial behavior
  SAFE_DIVIDE(total_charges, tenure) AS avg_monthly_spend
FROM `churn_staging.customers_clean`;

-- Validate the Feature Table

SELECT COUNT(*) FROM `churn_analytics.customer_features`;

-- Churn Rate Sanity Check

SELECT
  AVG(churn_flag) AS churn_rate
FROM `churn_analytics.customer_features`;

-- Check Engineered Features

SELECT
  tenure_group,
  AVG(churn_flag) AS churn_rate,
  COUNT(*) AS customers
FROM `churn_analytics.customer_features`
GROUP BY tenure_group
ORDER BY tenure_group;
