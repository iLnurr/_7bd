INSERT INTO events(title, starts, ends, venue_id) VALUES ('LARP Club', '2012-02-15 17:30:00', '2012-02-15 19:30:00', 2);

INSERT INTO events(title, starts, ends)
VALUES ('April Fools Day', '2012-04-01 00:00:00', '2012-04-01 23:59:00');

INSERT INTO events(title, starts, ends)
VALUES ('Christmas Day', '2012-12-25 00:00:00', '2012-12-25 23:59:00');

INSERT INTO events (title, starts, ends, venue_id)
VALUES ('Moby', '2012-02-06 21:00', '2012-02-06 23:00', (
  SELECT venue_id FROM venues WHERE name = 'Crystal Ballroom'
));

INSERT INTO events (title, starts, ends, venue_id)
VALUES ('Moby', '2012-02-06 21:00', '2012-02-06 23:00', (
  SELECT venue_id FROM venues WHERE name = 'Crystal Ballroom'
));

INSERT INTO events (title, starts, ends, venue_id)
VALUES ('Wedding', '2012-02-26 21:00', '2012-02-26 23:00', (
  SELECT venue_id FROM venues WHERE name = 'Voodoo Donuts'
));

INSERT INTO events (title, starts, ends, venue_id)
VALUES ('Dinner with Mom', '2012-02-26 18:00', '2012-02-26 20:30', (
  SELECT venue_id FROM venues WHERE name = 'My Place'
));

INSERT INTO events (title, starts, ends, venue_id)
VALUES ('Valentine''s Day', '2012-02-14 00:00', '2012-02-14 23:59', NULL);