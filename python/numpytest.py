#!/usr/bin/python
from numpy import *

N=10

A = zeros((N,N,N,), dtype = float64)

for i in range(0,N):
    for j in range(0,N):
        for k in range(0,N):
            A[i, j, k] = i*N*N+j*N+k+1
            A[i, j, k] = A[i, j, k] * 3.1415926535897

#print "Last element is: ", A[N-1, N-1, N-1]


