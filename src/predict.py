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
from pathlib import Path

# -----------------------------
# Load trained pipeline (robust path)
# -----------------------------

# Get the project root (parent of src)
BASE_DIR = Path(__file__).parent.parent

ARTIFACTS_DIR = BASE_DIR / "artifacts"
MODEL_PATH = ARTIFACTS_DIR / "model.pkl"

model = joblib.load(MODEL_PATH)

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
