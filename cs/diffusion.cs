using System;

// C# Code checked for mass consistency on 11/1/17

public class MemTest{
    static public void Main(){
        
        /***DIMENSIONS***/
        const int N = 10;
        /****************/

        // declare and allocate cube
        double[,,] cube = new double[N,N,N];
        for (int i = 0; i < N; i++){
            for(int j = 0; j < N; j++){
                for(int k = 0; k < N; k++){
                    cube[i,j,k] = i*N*N+j*N+k+1;
                }
            }
        }

        /* SET WHETHER TO USE PARTITION */
        bool usepartition = true; 
        /********************************/


        // declare and set variables
        double diff_coeff = 0.175;
        double dimension = 5;
        double gas_speed = 250.0;
        double step = (dimension / gas_speed) / N;
        double dist = dimension / N;

        double dterm  = diff_coeff * step / (dist * dist);


        cube[0, 0, 0] = 1.0e21;

        double time = 0.0;
        double rat = 0.0;
        double change = 0.0;


        // set markers for partition
        if(usepartition == true){
            for(int j = (N/2)-1; j < N; j++){
                for(int k = 0; k < N; k++){
                    cube[(N/2)-1, j,k] = -1.0;
                }
            }
        }




        // loop through cube until equilibrium reached
        do {
            for(int i = 0; i < N; i++){
                for(int j = 0; j < N; j++){
                    for(int k = 0; k < N; k++){ 
                        if(cube[i,j,k] != -1.0 && usepartition == true){
                            if(i > 1 && cube[i-1,j,k] != -1.0){
                                change = (cube[i,j,k] - cube[i-1,j,k]) * dterm;
                                cube[i,j,k] = cube[i,j,k] - change;
                                cube[i-1,j,k] = cube[i-1,j,k] + change;
                            }
                            if(i + 1 < N && cube[i+1, j, k] != -1.0){
                                change = (cube[i,j,k] - cube[i+1,j,k]) * dterm;
                                cube[i,j,k] = cube[i,j,k] - change;
                                cube[i+1,j,k] = cube[i+1,j,k] + change;
                            }
                            if(j > 1 && cube[i, j-1, k] != -1.0){
                                change = (cube[i,j,k] - cube[i,j-1,k]) * dterm;
                                cube[i,j,k] = cube[i,j,k] - change;
                                cube[i,j-1,k] = cube[i,j-1,k] + change;
                            }
                            if(j + 1 < N && cube[i,j+1,k] != -1.0){
                                change = (cube[i,j,k] - cube[i,j+1,k]) * dterm;
                                cube[i,j,k] = cube[i,j,k] - change;
                                cube[i,j+1,k] = cube[i,j+1,k] + change;
                            }
                            if(k > 1 && cube[i,j,k-1] != -1.0){
                                change = (cube[i,j,k] - cube[i,j,k-1]) * dterm;
                                cube[i,j,k] = cube[i,j,k] - change;
                                cube[i,j,k-1] = cube[i,j,k-1] + change;
                            }
                            if(k + 1 < N && cube[i,j,k+1] != -1.0){
                                change = (cube[i,j,k] - cube[i,j,k+1]) * dterm;
                                cube[i,j,k] = cube[i,j,k] - change;
                                cube[i,j,k+1] = cube[i,j,k+1] + change;
                            }
                        } 
                        else if(usepartition == false){
                            if(i > 1){
                                change = (cube[i,j,k] - cube[i-1,j,k]) * dterm;
                                cube[i,j,k] = cube[i,j,k] - change;
                                cube[i-1,j,k] = cube[i-1,j,k] + change;
                            }
                            if(i + 1 < N){
                                change = (cube[i,j,k] - cube[i+1,j,k]) * dterm;
                                cube[i,j,k] = cube[i,j,k] - change;
                                cube[i+1,j,k] = cube[i+1,j,k] + change;
                            }
                            if(j > 1){
                                change = (cube[i,j,k] - cube[i,j-1,k]) * dterm;
                                cube[i,j,k] = cube[i,j,k] - change;
                                cube[i,j-1,k] = cube[i,j-1,k] + change;
                            }
                            if(j + 1 < N){
                                change = (cube[i,j,k] - cube[i,j+1,k]) * dterm;
                                cube[i,j,k] = cube[i,j,k] - change;
                                cube[i,j+1,k] = cube[i,j+1,k] + change;
                            }
                            if(k > 1){
                                change = (cube[i,j,k] - cube[i,j,k-1]) * dterm;
                                cube[i,j,k] = cube[i,j,k] - change;
                                cube[i,j,k-1] = cube[i,j,k-1] + change;
                            }
                            if(k + 1 < N){
                                change = (cube[i,j,k] - cube[i,j,k+1]) * dterm;
                                cube[i,j,k] = cube[i,j,k] - change;
                                cube[i,j,k+1] = cube[i,j,k+1] + change;
                            }
                        }
                    }
                }
            }
            time = time+step;
            double sum = 0.0;
            double max = cube[0, 0, 0];
            double min = cube[0, 0, 0];

            for(int i = 0; i < N; i++){
                for(int j = 0; j < N; j++){
                    for(int k = 0; k < N; k++){
                        if(cube[i,j,k] != -1.0){
                            max = dmax(cube[i, j, k], max);
                            min = dmin(cube[i, j, k], min);
                            sum += cube[i, j, k];
                        }
                    }
                } 
            }

            rat = min/max;

            // print data for each loop            
            Console.WriteLine("time: " + time + " ratio: " + rat + " value: " + cube[0,0,0]);
            Console.WriteLine("last val: " + cube[N-1,N-1,N-1]);
            Console.WriteLine("sum: " + sum);

        } while(rat < 0.99); 

        // print resulting data
        Console.WriteLine("Last element is: " + cube[N-1,N-1,N-1]);
        Console.WriteLine("Box equilibrated in " + time + " seconds of simulated time.");
    }


    static double dmax(double x, double y){
        // returns the max of two doubles x and y
        if(x > y)
            return x;
        else if (y > x)
            return y;
        else if(y == x) 
            return y;
        else 
            return 0.0;
    }

    static double dmin(double x, double y){
        // returns the min of two doubles x and y
        if(x < y)
            return x;
        else if (y < x)
            return y;
        else if (y == x)
            return y;
        else 
            return 0.0;
    }

}
