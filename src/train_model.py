"""
Production training script for churn prediction model.

This script:
1. Loads features from BigQuery
2. Splits data into train/test
3. Builds preprocessing + model pipeline
4. Trains logistic regression
5. Saves full pipeline artifact

Designed for execution as a Vertex AI Custom Training Job.
"""

from google.cloud import bigquery
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import OneHotEncoder
from sklearn.pipeline import Pipeline
from sklearn.impute import SimpleImputer
from sklearn.linear_model import LogisticRegression
import joblib
import os

# -----------------------------
# Load data from BigQuery
# -----------------------------

client = bigquery.Client()

query = """
SELECT *
FROM `churn_analytics.customer_features`
"""

df = client.query(query).to_dataframe()

# Separate target and features
y = df["churn_flag"]
X = df.drop(columns=["churn_flag", "customer_id"])

# -----------------------------
# Train / Test Split
# -----------------------------

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# -----------------------------
# Identify column types
# -----------------------------

categorical_cols = X_train.select_dtypes(include="object").columns.tolist()
numerical_cols = X_train.select_dtypes(exclude="object").columns.tolist()

# -----------------------------
# Preprocessing
# -----------------------------

preprocessor = ColumnTransformer(
    transformers=[
        ("num", SimpleImputer(strategy="median"), numerical_cols),
        ("cat", OneHotEncoder(handle_unknown="ignore"), categorical_cols),
    ]
)

# -----------------------------
# Build Pipeline
# -----------------------------

pipeline = Pipeline(steps=[
    ("preprocessing", preprocessor),
    ("classifier", LogisticRegression(max_iter=10000))
])

# -----------------------------
# Train Model
# -----------------------------

pipeline.fit(X_train, y_train)

# -----------------------------
# Save Artifact
# -----------------------------

os.makedirs("artifacts", exist_ok=True)
joblib.dump(pipeline, "artifacts/model.pkl")

print("Training completed and model artifact saved.")
