#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define mval(MEM,i,j,k) MEM[i*N*N+j*N+k]

double dmax(double x, double y){
    if(x > y)
        return x;
    else if (y > x)
        return y;
}

double dmin(double x, double y){
    if(x < y)
        return x;
    else if (y < x)
        return y;
}

int main(int argc, char** argv){
    const int N = 10;
    int i, j, k;
    double ***cube = malloc(N*sizeof(double**));
    for(i = 0; i < N; i++){
        cube[i] = malloc(N*sizeof(double*));
        for(j=0;j<N;j++){
            cube[i][j] = malloc(N*sizeof(double));
        }
    }
    for(i = 0; i < N; i++){
        for(j = 0; j < N; j++){
            for(k = 0; k < N; k++){
                cube[i][j][k] = i*N*N+j*N+k+1.0;
            }
        }
    }

    double diff_coeff = 0.175;
    double dimension = 5;
    double gas_speed = 250.0;
    double step = (dimension / gas_speed) / N;
    double dist = dimension / N;

    double dterm  = diff_coeff * step / (dist * dist);

    cube[0][0][0] = 1.0e21;
    i = 0; 
    double time = 0.0;
    double rat = 0.0;

    do {
        for(int i = 0; i < N; i++){
            for(int j = 0; j < N; j++){
                for(int k = 0; k < N; k++){
                    for(int l = 0; l < N; l++){
                        for(int m = 0; m < N; m++){
                            for(int n = 0; n < N; n++){
                                if  (( ( i == l ) && ( j == m ) && ( k == n + 1 ) ) ||
                                        ( ( i == l ) && ( j == m ) && ( k == n - 1 ) ) ||
                                        ( ( i == l ) && ( j == m + 1 ) && ( k == n ) ) ||
                                        ( ( i == l ) && ( j == m - 1 ) && ( k == n ) ) ||
                                        ( ( i == l + 1 ) && ( j == m ) && ( k == n ) ) ||
                                        ( ( i == l - 1 ) && ( j == m + 1 ) && ( k == n ) )){ 
                                    double change = (cube[i][j][k] - cube[l][m][n]) * dterm;
                                    cube[i][j][k] = cube[i][j][k] - change;
                                    cube[l][m][n] = cube[l][m][n] + change; 
                                }
                            }
                        }
                    }  
                }
            }
        }
        time = time+step;
        double sum = 0.0;
        double max = cube[0][0][0];
        double min = cube[0][0][0];
        for(int i = 0; i < N; i++){
            for(int j = 0; j < N; j++){
                for(int k = 0; k < N; k++){
                    max = dmax(cube[i][j][k], max);
                    min = dmin(cube[i][j][k], min);
                    sum += cube[i][j][k];
                }
            } 
        } 
        rat = min/max;
        printf("time: %f ratio: %f val: %f\n", time, rat, cube[0][0][0]);
        printf("last val: %f\n", cube[N - 1][N - 1][N - 1]);
        printf("sum: %f\n", sum);
    } while(rat < 0.99);
    printf("Box equilibrated in %f seconds of simulated time.\n", time);



    printf("The last array element is %f\n", cube[N-1][N-1][N-1]);
    free(cube);
}
