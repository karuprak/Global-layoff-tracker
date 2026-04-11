USE DATABASE LAYOFF_DB;
USE SCHEMA RAW;

-- Creating raw table matching CSV column order exactly
CREATE OR REPLACE TABLE layoffs_raw (
    company                STRING,
    location               STRING,
    total_laid_off         INT,
    date                   STRING,
    percentage_laid_off    FLOAT,
    industry               STRING,
    source                 STRING,
    stage                  STRING,
    funds_raised           FLOAT,
    country                STRING,
    date_added             STRING
);