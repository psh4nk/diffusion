#!/usr/bin/python
from numpy import *

N=10

cube = zeros((N,N,N,), dtype = float64)

for i in range(0,N):
    for j in range(0,N):
        for k in range(0,N):
            cube[i, j, k] = i*N*N+j*N+k+1
            cube[i, j, k] = cube[i, j, k] * 3.1415926535897

print "Last element is: ", cube[N-1, N-1, N-1]


