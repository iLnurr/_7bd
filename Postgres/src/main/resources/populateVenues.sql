INSERT INTO venues (name, postal_code, country_code) VALUES ('Crystal Ballroom', '97205', 'us');

INSERT INTO venues (name, postal_code, country_code) VALUES ('Voodoo Donuts', '97205', 'us') RETURNING venue_id;