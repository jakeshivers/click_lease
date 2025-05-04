{{ config(materialized='table') }}

WITH loan_activity AS (
    SELECT
        l.application_id,
        l.applicant_id,
        l.application_date,
        l.status,
        l.loan_amount
    FROM {{ ref('stg_loan_applications') }} l
    WHERE status = 'approved'
)

SELECT
    d.date_day,
    a.application_id,
    a.applicant_id,
    a.loan_amount
FROM {{ ref('date_spine') }} d
LEFT JOIN loan_activity a
  ON d.date_day = a.application_date
