PROGRAM diffusion

    USE cube_mem
    !real (kind = 4) :: cubesum
    integer :: N = 10
    integer :: mem_stat
    real*8 :: diff_coeff, dimension, gas_speed, step, dist 
    real*8 :: time, rat, change, dterm, sumv, maxv, minv, curr


    diff_coeff = 0.175
    dimension = 5.0
    gas_speed = 250.0
    step = (dimension / gas_speed) / N
    dist = dimension / N
    time = 0.0
    rat = 0.0
    change = 0.0
    sumv = 0.0
    curr = 0.0
    dterm = diff_coeff * step / (dist * dist)

    mdim = 10

    call fill_cube

    cube(1,1,1) = 1.0e21      

    do while (rat < 0.99)

    do i = 1, mdim
        do j = 1, mdim
            do k = 1, mdim
            
            if(i - 1 > 0) then
                change = (cube(i, j, k) - cube(i-1, j, k)) * dterm
                cube(i, j, k) = cube(i, j, k) - change
                cube(i-1,j,k) = cube(i-1,j,k) + change 
            end if

            if(i + 1 <= N) then
                change = (cube(i,j,k) - cube(i+1, j, k)) * dterm
                cube(i, j, k) = cube(i,j,k) - change
                cube(i+1,j,k) = cube(i+1,j,k) + change
            end if

            if(j - 1 > 0) then
                change = (cube(i,j,k) - cube(i, j-1, k)) * dterm
                cube(i, j, k) = cube(i,j,k) - change
                cube(i, j-1, k) = cube(i,j-1,k) + change
            end if

            if(j + 1 <= N) then 
                change = (cube(i,j,k) - cube(i, j+1, k)) * dterm
                cube(i, j, k) = cube(i,j,k) - change
                cube(i,j+1,k) = cube(i,j+1,k) + change
            end if

            if(k - 1 > 0) then 
                change = (cube(i,j,k) - cube(i, j, k-1)) * dterm
                cube(i, j, k) = cube(i,j,k) - change
                cube(i,j,k-1) = cube(i,j,k-1) + change
            end if
    
            if(k + 1 <= N) then 
                change = (cube(i,j,k) - cube(i, j, k+1)) * dterm
                cube(i,j,k) = cube(i,j,k) - change
                cube(i,j,k+1) = cube(i,j,k+1) + change
            end if


            end do
        end do
    end do
        
        time = time + step
        
        sumv = 0.0
        maxv = cube(1,1,1)
        minv = cube(1,1,1)
        do i = 1, mdim
            do j = 1, mdim
                do k = 1, mdim
                    curr = cube(i,j,k)
                    maxv = max(curr, maxv) 
                    minv = min(curr, minv)
                    sumv = sumv + cube(i, j, k)
                end do
            end do 
        end do
        rat = minv / maxv

        print *, "time: ", time, " ratio: ", rat, " val: ", cube(1,1,1)
        print *, " last val: ", cube(N - 1, N - 1, N - 1)
        print *, " sum: ", sumv 

    end do 
    
    print *, "Box equilibrated in ", time, " seconds of simulated time."

    deallocate( cube, STAT = mem_stat )
    if (mem_stat /= 0) STOP "ERROR DEALLOCATING ARRAY"
END PROGRAM diffusion

SUBROUTINE fill_cube

    USE cube_mem
    integer :: mem_stat

    allocate (cube(mdim,mdim,mdim), STAT = mem_stat)
    if(mem_stat /= 0) STOP "MEMORY ALLOCATION ERROR"

    do i = 1, mdim
        do j = 1, mdim
            do k = 1, mdim
                cube(i,j,k) = 0.0
            end do
        end do
    end do

END SUBROUTINE fill_cube
