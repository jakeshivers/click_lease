{% macro backfill_date_spine(start_date='2022-01-01', end_date='2027-12-31') %}
    {{ generate_date_spine(start_date, end_date) }}
{% endmacro %}