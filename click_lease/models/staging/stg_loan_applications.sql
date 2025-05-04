{{ config(materialized='view') }}

select 
    application_id,
    applicant_id,
    application_date,
    loan_amount,
    term_months,
    purpose,
    status,
    credit_score,
    risk_band
from  {{ source('raw', 'raw_loan_applications') }} l