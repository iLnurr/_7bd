-- DAY 1

SELECT * FROM countries;

DELETE FROM countries WHERE country_code = 'll';

SELECT cities.*, country_name FROM cities INNER JOIN countries
    ON cities.country_code = countries.country_code;

SELECT v.venue_id, v.name, c.name FROM venues v INNER JOIN cities c
    ON v.postal_code=c.postal_code AND v.country_code=c.country_code;

SELECT e.title, v.name FROM events e JOIN venues v
    ON e.venue_id = v.venue_id;

SELECT e.title, v.name FROM events e LEFT JOIN venues v
    ON e.venue_id = v.venue_id;

SELECT e.title, v.name FROM events e RIGHT JOIN venues v
    ON e.venue_id = v.venue_id;

-- DZ1:

SELECT * FROM pg_class p WHERE p.relname='countries' OR p.relname='cities' OR p.relname='venues' OR p.relname='events';

SELECT c.country_name FROM countries c JOIN (SELECT v.country_code FROM events e JOIN venues v ON v.venue_id = e.venue_id WHERE e.title='LARP Club') x ON c.country_code=x.country_code;

ALTER TABLE venues ADD COLUMN active bool DEFAULT TRUE;

-- DAY 2

INSERT INTO events (title, starts, ends, venue_id)
VALUES ('Moby', '2012-02-06 21:00', '2012-02-06 23:00', (
    SELECT venue_id FROM venues WHERE name = 'Crystal Ballroom'
));

INSERT INTO events (title, starts, ends, venue_id)
VALUES ('Wedding', '2012-02-26 21:00', '2012-02-26 23:00', (
  SELECT venue_id FROM venues WHERE name = 'Voodoo Donuts'
));

INSERT INTO countries (country_code, country_name) VALUES ('ru', 'Russia');
INSERT INTO cities (name, postal_code, country_code) VALUES ('Ufa', '450022', 'ru');
INSERT INTO venues (name, street_address, postal_code, country_code) VALUES ('My Place', 'Gub. street 11-16', '450022', 'ru');
INSERT INTO events (title, starts, ends, venue_id)
VALUES ('Dinner with Mom', '2012-02-26 18:00', '2012-02-26 20:30', (
  SELECT venue_id FROM venues WHERE name = 'My Place'
));

INSERT INTO events (title, starts, ends, venue_id)
VALUES ('Valentine''s Day', '2012-02-14 00:00', '2012-02-14 23:59', NULL);



SELECT count(title)
FROM events
WHERE title LIKE '%Day';

SELECT min(starts), max(ends) FROM events INNER JOIN venues
    ON events.venue_id = venues.venue_id
WHERE venues.name = 'Crystal Ballroom';

SELECT venue_id, count(*) FROM events
GROUP BY venue_id;

SELECT venue_id, count(*) FROM events
GROUP BY venue_id
HAVING count(*) >= 2 AND venue_id IS NOT NULL;

BEGIN TRANSACTION;
DELETE FROM events;
ROLLBACK;
SELECT * FROM events;

SELECT add_event('House Party', '2012-05-03 23:00', '2012-05-04 02:00', 'Run''s House', '97205', 'us');


UPDATE events SET ends='2012-05-04 01:00:00' WHERE title='House Party';

SELECT name, to_char(date, 'Month DD, YYYY') AS DATE FROM holidays
WHERE date <= '2012-04-01';

ALTER TABLE events ADD colors text ARRAY;

EXPLAIN VERBOSE SELECT * FROM holidays;

CREATE RULE update_holidays AS ON UPDATE TO holidays DO INSTEAD UPDATE events
SET title = NEW.name,
  starts = NEW.date,
  colors = NEW.colors
WHERE title = OLD.name;

UPDATE holidays SET colors = '{"red","green"}' WHERE name = 'Christmas Day';

SELECT extract(year FROM starts) AS year, extract(month FROM starts) AS month, count(*) FROM events
GROUP BY year, month;

CREATE TEMPORARY TABLE month_count(month INT);
INSERT INTO month_count VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12);


SELECT * FROM crosstab(
                  'SELECT extract(year FROM starts) AS year, extract(month FROM starts) AS month, count(*) FROM events
                GROUP BY year, month',
                  'SELECT * FROM month_count'
              ) AS (
              year int,
              jan int, feb int, mar int, apr int, may int, jun int,
              jul int, aug int, sep int, oct int, nov int, dec int
              ) ORDER BY year;

-- DZ 2
SELECT * FROM crosstab(
                  'SELECT extract(week from starts) AS week, extract(month FROM starts) AS month, extract(DOW FROM starts) AS day, count(*) FROM events
                GROUP BY month, week, day',
                  'SELECT generate_series (0,6)'
              ) AS (
              week int, month int,
              mon int, tue int, wed int, thu int, fri int, sat int, sun int
              ) ORDER BY week;

-- DAY 3

SELECT title FROM movies WHERE title ILIKE 'stardust%';

SELECT title FROM movies WHERE title ILIKE 'stardust_%';

-- ! - not, ~ - reg.ex., * - any register
SELECT count(*) FROM movies WHERE title !~* '^the.*';
CREATE INDEX movies_title_pattern ON movies (lower(title) TEXT_PATTERN_OPS);

SELECT levenshtein('bat', 'fads');
SELECT levenshtein('bat', 'fad') fad,
       levenshtein('bat', 'fat') fat,
       levenshtein('bat', 'bat') bat;
SELECT movie_id, title FROM movies
WHERE levenshtein(lower(title), lower('a hard day nght')) <= 3;

SELECT show_trgm('Avatar');
CREATE INDEX movies_title_trigram ON movies
USING GIST (title gist_trgm_ops);
SELECT * FROM movies WHERE title % 'Avatre';

SELECT title FROM movies WHERE title @@ 'nigth & day';
SELECT title FROM movies WHERE to_tsvector(title) @@ to_tsquery('english', 'night & day');
SELECT to_tsvector('A Hard Day''s Night'), to_tsquery('english', 'night & day');
SELECT * FROM movies WHERE title @@ to_tsquery('english', 'a');
SELECT to_tsvector('english', 'A Hard Day''s Night');
SELECT to_tsvector('simple', 'A Hard Day''s Night');

SELECT ts_lexize('english_stem', 'Day''s');
SELECT to_tsvector('german', 'was macht du gerade?');

EXPLAIN SELECT * FROM movies WHERE title @@ 'night & day';
CREATE INDEX movies_title_searchable ON movies USING GIN (to_tsvector('english', title));
EXPLAIN SELECT * FROM movies WHERE to_tsvector('english', title) @@ 'night & day';

SELECT * FROM actors WHERE name = 'Broos Wlis';
SELECT * FROM actors WHERE name % 'Broos Wlis';
SELECT * FROM actors WHERE metaphone(name, 6) = metaphone('Broos Wils', 6);
SELECT title FROM movies NATURAL JOIN movies_actors NATURAL JOIN actors WHERE metaphone(name, 6) = metaphone('Broos Wils', 6);
SELECT name, dmetaphone(name), dmetaphone_alt(name), metaphone(name, 8), soundex(name) FROM actors;

SELECT genre FROM movies WHERE title='Star Wars';
SELECT name, cube_ur_coord('(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)', position) AS score FROM genres g WHERE cube_ur_coord('(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)', position) > 0;
SELECT *, cube_distance(genre, '(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)') dist FROM movies ORDER BY dist;
SELECT cube_enlarge('(1,1)',1,2);
SELECT title, cube_distance(genre, '(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)') dist FROM movies WHERE cube_enlarge('(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)'::cube, 5, 18) @> genre ORDER BY dist;
SELECT m.movie_id, m.title FROM movies m, (SELECT genre, title FROM movies WHERE title = 'Mad Max') s WHERE cube_enlarge(s.genre, 5, 18) @> m.genre AND s.title <> m.title ORDER BY cube_distance(m.genre, s.genre) LIMIT 10;

