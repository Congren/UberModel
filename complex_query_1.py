# Complex Query 1
import psycopg2
import sys
import math
# determines the distance between two latitude and longitude poitns
def get_distance(lat1, lon1, lat2, lon2):
    return math.sqrt(abs(lat1-lat2)**2 + abs(lon1 - lon2)**2)
# main function to determine closest ride to a driver and accepts it
if __name__ == '__main__':
    db, user = 'uber', 'postgres'
    conn = psycopg2.connect(database=db, user=user)
    conn.autocommit = True
    cur = conn.cursor()
    # arbitrary driver id with is #1
    driver_id = "1"
    # select location for a specific driver
    tmpl1 = '''
              SELECT latitude, longitude
                FROM Account 
               WHERE id = %s;
            '''
    # find all ride requests that are avaliable
    tmpl2 = '''
              SELECT * 
                FROM RidesRequest
               WHERE availability = true;
            '''
    cmd1 = cur.mogrify(tmpl1, (driver_id))
    cmd2 = cur.mogrify(tmpl2)
    cur.execute(cmd1)
    location = cur.fetchall()
    #save driver lat and long
    ulat, ulon = location[0]
    cur.execute(cmd2)
    rows = cur.fetchall()
    #creates a table of distances
    distances = []
    for row in rows:
          id, ride_user_id, latitude, longitude, availability, date_time, pickup_distance = row
          distances.append((id, get_distance(ulat, ulon, latitude, longitude)))

    if(len(rows) == 0):
         #determines if there are riders who need rides currently
        print("No Rides Avaliable")
    else:
      #sorts the riders by their distances, the first is the closest rider
      closest = sorted(distances, key=lambda obj: obj[1])[0]
      #updates ride request table to show that the ride request has been taken
      tmpl3 = '''
                UPDATE RidesRequest 
                   SET availability = false, pickup_distance = %s
                 WHERE id = %s;
              '''
      cmd3 = cur.mogrify(tmpl3, (str(closest[1]), str(closest[0])))
      cur.execute(cmd3)
      #selects the rider's name who is being picked up
      usr = ''' 
                SELECT a.first_name, a.last_name
                  FROM Account as a 
                 WHERE a.id = %s; 
            '''
      cmd4 = cur.mogrify(usr, str(closest[0]))
      cur.execute(cmd4)
      first_name, last_name = cur.fetchall()[0]
      # prints who is being picked up
      print("Closest request accepted!")
      print("You are picking up %s %s and he/she is %d away." % (first_name, last_name, closest[1]))

