USE DATABASE LAYOFF_DB;
USE SCHEMA CLEAN;

--Query 1: Top 10 companies by layoffs
SELECT 
    company,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_clean
WHERE total_laid_off IS NOT NULL
GROUP BY company
ORDER BY total_laid_off DESC
LIMIT 10;

-- Query 2: Industry impact 
SELECT 
    industry,
    SUM(total_laid_off)                      AS total_laid_off,
    ROUND(AVG(percentage_laid_off)*100, 1)   AS avg_percent_laid_off
FROM layoffs_clean
WHERE total_laid_off IS NOT NULL
AND industry IS NOT NULL
GROUP BY industry
ORDER BY total_laid_off DESC;

--Query 3: Layoffs by year 
SELECT 
    YEAR(layoff_date)   AS layoff_year,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_clean
WHERE total_laid_off IS NOT NULL
AND layoff_date IS NOT NULL
GROUP BY layoff_year
ORDER BY layoff_year ASC;

--Query 4: Layoffs by country
SELECT 
    country,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_clean
WHERE total_laid_off IS NOT NULL
AND country IS NOT NULL
GROUP BY country
ORDER BY total_laid_off DESC
LIMIT 10;

--Query 5: Monthly trend
SELECT 
    DATE_TRUNC('month', layoff_date) AS layoff_month,
    SUM(total_laid_off)              AS total_laid_off
FROM layoffs_clean
WHERE total_laid_off IS NOT NULL
AND layoff_date IS NOT NULL
GROUP BY layoff_month
ORDER BY layoff_month ASC;

--Query 6: Company stage
SELECT 
    stage,
    SUM(total_laid_off) AS total_laid_off,
    COUNT(*)            AS number_of_events
FROM layoffs_clean
WHERE total_laid_off IS NOT NULL
AND stage IS NOT NULL
GROUP BY stage
ORDER BY total_laid_off DESC;

--Query 7: Rolling 3 month total
SELECT
    DATE_TRUNC('month', layoff_date)         AS layoff_month,
    SUM(total_laid_off)                      AS monthly_total,
    SUM(SUM(total_laid_off)) OVER (
        ORDER BY DATE_TRUNC('month', layoff_date)
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    )                                        AS rolling_3month_total
FROM layoffs_clean
WHERE total_laid_off IS NOT NULL
AND layoff_date IS NOT NULL
GROUP BY layoff_month
ORDER BY layoff_month ASC;

--Query 8: Year over year by industry
SELECT
    industry,
    YEAR(layoff_date)                        AS layoff_year,
    SUM(total_laid_off)                      AS total_laid_off,
    LAG(SUM(total_laid_off)) OVER (
        PARTITION BY industry
        ORDER BY YEAR(layoff_date)
    )                                        AS prev_year_total,
    SUM(total_laid_off) - LAG(SUM(total_laid_off)) OVER (
        PARTITION BY industry
        ORDER BY YEAR(layoff_date)
    )                                        AS yoy_change
FROM layoffs_clean
WHERE total_laid_off IS NOT NULL
AND layoff_date IS NOT NULL
AND industry IS NOT NULL
GROUP BY industry, layoff_year
ORDER BY industry, layoff_year;

--Query 9: Rank companies within industry
SELECT
    industry,
    company,
    SUM(total_laid_off)                      AS total_laid_off,
    RANK() OVER (
        PARTITION BY industry
        ORDER BY SUM(total_laid_off) DESC
    )                                        AS rank_in_industry
FROM layoffs_clean
WHERE total_laid_off IS NOT NULL
AND industry IS NOT NULL
GROUP BY industry, company
QUALIFY rank_in_industry <= 3
ORDER BY industry, rank_in_industry;

--Query 10: Country % of global layoffs
SELECT
    country,
    SUM(total_laid_off)                      AS total_laid_off,
    ROUND(
        SUM(total_laid_off) * 100.0 /
        SUM(SUM(total_laid_off)) OVER ()
    , 2)                                     AS pct_of_global_layoffs
FROM layoffs_clean
WHERE total_laid_off IS NOT NULL
AND country IS NOT NULL
GROUP BY country
ORDER BY total_laid_off DESC
LIMIT 10;