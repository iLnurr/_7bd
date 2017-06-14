CREATE TABLE events (
  event_id SERIAL PRIMARY KEY,
  title VARCHAR(255),
  starts TIMESTAMP,
  ends TIMESTAMP,
  venue_id INTEGER REFERENCES venues
);