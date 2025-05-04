{{ config(materialized='table') }}

SELECT
  risk_band,
  COUNT(CASE WHEN r.payment_status = 'defaulted' THEN 1 END) * 1.0
    / COUNT(*) AS default_rate
FROM {{ ref('fact_loans') }} l
JOIN {{ ref('stg_repayments') }} r ON l.application_id = r.application_id
GROUP BY risk_band
