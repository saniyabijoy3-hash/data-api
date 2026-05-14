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
