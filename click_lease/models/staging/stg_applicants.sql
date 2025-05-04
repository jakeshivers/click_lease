{{ config(materialized='view') }}

SELECT
    applicant_id,
    INITCAP(business_name) AS business_name,
    industry,
    founded_date,
    annual_revenue,
    num_employees
FROM {{ source('raw', 'raw_applicants') }}
