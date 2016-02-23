---------------------------
-- Populate VehicleModel table
---------------------------

COPY VehicleModel(vehicle_make, vehicle_size, vehicle_model_name, uber_type) 
FROM 'VehicleModelPop.txt' DELIMITER ',' NULL 'null' CSV;

---------------------------
-- Populate Vehicle table
---------------------------

COPY Vehicle(vehicle_model_id, vehicle_license_plate, vehicle_year, purchase_date, miles_driven, max_capacity, rate_multiplier, availability) 
FROM 'VehiclePop.txt' DELIMITER ',' NULL 'null' CSV;

---------------------------
-- Populate Account table
---------------------------

COPY Account(vehicle_id, is_employee, first_name, last_name, email, cell_number, latitude, longitude, credit_card) 
FROM 'AccountPop.txt' DELIMITER ',' NULL 'null' CSV;

---------------------------
-- Populate Transaction table
---------------------------

COPY Transaction(user_id, date_time, transaction_type, amount) 
FROM 'TransactionPop.txt' DELIMITER ',' NULL 'null' CSV;

---------------------------
-- Populate RidesRequest table
---------------------------

COPY RidesRequest(rider_user_id, latitude, longitude, availability, date_time, pickup_distance) 
FROM 'RidesRequestPop.txt' DELIMITER ',' NULL 'null' CSV;


---------------------------
-- Populate PastRide table
---------------------------

COPY PastRide(driver_user_id, rider_user_id, start_date_time, end_date_time, trip_fare, start_lat, start_lon, end_lat, end_lon, canceled, completed, destination_distance) 
FROM 'PastRidePop.txt' DELIMITER ',' NULL 'null' CSV;

---------------------------
-- Populate RiderRating table
---------------------------

COPY RiderRating(past_ride_id, score) 
FROM 'RiderRatingPop.txt' DELIMITER ',' NULL 'null' CSV;

---------------------------
-- Populate DriverRating table
---------------------------

COPY DriverRating(past_ride_id, score, comment) 
FROM 'DriverRatingPop.txt' DELIMITER ',' NULL 'null' CSV;
