## End-to-End Customer Churn Prediction on Google Cloud

### 1️⃣ Project Objective

Build an end-to-end analytics and machine learning solution on **Google Cloud Platform** to predict customer churn and provide actionable business insights.

---

### 2️⃣ Business Framework (PACE)

### **Problem**

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
* Load raw CSV from Cloud Storage
* Clean and standardize data
* Encode categorical variables
* Create derived features (tenure buckets, service counts, ratios)
* Build final feature table for ML

---

### 6️⃣ Exploratory Data Analysis (Python)

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
