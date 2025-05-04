{{ config(materialized='table') }}

WITH latest_score AS (
    SELECT
        applicant_id,
        credit_score,
        score_source,
        ROW_NUMBER() OVER (PARTITION BY applicant_id ORDER BY score_date DESC) AS rn
    FROM {{ ref('stg_credit_score_snapshots') }}
)

SELECT
    a.*,
    s.credit_score AS latest_credit_score,
    s.score_source AS credit_score_source
FROM {{ ref('stg_applicants') }} a
LEFT JOIN latest_score s
  ON a.applicant_id = s.applicant_id
WHERE s.rn = 1;
