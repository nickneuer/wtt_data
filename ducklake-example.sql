
INSTALL ducklake;
INSTALL postgres;
INSTALL httpfs;
LOAD httpfs;


-- Make sure that the database `ducklake_catalog` exists in PostgreSQL.
ATTACH 'ducklake:postgres:dbname=ducklake ' AS my_ducklake
     (DATA_PATH 's3://wtt-data/ducklake/');
USE my_ducklake;

CREATE SECRET (
    TYPE postgres,
    HOST 'localhost',
    PORT 5432,
    DATABASE 'ducklake',
    USER 'ducklake',
    PASSWORD 'ducklake'
);

CREATE SECRET (
    TYPE s3,
    KEY_ID 'dagster',
    SECRET 'dagster123',
    ENDPOINT 'localhost:4566',
    USE_SSL false,
    URL_STYLE 'path',
    URL_COMPATIBILITY_MODE false
);

drop table if exists ratings_raw;
create table ratings_raw 
as select result
from read_json('https://wttcmsapigateway-new.azure-api.net/ttu/Rankings/GetRankingIndividuals?SubEventCode=MS&CategoryCode=SEN');

drop table if exists ms_ratings;
create table ms_ratings as
with ratings_parsed as (
    select unnest(result) rating_row
    from ratings_raw
)
select unnest(rating_row)
from ratings_parsed;

/* try for players */
drop table if exists players_raw;
create table players_raw 
as select result
from read_json('https://wttcmsapigateway-new.azure-api.net/ttu/Players/GetPlayers?Limit=1000');

drop table if exists all_players;
create table all_players as
with parsed as (
    select unnest(result) result
    from players_raw
)
select unnest(result)
from parsed;



drop table if exists events;
CREATE TABLE events AS 
SELECT * FROM read_parquet('s3://wtt-data/wtt_data/wtt_events/*.parquet');

drop table if exists matches;
CREATE TABLE matches AS 
SELECT * FROM read_parquet('s3://wtt-data/wtt_data/wtt_matches/*.parquet');

drop table if exists players;
CREATE TABLE players AS 
SELECT * FROM read_parquet('s3://wtt-data/wtt_data/wtt_players/*.parquet');

drop table if exists match_stats;
CREATE TABLE match_stats AS 
SELECT * FROM read_parquet('s3://wtt-data/wtt_data/wtt_match_stats/*.parquet');
