package main

// Go checked for mass conservation on 11/1/17

import "fmt"
import "math"

func main() {

    // declare and set variables
    
        /***DIMENSIONS***/
        const N = 10
        /****************/
        
        var cube[N][N][N] float64 
        var diff_coeff float64 = 0.175
        var dimension float64 = 5
        var gas_speed float64 = 250.0
        var step float64 = (dimension / gas_speed) / N
        var distance float64 = dimension / N
        var dterm float64 = diff_coeff * step / ( distance * distance ) 
        var time float64 = 0
        var ratio float64 = 0
        var change float64 = 0

        /* SET WHETHER TO USE PARTITION  */
        /* 1 = USE       0 = DO NOT USE  */
        var usepartition = 1
        /*********************************/


        for i := 0; i < N; i++{
            for j := 0; j < N; j++{
                for k := 0; k < N; k++{
                    cube[i][j][k] = 0      
                }
            }
        }

    if(usepartition == 1){
        for j := (N/2) - 1; j < N; j++{
            for k := 0; k < N; k++{
                cube[(N/2)-1][j][k] = -1.0
            }
        }
    }

    // set beginning loc of cube to 1e21
    cube[0][0][0] = 1.0e21 

        // loop through cube until equilibrium is reached
        for{
            for i:=0; i < N; i++{
                for j := 0; j < N; j++{  
                    for k:= 0; k < N; k++{
                        if(usepartition == 1 && cube[i][j][k] != -1.0){   
                            if(i > 1 && cube[i-1][j][k] != -1.0){
                                change = (cube[i][j][k] - cube[i-1][j][k]) * dterm
                                    cube[i][j][k] = cube[i][j][k] - change
                                    cube[i-1][j][k] = cube[i-1][j][k] + change
                            }
                            if(i + 1 < N && cube[i+1][j][k] != -1.0){
                                change = (cube[i][j][k] - cube[i+1][j][k]) * dterm
                                    cube[i][j][k] = cube[i][j][k] - change
                                    cube[i+1][j][k] = cube[i+1][j][k] + change
                            }
                            if(j > 1 && cube[i][j-1][k] != -1.0){
                                change = (cube[i][j][k] - cube[i][j-1][k]) * dterm
                                    cube[i][j][k] = cube[i][j][k] - change
                                    cube[i][j-1][k] = cube[i][j-1][k] + change
                            }
                            if(j + 1 < N && cube[i][j+1][k] != -1.0){
                                change = (cube[i][j][k] - cube[i][j+1][k]) * dterm
                                    cube[i][j][k] = cube[i][j][k] - change
                                    cube[i][j+1][k] = cube[i][j+1][k] + change
                            }
                            if(k > 1 && cube[i][j][k-1] != -1.0){
                                change = (cube[i][j][k] - cube[i][j][k-1]) * dterm
                                    cube[i][j][k] = cube[i][j][k] - change
                                    cube[i][j][k-1] = cube[i][j][k-1] + change
                            }
                            if(k + 1 < N && cube[i][j][k+1] != -1.0){
                                change = (cube[i][j][k] - cube[i][j][k+1]) * dterm
                                    cube[i][j][k] = cube[i][j][k] - change
                                    cube[i][j][k+1] = cube[i][j][k+1] + change
                            }
                        }else if(usepartition == 0){
                            if(i > 1){
                                change = (cube[i][j][k] - cube[i-1][j][k]) * dterm
                                    cube[i][j][k] = cube[i][j][k] - change
                                    cube[i-1][j][k] = cube[i-1][j][k] + change
                            }
                            if(i + 1 < N){
                                change = (cube[i][j][k] - cube[i+1][j][k]) * dterm
                                    cube[i][j][k] = cube[i][j][k] - change
                                    cube[i+1][j][k] = cube[i+1][j][k] + change
                            }
                            if(j > 1){
                                change = (cube[i][j][k] - cube[i][j-1][k]) * dterm
                                    cube[i][j][k] = cube[i][j][k] - change
                                    cube[i][j-1][k] = cube[i][j-1][k] + change
                            }
                            if(j + 1 < N){
                                change = (cube[i][j][k] - cube[i][j+1][k]) * dterm
                                    cube[i][j][k] = cube[i][j][k] - change
                                    cube[i][j+1][k] = cube[i][j+1][k] + change
                            }
                            if(k > 1){
                                change = (cube[i][j][k] - cube[i][j][k-1]) * dterm
                                    cube[i][j][k] = cube[i][j][k] - change
                                    cube[i][j][k-1] = cube[i][j][k-1] + change
                            }
                            if(k + 1 < N){
                                change = (cube[i][j][k] - cube[i][j][k+1]) * dterm
                                    cube[i][j][k] = cube[i][j][k] - change
                                    cube[i][j][k+1] = cube[i][j][k+1] + change
                            }
                        } 
                    }
                }
            }
            time = time+step
                var sumv float64 = 0            
                var maxv float64 = cube[0][0][0]
                var minv float64 = cube[0][0][0]
                for i := 0; i < N; i++{
                    for j := 0; j < N; j++{
                        for k := 0; k < N; k++{
                            if(cube[i][j][k] != -1.0) {
                                maxv = math.Max(cube[i][j][k], maxv)
                                minv = math.Min(cube[i][j][k], minv)
                                sumv += cube[i][j][k]
                            }
                        }
                    } 
                } 
            ratio = minv/maxv

                // print important data for each loop
                fmt.Print("time: ") 
                fmt.Print(time)
                fmt.Print(" ratio: ")
                fmt.Print(ratio)
                fmt.Print(" val: ")
                fmt.Print(cube[0][0][0])
                fmt.Println()
                fmt.Print("last val: ")
                fmt.Print(cube[N-1][N-1][N-1])
                fmt.Println()
                fmt.Print("sum: ")
                fmt.Print(sumv)
                fmt.Println()
                if(ratio > 0.99){
                    break
                }
        }
    // print end data
    fmt.Print("Box equilibrated in ")
        fmt.Print(time)
        fmt.Print(" seconds of simulated time") 
        fmt.Println()
}
