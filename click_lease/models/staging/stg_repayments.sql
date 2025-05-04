{{ config(materialized='view') }}

SELECT
    repayment_id,
    application_id,
    payment_date,
    amount_paid,
    payment_status
FROM {{ source('raw', 'raw_repayments') }};
