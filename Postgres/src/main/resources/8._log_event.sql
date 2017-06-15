CREATE OR REPLACE FUNCTION log_event() RETURNS TRIGGER AS $$
  DECLARE
  BEGIN
    INSERT INTO logs (event_id, old_title, old_starts, old_ends)
      VALUES (OLD.event_id, OLD.title, OLD.starts, OLD.ends);
    RAISE NOTICE 'Someone just changed event #%', OLD.event_id;
    RETURN NEW;
  END;
  $$ LANGUAGE plpgsql;

CREATE TRIGGER log_events
  AFTER UPDATE ON events
  FOR EACH ROW EXECUTE PROCEDURE log_event();