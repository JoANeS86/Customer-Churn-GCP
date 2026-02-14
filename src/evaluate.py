"""
Model evaluation script.

Loads trained pipeline and evaluates performance
on a held-out test split.
"""

from google.cloud import bigquery
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, roc_auc_score
import joblib

# -----------------------------
# Load trained pipeline
# -----------------------------

model = joblib.load("artifacts/model.pkl")

# -----------------------------
# Reload dataset
# -----------------------------

client = bigquery.Client()

query = """
SELECT *
FROM `churn_analytics.customer_features`
"""

df = client.query(query).to_dataframe()

y = df["churn_flag"]
X = df.drop(columns=["churn_flag", "customer_id"])

# -----------------------------
# Train / Test Split
# -----------------------------

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# -----------------------------
# Predictions
# -----------------------------

y_pred = model.predict(X_test)
y_prob = model.predict_proba(X_test)[:, 1]

print(classification_report(y_test, y_pred))
print("ROC AUC:", roc_auc_score(y_test, y_prob))
