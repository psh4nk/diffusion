#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define mval(MEM,i,j,k) MEM[i*N*N+j*N+k]

typedef int bool;
#define true 1
#define false 0

// C code checked for mass conservation on 11/1/17

double dmax(double x, double y){
    if(x > y)
        return x;
    else if (y > x)
        return y;
    else 
        return y;
}

double dmin(double x, double y){
    if(x < y)
        return x;
    else if (y < x)
        return y;
    else
        return y;
}

int main(int argc, char** argv){ 
    
    /***DIMENSIONS***/
    const int N = 10;
    /****************/
    
    int i, j, k;

    // declare and allocate cube
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
    
    /* SET WHETHER TO USE PARTITION */
    /* 1 == use,    0 == don't use  */
    int usepartition = 1;
    //printf("1 for partition, 0 for no partition. Press enter after selection: ");
    //scanf("%d", &usepartition);
    //printf("\n");
    /********************************/

    // declare and set vars
    double diff_coeff = 0.175;
    double dimension = 5;
    double gas_speed = 250.0;
    double step = (dimension / gas_speed) / N;
    double dist = dimension / N;
    double change = 0.0;
    double dterm  = diff_coeff * step / (dist * dist);
    double time = 0.0;
    double rat = 0.0;
    
    // set 0-0-0 location of cube to 1.0e21
    cube[0][0][0] = 1.0e21; 
    

    // set markers for partition
    if(usepartition == 1){
        for(int j = (N/2) - 1; j < N; j++){
            for(int k = 0; k < N; k++){
                cube[(N/2) - 1][j][k] = -1.0;
            }
        }
    }

    // loop through cube until equilibrium reached
    do {
       for(int i = 0; i < N; i++){
            for(int j = 0; j < N; j++){
                for(int k = 0; k < N; k++){
                    if(cube[i][j][k] != -1.0  && usepartition == 1){  
                        if(i > 1 && cube[i-1][j][k] != -1.0){
                            change = (cube[i][j][k] - cube[i-1][j][k]) * dterm;
                            cube[i][j][k] = cube[i][j][k] - change;
                            cube[i-1][j][k] = cube[i-1][j][k] + change;
                        }
                        if(i + 1 < N && cube[i+1][j][k] != -1.0){
                            change = (cube[i][j][k] - cube[i+1][j][k]) * dterm;
                            cube[i][j][k] = cube[i][j][k] - change;
                            cube[i+1][j][k] = cube[i+1][j][k] + change;
                        }
                        if(j > 1 && cube[i][j-1][k] != -1.0){
                            change = (cube[i][j][k] - cube[i][j-1][k]) * dterm;
                            cube[i][j][k] = cube[i][j][k] - change;
                            cube[i][j-1][k] = cube[i][j-1][k] + change;
                        }
                        if(j + 1 < N && cube[i][j+1][k] != -1.0){
                            change = (cube[i][j][k] - cube[i][j+1][k]) * dterm;
                            cube[i][j][k] = cube[i][j][k] - change;
                            cube[i][j+1][k] = cube[i][j+1][k] + change;
                        }
                        if(k > 1 && cube[i][j][k-1] != -1.0){
                            change = (cube[i][j][k] - cube[i][j][k-1]) * dterm;
                            cube[i][j][k] = cube[i][j][k] - change;
                            cube[i][j][k-1] = cube[i][j][k-1] + change;
                        }
                        if(k + 1 < N && cube[i][j][k+1] != -1.0){
                            change = (cube[i][j][k] - cube[i][j][k+1]) * dterm;
                            cube[i][j][k] = cube[i][j][k] - change;
                            cube[i][j][k+1] = cube[i][j][k+1] + change;
                        } 
                    }
                    else if(usepartition == 0){
                        if(i > 1){
                            change = (cube[i][j][k] - cube[i-1][j][k]) * dterm;
                            cube[i][j][k] = cube[i][j][k] - change;
                            cube[i-1][j][k] = cube[i-1][j][k] + change;
                        }
                        if(i + 1 < N){
                            change = (cube[i][j][k] - cube[i+1][j][k]) * dterm;
                            cube[i][j][k] = cube[i][j][k] - change;
                            cube[i+1][j][k] = cube[i+1][j][k] + change;
                        }
                        if(j > 1){
                            change = (cube[i][j][k] - cube[i][j-1][k]) * dterm;
                            cube[i][j][k] = cube[i][j][k] - change;
                            cube[i][j-1][k] = cube[i][j-1][k] + change;
                        }
                        if(j + 1 < N){
                            change = (cube[i][j][k] - cube[i][j+1][k]) * dterm;
                            cube[i][j][k] = cube[i][j][k] - change;
                            cube[i][j+1][k] = cube[i][j+1][k] + change;
                        }
                        if(k > 1){
                            change = (cube[i][j][k] - cube[i][j][k-1]) * dterm;
                            cube[i][j][k] = cube[i][j][k] - change;
                            cube[i][j][k-1] = cube[i][j][k-1] + change;
                        }
                        if(k + 1 < N){
                            change = (cube[i][j][k] - cube[i][j][k+1]) * dterm;
                            cube[i][j][k] = cube[i][j][k] - change;
                            cube[i][j][k+1] = cube[i][j][k+1] + change;
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
                   if(cube[i][j][k] != -1.0){
                        max = dmax(cube[i][j][k], max);
                        min = dmin(cube[i][j][k], min);
                        sum += cube[i][j][k];
                    }
                }
            } 
        } 
        rat = min/max;
        // print current values in each loop
        printf("time: %f ratio: %f val: %f\n", time, rat, cube[0][0][0]);
        printf("last val: %f\n", cube[N - 1][N - 1][N - 1]);
        printf("sum: %f\n", sum);
    } while(rat < 0.99);
    // print final results
    printf("Box equilibrated in %f seconds of simulated time.\n", time);



    printf("The last array element is %f\n", cube[N-1][N-1][N-1]);
    
    // deallocate array
    free(cube);
}
