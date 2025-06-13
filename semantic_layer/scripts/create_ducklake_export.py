
import duckdb
import argparse

DUCKLAKE_TABLES = [
    "events",
    "players",
    "player_ratings",
    "event_players",
    "match_stats",
    "matches"
]

# def create_ducklake_wrapper(wrapper_db_path, ducklake_tables=DUCKLAKE_TABLES):
#     db = duckdb.connect(wrapper_db_path)

#     db.sql("""
#     install postgres;

#     create secret if not exists (
#         TYPE postgres,
#         HOST 'localhost',
#         PORT 5432,
#         DATABASE ducklake,
#         USER 'ducklake',
#         PASSWORD 'ducklake'
#     );

#     ATTACH 'ducklake:postgres:dbname=ducklake ' AS wtt_ducklake
#          (DATA_PATH 's3://wtt-data/ducklake/');
#     """)

#     for table in ducklake_tables:
#         # create a view for the associated table in this db
#         sql = f"create or replace view {table} as select t.* from wtt_ducklake.main.{table} t;"
#         db.sql(sql)

#     db.close()

def create_ducklake_wrapper(wrapper_db_path, ducklake_tables=DUCKLAKE_TABLES):
    db = duckdb.connect()

    db.sql(f"""
    INSTALL postgres;
    INSTALL httpfs;
    INSTALL ducklake;
    LOAD httpfs;

    CREATE or replace SECRET (
        TYPE postgres,
        HOST 'localhost',
        PORT 5432,
        DATABASE ducklake,
        USER 'ducklake',
        PASSWORD 'ducklake'
    );

    CREATE or replace SECRET (
        TYPE s3,
        KEY_ID 'dagster',
        SECRET 'dagster123',
        ENDPOINT 'localhost:9000',
        USE_SSL false,
        URL_STYLE 'path',
        URL_COMPATIBILITY_MODE false
    );

    ATTACH 'ducklake:postgres:dbname=ducklake' AS wtt_ducklake
        (DATA_PATH 's3://wtt-data/ducklake/');

    ATTACH '{wrapper_db_path}' as wrapper_db;

    """)

    # Confirm catalog + schema exist
    # schemas = db.sql("SHOW SCHEMAS FROM wtt_ducklake").fetchall()
    # print("Schemas in DuckLake:", schemas)

    for table in ducklake_tables:
        print(f"Creating table {table}")
        db.sql(f"""
            use wrapper_db;
            drop table if exists wrapper_db.{table};
            create table wrapper_db.{table} AS
            SELECT t.* FROM wtt_ducklake.{table} t
        """)

    db.close()

if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument('-db', "--db_file_path", default='../wtt_ducklake_export.db', help="")
    args = parser.parse_args()

    create_ducklake_wrapper(args.db_file_path)

