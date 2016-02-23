-------------------------
-- Create User table
-------------------------

CREATE TABLE Account
(
  id 		serial 	     NOT NULL,
  vehicle_id    int,
  is_employee   boolean      NOT NULL,
  first_name    varchar(25)  NOT NULL,
  last_name     varchar(25)  NOT NULL,
  email         varchar(25)  NOT NULL,
  cell_number   bigint 	     NOT NULL,
  latitude      decimal(9,6) NOT NULL,
  longitude     decimal(9,6) NOT NULL, 
  credit_card   bigint       NOT NULL
);

--------------------------
-- Create Transaction table
--------------------------

CREATE TABLE Transaction
(
  id    	     serial 	     NOT NULL,
  user_id            bigint          NOT NULL,
  date_time          timestamp       NOT NULL,
  transaction_type   varchar(20)     NOT NULL,
  amount             float	     NOT NULL
);

-----------------------
-- Create VehicleModel table
-----------------------

CREATE TABLE VehicleModel
(
  id        	         serial      NOT NULL,
  vehicle_make           varchar(10) NOT NULL,
  vehicle_size		 float       NOT NULL,
  vehicle_model_name	 varchar(10) NOT NULL,
  uber_type		 varchar(25) NOT NULL
);

-----------------------
-- Create RidesRequest table
-----------------------

CREATE TABLE RidesRequest
(
  id		         serial       NOT NULL,
  rider_user_id          bigint       NOT NULL,
  latitude               decimal(9,6) NOT NULL,
  longitude              decimal(9,6) NOT NULL,
  availability           boolean      NOT NULL,
  date_time 		 timestamp    NOT NULL,
  pickup_distance 	 float        NOT NULL
);

-----------------------
-- Create RiderRating table
-----------------------

CREATE TABLE RiderRating
(
  id		         serial      NOT NULL,
  past_ride_id           bigint      NOT NULL,
  score			 float       NOT NULL
);

-----------------------
-- Create DriverRating table
-----------------------

CREATE TABLE DriverRating
(
  id		         serial      NOT NULL,
  past_ride_id           bigint      NOT NULL,
  score       		 float	     NOT NULL,
  comment 		 varchar(50) NOT NULL
);

-----------------------
-- Create PastRide table
-----------------------

CREATE TABLE PastRide
(
  id            	 serial       NOT NULL,
  driver_user_id         bigint       NOT NULL,
  rider_user_id          bigint       NOT NULL,
  start_date_time        timestamp    NOT NULL,
  end_date_time          timestamp    NOT NULL,
  trip_fare 		 float        NOT NULL,
  start_lat	 	 decimal(9,6) NOT NULL,
  start_lon 		 decimal(9,6) NOT NULL,
  end_lat	 	 decimal(9,6) NOT NULL,
  end_lon	 	 decimal(9,6) NOT NULL,
  canceled 		 boolean      NOT NULL,
  completed	 	 boolean      NOT NULL,
  destination_distance   float        NOT NULL
);

-----------------------
-- Create Vehicle table
-----------------------

CREATE TABLE Vehicle
(
  id            	 serial       NOT NULL,
  vehicle_model_id       int	      NOT NULL,
  vehicle_license_plate  varchar(25)  NOT NULL,
  vehicle_year           int          NOT NULL,
  purchase_date          timestamp    NOT NULL,
  miles_driven           float        NOT NULL,
  max_capacity           int,	      
  rate_multiplier        float        NOT NULL,
  availability		 boolean      NOT NULL
);

----------------------
-- Define primary keys
----------------------

ALTER TABLE Account ADD PRIMARY KEY (id);

ALTER TABLE Vehicle ADD PRIMARY KEY (id);

ALTER TABLE Transaction ADD PRIMARY KEY (id);

ALTER TABLE RidesRequest ADD PRIMARY KEY (id);

ALTER TABLE RiderRating ADD PRIMARY KEY (id);

ALTER TABLE DriverRating ADD PRIMARY KEY (id);

ALTER TABLE PastRide ADD PRIMARY KEY (id);

ALTER TABLE VehicleModel ADD PRIMARY KEY (id);

----------------------
-- Define foreign keys
----------------------

ALTER TABLE Account ADD FOREIGN KEY (vehicle_id) 
REFERENCES Vehicle(id);

ALTER TABLE Vehicle ADD FOREIGN KEY (vehicle_model_id)
REFERENCES VehicleModel(id);

ALTER TABLE Transaction ADD FOREIGN KEY (user_id) 
REFERENCES Account(id);

ALTER TABLE RidesRequest ADD FOREIGN KEY (rider_user_id)
REFERENCES Account(id);

ALTER TABLE RiderRating ADD FOREIGN KEY (past_ride_id)
REFERENCES PastRide(id);

ALTER TABLE DriverRating ADD FOREIGN KEY (past_ride_id)
REFERENCES PastRide(id);

ALTER TABLE PastRide ADD FOREIGN KEY (driver_user_id) 
REFERENCES Account(id);

ALTER TABLE PastRide ADD FOREIGN KEY (rider_user_id)
REFERENCES Account(id);




