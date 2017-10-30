#!/usr/bin/python

# declare and set variables
N=10
diff_coeff = 0.175
dimension = 5.0
gas_speed = 250.0
step = (dimension / gas_speed) / N
dist = dimension / N
time = 0.0
ratio = 0.0
change = 0.0
sumv = 0.0
curr = 0.0
dterm = diff_coeff * step / (dist * dist)


cube = [[[0.0 for k in range(N) ] for j in range(N)] for i in range(N)]

# allocate cube array
for i in range(0,N):
    for j in range(0,N):
        for k in range(0,N):
            cube[i][j][k] = 0

# set beginning location of cube to 1e21
cube[0][0][0] = 1.0e21

# loop through cube until equilibrium reached
while ratio <= 0.99:
    for i in range(0,N):
        for j in range(0,N):
            for k in range(0,N):
                if i > 1:
                    change = (cube[i][j][k] - cube[i-1][j][k]) * dterm
                    cube[i][j][k] = cube[i][j][k] - change
                    cube[i-1][j][k] = cube[i-1][j][k] + change
                if i + 1 < N:
                    change = (cube[i][j][k] - cube[i+1][j][k]) * dterm
                    cube[i][j][k] = cube[i][j][k] - change
                    cube[i+1][j][k] = cube[i+1][j][k] + change
                if j > 1:
                    change = (cube[i][j][k] - cube[i][j-1][k]) * dterm
                    cube[i][j][k] = cube[i][j][k] - change
                    cube[i][j-1][k] = cube[i][j-1][k] + change
                if j + 1 < N:
                    change = (cube[i][j][k] - cube[i][j+1][k]) * dterm
                    cube[i][j][k] = cube[i][j][k] - change
                    cube[i][j+1][k] = cube[i][j+1][k] + change
                if k > 1:
                    change = (cube[i][j][k] - cube[i][j][k-1]) * dterm
                    cube[i][j][k] = cube[i][j][k] - change
                    cube[i][j][k-1] = cube[i][j][k-1] + change
                if k + 1 < N:
                    change = (cube[i][j][k] - cube[i][j][k+1]) * dterm
                    cube[i][j][k] = cube[i][j][k] - change
                    cube[i][j][k+1] = cube[i][j][k+1] + change

    time = time + step;
    sumv = 0.0
    maxv = cube[0][0][0]
    minv = cube[0][0][0]
    for i in range(0,N):
        for j in range(0,N):
            for k in range(0,N):
                curr = cube[i][j][k]
                maxv = max(curr, maxv)
                minv = min(curr, minv)
                sumv = sumv + cube[i][j][k]
    ratio = minv / maxv
    # print important data for each loop
    print "time: ",time, " ratio: ", ratio," val: ", cube[0][0][0]
    print "last val: ", cube[N-1][N-1][N-1]
    print "sum: ", sumv
# print resulting cube data
print "Box equilibrated in", time, " seconds of simulated time"
