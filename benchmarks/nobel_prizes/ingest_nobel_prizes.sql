CREATE SCHEMA IF NOT EXISTS target;
CREATE TABLE target.nobel_prizes_1901_2023_awardees(id BIGINT, award_year BIGINT, date_awarded VARCHAR, category VARCHAR, is_shared BIGINT, name VARCHAR, is_repeat_winner BIGINT, affiliation_name VARCHAR, affiliation_city VARCHAR, affiliation_country VARCHAR);
CREATE TABLE target.nobel_prizes_1901_2023_recipients(name VARCHAR, full_name VARCHAR, sex VARCHAR, birth_date VARCHAR, birth_city VARCHAR, birth_country VARCHAR, death_date VARCHAR, death_city VARCHAR, death_country VARCHAR);

COPY target.nobel_prizes_1901_2023_awardees FROM 'nobel_prizes_1901_2023_awardees.csv';
COPY target.nobel_prizes_1901_2023_recipients FROM 'nobel_prizes_1901_2023_recipients.csv';