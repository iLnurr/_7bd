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