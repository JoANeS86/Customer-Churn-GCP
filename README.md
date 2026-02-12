## End-to-End Customer Churn Prediction on Google Cloud

### 1️ Project Objective

Build an end-to-end analytics and machine learning solution on **Google Cloud Platform** to predict customer churn and provide actionable business insights.

---

### 2️⃣ Business Framework (PACE)

### **Plan**

Customer churn reduces recurring revenue. The goal is to identify customers at high risk of churn and understand the main drivers behind churn behavior.

### **Analyze**

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

* **Google Cloud Storage** – Raw data storage (conceptual production layer)
* **BigQuery** – Data warehouse & feature engineering
* **Python** – EDA, ML logic, evaluation
* **Vertex AI** – Model training & experimentation
* **Looker Studio** – Business dashboard
* **GitHub** – Code, documentation, version control

---

### 4️⃣ Data Architecture

### **Cloud Storage**

* In a production setup, raw data would be stored in **Cloud Storage**. For this project, data was uploaded directly into **BigQuery** due to billing constraints.

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
* Load raw CSV into BigQuery
* Handle missing values
* Binary encoding (Yes/No)
* Tenure buckets
* Aggregated service counts
* Billing behavior ratios

<ins>"Contract" was retained as string for EDA purposes, encoded later in VS Code</ins>.

---

### 6️⃣ Exploratory Data Analysis (Python)

Conducted EDA on BigQuery-hosted analytical tables using Python (Pandas, Matplotlib) in Jupyter.

* Churn rate overview
* Feature distributions
* Churn by customer segment
* Correlation analysis
* Data leakage checks

---

### 7️⃣ Machine Learning

### **Models**

* Logistic Regression

### **Evaluation Metrics**

* ROC-AUC
* Precision / Recall
* Confusion Matrix

### **Platform**

* Local Python + **Vertex AI** (safe, limited usage)

---

### 8️⃣ Visualization & Reporting

### **Dashboard (Looker Studio)**

* Overall churn rate
* Churn trends by contract and service
* High-risk customer segments
* Key churn drivers

### **Business Recommendations**

* Targeted retention strategies
* Suggested actions per customer segment

---

### 9️⃣ Project Deliverables

* BigQuery SQL scripts
* Python notebooks/scripts
* Vertex AI training configuration
* Looker Studio dashboard
* GitHub repository with README
* Clear business insights and conclusions

---

Once the churn model was validated locally, the training logic was refactored into a production-ready script (train_model.py). In a production environment, this script would be executed as a Vertex AI Custom Training Job, reading features directly from BigQuery and storing model artifacts in Cloud Storage.

---

# 🔹 Production ML Architecture (Conceptual – GCP)

While experimentation and model validation were performed locally using Jupyter notebooks, the production version of this churn model would be operationalized using **BigQuery and Vertex AI**.

### Data Layer — BigQuery

All feature engineering is performed in BigQuery, where a curated `customer_features` table serves as the production-ready dataset.
BigQuery acts as the single source of truth for both training and inference, ensuring consistency and eliminating reliance on local files.

---

### Training — Vertex AI Custom Job

The validated modeling logic would be refactored into a production script (`train_model.py`) and executed as a **Vertex AI Custom Training Job**.

This would enable:

* Reproducible, managed training environments
* Scalable compute resources
* Centralized logging and monitoring
* Artifact storage in Cloud Storage

---

### Model Registry & Versioning

Trained models would be registered in **Vertex AI Model Registry** to ensure:

* Version control
* Auditability of training runs
* Controlled promotion to production

---

### Inference — Batch Prediction

Given the business nature of churn prediction, **batch inference** is preferred over real-time endpoints.

Workflow:

```
BigQuery (customer features)
        ↓
Vertex AI Batch Prediction
        ↓
BigQuery (churn_scores table)
```

This approach is cost-efficient, scalable, and aligned with periodic retention analysis workflows.

---

### Pipeline Orchestration (Future Extension)

A Vertex AI Pipeline could orchestrate:

1. Feature validation
2. Model training
3. Evaluation
4. Conditional model registration
5. Batch scoring

This would ensure a fully automated and reproducible ML lifecycle.

---

## End-to-End ML Production Architecture (BigQuery + Vertex AI)

<p align="center">
<img src="https://github.com/user-attachments/assets/ccfc4fdb-b2db-429e-876a-bdf25734232b" />
</p><br/><br/>






