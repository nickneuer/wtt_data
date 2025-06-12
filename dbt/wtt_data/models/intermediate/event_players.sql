{{ config(
    materialized='table'
) }}
-- TODO: add seeds from match_stats somehow
with event_players as (
    select
        e.event_id,
        m.player1_id player_id
    from {{ ref('events') }} e
    join {{ ref('matches') }} m
        on e.event_id = m.event_id

    union

    select
        e.event_id,
        m.player2_id player_id
    from {{ ref('events') }} e
    join {{ ref('matches') }} m
        on e.event_id = m.event_id
), distinct_event_players as (
    select distinct
        event_id,
        player_id
    from event_players
)
select
    {{ dbt_utils.generate_surrogate_key(['event_id', 'player_id']) }} event_player_id,
    event_id,
    player_id
from distinct_event_players
