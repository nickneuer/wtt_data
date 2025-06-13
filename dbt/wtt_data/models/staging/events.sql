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
    try_cast(ranking_year as int) ranking_year,
    try_cast(ranking_month as int) ranking_month,
    try_cast(ranking_week as int) ranking_week,
    try_cast(total_mixed_players as int) total_mixed_players,
    try_cast(total_men_players as int) total_men_players,
    try_cast(total_women_players as int) total_women_players,
    try_cast(number_of_participating_na as int) number_of_participating_na,
    _dlt_load_id,
    _dlt_id
from {{ source('wtt_dlt_data', 'events') }}
