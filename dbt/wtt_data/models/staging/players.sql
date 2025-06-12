{{ config(
    materialized='table'
) }}

select
    *
from {{ source('wtt_dlt_data', 'players') }}
