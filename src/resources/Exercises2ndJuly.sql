--1
--Which city has the most invoices?
--Order by invoice count
SELECT BillingCity, COUNT(invoiceid) FROM invoices i
GROUP BY BillingCity
ORDER BY COUNT(invoiceid) DESC;
--2
--Which cities has the best customers 
--This means we want to have an ordered list
--5 best cities with highest sum of totals
SELECT BillingCity, SUM(total) FROM invoices i
GROUP BY BillingCity
ORDER BY SUM(total) DESC
LIMIT 5;

SELECT c.CustomerID, c.Firstname, c.Lastname, SUM(ii.UnitPrice) as invoices
FROM invoices i 
JOIN invoice_items ii ON ii.InvoiceId = i.InvoiceId 
JOIN customers c ON c.CustomerId = i.InvoiceId 
GROUP BY c.CustomerId, c.FirstName 
ORDER by i.Total DESC
LIMIT 3;


--3
--Find the biggest 3 spendersn
--this might involve joining customers and invoices and invoice items
--then using GROUP BY and then SUM on grouped TOTAL
SELECT C.CUSTOMERID, SUM(I.TOTAL)
  FROM customers C
  JOIN invoices i ON C.CUSTOMERID = I.CUSTOMERID
  GROUP BY C.CUSTOMERID
  ORDER BY SUM(I.TOTAL) DESC;
 
 SELECT * FROM invoices i;
SELECT * FROM invoice_items ii;



--4 Find ALL listeners to classical music
--include their names and emails and phone numbers. this might not need aggregation
SELECT DISTINCT firstname, lastname, email, phone, g.Name 
FROM customers c 
JOIN invoices i ON c.CustomerId = i.CustomerId 
JOIN invoice_items ii ON i.InvoiceId = ii.InvoiceId 
JOIN tracks t ON ii.TrackId = t.TrackId 
JOIN genres g ON t.GenreId = g.GenreId 
WHERE g.Name = 'Classical';
 
 
 

--SELECT SUM(total), COUNT(total), MIN(total), AVG(total), MAX(total) FROM invoices i;
--SELECT COUNT(*), 'Invoices over 5.99' AS numbering,
--SUM(total), COUNT(total), MIN(total), AVG(total), MAX(total) FROM invoices i 
--WHERE total > 5.99;
--
--SELECT total, COUNT(total)
--FROM invoices i 
--GROUP BY total;
--
--SELECT BillingCountry, COUNT(invoiceid) as 'invoices'FROM invoices i
--GROUP BY BillingCountry;
--
--SELECT BillingCity, COUNT(invoiceid) FROM invoices i
--GROUP BY BillingCity
--ORDER BY COUNT(invoiceid) DESC;
--
--SELECT BillingCity, SUM(total) FROM invoices i
--GROUP BY BillingCity
--ORDER BY SUM(total) DESC
--LIMIT 5;
--
-- 
---- SELECT C.CUSTOMERID,
----  	SUM(I.TOTAL)
----  FROM CUSTOMER C
----  JOIN INVOICE I ON C.CUSTOMERID = I.CUSTOMERID
----  GROUP BY 1
----  ORDER BY 2 DESC;
---- 
-- SELECT c.customerid, SUM(i.total) FROM customers c 
-- JOIN invoices i ON c.CustomerId = i.CustomerId
-- JOIN invoice_items ii ON i.InvoiceId = ii.InvoiceId 
--GROUP BY c.CustomerId
--ORDER BY SUM(i.total) DESC;
 
  






