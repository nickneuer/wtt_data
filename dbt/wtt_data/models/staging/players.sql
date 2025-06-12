{{ config(
    materialized='table',
    database='wtt_ducklake',
    pre_hook=[
      "ATTACH 'ducklake:postgres:dbname=ducklake' AS wtt_ducklake (DATA_PATH 's3://wtt-data/ducklake/')"
    ]
) }}

select
    *
from {{ source('wtt_dlt_data', 'players') }}
