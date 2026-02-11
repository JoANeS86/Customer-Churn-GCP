## End-to-End Customer Churn Prediction on Google Cloud

### 1️⃣ Project Objective

Build an end-to-end analytics and machine learning solution on **Google Cloud Platform** to predict customer churn and provide actionable business insights.

---

### 2️⃣ Business Framework (PACE)

### **Plan**

Customer churn reduces recurring revenue. The goal is to identify customers at high risk of churn and understand the main drivers behind churn behavior.

### **Analysis Plan**

* Explore customer demographics, services, and billing data
* Identify churn patterns and drivers
* Engineer predictive features
* Train and evaluate ML models
* Communicate insights through dashboards

### **Construct**

* Data warehouse in **BigQuery**
* SQL-based data transformations and feature engineering
* Python-based EDA and modeling
* ML training using **Vertex AI**
* Visualization with **Looker Studio**

### **Execute**

* Deliver churn predictions
* Summarize business insights
* Recommend retention strategies

---

### 3️⃣ Tech Stack

* **Google Cloud Storage** – Raw data storage
* **BigQuery** – Data warehouse & feature engineering
* **Python** – EDA, ML logic, evaluation
* **Vertex AI** – Model training & experimentation
* **Looker Studio** – Business dashboard
* **GitHub** – Code, documentation, version control

---

### 4️⃣ Data Architecture

### **Cloud Storage**

* `gs://churn-project-raw/telco_churn.csv`

### **BigQuery Datasets**

* `churn_raw`
* `churn_staging`
* `churn_analytics`

### **BigQuery Tables**

1. **`churn_raw.telco_customers`**

   * Raw ingested data (no transformations)

2. **`churn_staging.customers_clean`**

   * Cleaned and standardized data
   * Type casting and null handling

3. **`churn_analytics.customer_features`**

   * One row per customer
   * ML-ready features
   * Target variable (`churn`)

---

### 5️⃣ SQL Tasks (BigQuery)

* Create datasets and tables
* Load raw CSV from Cloud Storage (raw data was ingested into BigQuery using direct file upload due to project billing constraints.)
* Clean and standardize data
* Encode categorical variables
* Create derived features (tenure buckets, service counts, ratios)
* Build final feature table for ML

---

### 6️⃣ Exploratory Data Analysis (Python)

Conducted EDA on BigQuery-hosted analytical tables using Python (Pandas, Matplotlib) in Jupyter.

* Churn rate overview
* Feature distributions
* Churn by customer segment
* Correlation analysis
* Data leakage checks

---

### 7️⃣ Feature Engineering

* Binary encoding (Yes/No)
* Aggregated service usage
* Contract type indicators
* Tenure-based features
* Billing behavior ratios

---

### 8️⃣ Machine Learning

### **Models**

* Logistic Regression (baseline & explainability)
* Tree-based model (AutoML Tables or XGBoost)

### **Evaluation Metrics**

* ROC-AUC
* Precision / Recall
* Confusion Matrix

### **Platform**

* Local Python + **Vertex AI** (safe, limited usage)

---

### 9️⃣ Visualization & Reporting

### **Dashboard (Looker Studio)**

* Overall churn rate
* Churn trends by contract and service
* High-risk customer segments
* Key churn drivers

### **Business Recommendations**

* Targeted retention strategies
* Suggested actions per customer segment

---

### 🔟 Project Deliverables

* BigQuery SQL scripts
* Python notebooks/scripts
* Vertex AI training configuration
* Looker Studio dashboard
* GitHub repository with README
* Clear business insights and conclusions

---

## 🗓️ Estimated Timeline

* **Week 1** – GCP setup & BigQuery warehouse
* **Week 2** – SQL transformations & EDA
* **Week 3** – Feature engineering & baseline ML
* **Week 4** – Advanced model & evaluation
* **Week 5** – Dashboard & insights
* **Week 6** – Vertex AI polish & documentation

---

# 🔹 Production ML Architecture (Conceptual – Vertex AI)

## From Experimentation to Production

Model development and experimentation were conducted locally using Jupyter notebooks (`01_eda.ipynb`, `02_modeling.ipynb`) for rapid iteration and analytical exploration.

In a production environment, the validated training logic would be migrated to **Vertex AI** to ensure scalability, reproducibility, and governance.

The production workflow would follow the architecture below.

---

## 🔹 Data Layer – BigQuery as Source of Truth

All feature engineering is performed in **BigQuery**, where a curated `customer_features` table serves as the production-ready dataset.

BigQuery acts as:

* The centralized feature store
* The single source of truth for training and inference
* The storage layer for batch prediction outputs

This eliminates dependency on local CSV files and ensures consistency between training and scoring environments.

---

## 🔹 Training – Vertex AI Custom Training Job

Once experimentation validated the modeling approach (Logistic Regression with preprocessing and imputation), the logic would be refactored into a production script:

```
src/train_model.py
```

This script would:

1. Load features directly from BigQuery
2. Perform preprocessing and imputation
3. Train the model
4. Evaluate performance
5. Save the trained artifact to Cloud Storage

The script would be executed as a **Vertex AI Custom Training Job**, which provides:

* Managed compute infrastructure
* Reproducible training environments
* Dependency isolation via `requirements.txt`
* Training logs and monitoring
* Automatic artifact storage

This replaces local notebook execution with scalable, versioned cloud training.

---

## 🔹 Model Registry & Versioning

After successful training, the model artifact would be:

* Stored in Cloud Storage
* Registered in Vertex AI Model Registry
* Versioned for traceability

This enables:

* Auditability of training runs
* Controlled promotion to production
* Rollback to previous model versions if necessary

---

## 🔹 Inference Strategy – Batch over Real-Time

For a churn prediction use case, real-time inference is typically unnecessary. Instead, the recommended approach is:

**Vertex AI Batch Prediction**

Workflow:

```
BigQuery customer table
        ↓
Vertex AI Batch Prediction Job
        ↓
BigQuery churn_scores table
```

This approach:

* Is more cost-efficient than managed endpoints
* Fits business workflows (weekly/monthly churn scoring)
* Integrates naturally with BI tools (e.g., dashboards)

Real-time endpoints would only be deployed if immediate churn probability scoring were required within transactional systems.

---

## 🔹 Pipeline Orchestration (Future Extension)

To fully automate the lifecycle, a **Vertex AI Pipeline** could orchestrate:

1. Feature validation
2. Model training
3. Model evaluation
4. Conditional model registration
5. Batch prediction execution

This ensures repeatability, automation, and production-grade ML governance.

---

## 🔹 Architectural Summary

The end-to-end production design would follow:

```
BigQuery (Feature Table)
        ↓
Vertex AI Custom Training Job
        ↓
Model Registry
        ↓
Vertex AI Batch Prediction
        ↓
BigQuery (Churn Scores)
```

This design separates:

* Experimentation (local notebooks)
* Production training (managed jobs)
* Inference (batch scoring)
* Data storage (BigQuery)

and aligns with modern cloud-based ML system design.

---

## End-to-End ML Production Architecture (BigQuery + Vertex AI)

<p align="center">
<img src="https://github.com/user-attachments/assets/ccfc4fdb-b2db-429e-876a-bdf25734232b" />
</p><br/><br/>






