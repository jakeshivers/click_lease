{{ config(materialized='view') }}

SELECT
 snapshot_id,
 applicant_id,
 score_date,
 credit_score,
 score_source

FROM {{ source('raw', 'raw_credit_score_snapshots') }}
