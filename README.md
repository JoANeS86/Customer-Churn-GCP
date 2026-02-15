# End-to-End Customer Churn Prediction on Google Cloud

In this project, we're building an end-to-end analytics and machine learning solution on **Google Cloud Platform** to predict customer churn and provide actionable business insights: Customer churn reduces recurring revenue, therefore the goal is to identify customers at high risk of churn and understand the main drivers behind churn behavior.

## Project Process

<p align="center">
<img src="https://github.com/user-attachments/assets/ba360102-1590-49f6-8824-2e10dec2635e" />
</p>

---

## Tools

* **Google Cloud Storage** – Raw data storage (conceptual production layer)
* **BigQuery** – Data warehouse & feature engineering
* **Python** – EDA, ML logic, evaluation
* **Vertex AI** – Production training architecture (conceptual implementation)
* **Looker Studio** – Business dashboard
* **GitHub** – Code, documentation, version control

---

## Detailed Project Process



### 2️⃣ Business Framework (PACE)

 <ins>**Plan**</ins>



 <ins>**Analyze**</ins>

* Explore customer demographics, services, and billing data
* Identify churn patterns and drivers
* Engineer predictive features
* Train and evaluate ML models
* Communicate insights through dashboards

 <ins>**Construct**</ins>

* Data warehouse in **BigQuery**
* SQL-based data transformations and feature engineering
* Python-based EDA and modeling
* Production-ready ML training designed for **Vertex AI** (executed locally for this project)**
* Visualization with **Looker Studio**

 <ins>**Execute**</ins>

* Deliver churn predictions
* Summarize business insights
* Recommend retention strategies

---

### 4️⃣ Data Architecture

 <ins>**Cloud Storage**</ins>

* In a production setup, raw data would be stored in **Cloud Storage**. For this project, data was uploaded directly into **BigQuery** due to billing constraints.

 <ins>**BigQuery Datasets**</ins>

* `churn_raw`
* `churn_staging`
* `churn_analytics`

 <ins>**BigQuery Tables**</ins>

1. **`churn_raw.telco_customers`**

   * Raw ingested data (no transformations)

2. **`churn_staging.customers_clean`**

   * Cleaned and standardized data
   * Type casting and null handling

3. **`churn_analytics.customer_features`**

   * One row per customer
   * ML-ready features
   * Target variable (`churn_flag`)
  
4. **`churn_analytics.churn_scores`**

   * Model-generated churn predictions
   * Stores churn probability and binary prediction
   * Timestamped batch scoring results
   * Designed for downstream analytics in Looker Studio

---

### 5️⃣ SQL Tasks (BigQuery)

* Create datasets and tables
* Load raw CSV into BigQuery
* Handle missing values
* Binary encoding (Yes/No)
* Tenure buckets
* Aggregated service counts
* Billing behavior ratios

*"Contract" was retained as string for EDA purposes, encoded later in VS Code.*

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

 <ins>**Models**</ins>

* Logistic Regression

 <ins>**Evaluation Metrics**</ins>

* ROC-AUC
* Precision / Recall
* Confusion Matrix

 <ins>**Platform**</ins>

* Platform – Local Python (production-ready for **Vertex AI** deployment)

---

### 8️⃣ Visualization & Reporting

 <ins>**Dashboard (Looker Studio)**</ins>

* Overall churn rate
* Churn trends by contract and service
* High-risk customer segments
* Key churn drivers

 <ins>**Business Recommendations**</ins>

* Targeted retention strategies
* Suggested actions per customer segment

---

### 9️⃣ Project Deliverables

* BigQuery SQL scripts
* Python notebooks/scripts
* Production-ready training script compatible with **Vertex AI** Custom Jobs
* [Looker Studio dashboard](https://lookerstudio.google.com/reporting/6bb5b49b-8201-40e5-b064-bb75a7a34ec3/page/a9aoF)
* GitHub repository with README
* Clear business insights and conclusions

---

Once the churn model was validated locally, the training logic was refactored into a production-ready script (train_model.py). In a production environment, this script would be executed as a Vertex AI Custom Training Job, reading features directly from BigQuery and storing model artifacts in Cloud Storage.

---

## 🔹 Production ML Architecture (Conceptual – GCP)

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






