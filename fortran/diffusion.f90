PROGRAM diffusion

! fortran checked for mass conservatin on 11/1/17

    USE cube_mem
    
    ! declare and set variables 
    integer :: mem_stat, usepartition
    real*8 :: diff_coeff, dimension, gas_speed, step, dist 
    real*8 :: time, rat, change, dterm, sumv, maxv, minv, curr
    
    !!! set 1 to use partition, set 0 to not use partition
        usepartition = 1
    !!!

    !!! DIMENSIONS
    mdim = 10
    !!!

    diff_coeff = 0.175
    dimension = 5.0
    gas_speed = 250.0
    step = (dimension / gas_speed) / mdim
    dist = dimension / mdim
    time = 0.0
    rat = 0.0
    change = 0.0
    sumv = 0.0
    curr = 0.0
    dterm = diff_coeff * step / (dist * dist)
    
    call fill_cube

    cube(1,1,1) = 1.0e21

    if(usepartition .eq. 1) then
        do j = (mdim/2), mdim
            do k = 1, mdim
                cube((mdim/2), j, k) = -1.0
            end do
        end do
    end if    

    ! loop through cube until equilibrium is reached
    do while (rat < 0.99)

    do i = 1, mdim
        do j = 1, mdim
            do k = 1, mdim
                if(cube(i,j,k) /= -1.0 .and. usepartition .eq. 1) then
                    if(i > 1 .and. cube(i-1, j, k) /= -1.0) then
                        change = (cube(i, j, k) - cube(i-1, j, k)) * dterm
                        cube(i, j, k) = cube(i, j, k) - change
                        cube(i-1,j,k) = cube(i-1,j,k) + change 
                    end if

                    if(i + 1 < mdim .and. cube(i+1, j, k) /= -1.0) then
                        change = (cube(i,j,k) - cube(i+1, j, k)) * dterm
                        cube(i, j, k) = cube(i,j,k) - change
                        cube(i+1,j,k) = cube(i+1,j,k) + change
                    end if

                    if(j > 1 .and. cube(i, j-1, k) /= -1.0) then
                        change = (cube(i,j,k) - cube(i, j-1, k)) * dterm
                        cube(i, j, k) = cube(i,j,k) - change
                        cube(i, j-1, k) = cube(i,j-1,k) + change
                    end if

                    if(j + 1 < mdim .and. cube(i, j+1, k) /= -1.0) then 
                        change = (cube(i,j,k) - cube(i, j+1, k)) * dterm
                        cube(i, j, k) = cube(i,j,k) - change
                        cube(i,j+1,k) = cube(i,j+1,k) + change
                    end if

                    if(k > 1 .and. cube(i,j,k-1) /= -1.0) then 
                        change = (cube(i,j,k) - cube(i, j, k-1)) * dterm
                        cube(i, j, k) = cube(i,j,k) - change
                        cube(i,j,k-1) = cube(i,j,k-1) + change
                    end if
    
                    if(k + 1 < mdim .and. cube(i,j,k+1) /= -1.0) then 
                        change = (cube(i,j,k) - cube(i, j, k+1)) * dterm
                        cube(i,j,k) = cube(i,j,k) - change
                        cube(i,j,k+1) = cube(i,j,k+1) + change
                    end if
                else if(usepartition .eq. 0) then
                    if(i > 1) then
                        change = (cube(i, j, k) - cube(i-1, j, k)) * dterm
                        cube(i, j, k) = cube(i, j, k) - change
                        cube(i-1,j,k) = cube(i-1,j,k) + change 
                    end if

                    if(i + 1 < mdim) then
                        change = (cube(i,j,k) - cube(i+1, j, k)) * dterm
                        cube(i, j, k) = cube(i,j,k) - change
                        cube(i+1,j,k) = cube(i+1,j,k) + change
                    end if

                    if(j > 1) then
                        change = (cube(i,j,k) - cube(i, j-1, k)) * dterm
                        cube(i, j, k) = cube(i,j,k) - change
                        cube(i, j-1, k) = cube(i,j-1,k) + change
                    end if

                    if(j + 1 < mdim) then 
                        change = (cube(i,j,k) - cube(i, j+1, k)) * dterm
                        cube(i, j, k) = cube(i,j,k) - change
                        cube(i,j+1,k) = cube(i,j+1,k) + change
                    end if

                    if(k > 1) then 
                        change = (cube(i,j,k) - cube(i, j, k-1)) * dterm
                        cube(i, j, k) = cube(i,j,k) - change
                        cube(i,j,k-1) = cube(i,j,k-1) + change
                    end if
    
                    if(k + 1 < mdim) then 
                        change = (cube(i,j,k) - cube(i, j, k+1)) * dterm
                        cube(i,j,k) = cube(i,j,k) - change
                        cube(i,j,k+1) = cube(i,j,k+1) + change
                    end if
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
                     if(cube(i,j,k) /= -1.0) then
                        curr = cube(i,j,k)
                        maxv = max(curr, maxv) 
                        minv = min(curr, minv)
                        sumv = sumv + cube(i, j, k)
                    end if
                end do
            end do 
        end do
        rat = minv / maxv
        
        ! print data for each loop
        print *, "time: ", time, " ratio: ", rat, " val: ", cube(1,1,1)
        print *, " last val: ", cube(mdim - 1, mdim - 1, mdim - 1)
        print *, " sum: ", sumv 

    end do 
    
    ! print end data
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
