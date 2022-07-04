SELECT *, 'blank value' AS someColumn FROM employees e ;

SELECT FirstName, LastName, Fax, 'employee' as category FROM employees e
UNION
SELECT FirstName, LastName, Phone, 'customer' as category FROM customers c 
ORDER BY LastName ;

SELECT * FROM employees e 
WHERE LastName LIKE 'P%'
UNION ALL -- shows also duplicate rows
SELECT * FROM employees e 
WHERE FirstName LIKE 'M%';

--TODO1
--query for all tracks that appear on any playlist (playlist_track)
--order by track name

SELECT * FROM tracks t 
WHERE EXISTS (
			SELECT 1 FROM playlist_track pt 
			WHERE t.TrackId  = pt.TrackId)
		ORDER BY t.Name;

--TODO2
--query for all tracks that have been bought
--order by track name, show track name
SELECT Name  FROM tracks t 
WHERE EXISTS (
			SELECT 1 FROM invoice_items ii  
			WHERE t.TrackId  = ii.TrackId)
		ORDER BY Name;
	

--all artists who have no albums in album table
SELECT ArtistID FROM artists a
EXCEPT 
SELECT ArtistId FROM albums a2 ;
--all artists who have albums in album table
SELECT ArtistID FROM artists a
INTERSECT 
SELECT ArtistId FROM albums a2 ;
--customers who have invoices
SELECT CustomerID FROM customers c 
INTERSECT 
SELECT CustomerID FROM invoices i;
--get all customer ids just from invoices (same as with intersect)
SELECT DISTINCT customerid FROM invoices i;
--SUBQERIES

--all tracks where album title has 'jagged little pill' (could join with albm and use WHERE) using subquery
SELECT trackID , name, albumID FROM tracks t 
WHERE albumID = (SELECT albumID FROM albums a 
WHERE title = 'Jagged Little Pill');

--the same with multiple albums 
SELECT trackID , name, albumID FROM tracks t 
WHERE albumID = (SELECT albumID FROM albums a 
WHERE title LIKE 'J%');
--with = we got match on first row value in subquery
--for multiple matcges we use IN 
SELECT trackID , name, albumID FROM tracks t 
WHERE albumID IN (SELECT albumID FROM albums a 
WHERE title LIKE 'J%');
--customers that have invoices
SELECT * FROM customers c
--it is typical to use 1 as non null value
WHERE EXISTS (
			SELECT 1 FROM invoices i 
			WHERE i.CustomerId = c.CustomerId);
		
SELECT FirstName, LastName, customerid FROM customers c 
WHERE EXISTS (
			SELECT 1 FROM invoices i 
			WHERE i.CustomerId = c.CustomerId)
		ORDER BY LastName, FirstName;

SELECT COUNT(country) countries FROM customers c;
--CASE expression
--simple case expression	
SELECT customerid, firstname, lastname, 
CASE country 
WHEN 'USA' THEN 'AMERICAN' ELSE 'FOREIGN'
END CustomerGroup
FROM customers c ;
--searched case expression, it lets you use any form of comparasion
SELECT trackid, name, CASE 
	WHEN Milliseconds  < 60000 THEN 'short'
	WHEN Milliseconds  > 60000 AND Milliseconds < 300000 THEN 'medium'
	ELSE 'long'
	END category
FROM tracks t;
--saving results as VIEW to simply further queries
CREATE VIEW v_customerCountries
AS 
SELECT customerid, firstname, lastname, 
CASE country 
WHEN 'USA' THEN 'AMERICAN' ELSE 'FOREIGN'
END CustomerGroup
FROM customers c;

SELECT CustomerGroup, COUNT(CustomerId) FROM v_customerCountries vcc 
GROUP BY CustomerGroup ;

--WITH CTE - common table expressions
--we can create temporary views on the fly
WITH c_customerCountries
AS (SELECT customerid, firstname, lastname, 
CASE country 
WHEN 'USA' THEN 'AMERICAN' ELSE 'FOREIGN'
END CustomerGroup
FROM customers c)
SELECT * FROM c_customerCountries;

CREATE TABLE accounts (
	account_no INTEGER NOT NULL,
	balance DECIMAL NOT NULL DEFAULT 0,
	PRIMARY KEY(account_no),
	CHECK(balance >=0));

CREATE TABLE account_changes (
	change_no INT NOT NULL PRIMARY KEY,
	account_no INTEGER NOT NULL,
	flag TEXT NOT NULL,
	amount DECIMAL NOT NULL,
	changed_at TEXT NOT NULL);

INSERT INTO accounts (account_no, balance)
VALUES (100, 20100);
INSERT INTO accounts (account_no, balance)
VALUES (200, 10100);
SELECT * FROM accounts a;

BEGIN TRANSACTION;
UPDATE accounts 
SET balance = balance - 1000
WHERE account_no = 100;
UPDATE accounts 
SET balance = balance + 1000
WHERE account_no = 200;

INSERT INTO account_changes (change_no, account_no, flag, amount, changed_at)
VALUES(1, 100, '-', 1000, datetime('now'));
INSERT INTO account_changes (change_no, account_no, flag, amount, changed_at)
VALUES(2, 200, '+', 1000, datetime('now'));

COMMIT;



	










