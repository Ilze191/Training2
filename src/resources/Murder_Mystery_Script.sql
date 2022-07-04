
--I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
-- She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.

SELECT name FROM person p
JOIN facebook_event_checkin fec 
ON p.id = fec.person_id
JOIN drivers_license dl 
ON p.license_id = dl.id 
WHERE hair_color = 'red'
AND (height  BETWEEN 65 AND 67)
AND car_model = 'Model S'
AND car_make LIKE 'Tesla%'
AND p.id IN 
(SELECT person_id 
FROM 
(SELECT person_id, COUNT(person_id) as times FROM facebook_event_checkin fec 
WHERE event_name LIKE "SQL Symphony%"
AND date > 20171130
AND date < 20180101
GROUP BY person_id
HAVING times = 3))
LIMIT 1;











