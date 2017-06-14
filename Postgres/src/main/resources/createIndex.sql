CREATE INDEX event_title ON events USING HASH (title);

CREATE INDEX events_starts ON events USING BTREE (starts);