#include <stdio.h>
#include <stdlib.h>

#define mval(MEM,i,j,k) MEM[i*N*N+j*N+k]

int main(int argc, char** argv){
    const int N = 300;
    int i, j, k;

    double* A = malloc(N*N*N*sizeof(double));

    for(i = 0; i < N; i++){
        for(j = 0; j < N; j++){
            for(k = 0; k < N; k++){
                mval(A,i,j,k) = i*N*N+j*N+k+1.0;
            }
        }
    }

    printf("The last array element is %f\n", A[N*N*N-1]);
    free(A);

}
