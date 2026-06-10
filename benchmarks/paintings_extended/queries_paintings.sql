--query1
SELECT name, city FROM target.museum WHERE country = 'USA';

--query2
SELECT name, city FROM target.museum WHERE country = 'France';

--query3
SELECT name, city FROM target.museum WHERE country = 'UK';

--query4
SELECT name, city FROM target.museum WHERE country = 'Netherlands';

--query5
SELECT name, city FROM target.museum WHERE country = 'Spain';

--query6
SELECT name, city FROM target.museum WHERE country = 'Russia';

--query7
SELECT name, city FROM target.museum WHERE country = 'Switzerland';

--query8
SELECT name, city FROM target.museum WHERE country = 'Australia';

--query9
SELECT name, city FROM target.museum WHERE country = 'Brazil';

--query10
SELECT name, city FROM target.museum WHERE country = 'Italy';

--query11
SELECT full_name FROM target.artist WHERE nationality = 'French' AND birth >= 1800 AND birth <= 1899;

--query12
SELECT full_name FROM target.artist WHERE nationality = 'American' AND birth >= 1800 AND birth <= 1899;

--query13
SELECT full_name FROM target.artist WHERE nationality = 'Dutch' AND birth >= 1600 AND birth <= 1699;

--query14
SELECT full_name FROM target.artist WHERE nationality = 'English' AND birth >= 1700 AND birth <= 1799;

--query15
SELECT full_name FROM target.artist WHERE nationality = 'Italian' AND birth >= 1400 AND birth <= 1599;

--query16
SELECT full_name FROM target.artist WHERE nationality = 'German' AND birth >= 1800 AND birth <= 1899;

--query17
SELECT full_name FROM target.artist WHERE nationality = 'Russian' AND birth >= 1800 AND birth <= 1899;

--query18
SELECT full_name FROM target.artist WHERE nationality = 'Spanish' AND birth >= 1500 AND birth <= 1699;

--query19
SELECT full_name FROM target.artist WHERE nationality = 'Flemish' AND birth >= 1500 AND birth <= 1699;

--query20
SELECT full_name FROM target.artist WHERE nationality = 'Austrian' AND birth >= 1800 AND birth <= 1899;

--query21
SELECT full_name, nationality FROM target.artist WHERE style = 'Baroque' AND nationality = 'Dutch';

--query22
SELECT full_name, nationality FROM target.artist WHERE style = 'Impressionist' AND nationality = 'French';

--query23
SELECT full_name, nationality FROM target.artist WHERE style = 'Impressionist' AND nationality = 'American';

--query24
SELECT full_name, nationality FROM target.artist WHERE style = 'Hudson River School' AND nationality = 'American';

--query25
SELECT full_name, nationality FROM target.artist WHERE style = 'Realist' AND nationality = 'American';

--query26
SELECT full_name, nationality FROM target.artist WHERE style = 'Marine Art' AND nationality = 'English';

--query27
SELECT full_name, nationality FROM target.artist WHERE style = 'Colonial' AND nationality = 'American';

--query28
SELECT full_name, nationality FROM target.artist WHERE style = 'Expressionist' AND nationality = 'German';

--query29
SELECT full_name, nationality FROM target.artist WHERE style = 'Post-Impressionist' AND nationality = 'French';

--query30
SELECT full_name, nationality FROM target.artist WHERE style = 'Neoclassical' AND nationality = 'French';

--query31
SELECT name, state FROM target.museum WHERE country = 'USA' AND state = 'CA';

--query32
SELECT name, state FROM target.museum WHERE country = 'USA' AND state = 'DC';

--query33
SELECT name, state FROM target.museum WHERE country = 'USA' AND state = 'NY';

--query34
SELECT name, state FROM target.museum WHERE country = 'USA' AND state = 'OH';

--query35
SELECT name, state FROM target.museum WHERE country = 'USA' AND state = 'TX';

--query36
SELECT name, state FROM target.museum WHERE country = 'USA' AND state = 'MO';

--query37
SELECT name, state FROM target.museum WHERE country = 'USA' AND state = 'PA';

--query38
SELECT name, state FROM target.museum WHERE country = 'USA' AND state = 'IL';

--query39
SELECT name, state FROM target.museum WHERE country = 'USA' AND state = 'MA';

--query40
SELECT name, state FROM target.museum WHERE country = 'USA' AND state = 'VA';

--query41
SELECT name, city FROM target.museum WHERE country = 'USA' AND city = 'New York';

--query42
SELECT name, city FROM target.museum WHERE country = 'USA' AND city = 'Washington';

--query43
SELECT name, city FROM target.museum WHERE country = 'USA' AND city = 'Los Angeles';

--query44
SELECT name, city FROM target.museum WHERE country = 'USA' AND city = 'Philadelphia';

--query45
SELECT name, city FROM target.museum WHERE country = 'USA' AND city = 'Boston';

--query46
SELECT name, city FROM target.museum WHERE country = 'France' AND city = 'Paris';

--query47
SELECT name, city FROM target.museum WHERE country = 'Spain' AND city = 'Madrid';

--query48
SELECT name, city FROM target.museum WHERE country = 'UK' AND city = 'London';

--query49
SELECT name, city FROM target.museum WHERE country = 'Netherlands' AND city = 'Amsterdam';

--query50
SELECT name, city FROM target.museum WHERE country = 'Brazil' AND city = 'São Paulo';

--query51
SELECT full_name FROM target.artist WHERE birth < 1700 AND style = 'Baroque';

--query52
SELECT full_name FROM target.artist WHERE birth < 1750 AND style = 'Rococo';

--query53
SELECT full_name FROM target.artist WHERE birth < 1800 AND style = 'Neoclassical';

--query54
SELECT full_name FROM target.artist WHERE birth < 1600 AND style = 'Renaissance';

--query55
SELECT full_name FROM target.artist WHERE birth < 1800 AND style = 'Romantic';

--query56
SELECT full_name FROM target.artist WHERE birth < 1850 AND style = 'Realist';

--query57
SELECT full_name FROM target.artist WHERE birth < 1850 AND style = 'Impressionist';

--query58
SELECT full_name FROM target.artist WHERE birth < 1900 AND style = 'Expressionist';

--query59
SELECT full_name FROM target.artist WHERE birth < 1850 AND style = 'Marine Art';

--query60
SELECT full_name FROM target.artist WHERE birth < 1800 AND style = 'Portraitist';

--query61
SELECT full_name FROM target.artist WHERE nationality = 'Spanish' AND death > 1900;

--query62
SELECT full_name FROM target.artist WHERE nationality = 'French' AND death > 1900;

--query63
SELECT full_name FROM target.artist WHERE nationality = 'American' AND death > 1900;

--query64
SELECT full_name FROM target.artist WHERE nationality = 'Dutch' AND death > 1900;

--query65
SELECT full_name FROM target.artist WHERE nationality = 'English' AND death > 1900;

--query66
SELECT full_name FROM target.artist WHERE nationality = 'Italian' AND death > 1800;

--query67
SELECT full_name FROM target.artist WHERE nationality = 'German' AND death > 1900;

--query68
SELECT full_name FROM target.artist WHERE nationality = 'Russian' AND death > 1900;

--query69
SELECT full_name FROM target.artist WHERE nationality = 'Austrian' AND death > 1900;

--query70
SELECT full_name FROM target.artist WHERE nationality = 'Swiss' AND death > 1900;

--query71
SELECT name FROM target.work WHERE style = 'Impressionism' AND museum_id = 35;

--query72
SELECT name FROM target.work WHERE style = 'Impressionism' AND museum_id = 51;

--query73
SELECT name FROM target.work WHERE style = 'Baroque' AND museum_id = 43;

--query74
SELECT name FROM target.work WHERE style = 'Impressionism' AND museum_id = 49;

--query75
SELECT name FROM target.work WHERE style = 'Baroque' AND museum_id = 47;

--query76
SELECT name FROM target.work WHERE style = 'Impressionism' AND museum_id = 46;

--query77
SELECT name FROM target.work WHERE style = 'Impressionism' AND museum_id = 67;

--query78
SELECT name FROM target.work WHERE style = 'Baroque' AND museum_id = 35;

--query79
SELECT name FROM target.work WHERE style = 'American Art' AND museum_id = 35;

--query80
SELECT name FROM target.work WHERE style = 'Romanticism' AND museum_id = 35;

--query81
SELECT w.name FROM target.work w JOIN target.artist a ON w.artist_id = a.artist_id WHERE a.last_name = 'Renoir';

--query82
SELECT w.name FROM target.work w JOIN target.artist a ON w.artist_id = a.artist_id WHERE a.last_name = 'Monet';

--query83
SELECT w.name FROM target.work w JOIN target.artist a ON w.artist_id = a.artist_id WHERE a.last_name = 'Van Gogh';

--query84
SELECT w.name FROM target.work w JOIN target.artist a ON w.artist_id = a.artist_id WHERE a.last_name = 'Utrillo';

--query85
SELECT w.name FROM target.work w JOIN target.artist a ON w.artist_id = a.artist_id WHERE a.last_name = 'Marquet';

--query86
SELECT w.name FROM target.work w JOIN target.artist a ON w.artist_id = a.artist_id WHERE a.last_name = 'Lebasque';

--query87
SELECT w.name FROM target.work w JOIN target.artist a ON w.artist_id = a.artist_id WHERE a.last_name = 'Pissarro';

--query88
SELECT w.name FROM target.work w JOIN target.artist a ON w.artist_id = a.artist_id WHERE a.last_name = 'Valtat';

--query89
SELECT w.name FROM target.work w JOIN target.artist a ON w.artist_id = a.artist_id WHERE a.last_name = 'Luce';

--query90
SELECT w.name FROM target.work w JOIN target.artist a ON w.artist_id = a.artist_id WHERE a.last_name = 'Le Sidaner';

--query91
SELECT w.name, m.name AS museum_name FROM target.work w JOIN target.artist a ON w.artist_id = a.artist_id JOIN target.museum m ON w.museum_id = m.museum_id WHERE m.country = 'USA' AND a.nationality = 'French';

--query92
SELECT w.name, m.name AS museum_name FROM target.work w JOIN target.artist a ON w.artist_id = a.artist_id JOIN target.museum m ON w.museum_id = m.museum_id WHERE m.country = 'USA' AND a.nationality = 'American';

--query93
SELECT w.name, m.name AS museum_name FROM target.work w JOIN target.artist a ON w.artist_id = a.artist_id JOIN target.museum m ON w.museum_id = m.museum_id WHERE m.country = 'Netherlands' AND a.nationality = 'Dutch';

--query94
SELECT w.name, m.name AS museum_name FROM target.work w JOIN target.artist a ON w.artist_id = a.artist_id JOIN target.museum m ON w.museum_id = m.museum_id WHERE m.country = 'France' AND a.nationality = 'French';

--query95
SELECT w.name, m.name AS museum_name FROM target.work w JOIN target.artist a ON w.artist_id = a.artist_id JOIN target.museum m ON w.museum_id = m.museum_id WHERE m.country = 'USA' AND a.nationality = 'Dutch';

--query96
SELECT w.name, m.name AS museum_name FROM target.work w JOIN target.artist a ON w.artist_id = a.artist_id JOIN target.museum m ON w.museum_id = m.museum_id WHERE m.country = 'UK' AND a.nationality = 'French';

--query97
SELECT w.name, m.name AS museum_name FROM target.work w JOIN target.artist a ON w.artist_id = a.artist_id JOIN target.museum m ON w.museum_id = m.museum_id WHERE m.country = 'USA' AND a.nationality = 'English';

--query98
SELECT w.name, m.name AS museum_name FROM target.work w JOIN target.artist a ON w.artist_id = a.artist_id JOIN target.museum m ON w.museum_id = m.museum_id WHERE m.country = 'United Kingdom' AND a.nationality = 'English';

--query99
SELECT w.name, m.name AS museum_name FROM target.work w JOIN target.artist a ON w.artist_id = a.artist_id JOIN target.museum m ON w.museum_id = m.museum_id WHERE m.country = 'USA' AND a.nationality = 'Italian';

--query100
SELECT w.name, m.name AS museum_name FROM target.work w JOIN target.artist a ON w.artist_id = a.artist_id JOIN target.museum m ON w.museum_id = m.museum_id WHERE m.country = 'Russia' AND a.nationality = 'French';

--query101
SELECT w.name, s.subject FROM target.work w JOIN target.subject s ON w.work_id = s.work_id WHERE s.subject = 'Landscape Art' AND w.style = 'American Landscape';

--query102
SELECT w.name, s.subject FROM target.work w JOIN target.subject s ON w.work_id = s.work_id WHERE s.subject = 'Rivers/Lakes' AND w.style = 'Impressionism';

--query103
SELECT w.name, s.subject FROM target.work w JOIN target.subject s ON w.work_id = s.work_id WHERE s.subject = 'Seascapes' AND w.style = 'Impressionism';

--query104
SELECT w.name, s.subject FROM target.work w JOIN target.subject s ON w.work_id = s.work_id WHERE s.subject = 'Nude' AND w.style = 'Impressionism';

--query105
SELECT w.name, s.subject FROM target.work w JOIN target.subject s ON w.work_id = s.work_id WHERE s.subject = 'Flowers' AND w.style = 'Post-Impressionism';

--query106
SELECT w.name, s.subject FROM target.work w JOIN target.subject s ON w.work_id = s.work_id WHERE s.subject = 'Winter' AND w.style = 'Impressionism';

--query107
SELECT w.name, s.subject FROM target.work w JOIN target.subject s ON w.work_id = s.work_id WHERE s.subject = 'Portraits' AND w.style = 'Neo-Classicism';

--query108
SELECT w.name, s.subject FROM target.work w JOIN target.subject s ON w.work_id = s.work_id WHERE s.subject = 'Nude' AND w.style = 'Post-Impressionism';

--query109
SELECT w.name, s.subject FROM target.work w JOIN target.subject s ON w.work_id = s.work_id WHERE s.subject = 'Christianity' AND w.style = 'Renaissance';

--query110
SELECT w.name, s.subject FROM target.work w JOIN target.subject s ON w.work_id = s.work_id WHERE s.subject = 'Horses' AND w.style = 'Realism';

--query111
SELECT w.name, ps.sale_price, ps.regular_price FROM target.work w JOIN target.product_size ps ON w.work_id = ps.work_id WHERE w.style = 'Impressionism' AND ps.sale_price = 285;

--query112
SELECT w.name, ps.sale_price, ps.regular_price FROM target.work w JOIN target.product_size ps ON w.work_id = ps.work_id WHERE w.style = 'Impressionism' AND ps.sale_price = 385;

--query113
SELECT w.name, ps.sale_price, ps.regular_price FROM target.work w JOIN target.product_size ps ON w.work_id = ps.work_id WHERE w.style = 'Impressionism' AND ps.sale_price = 355;

--query114
SELECT w.name, ps.sale_price, ps.regular_price FROM target.work w JOIN target.product_size ps ON w.work_id = ps.work_id WHERE w.style = 'Impressionism' AND ps.sale_price = 475;

--query115
SELECT w.name, ps.sale_price, ps.regular_price FROM target.work w JOIN target.product_size ps ON w.work_id = ps.work_id WHERE w.style = 'Impressionism' AND ps.sale_price = 215;

--query116
SELECT w.name, ps.sale_price, ps.regular_price FROM target.work w JOIN target.product_size ps ON w.work_id = ps.work_id WHERE w.style = 'Impressionism' AND ps.sale_price = 305;

--query117
SELECT w.name, ps.sale_price, ps.regular_price FROM target.work w JOIN target.product_size ps ON w.work_id = ps.work_id WHERE w.style = 'Impressionism' AND ps.sale_price = 655;

--query118
SELECT w.name, ps.sale_price, ps.regular_price FROM target.work w JOIN target.product_size ps ON w.work_id = ps.work_id WHERE w.style = 'Post-Impressionism' AND ps.sale_price = 265;

--query119
SELECT w.name, ps.sale_price, ps.regular_price FROM target.work w JOIN target.product_size ps ON w.work_id = ps.work_id WHERE w.style = 'Post-Impressionism' AND ps.sale_price = 335;

--query120
SELECT w.name, ps.sale_price, ps.regular_price FROM target.work w JOIN target.product_size ps ON w.work_id = ps.work_id WHERE w.style = 'Post-Impressionism' AND ps.sale_price = 455;

--query121
SELECT w.name, il.thumbnail_small_url FROM target.work w JOIN target.image_link il ON w.work_id = il.work_id JOIN target.museum m ON w.museum_id = m.museum_id WHERE w.style = 'Impressionism' AND m.country = 'USA';

--query122
SELECT w.name, il.thumbnail_small_url FROM target.work w JOIN target.image_link il ON w.work_id = il.work_id JOIN target.museum m ON w.museum_id = m.museum_id WHERE w.style = 'Baroque' AND m.country = 'USA';

--query123
SELECT w.name, il.thumbnail_small_url FROM target.work w JOIN target.image_link il ON w.work_id = il.work_id JOIN target.museum m ON w.museum_id = m.museum_id WHERE w.style = 'Realism' AND m.country = 'USA';

--query124
SELECT w.name, il.thumbnail_small_url FROM target.work w JOIN target.image_link il ON w.work_id = il.work_id JOIN target.museum m ON w.museum_id = m.museum_id WHERE w.style = 'Baroque' AND m.country = 'Netherlands';

--query125
SELECT w.name, il.thumbnail_small_url FROM target.work w JOIN target.image_link il ON w.work_id = il.work_id JOIN target.museum m ON w.museum_id = m.museum_id WHERE w.style = 'Impressionism' AND m.country = 'France';

--query126
SELECT w.name, il.thumbnail_small_url FROM target.work w JOIN target.image_link il ON w.work_id = il.work_id JOIN target.museum m ON w.museum_id = m.museum_id WHERE w.style = 'American Art' AND m.country = 'USA';

--query127
SELECT w.name, il.thumbnail_small_url FROM target.work w JOIN target.image_link il ON w.work_id = il.work_id JOIN target.museum m ON w.museum_id = m.museum_id WHERE w.style = 'Rococo' AND m.country = 'USA';

--query128
SELECT w.name, il.thumbnail_small_url FROM target.work w JOIN target.image_link il ON w.work_id = il.work_id JOIN target.museum m ON w.museum_id = m.museum_id WHERE w.style = 'Baroque' AND m.country = 'UK';

--query129
SELECT w.name, il.thumbnail_small_url FROM target.work w JOIN target.image_link il ON w.work_id = il.work_id JOIN target.museum m ON w.museum_id = m.museum_id WHERE w.style = 'Romanticism' AND m.country = 'USA';

--query130
SELECT w.name, il.thumbnail_small_url FROM target.work w JOIN target.image_link il ON w.work_id = il.work_id JOIN target.museum m ON w.museum_id = m.museum_id WHERE w.style = 'Post-Impressionism' AND m.country = 'USA';

--query131
SELECT a.full_name, w.name FROM target.artist a JOIN target.work w ON a.artist_id = w.artist_id JOIN target.subject s ON w.work_id = s.work_id WHERE a.nationality = 'French' AND s.subject = 'Nude';

--query132
SELECT a.full_name, w.name FROM target.artist a JOIN target.work w ON a.artist_id = w.artist_id JOIN target.subject s ON w.work_id = s.work_id WHERE a.nationality = 'American' AND s.subject = 'Landscape Art';

--query133
SELECT a.full_name, w.name FROM target.artist a JOIN target.work w ON a.artist_id = w.artist_id JOIN target.subject s ON w.work_id = s.work_id WHERE a.nationality = 'American' AND s.subject = 'Portraits';

--query134
SELECT a.full_name, w.name FROM target.artist a JOIN target.work w ON a.artist_id = w.artist_id JOIN target.subject s ON w.work_id = s.work_id WHERE a.nationality = 'French' AND s.subject = 'Flowers';

--query135
SELECT a.full_name, w.name FROM target.artist a JOIN target.work w ON a.artist_id = w.artist_id JOIN target.subject s ON w.work_id = s.work_id WHERE a.nationality = 'French' AND s.subject = 'Rivers/Lakes';

--query136
SELECT a.full_name, w.name FROM target.artist a JOIN target.work w ON a.artist_id = w.artist_id JOIN target.subject s ON w.work_id = s.work_id WHERE a.nationality = 'American' AND s.subject = 'Abstract/Modern Art';

--query137
SELECT a.full_name, w.name FROM target.artist a JOIN target.work w ON a.artist_id = w.artist_id JOIN target.subject s ON w.work_id = s.work_id WHERE a.nationality = 'French' AND s.subject = 'Portraits';

--query138
SELECT a.full_name, w.name FROM target.artist a JOIN target.work w ON a.artist_id = w.artist_id JOIN target.subject s ON w.work_id = s.work_id WHERE a.nationality = 'French' AND s.subject = 'Still-Life';

--query139
SELECT a.full_name, w.name FROM target.artist a JOIN target.work w ON a.artist_id = w.artist_id JOIN target.subject s ON w.work_id = s.work_id WHERE a.nationality = 'Dutch' AND s.subject = 'Portraits';

--query140
SELECT a.full_name, w.name FROM target.artist a JOIN target.work w ON a.artist_id = w.artist_id JOIN target.subject s ON w.work_id = s.work_id WHERE a.nationality = 'French' AND s.subject = 'Seascapes';
