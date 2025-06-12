{{ config(
    materialized='table'
) }}

select
    IttfId ittf_id,
    PlayerName player_name,
    CountryCode country_code,
    CountryName country_name,
    AssociationCountryCode association_country_code,
    AssociationCountryName association_country_name,
    CategoryCode category_code,
    AgeCategoryCode age_category_code,
    SubEventCode sub_event_code,
    RankingYear ranking_year,
    RankingMonth ranking_month,
    RankingWeek ranking_week,
    RankingPointsYTD ranking_points_ytd,
    RankingPosition ranking_position,
    CurrentRank current_rank,
    PreviousRank previous_rank,
    RankingDifference ranking_difference,
    STRPTIME(PublishDate, '%m/%d/%Y %H:%M:%S') publish_date
from {{ ref('ms_rankings_raw') }}
union all
select
    IttfId ittf_id,
    PlayerName player_name,
    CountryCode country_code,
    CountryName country_name,
    AssociationCountryCode association_country_code,
    AssociationCountryName association_country_name,
    CategoryCode category_code,
    AgeCategoryCode age_category_code,
    SubEventCode sub_event_code,
    RankingYear ranking_year,
    RankingMonth ranking_month,
    RankingWeek ranking_week,
    RankingPointsYTD ranking_points_ytd,
    RankingPosition ranking_position,
    CurrentRank current_rank,
    PreviousRank previous_rank,
    RankingDifference ranking_difference,
    STRPTIME(PublishDate, '%m/%d/%Y %H:%M:%S') publish_date
from {{ ref('ws_rankings_raw') }}
