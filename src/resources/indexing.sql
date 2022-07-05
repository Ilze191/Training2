--TODO1
--create index for milliseconds on tracks TABLE 
--can it use unique contraint? -no
--query all tracks over 5 min lenght
--check if the query uses index
CREATE UNIQUE INDEX idx_millseconds
ON tracks(milliseconds);
DROP INDEX IF EXISTS
idx_millseconds;
CREATE INDEX idx_millseconds
ON tracks(milliseconds);

SELECT *  FROM tracks t 
WHERE milliseconds > 300000;

--PRAGMA index_list('tracks');
EXPLAIN QUERY PLAN
SELECT * FROM tracks t  
WHERE (milliseconds/60000) > 5 ; --indexing didnt benefit here, because we are doing calculations

EXPLAIN QUERY PLAN
SELECT * FROM tracks t  
WHERE milliseconds > 300000; --by moving the constant value to the right we gain the ability to use plain index 



--TODO2
--create index on combined LENGHT of customers firs_name and last_name in customers table
-- 2 possible approaches, 1 with concat, 1 WITHOUT (using +)
--find all customers with combined name lenght over 20 symbols
--check if the query uses INDEX
CREATE INDEX idx_lenght_customer_name
ON customers(LENGTH(firstname) + LENGTH(lastname));
SELECT customerid, FirstName, LastName  FROM customers c 
WHERE (LENGTH(firstname) + LENGTH(lastname)) >= 20;

EXPLAIN QUERY PLAN
SELECT customerid, FirstName, LastName  FROM customers c 
WHERE LENGTH(firstname + lastname) > 20;
--another approach (using || for concat)
CREATE INDEX idx_customer_name_length
ON customers(LENGTH(firstname || lastname));

EXPLAIN QUERY PLAN
SELECT * FROM customers 
WHERE LENGTH(firstname || lastname) > 20;


--VACUUM is like a cleanup for database. might change primary key rowid values. it is done after DROP and many row deletions
DROP table accounts;
DROP table account_changes;
--shows all the different settings
PRAGMA pragma_list;












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
SELECT customerid, company FROM customers c 
WHERE LENGTH(company) > 10
ORDER BY LENGTH(Company) DESC;

EXPLAIN QUERY PLAN
SELECT customerid, company FROM customers c 
WHERE LENGTH(company) > 10
ORDER BY LENGTH(Company) DESC;
--we want to create an index based on expression LENGHT(company)
CREATE INDEX idx_lenght_company_customers
ON customers(LENGTH(Company));

EXPLAIN QUERY PLAN
SELECT customerid, company FROM customers c 
WHERE LENGTH(company) > 10
ORDER BY LENGTH(Company) DESC;

--expression based index will work ONLY if the expression is exactly the same
CREATE INDEX idx_invoice_line_amount
ON invoice_items(unitprice*quantity);
--without exact match in WHERE (or ORDER BY)the index will not apply
EXPLAIN QUERY PLAN
SELECT invoicelineid, InvoiceId, UnitPrice * Quantity  FROM invoice_items ii 
WHERE Quantity * UnitPrice > 9000;




