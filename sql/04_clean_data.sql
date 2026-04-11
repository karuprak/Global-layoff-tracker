USE DATABASE LAYOFF_DB;

-- Creating clean table with proper formatting
CREATE OR REPLACE TABLE LAYOFF_DB.CLEAN.layoffs_clean AS
SELECT
    TRIM(company)                             AS company,
    TRIM(location)                            AS location,
    total_laid_off,
    TRY_TO_DATE(date, 'MM/DD/YYYY')           AS layoff_date,
    percentage_laid_off,
    TRIM(industry)                            AS industry,
    TRIM(source)                              AS source,
    TRIM(stage)                               AS stage,
    funds_raised,
    TRIM(country)                             AS country,
    TRY_TO_DATE(date_added, 'MM/DD/YYYY')     AS date_added
FROM LAYOFF_DB.RAW.layoffs_raw
WHERE company IS NOT NULL;