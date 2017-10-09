#!/usr/bin/python

N = 10

# Here is a list
A = [ 0.0, 0.0, 0.0, 0.0, 0.0,
      0.0, 0.0, 0.0, 0.0, 0.0] 

B = [ 0.0 for i in range(N) ]

print "Contents of A: "
for i in range(0,N):
    print A[i]

print "Contents of B: "
for i in range(0, len(B)):
    print B[i]
