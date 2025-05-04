{{ config(materialized='table') }}

WITH date_spine AS (
    SELECT
        DATEADD(DAY, seq4(), '2022-01-01') AS date_day
    FROM TABLE(GENERATOR(ROWCOUNT => 2000))
)

SELECT *
FROM date_spine
WHERE date_day <= dateadd(CURRENT_DATE, year, 5)
