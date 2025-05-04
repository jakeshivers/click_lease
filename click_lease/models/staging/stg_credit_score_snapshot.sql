{{ config(materialized='view') }}

SELECT
 snapshot_id,
 applicant_id,
 score_date,
 credit_score,
 score_source

FROM {{ source('raw', 'RAW_CREDIT_SCORE_SNAPSHOTS') }}
