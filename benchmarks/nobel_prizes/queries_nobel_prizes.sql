--query1
SELECT award_year, category FROM target.nobel_prizes_1901_2023_awardees WHERE name = 'Albert Einstein';

--query2
SELECT award_year, category FROM target.nobel_prizes_1901_2023_awardees WHERE name = 'Niels Bohr';

--query3
SELECT award_year, category FROM target.nobel_prizes_1901_2023_awardees WHERE name = 'Marie Curie';

--query4
SELECT award_year, category FROM target.nobel_prizes_1901_2023_awardees WHERE name = 'Sir Alexander Fleming';

--query5
SELECT award_year, category FROM target.nobel_prizes_1901_2023_awardees WHERE name = 'Barack H. Obama';

--query6
SELECT award_year, category FROM target.nobel_prizes_1901_2023_awardees WHERE name = 'Peter Higgs';

--query7
SELECT award_year, category FROM target.nobel_prizes_1901_2023_awardees WHERE name = 'Kip S. Thorne';

--query8
SELECT award_year, category FROM target.nobel_prizes_1901_2023_awardees WHERE name = 'Malala Yousafzai';

--query9
SELECT award_year, category FROM target.nobel_prizes_1901_2023_awardees WHERE name = 'Ernest Hemingway';

--query10
SELECT award_year, category FROM target.nobel_prizes_1901_2023_awardees WHERE name = 'Linus Pauling';

--query11
SELECT a.category, a.name, w.birth_country FROM target.nobel_prizes_1901_2023_awardees AS a JOIN target.nobel_prizes_1901_2023_recipients as w ON a.name = w.name WHERE a.award_year = 2023;

--query12
SELECT a.category, a.name, w.birth_country FROM target.nobel_prizes_1901_2023_awardees AS a JOIN target.nobel_prizes_1901_2023_recipients as w ON a.name = w.name WHERE a.award_year = 2013;

--query13
SELECT a.category, a.name, w.birth_country FROM target.nobel_prizes_1901_2023_awardees AS a JOIN target.nobel_prizes_1901_2023_recipients as w ON a.name = w.name WHERE a.award_year = 2000;

--query14
SELECT a.category, a.name, w.birth_country FROM target.nobel_prizes_1901_2023_awardees AS a JOIN target.nobel_prizes_1901_2023_recipients as w ON a.name = w.name WHERE a.award_year = 1993;

--query15
SELECT a.category, a.name, w.birth_country FROM target.nobel_prizes_1901_2023_awardees AS a JOIN target.nobel_prizes_1901_2023_recipients as w ON a.name = w.name WHERE a.award_year = 1973;

--query16
SELECT a.category, a.name, w.birth_country FROM target.nobel_prizes_1901_2023_awardees AS a JOIN target.nobel_prizes_1901_2023_recipients as w ON a.name = w.name WHERE a.award_year = 1964;

--query17
SELECT a.category, a.name, w.birth_country FROM target.nobel_prizes_1901_2023_awardees AS a JOIN target.nobel_prizes_1901_2023_recipients as w ON a.name = w.name WHERE a.award_year = 1956;

--query18
SELECT a.category, a.name, w.birth_country FROM target.nobel_prizes_1901_2023_awardees AS a JOIN target.nobel_prizes_1901_2023_recipients as w ON a.name = w.name WHERE a.award_year = 1932;

--query19
SELECT a.category, a.name, w.birth_country FROM target.nobel_prizes_1901_2023_awardees AS a JOIN target.nobel_prizes_1901_2023_recipients as w ON a.name = w.name WHERE a.award_year = 1914;

--query20
SELECT a.category, a.name, w.birth_country FROM target.nobel_prizes_1901_2023_awardees AS a JOIN target.nobel_prizes_1901_2023_recipients as w ON a.name = w.name WHERE a.award_year = 1901;

--query21
SELECT COUNT(*) AS italian_winners FROM target.nobel_prizes_1901_2023_recipients WHERE birth_country = 'Italy';

--query22
SELECT COUNT(*) AS usa_winners FROM target.nobel_prizes_1901_2023_recipients WHERE birth_country = 'USA';

--query23
SELECT COUNT(*) AS united_kingdom_winners FROM target.nobel_prizes_1901_2023_recipients WHERE birth_country = 'United Kingdom';

--query24
SELECT COUNT(*) AS germany_winners FROM target.nobel_prizes_1901_2023_recipients WHERE birth_country = 'Germany';

--query25
SELECT COUNT(*) AS france_winners FROM target.nobel_prizes_1901_2023_recipients WHERE birth_country = 'France';

--query26
SELECT COUNT(*) AS sweden_winners FROM target.nobel_prizes_1901_2023_recipients WHERE birth_country = 'Sweden';

--query27
SELECT COUNT(*) AS poland_winners FROM target.nobel_prizes_1901_2023_recipients WHERE birth_country = 'Poland';

--query28
SELECT COUNT(*) AS russia_winners FROM target.nobel_prizes_1901_2023_recipients WHERE birth_country = 'Russia';

--query29
SELECT COUNT(*) AS the_netherlands_winners FROM target.nobel_prizes_1901_2023_recipients WHERE birth_country = 'the Netherlands';

--query30
SELECT COUNT(*) AS japan_winners FROM target.nobel_prizes_1901_2023_recipients WHERE birth_country = 'Japan';

--query31
SELECT a.award_year, a.category, w.birth_country FROM target.nobel_prizes_1901_2023_awardees AS a JOIN target.nobel_prizes_1901_2023_recipients AS w ON a.name = w.name WHERE a.name = 'Rita Levi-Montalcini';

--query32
SELECT a.award_year, a.category, w.birth_country FROM target.nobel_prizes_1901_2023_awardees AS a JOIN target.nobel_prizes_1901_2023_recipients AS w ON a.name = w.name WHERE a.name = 'John Bardeen';

--query33
SELECT a.award_year, a.category, w.birth_country FROM target.nobel_prizes_1901_2023_awardees AS a JOIN target.nobel_prizes_1901_2023_recipients AS w ON a.name = w.name WHERE a.name = 'Frederick Sanger';

--query34
SELECT a.award_year, a.category, w.birth_country FROM target.nobel_prizes_1901_2023_awardees AS a JOIN target.nobel_prizes_1901_2023_recipients AS w ON a.name = w.name WHERE a.name = 'Tu Youyou';

--query35
SELECT a.award_year, a.category, w.birth_country FROM target.nobel_prizes_1901_2023_awardees AS a JOIN target.nobel_prizes_1901_2023_recipients AS w ON a.name = w.name WHERE a.name = 'Liu Xiaobo';

--query36
SELECT a.award_year, a.category, w.birth_country FROM target.nobel_prizes_1901_2023_awardees AS a JOIN target.nobel_prizes_1901_2023_recipients AS w ON a.name = w.name WHERE a.name = 'Toni Morrison';

--query37
SELECT a.award_year, a.category, w.birth_country FROM target.nobel_prizes_1901_2023_awardees AS a JOIN target.nobel_prizes_1901_2023_recipients AS w ON a.name = w.name WHERE a.name = 'Richard P. Feynman';

--query38
SELECT a.award_year, a.category, w.birth_country FROM target.nobel_prizes_1901_2023_awardees AS a JOIN target.nobel_prizes_1901_2023_recipients AS w ON a.name = w.name WHERE a.name = 'Joseph E. Stiglitz';

--query39
SELECT a.award_year, a.category, w.birth_country FROM target.nobel_prizes_1901_2023_awardees AS a JOIN target.nobel_prizes_1901_2023_recipients AS w ON a.name = w.name WHERE a.name = 'Bob Dylan';

--query40
SELECT a.award_year, a.category, w.birth_country FROM target.nobel_prizes_1901_2023_awardees AS a JOIN target.nobel_prizes_1901_2023_recipients AS w ON a.name = w.name WHERE a.name = 'Mother Teresa';

--query41
SELECT award_year, COUNT(*) AS nobel_awarded FROM target.nobel_prizes_1901_2023_awardees WHERE award_year BETWEEN 1940 AND 1945 GROUP BY award_year;

--query42
SELECT award_year, COUNT(*) AS nobel_awarded FROM target.nobel_prizes_1901_2023_awardees WHERE award_year BETWEEN 1914 AND 1918 GROUP BY award_year;

--query43
SELECT award_year, COUNT(*) AS nobel_awarded FROM target.nobel_prizes_1901_2023_awardees WHERE award_year BETWEEN 2019 AND 2023 GROUP BY award_year;

--query44
SELECT award_year, COUNT(*) AS nobel_awarded FROM target.nobel_prizes_1901_2023_awardees WHERE award_year BETWEEN 1920 AND 1930 GROUP BY award_year;

--query45
SELECT award_year, COUNT(*) AS nobel_awarded FROM target.nobel_prizes_1901_2023_awardees WHERE award_year BETWEEN 1930 AND 1940 GROUP BY award_year;

--query46
SELECT award_year, COUNT(*) AS nobel_awarded FROM target.nobel_prizes_1901_2023_awardees WHERE award_year BETWEEN 1950 AND 1960 GROUP BY award_year;

--query47
SELECT award_year, COUNT(*) AS nobel_awarded FROM target.nobel_prizes_1901_2023_awardees WHERE award_year BETWEEN 1970 AND 1980 GROUP BY award_year;

--query48
SELECT award_year, COUNT(*) AS nobel_awarded FROM target.nobel_prizes_1901_2023_awardees WHERE award_year BETWEEN 1980 AND 1990 GROUP BY award_year;

--query49
SELECT award_year, COUNT(*) AS nobel_awarded FROM target.nobel_prizes_1901_2023_awardees WHERE award_year BETWEEN 1990 AND 2000 GROUP BY award_year;

--query50
SELECT award_year, COUNT(*) AS nobel_awarded FROM target.nobel_prizes_1901_2023_awardees WHERE award_year BETWEEN 2000 AND 2010 GROUP BY award_year;
