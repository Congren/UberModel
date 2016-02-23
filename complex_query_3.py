# Complex Query 3
import psycopg2
import sys
import math
# Which area is historically the most profitable area to pick up riders.

#calculates the distance
def get_distance(lat1, lon1, lat2, lon2):
    return math.sqrt(abs(lat1-lat2)**2 + abs(lon1 - lon2)**2)

#the total fare
def get_total_fare(lat, lon, fares, radius):
    total_fare  = 0
    for f in fares:
        if(get_distance(lat, lon, f[2], f[3]) <= radius):
            total_fare += f[1]
    return total_fare

#counts the number of user requests
def get_nearby_requests(lat1, lon1, requests, radius):
    count = 0
    #counts the requests
    for r in requests:
        if(get_distance(lat1, lon1, r[0], r[1]) <= radius):
            count += 1
    return count


if __name__ == '__main__':
    db, user = 'uber', 'postgres'
    conn = psycopg2.connect(database=db, user=user)
    conn.autocommit = True
    cur = conn.cursor()
    #chooses arbitrary radius for the search area of requests
    radius = 10
    # selects all the past rides, their location and trip fare
    tmpl1 = '''
                SELECT driver_user_id, trip_fare, start_lat, start_lon
                    FROM PastRide;
            '''
    cmd1 = cur.mogrify(tmpl1)
    cur.execute(cmd1)
    #returns the fares, id, lat and lon
    fares = cur.fetchall()
    data = []
    #adds the total fare to a list, data
    for f in fares:
        driver_user_id, trip_fare, lat, lon = f
        data.append(((lat, lon), get_total_fare(lat, lon, fares, radius)))
    #sorts the fares based on the higest value
    top_fares = sorted(data, key=lambda obj: obj[1], reverse=True)
    #selects all the locations from ridesrequest
    tmpl2 = '''
                SELECT latitude, longitude
                  FROM RidesRequest;
            '''
    cmd2 = cur.mogrify(tmpl2)
    cur.execute(cmd2)
    requests = cur.fetchall()
    nearby_requests = []
    #adds the requests to a list of requests that are close by
    for t in top_fares:
        nearby_requests.append(get_nearby_requests(t[0][0], t[0][1], requests, radius))
    #aggregates the total rides for the most profitable area
    total = [(a[1], a[1]*b) for a,b in zip(top_fares,nearby_requests)]
    #sorts the rides based on fare cost
    total = sorted(total, key=lambda obj: obj[1], reverse=True)[0]
    if(len(total) == 0): 
    	print("No past rides")
    else:
        print("Most profitable location to pick up is at lat: " + str(total[0]) + " lon: " + str(total[1]))





