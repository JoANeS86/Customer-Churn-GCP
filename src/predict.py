"""
Batch prediction script.

Loads trained pipeline,
generates churn predictions for all customers,
and uploads results to BigQuery.
"""

from google.cloud import bigquery
import pandas as pd
import joblib
from datetime import datetime

# -----------------------------
# Load trained pipeline
# -----------------------------

model = joblib.load("artifacts/model.pkl")

# -----------------------------
# Load feature table
# -----------------------------

client = bigquery.Client()

query = """
SELECT *
FROM `churn_analytics.customer_features`
"""

df = client.query(query).to_dataframe()

customer_ids = df["customer_id"]
X = df.drop(columns=["churn_flag", "customer_id"])

# -----------------------------
# Generate Predictions
# -----------------------------

y_prob = model.predict_proba(X)[:, 1]
y_pred = (y_prob >= 0.5).astype(int)

# -----------------------------
# Prepare Results DataFrame
# -----------------------------

results_df = pd.DataFrame({
    "customer_id": customer_ids,
    "churn_probability": y_prob,
    "churn_prediction": y_pred,
    "prediction_timestamp": datetime.utcnow(),
    "model_version": "v1.0"
})

# -----------------------------
# Upload to BigQuery
# -----------------------------

table_id = "optimum-entity-484512-v0.churn_analytics.churn_scores"

job = client.load_table_from_dataframe(
    results_df,
    table_id
)

job.result()

print("Predictions uploaded successfully.")
