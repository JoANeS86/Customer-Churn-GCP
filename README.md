# End-to-End Customer Churn Prediction on Google Cloud

This project implements an end-to-end customer churn prediction system on **Google Cloud Platform** using the [Telco Customer Churn Dataset](https://github.com/JoANeS86/Customer-Churn-GCP/blob/main/docs/telco_churn.csv).

The objective is to identify high-risk customers and uncover the key drivers behind churn behavior, enabling data-driven retention strategies and protecting recurring revenue.

## Project Architecture and Workflow

<p align="center">
<img src="https://github.com/user-attachments/assets/0b137b93-eb29-4d6a-bc04-a7161aa63f9b" />
</p>

---

## Tools

* **Google Cloud Storage** – Raw data storage (conceptual production layer)
* **BigQuery** – Data warehouse & feature engineering
* **VS Code (Python)** – EDA, ML logic, evaluation
* **Vertex AI** – Production training architecture (conceptual implementation)
* **Looker Studio** – Business dashboard
* **GitHub** – Code, documentation, version control

---

## Project Deliverables

* BigQuery SQL scripts
* Python notebooks/scripts
* Production-ready training script compatible with Vertex AI Custom Jobs
* [Looker Studio dashboard](https://lookerstudio.google.com/reporting/6bb5b49b-8201-40e5-b064-bb75a7a34ec3/page/a9aoF)
* GitHub repository with README
* Clear business insights and conclusions

---

## Detailed Project Architecture and Workflow

### <ins>1. BigQuery Data Setup</ins>

* Create datasets and tables
* Load raw CSV into BigQuery (In a production setup, raw data would be stored in **Cloud Storage**, but in this case data was uploaded directly into **BigQuery** due to billing constraints)
* Feature Engineering:
  
   - Handle missing values
   - Binary encoding (Yes/No)
   - Tenure buckets
   - Aggregated service counts
   - Billing behavior ratios

    *"Contract" was retained as string for EDA purposes, encoded later in VS Code.*

<ins>**Final Data Architecture in BigQuery**</ins>:

 <ins>BigQuery Datasets</ins>

* `churn_raw`
* `churn_staging`
* `churn_analytics`

 <ins>BigQuery Tables</ins>

1. **`churn_raw.telco_customers`**

   * Raw ingested data (no transformations)

2. **`churn_staging.customers_clean`**

   * Type casting and null handling

3. **`churn_analytics.customer_features`**

   * ML-ready features
   * Target variable (churn_flag)

### <ins>2. EDA and Modeling in VS Code (Python)</ins>

EDA and Modeling performed locally in Python using Jupyter Notebooks, querying the analytical tables hosted in BigQuery.

* EDA
 
   - Churn rate overview
   - Feature distributions
   - Churn by customer segment
   - Correlation analysis
     
* Model

   - Logistic Regression

* Evaluation Metrics

   - Confusion Matrix
   - Precision / Recall
   - ROC-AUC

Once the churn model was validated locally, its logic was refactored into production-ready scripts (*train_model.py*, *evaluate.py*, and *predict.py*). In a production environment, *train_model.py* would be executed as a **Vertex AI Custom Training Job**, reading features directly from **BigQuery** and storing model artifacts in **Cloud Storage** (This is explained below, in section [Conceptual ML in GCP](#conceptual-ml-in-google-cloud-platform)).

Results coming from *predict.py* were loaded into a new table in the churn analytics dataset:

4. **`churn_analytics.churn_scores`**

    * Model-generated churn predictions
    * Stores churn probability and binary prediction
    * Timestamped batch scoring results
    * Designed for downstream analytics in Looker Studio

### <ins>3. Looker Studio Dashboard</ins>

The [Customer Churn Risk and Prediction Dashboard](https://lookerstudio.google.com/reporting/6bb5b49b-8201-40e5-b064-bb75a7a34ec3/page/a9aoF) was created utilizing data coming from the **`customer_features`** and **`churn_scores`** tables in BigQuery. This dashboard contains:

* Overall churn rate
* Churn trends by contract and tenure bucket
* High-risk customers (Churn Probability > 70%)
* Churn probability distribution and customer segmentation insights
* Business Recommendations (Targeted retention strategies and suggested actions per customer segment)

---

## Conceptual ML in Google Cloud Platform

While experimentation and model validation were performed locally using Jupyter notebooks, the production version of this churn model would be operationalized using **BigQuery** and **Vertex AI**.

As mentioned above, the validated modeling logic would be refactored into a production script (*train_model.py*) and executed as a **Vertex AI Custom Training Job**.

This would enable:

* Reproducible, managed training environments
* Scalable compute resources
* Centralized logging and monitoring
* Artifact storage in Cloud Storage

Trained models would be registered in **Vertex AI Model Registry** to ensure:

* Version control
* Auditability of training runs
* Controlled promotion to production

Given the business nature of churn prediction, batch inference is preferred over real-time endpoints (This approach is cost-efficient, scalable, and aligned with periodic retention analysis workflows):

    BigQuery (customer features) → Vertex AI Batch Prediction → BigQuery (churn_scores table)

In a production deployment, a Vertex AI Pipeline would orchestrate:

1. Feature validation
2. Model training
3. Evaluation
4. Conditional model registration
5. Batch scoring

This would ensure a fully automated and reproducible ML lifecycle.

<p align="center">
<img src="https://github.com/user-attachments/assets/ccfc4fdb-b2db-429e-876a-bdf25734232b" />
</p><br/><br/>






