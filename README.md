# Data Engineer Job Market Dashboard

An end-to-end analytics project: raw job-posting data → PostgreSQL views → Power BI dashboard.

![Dashboard](images/dashboard.png)

## Key findings

- **SQL (98%) and Python (93%)** are close to mandatory; ETL/ELT (85%) and Git (62%) follow.
- **AWS leads cloud demand at 44%**, ahead of Azure (33%) and GCP (23%).
- **Databricks (30.4%) and Snowflake (30.3%)** are almost tied as the most requested data platforms.
- **Mid-level roles make up 45% of postings**, Senior 40%, Associate 15%.
- **Technology and Finance/Fintech** are the biggest hiring industries.
- Only **15%** of postings are fully remote.

## Project overview

| Item | Detail |
|---|---|
| Dataset | 5,000 data engineering job postings (Jul – Oct 2026) |
| Database | PostgreSQL |
| Transformation | SQL views (aggregations, skill co-occurrence, demand %) |
| Visualization | Power BI Desktop |

## Workflow

1. **Clean data**: `fcleaned_dataset.csv` loaded into a `jobs` table in PostgreSQL.
2. **SQL views** (see `sql/views.sql`): skills and tools demand, cloud and warehouse demand, work mode mix, seniority mix, industry mix, monthly trend, skill pairs, skills by seniority.
3. **Power BI**: connected to PostgreSQL, loaded the views, and built the dashboard with a custom dark theme and a few DAX measures for KPI cards.

## Dashboard contents

- KPI cards: Total Postings, Top Skill, Top Cloud, Top Warehouse, Remote Share
- Top skills in demand (% of postings)
- Top data warehouses in demand
- Jobs by seniority
- Cloud platform demand
- Monthly postings trend
- Postings by industry

## Repository structure

```
├── README.md
├── data/        fcleaned_dataset.csv
├── sql/         views.sql
├── images/      dashboard.png
└── powerbi/     DE_Dashboard.pbix
```

## Skills demonstrated

SQL (CTEs, window functions, views, aggregation) • PostgreSQL • Power BI • DAX • Data modelling • Dashboard design

## Author

**Your Name** • [LinkedIn](https://linkedin.com/in/your-profile) • [GitHub](https://github.com/your-username)
