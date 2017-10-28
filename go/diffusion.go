package main

import "fmt"
//import "math"

func main() {

    const N = 10
    var cube[N][N][N] float64 
    var diff_coeff float64 = 0.175
    var dimension float64 = 5
    var gas_speed float64 = 250.0
    var step float64 = (dimension / gas_speed) / N
    var distance float64 = dimension / N
    var dterm float64 = diff_coeff * step / ( distance * distance )
    var pass integer = 0
    var time float64 = 0
    var ratio float64 = 0


    for i := 0; i < N; i++{
        for j := 0; j < N; j++{
            for k := 0; k < N; k++{
                cube[i][j][k] = 0;      
            }
        }
    }
   
    cube[0][0][0] = 1.0e21 
         
    
    for{


        if(ratio > 0.99){
            break
        }
    }
    
    fmt.Print("Value at cube[N-1][N-1][N-1]: ")
    fmt.Println(cube[N-1][N-1][N-1])
    
    fmt.Print("Value at cube[0][0][0]: ")
    fmt.Println(cube[0][0][0])
    

}
