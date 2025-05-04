version: 2

models:
  - name: stg_applicants
    description: Cleaned applicants staging model
    columns:
      - name: applicant_id
        tests:
          - not_null
          - unique

      - name: annual_revenue
        tests:
          - dbt_expectations.expect_column_values_to_be_between:
              min_value: 0
              strict_min: true
