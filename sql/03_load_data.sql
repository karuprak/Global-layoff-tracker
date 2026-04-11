
USE DATABASE LAYOFF_DB;
USE SCHEMA RAW;

-- Creating the loading dock (stage)
CREATE OR REPLACE STAGE layoff_stage
FILE_FORMAT = (
    TYPE = 'CSV'
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    SKIP_HEADER = 1
    EMPTY_FIELD_AS_NULL = TRUE
);

-- Loading the data from stage into raw table
COPY INTO layoffs_raw
FROM @layoff_stage
FILE_FORMAT = (
    TYPE = 'CSV'
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    SKIP_HEADER = 1
    EMPTY_FIELD_AS_NULL = TRUE
    NULL_IF = ('NULL', 'null', 'N/A', '')
)
ON_ERROR = 'CONTINUE';