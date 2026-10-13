

CREATE TABLE jobs (
    job_id                          VARCHAR(20) PRIMARY KEY,
    job_title                       TEXT,
    seniority                       VARCHAR(30),
    experience_required             INTEGER,
    posted_date                     DATE,
    employment_type                 VARCHAR(30),
    work_mode                       VARCHAR(20),
    location                        TEXT,
    company_size                    VARCHAR(40),
    industry                        VARCHAR(60),
    cloud_platform                  VARCHAR(20),
    data_warehouse                  VARCHAR(40),
    certifications                  TEXT,
    salary                          INTEGER,
    skills                          TEXT,
    skills_list                     TEXT,
    skills_count                    INTEGER,

    -- Skill flags (0/1)
    skill_sql                       SMALLINT,
    skill_python                    SMALLINT,
    skill_etl_elt                   SMALLINT,
    skill_spark_pyspark             SMALLINT,
    skill_airflow                   SMALLINT,
    skill_dbt                       SMALLINT,
    skill_kafka                     SMALLINT,
    skill_git                       SMALLINT,
    skill_docker                    SMALLINT,
    skill_ci_cd                     SMALLINT,
    skill_terraform_iac             SMALLINT,
    skill_kubernetes                SMALLINT,
    skill_scala                     SMALLINT,
    skill_java                      SMALLINT,
    skill_nosql                     SMALLINT,
    skill_flink_streaming           SMALLINT,
    skill_delta_lake_iceberg        SMALLINT,
    skill_bi_tools                  SMALLINT,

    -- Tool flags (0/1)
    tool_aws                        SMALLINT,
    tool_azure                      SMALLINT,
    tool_gcp                        SMALLINT,
    tool_snowflake                  SMALLINT,
    tool_databricks                 SMALLINT,
    tool_bigquery                   SMALLINT,
    tool_redshift                   SMALLINT,
    tool_s3                         SMALLINT,
    tool_glue                       SMALLINT,
    tool_lambda                     SMALLINT,
    tool_adf                        SMALLINT,
    tool_data_factory               SMALLINT,
    tool_synapse                    SMALLINT,
    tool_event_hubs                 SMALLINT,
    tool_gcs                        SMALLINT,
    tool_dataflow                   SMALLINT,
    tool_pub_sub                    SMALLINT,
    tool_dataproc                   SMALLINT
);

-- Indexes for common query patterns
CREATE INDEX idx_jobs_posted_date      ON jobs (posted_date);
CREATE INDEX idx_jobs_seniority        ON jobs (seniority);
CREATE INDEX idx_jobs_cloud_platform   ON jobs (cloud_platform);
CREATE INDEX idx_jobs_data_warehouse   ON jobs (data_warehouse);
CREATE INDEX idx_jobs_industry         ON jobs (industry);
CREATE INDEX idx_jobs_work_mode        ON jobs (work_mode);
CREATE INDEX idx_jobs_salary           ON jobs (salary);
CREATE INDEX idx_jobs_company_size     ON jobs (company_size);


-- 1. Top skills + tools combined
CREATE OR REPLACE VIEW top_skills AS
SELECT 'SQL' AS skill, 'skill' AS kind, SUM(skill_sql) AS job_count FROM jobs
UNION ALL SELECT 'Python', 'skill', SUM(skill_python) FROM jobs
UNION ALL SELECT 'ETL/ELT', 'skill', SUM(skill_etl_elt) FROM jobs
UNION ALL SELECT 'Spark/PySpark', 'skill', SUM(skill_spark_pyspark) FROM jobs
UNION ALL SELECT 'Airflow', 'skill', SUM(skill_airflow) FROM jobs
UNION ALL SELECT 'dbt', 'skill', SUM(skill_dbt) FROM jobs
UNION ALL SELECT 'Kafka', 'skill', SUM(skill_kafka) FROM jobs
UNION ALL SELECT 'Git', 'skill', SUM(skill_git) FROM jobs
UNION ALL SELECT 'Docker', 'skill', SUM(skill_docker) FROM jobs
UNION ALL SELECT 'CI/CD', 'skill', SUM(skill_ci_cd) FROM jobs
UNION ALL SELECT 'Terraform/IaC', 'skill', SUM(skill_terraform_iac) FROM jobs
UNION ALL SELECT 'Kubernetes', 'skill', SUM(skill_kubernetes) FROM jobs
UNION ALL SELECT 'Scala', 'skill', SUM(skill_scala) FROM jobs
UNION ALL SELECT 'Java', 'skill', SUM(skill_java) FROM jobs
UNION ALL SELECT 'NoSQL', 'skill', SUM(skill_nosql) FROM jobs
UNION ALL SELECT 'Flink/Streaming', 'skill', SUM(skill_flink_streaming) FROM jobs
UNION ALL SELECT 'Delta Lake/Iceberg', 'skill', SUM(skill_delta_lake_iceberg) FROM jobs
UNION ALL SELECT 'BI Tools', 'skill', SUM(skill_bi_tools) FROM jobs
UNION ALL SELECT 'AWS', 'tool', SUM(tool_aws) FROM jobs
UNION ALL SELECT 'Azure', 'tool', SUM(tool_azure) FROM jobs
UNION ALL SELECT 'GCP', 'tool', SUM(tool_gcp) FROM jobs
UNION ALL SELECT 'Snowflake', 'tool', SUM(tool_snowflake) FROM jobs
UNION ALL SELECT 'Databricks', 'tool', SUM(tool_databricks) FROM jobs
UNION ALL SELECT 'BigQuery', 'tool', SUM(tool_bigquery) FROM jobs
UNION ALL SELECT 'Redshift', 'tool', SUM(tool_redshift) FROM jobs
UNION ALL SELECT 'S3', 'tool', SUM(tool_s3) FROM jobs
UNION ALL SELECT 'Glue', 'tool', SUM(tool_glue) FROM jobs
UNION ALL SELECT 'Lambda', 'tool', SUM(tool_lambda) FROM jobs
UNION ALL SELECT 'ADF', 'tool', SUM(tool_adf) FROM jobs
UNION ALL SELECT 'Data Factory', 'tool', SUM(tool_data_factory) FROM jobs
UNION ALL SELECT 'Synapse', 'tool', SUM(tool_synapse) FROM jobs
UNION ALL SELECT 'Event Hubs', 'tool', SUM(tool_event_hubs) FROM jobs
UNION ALL SELECT 'GCS', 'tool', SUM(tool_gcs) FROM jobs
UNION ALL SELECT 'Dataflow', 'tool', SUM(tool_dataflow) FROM jobs
UNION ALL SELECT 'Pub/Sub', 'tool', SUM(tool_pub_sub) FROM jobs
UNION ALL SELECT 'Dataproc', 'tool', SUM(tool_dataproc) FROM jobs
ORDER BY job_count DESC;

-- 2. Salary by seniority
CREATE OR REPLACE VIEW salary_by_seniority AS
SELECT
    seniority,
    COUNT(*)                                            AS postings,
    COUNT(salary)                                       AS with_salary,
    ROUND(AVG(salary))                                  AS avg_salary,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) AS median_salary,
    MIN(salary)                                         AS min_salary,
    MAX(salary)                                         AS max_salary
FROM jobs
WHERE salary IS NOT NULL
GROUP BY seniority
ORDER BY avg_salary DESC;

-- 3. Salary by cloud platform
CREATE OR REPLACE VIEW salary_by_cloud AS
SELECT
    cloud_platform,
    COUNT(*)             AS postings,
    ROUND(AVG(salary))   AS avg_salary,
    MIN(salary)          AS min_salary,
    MAX(salary)          AS max_salary
FROM jobs
WHERE salary IS NOT NULL AND cloud_platform IS NOT NULL
GROUP BY cloud_platform
ORDER BY avg_salary DESC;

-- 4. Work mode mix
CREATE OR REPLACE VIEW work_mode_mix AS
SELECT
    work_mode,
    COUNT(*)                                            AS postings,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2)  AS pct
FROM jobs
GROUP BY work_mode
ORDER BY postings DESC;

-- 5. Top hiring locations
CREATE OR REPLACE VIEW top_locations AS
SELECT
    location,
    COUNT(*)             AS postings,
    ROUND(AVG(salary))   AS avg_salary
FROM jobs
GROUP BY location
HAVING COUNT(*) >= 100
ORDER BY postings DESC;

-- 6. Industry mix
CREATE OR REPLACE VIEW industry_mix AS
SELECT
    industry,
    COUNT(*)             AS postings,
    ROUND(AVG(salary))   AS avg_salary
FROM jobs
GROUP BY industry
ORDER BY postings DESC;

-- 7. Company size mix
CREATE OR REPLACE VIEW company_size_mix AS
SELECT
    company_size,
    COUNT(*)             AS postings,
    ROUND(AVG(salary))   AS avg_salary
FROM jobs
GROUP BY company_size
ORDER BY postings DESC;

-- 8. Monthly trend
CREATE OR REPLACE VIEW monthly_trend AS
SELECT
    DATE_TRUNC('month', posted_date)::date   AS month,
    COUNT(*)                                 AS postings,
    ROUND(AVG(salary))                       AS avg_salary
FROM jobs
WHERE posted_date IS NOT NULL
GROUP BY 1
ORDER BY 1;

-- 9. Top job titles
CREATE OR REPLACE VIEW top_job_titles AS
SELECT
    job_title,
    COUNT(*)             AS postings,
    ROUND(AVG(salary))   AS avg_salary
FROM jobs
GROUP BY job_title
HAVING COUNT(*) >= 20
ORDER BY postings DESC;

-- 10. Experience vs salary
CREATE OR REPLACE VIEW experience_vs_salary AS
SELECT
    experience_required,
    COUNT(*)                                            AS postings,
    ROUND(AVG(salary))                                  AS avg_salary,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) AS median_salary
FROM jobs
WHERE salary IS NOT NULL
GROUP BY experience_required
ORDER BY experience_required;

-- 11. Skill pairs
CREATE OR REPLACE VIEW skill_pairs AS
SELECT 'SQL + Python'          AS pair, COUNT(*) AS postings FROM jobs WHERE skill_sql=1 AND skill_python=1
UNION ALL SELECT 'Python + Spark',       COUNT(*) FROM jobs WHERE skill_python=1 AND skill_spark_pyspark=1
UNION ALL SELECT 'Python + Airflow',     COUNT(*) FROM jobs WHERE skill_python=1 AND skill_airflow=1
UNION ALL SELECT 'Spark + Databricks',   COUNT(*) FROM jobs WHERE skill_spark_pyspark=1 AND tool_databricks=1
UNION ALL SELECT 'Snowflake + dbt',      COUNT(*) FROM jobs WHERE tool_snowflake=1 AND skill_dbt=1
UNION ALL SELECT 'Kafka + Spark',        COUNT(*) FROM jobs WHERE skill_kafka=1 AND skill_spark_pyspark=1
UNION ALL SELECT 'Airflow + dbt',        COUNT(*) FROM jobs WHERE skill_airflow=1 AND skill_dbt=1
UNION ALL SELECT 'SQL + Snowflake',      COUNT(*) FROM jobs WHERE skill_sql=1 AND tool_snowflake=1
ORDER BY postings DESC;

-- 12. Skill penetration by seniority
CREATE OR REPLACE VIEW skill_by_seniority AS
SELECT
    seniority,
    COUNT(*)                                                AS total,
    ROUND(100.0 * SUM(skill_sql)           / COUNT(*), 1)   AS pct_sql,
    ROUND(100.0 * SUM(skill_python)        / COUNT(*), 1)   AS pct_python,
    ROUND(100.0 * SUM(skill_spark_pyspark) / COUNT(*), 1)   AS pct_spark,
    ROUND(100.0 * SUM(skill_airflow)       / COUNT(*), 1)   AS pct_airflow,
    ROUND(100.0 * SUM(skill_dbt)           / COUNT(*), 1)   AS pct_dbt,
    ROUND(100.0 * SUM(skill_kafka)         / COUNT(*), 1)   AS pct_kafka,
    ROUND(100.0 * SUM(tool_snowflake)      / COUNT(*), 1)   AS pct_snowflake,
    ROUND(100.0 * SUM(tool_aws)            / COUNT(*), 1)   AS pct_aws,
    ROUND(100.0 * SUM(tool_azure)          / COUNT(*), 1)   AS pct_azure,
    ROUND(100.0 * SUM(tool_gcp)            / COUNT(*), 1)   AS pct_gcp
FROM jobs
GROUP BY seniority
ORDER BY total DESC;



CREATE OR REPLACE VIEW skills_in_demand AS
SELECT skill AS skill_name, job_count,
       ROUND(100.0 * job_count / (SELECT COUNT(*) FROM jobs), 1) AS pct
FROM top_skills WHERE kind = 'skill'
ORDER BY job_count DESC;

CREATE OR REPLACE VIEW tools_in_demand AS
SELECT skill AS tool, job_count,
       ROUND(100.0 * job_count / (SELECT COUNT(*) FROM jobs), 1) AS pct
FROM top_skills WHERE kind = 'tool'
ORDER BY job_count DESC;

-- 3. Cloud platform demand (% of postings)
CREATE OR REPLACE VIEW cloud_demand AS
SELECT
    cloud_platform,
    COUNT(*)                                            AS postings,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2)  AS pct
FROM jobs
WHERE cloud_platform IS NOT NULL
GROUP BY cloud_platform
ORDER BY postings DESC;

-- 4. Data warehouse demand (% of postings)
CREATE OR REPLACE VIEW warehouse_demand AS
SELECT
    data_warehouse,
    COUNT(*)                                            AS postings,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2)  AS pct
FROM jobs
WHERE data_warehouse IS NOT NULL
  AND data_warehouse <> 'Other'
GROUP BY data_warehouse
ORDER BY postings DESC;

CREATE OR REPLACE VIEW kpis AS
SELECT
  (SELECT COUNT(*) FROM jobs) AS total_postings,
  (SELECT skill_name || '  ' || ROUND(100.0 * job_count / (SELECT COUNT(*) FROM jobs))::int || '%'
     FROM skills_in_demand ORDER BY job_count DESC LIMIT 1) AS top_skill,
  (SELECT cloud_platform || '  ' || ROUND(pct)::int || '%'
     FROM cloud_demand ORDER BY postings DESC LIMIT 1) AS top_cloud,
  (SELECT data_warehouse || '  ' || ROUND(pct)::int || '%'
     FROM warehouse_demand ORDER BY postings DESC LIMIT 1) AS top_warehouse,
  (SELECT ROUND(pct)::int || '%'
     FROM work_mode_mix WHERE work_mode = 'Remote') AS remote_share;

	 select count(*) from jobs
	 where data_warehouse='Redshift'