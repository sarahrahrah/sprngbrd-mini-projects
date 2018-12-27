/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */




/*ANSWER-----------------------------------------------------------------------*/

SELECT * 
FROM  `Facilities` 
WHERE membercost = 0

/* The names of the facilities that do not charge a fee to members are: 

Badminton Court

Tabble Tennis

Snooker Court

Pool Table 

------------------------------------------------------------------------------*/













/* Q2: How many facilities do not charge a fee to members? */






/*ANSWER-----------------------------------------------------------------------*/

SELECT COUNT(membercost) 
    FROM  `Facilities` 
    WHERE membercost =0



/* There are 4 facilities
------------------------------------------------------------------------------*/





/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */







/*ANSWER-----------------------------------------------------------------------*/

SELECT * 
FROM 'Facilities'
WHERE membercost > 0 
AND membercost < 0.2 * monthlymaintenance


/* 

Tennis Court 1 / membercost: 5.0 / monthlymaintenance: 200
Tennis Court 2 / membercost: 5.0 / monthlymaintenance: 200
Massage Room 1 / membercost: 9.9 / monthlymaintenance: 3000
Massage Room 2 / membercost: 9.9 / monthlymaintenance: 3000
Squash Court / membercost: 3.5 / monthlymaintenance: 80




------------------------------------------------------------------------------*/









/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */









/*ANSWER-----------------------------------------------------------------------*/


SELECT * 
FROM  `Facilities` 
WHERE facid
BETWEEN 1 AND 5 



------------------------------------------------------------------------------*/















/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */




/* ANSWER */


SELECT name,
		monthlymaintenance,
	CASE WHEN monthlymaintenance > 100 THEN 'expensive'
	ELSE 'cheap' END AS cheap_or_expensive
FROM  `Facilities` 













/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */





SELECT firstname, surname
FROM  `Members` 
ORDER BY joindate DESC 



/* OR */


SELECT CONCAT(firstname, ' ', surname) as fullname
FROM  `Members` 
ORDER BY joindate DESC 













/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */








SELECT DISTINCT CONCAT(Members.firstname, ' ', Members.surname) as fullname,  
Facilities.name
FROM Bookings
INNER  JOIN Members ON Members.memid = Bookings.memid
INNER  JOIN Facilities ON Bookings.facid = Facilities.name
WHERE name =  "Tennis Court 1"
OR name =  "Tennis Court 2"
ORDER BY fullname






/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */




SELECT CONCAT(Members.firstname, ' ', Members.surname) as fullname,
Facilities.name,
CASE WHEN Bookings.memid = 0 THEN Facilities.guestcost ELSE Facilities.membercost END AS booking_cost
FROM Bookings
INNER JOIN Facilities ON Bookings.facid = Facilities.facid
INNER  JOIN Members ON Members.memid = Bookings.memid
WHERE starttime LIKE  '2012-09-14%'
AND ((Facilities.membercost > 30 AND Bookings.memid <> 0) OR (Facilities.guestcost > 30 AND Bookings.memid = 0))
ORDER BY booking_cost DESC








/* Q9: This time, produce the same result as in Q8, but using a subquery. */








SELECT CONCAT(Members.firstname, ' ', Members.surname) as fullname,
Facilities.name,
CASE WHEN Bookings.memid = 0 THEN Facilities.guestcost ELSE Facilities.membercost END AS booking_cost
FROM (SELECT * 
        FROM Bookings
        WHERE starttime LIKE  '2012-09-14%') AS Bookings
INNER JOIN Facilities ON Bookings.facid = Facilities.facid
INNER  JOIN Members ON Members.memid = Bookings.memid
WHERE ((Facilities.membercost > 30 AND Bookings.memid <> 0) OR (Facilities.guestcost > 30 AND Bookings.memid = 0))
ORDER BY booking_cost DESC















/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */







/* I approached this problem in two steps, first creating a new view, then summing values in the new view 

I wasn't sure about whether the problem was concerned with gross or net revenue, so I just assumed it was gross renvenue and 
didn't subtract operation costs.

*/


/* STEP 1: */

CREATE VIEW new_view1 AS


SELECT Bookings.bookid, Bookings.starttime, Bookings.memid,
Facilities.guestcost,
Facilities.membercost,
Facilities.monthlymaintenance,
Facilities.facid,
Facilities.name,
CASE WHEN Bookings.memid = 0 THEN 'guest' ELSE 'member' END AS is_guest,
CASE WHEN Bookings.memid = 0 THEN Facilities.guestcost ELSE Facilities.membercost END AS booking_revenue, 

CASE WHEN Bookings.starttime LIKE  '2012-07%' THEN  'July'
WHEN Bookings.starttime LIKE  '2012-08%' THEN  'August'
WHEN Bookings.starttime LIKE  '2012-09%' THEN  'September'
ELSE  '0'
END AS  MONTH 
FROM  `Bookings`
INNER JOIN Facilities ON Bookings.facid = Facilities.facid
INNER  JOIN Members ON Members.memid = Bookings.memid



/* STEP 2: */

SELECT name, SUM(booking_revenue) 
FROM  `new_view1` 
GROUP BY name
ORDER BY SUM( booking_revenue ) ASC 

