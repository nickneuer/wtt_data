{{ config(
    materialized='table'
) }}

select
    ittf_id,
    player_name,
    player_given_name,
    player_family_name,
    player_family_name_first,
    country_code,
    country_name,
    nationality_code,
    nationality_name,
    organization_code,
    organization_name,
    gender,
    age,
    STRPTIME(dob, '%m/%d/%Y %H:%M:%S') birth_date,
    head_shot,
    _dlt_load_id,
    _dlt_id,
    handedness,
    grip
from {{ source('wtt_dlt_data', 'players') }}
