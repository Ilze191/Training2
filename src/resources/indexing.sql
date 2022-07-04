--TODO1
--create index for milliseconds on tracks TABLE 
--can it use unique contraint?
--query all tracks over 5 min lenght
--check if the query uses index

--TODO2
--create index on combined LENGHT of customers firs_name and last_name in customers table
-- 2 possible approaches, 1 with concat, 1 WITHOUT (using +)
--find all customers with combined name lenght over 20 symbols
--check if the query uses INDEX 
CREATE TABLE contacts(
first_name text NOT NULL,
last_name text NOT NULL,
email text NOT NULL
);
--by creating index we will speed up queries which use email column as part of the query
CREATE UNIQUE INDEX idx_contacts_email
ON contacts(email);
INSERT INTO contacts(first_name, last_name, email)
VALUES('Valdis', 'Saulespurens', 'valdis.s.coding@gmail.com');
INSERT INTO contacts(first_name, last_name, email)
VALUES('Valdis', 'Saulespurens', 'valdis.s.coding@prosemind.com');
INSERT INTO contacts(first_name, last_name, email)
VALUES('Alice', 'Doe', 'alice.doe@gmail.com');

SELECT * FROM contacts c;

--we can find out how the queries use index(-es) if at all
EXPLAIN QUERY PLAN
SELECT * FROM contacts c 
WHERE email = 'valdis.s.coding@gmail.com';
--this shows no indexing
EXPLAIN QUERY PLAN
SELECT * FROM contacts c 
WHERE first_name = 'Valdis';

EXPLAIN QUERY PLAN
SELECT * FROM tracks t 
WHERE name = 'Sing Joyfully';
--let's add index to track name
--inserting a new index usinf UNIQUE constraint might produce error if track names are the same
CREATE INDEX idx_track_name
ON tracks(name);
EXPLAIN QUERY PLAN
SELECT * FROM tracks t 
WHERE name = 'Sing Joyfully';
--we can check what indexes we have on some table 
PRAGMA index_list('tracks');
PRAGMA index_list('contacts');
--let's get all indexes in our database
SELECT type, name, tbl_name, sql
FROM sqlite_master
WHERE type = 'index';

--if we decide we do not need an index we can drop it
DROP INDEX IF EXISTS
idx_tracks_name;
--check if have duplicate track names
SELECT name, COUNT(trackid) FROM tracks t
GROUP BY name
ORDER BY COUNT(trackid) DESC;
--unique index will not work on column which has duplicates
CREATE UNIQUE INDEX idx_tracks_name
ON tracks(name);
--that's why we create a regular index
CREATE INDEX idx_tracks_name
ON tracks(name);
EXPLAIN QUERY PLAN
SELECT * FROM tracks t 
WHERE name = 'Sing Joyfully';

--we might want to create index based on expressions in some table columns
SELECT 



