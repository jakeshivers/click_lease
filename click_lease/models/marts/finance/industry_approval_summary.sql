{{ config(materialized='table') }}

SELECT
  a.industry,
  COUNT(*) AS total_apps,
  COUNT(CASE WHEN status = 'approved' THEN 1 END) * 1.0 / COUNT(*) AS approval_rate
FROM {{ ref('fact_loans') }} l
JOIN {{ ref('dim_applicants') }} a ON l.applicant_id = a.applicant_id
GROUP BY 1
ORDER BY 2 DESC
