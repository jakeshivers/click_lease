{{ config(materialized='table') }}

SELECT
  a.business_name,
  SUM(l.loan_amount) AS total_loans
FROM {{ ref('fact_loans') }} l
JOIN {{ ref('dim_applicants') }} a ON a.applicant_id = l.applicant_id
GROUP BY a.business_name
ORDER BY total_loans DESC
LIMIT 10
