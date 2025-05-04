{{ config(materialized='table') }}

WITH date_spine AS (
    SELECT DATEADD(DAY, SEQ4(), '2022-01-01') AS date_day
    FROM TABLE(GENERATOR(ROWCOUNT => 5000))
)
SELECT *
FROM date_spine
WHERE date_day <= CURRENT_DATE
