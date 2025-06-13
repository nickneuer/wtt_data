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
    try_cast(RankingYear as int) ranking_year,
    try_cast(RankingMonth as int) ranking_month,
    try_cast(RankingWeek as int) ranking_week,
    try_cast(RankingPointsYTD as int) ranking_points_ytd,
    try_cast(RankingPosition as int) ranking_position,
    try_cast(CurrentRank as int) current_rank,
    try_cast(PreviousRank as int) previous_rank,
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
    try_cast(RankingYear as int) ranking_year,
    try_cast(RankingMonth as int) ranking_month,
    try_cast(RankingWeek as int) ranking_week,
    try_cast(RankingPointsYTD as int) ranking_points_ytd,
    try_cast(RankingPosition as int) ranking_position,
    try_cast(CurrentRank as int) current_rank,
    try_cast(PreviousRank as int) previous_rank,
    RankingDifference ranking_difference,
    STRPTIME(PublishDate, '%m/%d/%Y %H:%M:%S') publish_date
from {{ ref('ws_rankings_raw') }}
