{{ config(
    materialized='table'
) }}

with ratings_raw as (
    select result
    from {{ source('wtt_api', 'rankings_adult_women') }}
), ratings_parsed as (
    select unnest(result) rating_row
    from ratings_raw
), unnested as (
    select unnest(rating_row)
    from ratings_parsed
) select * from unnested
