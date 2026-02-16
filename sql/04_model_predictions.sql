----------------------------------------
/* Analytics Layer: Model Predictions */
----------------------------------------


CREATE TABLE IF NOT EXISTS `churn_analytics.churn_scores` (
    customer_id STRING NOT NULL,
    churn_probability FLOAT64,
    churn_prediction INT64,
    prediction_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    model_version STRING
);