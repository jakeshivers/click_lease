{{ config(materialized='table') }}

WITH repayments_summary AS (
    SELECT
        application_id,
        COUNT(*) AS repayment_count,
        SUM(amount_paid) AS total_repaid,
        MAX(payment_date) AS last_payment_date,
        MAX(CASE WHEN payment_status = 'defaulted' THEN 1 ELSE 0 END) AS has_default
    FROM {{ ref('stg_repayments') }}
    GROUP BY application_id
)

SELECT
    l.*,
    r.total_repaid,
    r.repayment_count,
    r.last_payment_date,
    r.has_default
FROM {{ ref('stg_loan_applications') }} l
LEFT JOIN repayments_summary r
  ON l.application_id = r.application_id;