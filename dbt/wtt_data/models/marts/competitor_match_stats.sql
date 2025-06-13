{{ config(
    materialized='table'
) }}

with base as (
    select
        -- match-level identifiers and metadata
        match_id,
        match_status_id as match_stats_id,
        event_id,
        competition_code,
        category_code,
        age_category_code,
        para_class,
        match_description,
        gender,
        start_date_utc,
        start_date_local,
        match_score,
        game_score,
        match_number,
        best_of_x_games,
        venue,
        venue_name,
        created_date_time_utc,
        _dlt_id,
        _dlt_load_id,

        -- winner/loser indicators
        wlt1, wlt2,
        competitor_result1, competitor_result2,

        -- athlete and competitor fields (all 1/2 variants)
        competitor1_id, competitor2_id,
        competitor1_type, competitor2_type,
        competitor1_wlt, competitor2_wlt,
        competitor1_org_name, competitor2_org_name,
        competitor1_pts_won_value, competitor2_pts_won_value,
        competitor1_lead_max_value, competitor2_lead_max_value,
        competitor1_lead_max_agnst_value, competitor2_lead_max_agnst_value,
        competitor1_pts_service_won_value, competitor2_pts_service_won_value,
        competitor1_pts_opp_service_won_value, competitor2_pts_opp_service_won_value,
        competitor1_pts_service_lost_value, competitor2_pts_service_lost_value,
        competitor1_pts_opp_service_lost_value, competitor2_pts_opp_service_lost_value,
        competitor1_pts_consec_value, competitor2_pts_consec_value,
        competitor1_def_ovc_max_value, competitor2_def_ovc_max_value,
        competitor1_team_name, competitor2_team_name,
        competitor1_g1_score, competitor2_g1_score,
        competitor1_g2_score, competitor2_g2_score,
        competitor1_g3_score, competitor2_g3_score,
        competitor1_g4_score, competitor2_g4_score,
        competitor1_g5_score, competitor2_g5_score,
        competitor1_g6_score, competitor2_g6_score,
        competitor1_g7_score, competitor2_g7_score,

        -- athlete 1 & 2 (main)
        athelete1_id, athelete2_id,
        athelete1_given_name, athelete2_given_name,
        athelete1_family_name, athelete2_family_name,
        athelete1_gender, athelete2_gender,
        athelete1_organization, athelete2_organization,
        athelete1_birth_date, athelete2_birth_date,
        athelete1_if_id, athelete2_if_id,
        athelete1_seed,
        athelete2_seed

    from {{ source('wtt_dlt_data', 'match_stats') }}
),

long_format as (

    select
        match_id,
        match_stats_id,
        event_id,
        competition_code,
        category_code,
        age_category_code,
        para_class,
        match_description,
        gender,
        start_date_utc,
        start_date_local,
        match_score,
        game_score,
        match_number,
        best_of_x_games,
        venue,
        venue_name,
        created_date_time_utc,
        _dlt_id,
        _dlt_load_id,

        1 as player_number,

        -- athlete fields
        athelete1_id as player_id,
        athelete2_id as opponent_id,
        athelete1_given_name as given_name,
        athelete1_family_name as family_name,
        athelete1_gender as gender,
        athelete1_organization as organization,
        athelete1_birth_date as birth_date,
        athelete1_if_id as if_id,
        athelete1_seed as seed,

        -- competitor fields
        competitor1_id as competitor_id,
        competitor2_id as opponent_competitor_id,
        competitor1_type as competitor_type,
        competitor1_wlt as wlt,
        competitor1_org_name as org_name,
        competitor1_pts_won_value as pts_won_value,
        competitor1_lead_max_value as lead_max_value,
        competitor1_lead_max_agnst_value as lead_max_agnst_value,
        competitor1_pts_service_won_value as pts_service_won_value,
        competitor1_pts_opp_service_won_value as pts_opp_service_won_value,
        competitor1_pts_service_lost_value as pts_service_lost_value,
        competitor1_pts_opp_service_lost_value as pts_opp_service_lost_value,
        competitor1_pts_consec_value as pts_consec_value,
        competitor1_def_ovc_max_value as def_ovc_max_value,
        competitor1_team_name as team_name,
        competitor_result1 as competitor_result,

        -- score fields
        competitor1_g1_score as g1,
        competitor1_g2_score as g2,
        competitor1_g3_score as g3,
        competitor1_g4_score as g4,
        competitor1_g5_score as g5,
        competitor1_g6_score as g6,
        competitor1_g7_score as g7,

        wlt1 = 'W' as is_winner

    from base

    union all

    select
        match_id,
        match_stats_id,
        event_id,
        competition_code,
        category_code,
        age_category_code,
        para_class,
        match_description,
        gender,
        start_date_utc,
        start_date_local,
        match_score,
        game_score,
        match_number,
        best_of_x_games,
        venue,
        venue_name,
        created_date_time_utc,
        _dlt_id,
        _dlt_load_id,

        2 as player_number,

        -- athlete fields
        athelete2_id as player_id,
        athelete1_id as opponent_id,
        athelete2_given_name as given_name,
        athelete2_family_name as family_name,
        athelete2_gender as gender,
        athelete2_organization as organization,
        athelete2_birth_date as birth_date,
        athelete2_if_id as if_id,
        athelete2_seed as seed,

        -- competitor fields
        competitor2_id as competitor_id,
        competitor1_id as opponent_competitor_id,
        competitor2_type as competitor_type,
        competitor2_wlt as wlt,
        competitor2_org_name as org_name,
        competitor2_pts_won_value as pts_won_value,
        competitor2_lead_max_value as lead_max_value,
        competitor2_lead_max_agnst_value as lead_max_agnst_value,
        competitor2_pts_service_won_value as pts_service_won_value,
        competitor2_pts_opp_service_won_value as pts_opp_service_won_value,
        competitor2_pts_service_lost_value as pts_service_lost_value,
        competitor2_pts_opp_service_lost_value as pts_opp_service_lost_value,
        competitor2_pts_consec_value as pts_consec_value,
        competitor2_def_ovc_max_value as def_ovc_max_value,
        competitor2_team_name as team_name,
        competitor_result2 as competitor_result,

        -- score fields
        competitor2_g1_score as g1,
        competitor2_g2_score as g2,
        competitor2_g3_score as g3,
        competitor2_g4_score as g4,
        competitor2_g5_score as g5,
        competitor2_g6_score as g6,
        competitor2_g7_score as g7,

        wlt2 = 'W' as is_winner

    from base
)

select * from long_format

