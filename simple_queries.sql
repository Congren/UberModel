-- Simple Queries for Uber


\echo ------------------------------------------------------------
\echo -- [1] As a driver, I am able to see all the users and their 
\echo -- location that have requested rides.
\echo ------------------------------------------------------------
\echo


    SELECT a.first_name, a.last_name, r.longitude, r.latitude
      FROM RidesRequest as r
INNER JOIN Account as a
        ON r.rider_user_id = a.id
     WHERE r.availability = true;


\echo ------------------------------------------------------------
\echo -- [2] As a driver, I want to turn on and off availability.
\echo -- set user_driver_id = 2 and availability = true
\echo ------------------------------------------------------------
\echo


UPDATE Vehicle 
   SET availability = true
 WHERE id = (SELECT vehicle_id
               FROM Account 
              WHERE id = 2);

\echo ------------------------------------------------------------
\echo -- [3] As a customer service representative, I can see 
\echo --   date and time for rides for a particular user and driver.
\echo --   example rider_user_id = 4
\echo --   example driver_user_id = 1 
\echo ------------------------------------------------------------
\echo


SELECT p.start_date_time, p.end_date_time
  FROM PastRide as p
WHERE p.rider_user_id = 4 and p.driver_user_id = 1;


\echo ------------------------------------------------------------
\echo -- [4] As a driver, I can get the final destination of the
\echo --     current rider example driver_user_id -> 2
\echo ------------------------------------------------------------
\echo


SELECT p.end_lat, p.end_lon
  FROM PastRide as p
 WHERE p.driver_user_id = 2 and 
       p.completed = false and 
       p.canceled = false;


\echo ------------------------------------------------------------
\echo -- [5] As a rider, I can get history of all the rides that I 
\echo -- have completed (driver name, start end location, 
\echo -- start end time, and trip fare).
\echo -- example rider_user_id -> 4
\echo ------------------------------------------------------------
\echo


    SELECT a.first_name, a.last_name, p.start_lat, 
           p.start_lon, p.end_lat, p.end_lon, 
           p.start_date_time, p.end_date_time, p.trip_fare
      FROM PastRide as p
INNER JOIN Account as a
        ON p.driver_user_id = a.id
     WHERE p.rider_user_id = 4 and p.completed = true;


\echo ------------------------------------------------------------
\echo -- [6] As a rider, I want to see the types of available cars 
\echo -- to ride in. Ex. (UberX, UberXl, UberBlack)
\echo ------------------------------------------------------------
\echo


SELECT v.vehicle_model_name, v.vehicle_make, v.uber_type
  FROM VehicleModel as v
 WHERE v.id IN (SELECT vehicle_model_id
                  FROM Vehicle
                 WHERE availability = true
               );


\echo ------------------------------------------------------------
\echo -- [7] As a customer service representative, I can get the 
\echo -- rating of a particular driver.example driver_user_id -> 1
\echo ------------------------------------------------------------
\echo


    SELECT AVG(r.score)
      FROM PastRide as p
INNER JOIN DriverRating as r 
        ON r.past_ride_id = p.id 
     WHERE p.driver_user_id = 1;


\echo ------------------------------------------------------------
\echo -- [8] As a rider, I want to rate my driver 5 stars and 
\echo --  comment "Okay, driver" given the 
\echo --  PastRide_id is 1 in this example   
\echo ------------------------------------------------------------
\echo


INSERT INTO DriverRating (past_ride_id, score, comment)
     VALUES (1, 5, 'Okay, driver');
