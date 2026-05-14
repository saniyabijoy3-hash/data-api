CREATE OR REPLACE DATABASE weather1_db;
CREATE OR REPLACE SCHEMA weather1_schema;

USE DATABASE weather1_db;
USE SCHEMA weather1_schema;

CREATE OR REPLACE FILE FORMAT weather_json
TYPE = JSON;

CREATE OR REPLACE STAGE my_stage
URL = 's3://weatherdata9/'
CREDENTIALS = (
    AWS_KEY_ID = os.getenv('AWS_KEY_ID'),
    AWS_SECRET_KEY = os.getenv('AWS_SECRET_KEY')
)
FILE_FORMAT = weather_json;

LIST @my_stage;

CREATE OR REPLACE TABLE weather1_table (
    data VARIANT
);

COPY INTO weather1_table(data)
FROM @my_stage
FILE_FORMAT = (TYPE = JSON);

SELECT data
FROM weather1_table
LIMIT 1;

SELECT
    data:city::STRING AS city,
    data:temperature::FLOAT AS temperature,
    data:humidity::INTEGER AS humidity,
    data:weather::STRING AS weather,
    data:time::TIMESTAMP AS weather_time
FROM weather1_table;

CREATE OR REPLACE PIPE weather_pipe
AUTO_INGEST = FALSE
AS
COPY INTO weather1_table
FROM @my_stage
FILE_FORMAT = (TYPE = JSON);

ALTER PIPE weather_pipe REFRESH;

SHOW PIPES;
desc pipe weather_pipe;
SELECT * FROM weather1_table;