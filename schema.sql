CREATE TABLE entry (
  entry_id integer primary key autoincrement,
  logged_at integer not null,
  entry text not null
);

CREATE TABLE tag (
  tag_id integer primary key autoincrement,
  entry_id integer not null references entry (entry_id),
  tag text not null,
  value integer
);
