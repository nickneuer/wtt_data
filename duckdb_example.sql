
INSTALL httpfs;
LOAD httpfs;

-- SET s3_url_style='path';
-- SET s3_endpoint='http://localhost:4566';
-- SET s3_access_key_id='dagster' ;
-- SET s3_secret_access_key='dagster123';

CREATE SECRET (
    TYPE s3,
    KEY_ID 'dagster',
    SECRET 'dagster123',
    ENDPOINT 'localhost:4566',
    USE_SSL false,
    URL_STYLE 'path',
    URL_COMPATIBILITY_MODE false
);

drop table if exists events;
CREATE TABLE events AS 
SELECT * FROM read_parquet('s3://wtt-data/wtt_events_data/wtt_events/*.parquet');

drop table if exists matches;
CREATE TABLE matches AS 
SELECT * FROM read_parquet('s3://wtt-data/wtt_events_data/wtt_matches/*.parquet');

drop table if exists players;
CREATE TABLE players AS 
SELECT * FROM read_parquet('s3://wtt-data/wtt_events_data/wtt_players/*.parquet');

drop table if exists match_stats;
CREATE TABLE match_stats AS 
SELECT * FROM read_parquet('s3://wtt-data/wtt_events_data/wtt_match_stats/*.parquet');
