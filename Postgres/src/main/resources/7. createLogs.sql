CREATE TABLE logs(
  event_id INTEGER,
  old_title VARCHAR(255),
  old_starts TIMESTAMP,
  old_ends TIMESTAMP,
  logged_at TIMESTAMP DEFAULT current_timestamp
);