CREATE OR REPLACE FUNCTION add_event (title TEXT, starts TIMESTAMP, ends TIMESTAMP, venue TEXT, postal VARCHAR(9), country CHAR(2))
RETURNS boolean AS $$
DECLARE
did_insert boolean := FALSE;
found_count INTEGER;
the_venue_id INTEGER;
BEGIN
SELECT venue_id INTO the_venue_id FROM venues v
WHERE v.postal_code=postal AND v.country_code=country AND v.name ILIKE venue
LIMIT 1;

IF the_venue_id IS NULL THEN
INSERT INTO venues (name, postal_code, country_code)
VALUES (venue, postal, country)
RETURNING venue_id INTO the_venue_id;

did_insert := true;
END IF;

RAISE NOTICE 'Venue found %', the_venue_id;

INSERT INTO events (title, starts, ends, venue_id)
VALUES (title, starts, ends, the_venue_id);

RETURN did_insert;
END;
$$ LANGUAGE plpgsql;

-- insert this function into base 
-- book=# \i /home/ilnur/IdeaProjects/_7bd/Postgres/src/main/resources/6._add_event.sql
