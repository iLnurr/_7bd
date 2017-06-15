INSERT INTO cities VALUES ('Portland', '87200', 'us');

UPDATE cities SET postal_code = '97205' WHERE name = 'Portland';

INSERT INTO cities (name, postal_code, country_code)
VALUES ('Ufa', '450022', 'ru');