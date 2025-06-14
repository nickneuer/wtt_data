{{ config(
    materialized='table'
) }}

select
    event_id,
    match_id,
    match_key,
    sub_event_code,
    match_name,
    group1_id,
    player1_id,
    player1_name,
    player1_given_name,
    player1_family_name,
    player1_family_name_first,
    player1_country_code,
    player1_country_name,
    player1_gender,
    player1_age,
    player1_dob,
    player1_handedness,
    player1_grip,
    player1_style,
    player1_equipment_sponsor,
    player1_blade_type,
    player1_racket_coloring_a,
    player1_racket_coloring_b,
    player1_racket_covering_a,
    player1_racket_covering_b,
    player1_active_since,
    player1d_family_name_first,
    player1d_equipment_sponsor,
    player1d_blade_type,
    player1d_racket_coloring_a,
    player1d_racket_coloring_b,
    player1d_racket_covering_a,
    player1d_racket_covering_b,
    player1d_active_since,
    group2_id,
    player2_id,
    player2_name,
    player2_given_name,
    player2_family_name,
    player2_family_name_first,
    player2_country_code,
    player2_country_name,
    player2_gender,
    player2_age,
    player2_dob,
    player2_equipment_sponsor,
    player2_blade_type,
    player2_racket_coloring_a,
    player2_racket_coloring_b,
    player2_racket_covering_a,
    player2_racket_covering_b,
    player2_active_since,
    player2d_family_name_first,
    player2d_equipment_sponsor,
    player2d_blade_type,
    player2d_racket_coloring_a,
    player2d_racket_coloring_b,
    player2d_racket_covering_a,
    player2d_racket_covering_b,
    player2d_active_since,
    match_number,
    match_score,
    match_result,
    _dlt_load_id,
    _dlt_id,
    player2_handedness,
    player2_grip,
    player2_style
from {{ source('wtt_dlt_data', 'matches') }}
