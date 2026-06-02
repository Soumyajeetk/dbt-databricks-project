# Olist Data Engineering Project (DBT and Databricks)

## 📌 Overview
This project builds an end-to-end data pipeline using:
- Databricks (data ingestion & cleaning)
- dbt (transformations & modeling)
- GitHub (version control)
- Power BI (visualization)

Dataset: [Olist e-commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

---

## 🏗️ Project Structure
- `models/staging/` → Cleaned versions of raw Olist tables
- `models/intermediate/` → Joins & derived fields
- `models/marts/` → Business-ready tables for reporting
- `sources.yml` → Source definitions

---

## ✅ Current Progress
- Databricks connection configured
- All staging models created and tested
- GitHub repo synced with dbt Cloud

---

## 🚀 Next Steps
- Build intermediate models (fact tables, joins)
- Add product category translations if needed
- Create marts for reporting (sales, customer behavior, delivery performance)
- Visualize in Power BI

---

## 📂 How to Run
1. Clone the repo
2. Connect dbt Cloud to Databricks
3. Run:
   ```bash
   dbt run --select stg_*

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt community](https://getdbt.com/community) to learn from other analytics engineers
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
