{{ config(materialized='table') }}

SELECT
    applicant_id,
    COUNT(*) AS total_applications,
    SUM(CASE WHEN status = 'approved' THEN 1 ELSE 0 END) AS approved_count,
    AVG(credit_score) AS avg_credit_score,
    MIN(application_date) AS first_application,
    MAX(application_date) AS most_recent_application
FROM {{ ref('stg_loan_applications') }}
GROUP BY applicant_id