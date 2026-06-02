# Olist Logistics Analytics Engine (dbt Cloud & Databricks)

## 📌 Project Overview
This project builds a robust, enterprise-grade Analytics Engineering pipeline transforming raw e-commerce data into a high-performance star schema layout. The core objective is diagnosing supply chain friction, carrier bottlenecks, and customer churn drivers for a large-scale Brazilian e-commerce ecosystem.

### Modern Data Stack:
* **Data Lakehouse:** Databricks (Compute, Storage, & Delta Catalog)
* **Transformation Layer:** dbt Cloud (Staging, Intermediate, and Marts layers)
* **Version Control:** GitHub
* **BI & Analytics:** Power BI (Star-schema dimensional reporting)

**Dataset:** [Olist E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

---

## 🏗️ Analytics Architecture & Data Lineage
The repository enforces a strict multi-layer dbt architecture to isolate raw data cleanup from complex multi-row window calculations and final presentation facts:

```text
📂 models/
├── 📂 staging/
│   ├── sources.yml
│   ├── stg_customers.sql          # Standardizes geographic entities and unique customer hashes
│   ├── stg_order_items.sql        # Casts numeric values and exposes item-level grains
│   └── stg_orders.sql             # Standardizes timestamps and injects active binary status flags
│
├── 📂 intermediate/
│   ├── int_orders_operational_metrics.sql # Calculates multi-point time deltas (hours/days)
│   └── int_customer_order_history.sql    # Employs window functions to calculate prior lifetime behaviors
│
└── 📂 marts/                           
    ├── 📂 core/
    │   └── dim_customers.sql      # Shared Dimension: Deduplicated customer attributes & lifetime metrics
    └── 📂 logistics/
        ├── fct_order_items.sql    # Central Fact Table: Granular item-level logistics performance grain
        └── schema.yml             # Automated data quality schema definitions and referential integrity tests

---
## 📊 Core Business Use Case: Logistics & Delivery Diagnostic Engine
Rather than hosting passive metrics, this pipeline calculates advanced, actionable operational benchmarks across the order lifecycle:

Approval Efficiency: approval_delay_hours tracks data processing or payment friction before warehouse hand-off.

Dispatch Speed: dispatch_delay_days measures warehouse operational velocity against fulfillment deadlines.

Delivery SLA Compliance: delivery_accuracy_flag evaluates downstream carrier reliability by measuring actual arrivals against estimated promises.

Advanced Root-Cause Churn Profiling: Utilizes backward-looking window functions (prior_lifetime_late_deliveries, prior_lifetime_cancellations) to statistically isolate if specific late carrier hand-offs or prolonged approval delays directly cause customer order cancellations.

---

## ✅ Current Progress
- Completed: Automated staging layers configured with explicit 1/0 schema flags for seamless, lightweight boolean aggregations in downstream visualization layers.
- Completed: Advanced analytical features generated at the customer scale using analytical window logic bounded to track historical behavior up to 1 preceding row.
- Completed: Star Schema finalized with explicit Primary Key/Foreign Key tracking between the logistics and core analytical marts.
- Completed: Automated schema validation engines applied using YAML constraints to enforce relational integrity and absolute column uniqueness.

---

## 🚀 Next Steps
- Import the generated Databricks production views directly into Power BI.
- Model a 1-to-Many unidirectional relationship across dim_customers and fct_order_items.
- Construct core visual reporting sheets: a Logistics Performance Overview dashboard and an Operational Friction/Root-Cause Analysis dashboard.

---

## 📂 How to Run

Prerequisites
    An active dbt Cloud account connected to your GitHub repository.
    A running Databricks cluster with appropriate catalog write permissions.
    
1. Clone the repo
2. Connect dbt Cloud to Databricks
3. Run:
   ```bash
   dbt run --select stg_*

Note: The dbt build command compiles the models, deploys them to the Databricks Catalog, and tests them sequentially. If an internal data constraint or schema test fails, the process alerts you and halts immediately, preventing broken structures from corrupting production dashboards. 


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt community](https://getdbt.com/community) to learn from other analytics engineers
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

## 👤 Author & Connect
* **Name:** Soumyajeet Kundu
* **Role:** Data Engineer
* **LinkedIn:** https://www.linkedin.com/in/soumyajeet-kundu/
* **GitHub:** https://github.com/Soumyajeetk
* **Email:** soumyajeet.k8@gmail.com