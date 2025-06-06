
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

drop table if exists wtt_events;
CREATE TABLE wtt_events AS 
SELECT * FROM read_parquet('s3://wtt-data/wtt_events_data/wtt_events/*.parquet');

drop table if exists wtt_matches;
CREATE TABLE wtt_matches AS 
SELECT * FROM read_parquet('s3://wtt-data/wtt_events_data/wtt_matches/*.parquet');

drop table if exists wtt_players;
CREATE TABLE wtt_players AS 
SELECT * FROM read_parquet('s3://wtt-data/wtt_events_data/wtt_players/*.parquet');
