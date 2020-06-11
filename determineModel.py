"""
  Determines a starting model for the joint inversion based on known sediment thickness
"""
import sys
import math

# Get station name from sys.argv
sta = sys.argv[1]

# Get Station Coords
coords = {}

with open('/Users/khomman/Documents/JointInversionPA/staCoords.txt', 'r') as f:
    next(f)
    for line in f.readlines():
        l = line.split()
        coords[l[0]] = [l[1], l[2]]

# Get BAsement estimates
bst = {}

with open('/Users/khomman/Documents/JointInversionPA/basementEstimates.txt', 'r') as f:
    next(f)
    for line in f.readlines():
        l = line.split()
        bst[l[0]] = [l[1], l[2], l[3]]


if sta in bst:
    bst_est = float(bst[sta][2])
    if bst_est < 3:
        model = 'autoModel_2kmSed.0'
    elif bst_est >= 3 and bst_est < 5:
        model = 'autoModel_4kmSed.0'
    elif bst_est >=5 and bst_est < 7:
        model = 'autoModel_6kmSed.0'
    else:
        model = 'autoModel_8kmSed.0'
    
else:
    # If station not in the current basement results then determine the closest result we have
    try:
        sta_coord = coords[sta]
        min_dist = 9999
        for i in bst:
            dist = math.sqrt((float(sta_coord[1])-float(bst[i][1]))**2 + (float(sta_coord[0])-float(bst[i][0]))**2)
            if dist < min_dist:
                min_dist = dist
                closest_sta = i
    
        closest_station_depth = float(bst[closest_sta][2])
        if closest_station_depth < 3:
            model = 'autoModel_2kmSed.0'
        elif closest_station_depth >= 3 and closest_station_depth < 5:
            model = 'autoModel_4kmSed.0'
        elif closest_station_depth >=5 and closest_station_depth < 7:
            model = 'autoModel_6kmSed.0'
        else:
            model = 'autoModel_8kmSed.0'

    except KeyError:
        #print('Not a valid Station...setting model to 4km')
        model = 'autoModel_4kmSed.0'


print(model)
