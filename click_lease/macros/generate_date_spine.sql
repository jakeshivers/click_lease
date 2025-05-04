{% macro generate_date_spine(start_date='2022-01-01', end_date='2027-12-31') %}
WITH date_spine AS (
    SELECT DATEADD(DAY, SEQ4(), '{{ start_date }}') AS date_day
    FROM TABLE(GENERATOR(ROWCOUNT => 5000))
)
SELECT *
FROM date_spine
WHERE date_day <= {{ end_date }}
{% endmacro %}
