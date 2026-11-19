# E-Commerce Data Warehouse, Funnel & Retention Analytics

## 1. Business Objective
Build a clean, production-grade dimensional data model (Star Schema) from raw e-commerce transactional tables (`99,441` orders) to measure order fulfillment conversion funnels, customer repeat retention, and delivery performance, backed by automated SQL data quality checks and a LookML semantic layer[cite: 13].

## 2. Architecture & Deliverables
* **`schema_and_qa.sql`**: Remodels raw Olist e-commerce tables into `FACT_POD_ORDERS`, `DIM_POD_CUSTOMERS`, and `DIM_POD_PRODUCTS` in Oracle Autonomous Database, followed by automated SQL QA assertions checking for duplicate keys, null/negative revenues, and orphan foreign keys[cite: 12, 14].
* **`funnel_and_retention.sql`**: Analytical SQL queries calculating order lifecycle conversion rates (Order Placed → Payment Approved → Shipped to Carrier → Delivered) and customer repeat-purchase segmentation[cite: 13, 14].
* **`looker_semantic_model.lkml`**: Looker semantic layer (`explore`, `dimensions`, and `measures`) exposing governed KPIs for self-service BI exploration[cite: 14].

## 3. Key Findings
* **Order Fulfillment Funnel:** Out of **99,441** orders placed, **99.84%** (`99,281`) cleared payment approval, **98.37%** (`97,658`) handed off to carriers, and **98.79%** (`96,476`) completed final delivery[cite: 13].
* **Customer Retention Segments:** **97.0%** (`90,557`) of unique buyers placed a single order, **2.76%** (`2,573`) returned for a second order, and **0.24%** (`228`) became 3+ order VIP loyalists—demonstrating a major post-purchase retention opportunity[cite: 13].

## 4. Tech Stack
* **Database & SQL:** Oracle Autonomous Database (Database Actions), Dimensional Modeling (Star Schema), Window Functions, CTEs[cite: 12, 13]
* **BI Semantic Layer:** Looker / LookML[cite: 14]
* **Dataset:** [Brazilian E-Commerce Public Dataset by Olist (Kaggle)](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)[cite: 5]
