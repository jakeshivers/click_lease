{{ config(materialized='table') }}

WITH repayments_agg AS (
    SELECT
        application_id,
        COUNT(*) AS repayment_count,
        SUM(amount_paid) AS total_paid,
        MAX(CASE WHEN payment_status = 'defaulted' THEN 1 ELSE 0 END) AS is_defaulted
    FROM {{ ref('stg_repayments') }}
    GROUP BY application_id
)

SELECT
    l.application_id,
    l.applicant_id,
    l.application_date,
    l.loan_amount,
    l.term_months,
    l.purpose,
    l.status,
    l.credit_score,
    l.risk_band,
    COALESCE(r.total_paid, 0) AS total_repaid,
    COALESCE(r.repayment_count, 0) AS number_of_payments,
    COALESCE(r.is_defaulted, 0) = 1 AS is_defaulted
FROM {{ ref('stg_loan_applications') }} l
LEFT JOIN repayments_agg r
  ON l.application_id = r.application_id
