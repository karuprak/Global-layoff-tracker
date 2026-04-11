-- Creating the database (filing cabinet)
CREATE DATABASE IF NOT EXISTS LAYOFF_DB;

-- Creating schemas (drawers inside cabinet)
CREATE SCHEMA IF NOT EXISTS LAYOFF_DB.RAW;
CREATE SCHEMA IF NOT EXISTS LAYOFF_DB.CLEAN;