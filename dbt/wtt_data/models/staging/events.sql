{{ config(
    materialized='table'
) }}

select
    event_id,
    event_short_name,
    event_long_name,
    event_venue,
    event_venue_name,
    event_location,
    event_location_name,
    event_city,
    event_state,
    event_country_code,
    event_country_name,
    event_continent,
    event_sub_continent,
    event_start_date,
    event_end_date,
    event_type_code,
    event_type_description,
    ranking_year::int,
    ranking_month::int,
    ranking_week::int,
    total_mixed_players::int,
    total_men_players::int,
    total_women_players::int,
    number_of_participating_na::int,
    _dlt_load_id,
    _dlt_id
from {{ source('wtt_dlt_data', 'events') }}
