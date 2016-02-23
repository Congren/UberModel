import psycopg2
import sys
import math

# As a customer service rep, I want to know the number of requests at 
# the most popular pickup location of radius x 

def get_distance(lat1, lon1, lat2, lon2):
    # Get the distance between the 2 locations
    return math.sqrt(abs(lat1 - lat2)**2 + abs(lon1 - lon2)**2)

def get_nearest_locations(lat, lon, locations, radius):
    # Get how many locations are within radius distance from lat, lon
    count  = 0
    for loc in locations:
        if(get_distance(lat, lon, loc[0], loc[1]) <= radius):
            count += 1
    return count


if __name__ == '__main__':
    db, user = 'uber', 'postgres'
    conn = psycopg2.connect(database=db, user=user)
    conn.autocommit = True
    cur = conn.cursor()
    # Set default radius to determine if something is near
    radius = 10
    past_ride = '''
                SELECT start_lat, start_lon
                    FROM PastRide;
                '''
    rides_request = '''
                    SELECT latitude, longitude
                            FROM RidesRequest;
                    '''

    # Location gets all the start locations of all past rides
    get_past_ride_loc = cur.mogrify(past_ride)
    cur.execute(get_past_ride_loc)
    locations = cur.fetchall()

    # Contains all the past locations and a common score for each
    common_locations = []

    # For each past location, assign a score for how common the start location is
    for loc in locations:
        loc_common_score = get_nearest_locations(loc[0], loc[1], locations, radius)
        common_locations.append((loc, loc_common_score))

    # This sorts the common locations by the scores and then takes the top or most common location
    most_common_location = sorted(common_locations, key=lambda obj: obj[1], reverse=True)[0]

    # Requests gets all the locations of the requests
    get_ride_request_loc = cur.mogrify(rides_request)
    cur.execute(get_ride_request_loc)
    requests = cur.fetchall()

    # Nearest requests gets all the request locations that are nearest to the most common pickup location
    most_common_lat, most_common_lon = most_common_location[0]
    nearest_requests = get_nearest_locations(most_common_lat, most_common_lon, requests, radius)


    print("The most common pickup location is at (lat, lon): %f, %f" % (most_common_lat, most_common_lon))
    print("The number of requests near the most common pickup location: %d" % (nearest_requests))
