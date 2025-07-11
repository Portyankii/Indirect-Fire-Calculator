module ballistics_constants
    implicit none
    real, parameter :: g = 9.81
    real, parameter :: pi = 3.14159265
    real, parameter :: prefer_high_arc_below = 0.5
end module ballistics_constants

program IndirectFireREPL
    use ballistics_constants
    implicit none

    character(len=20) :: input
    integer :: current_x = -1, current_y = -1, target_x = -1, target_y = -1
    real :: square_size = 0.0
    real, dimension(3) :: velocity = [125.0, 172.0, 225.0]
    character(len=6), dimension(3) :: charge_name = ['Low   ', 'Medium', 'High  ']

    call print_help()

    do
        print *, 'Enter command:'
        read *, input
        call upcase(input)

        if (input(1:1) == 'S') then
            call set_square_size(input, square_size)

        else if (input(1:3) == 'CUR') then
            call set_grid(input(4:), current_x, current_y, 'Current')
            call maybe_calculate(current_x, current_y, target_x, target_y, square_size, velocity, charge_name)

        else if (input(1:3) == 'TAR') then
            call set_grid(input(4:), target_x, target_y, 'Target')
            call maybe_calculate(current_x, current_y, target_x, target_y, square_size, velocity, charge_name)

        else if (trim(input) == 'QUIT') then
            print *, 'Exiting.'
            exit

        else
            print *, 'Unknown command.'
        end if
    end do
end program IndirectFireREPL

subroutine print_help()
    print *, 'Indirect Fire REPL'
    print *, 'Commands:'
    print *, '  s<number>     - set square size in meters (e.g., s10)'
    print *, '  cur<grid>     - set current square (e.g., curA1 or curB10)'
    print *, '  tar<grid>     - set target square (e.g., tarC3 or tarH12)'
    print *, '  quit          - exit'
end subroutine print_help

subroutine set_square_size(input, square_size)
    character(len=*), intent(in) :: input
    real, intent(out) :: square_size
    read(input(2:), *, err=100) square_size
    print *, 'Square size set to', square_size, 'meters.'
    return
100 print *, 'Invalid square size.'
end subroutine set_square_size

subroutine set_grid(grid, x, y, label)
    character(len=*), intent(in) :: grid, label
    integer, intent(out) :: x, y
    character(len=1) :: letter
    character(len=8) :: numpart
    x = -1
    y = -1
    if (len_trim(grid) < 2) return
    letter = grid(1:1)
    numpart = grid(2:)
    if (iachar(letter) < iachar('A') .or. iachar(letter) > iachar('Z')) return
    read(numpart, *, err=999) y
    if (y < 1) return
    x = iachar(letter) - iachar('A') + 1
    print *, trim(label), 'square set to:', letter // trim(numpart)
    return
999 print *, 'Invalid grid input.'
    x = -1
    y = -1
end subroutine set_grid

subroutine maybe_calculate(cx, cy, tx, ty, sz, velocity, charge_name)
    use ballistics_constants
    integer, intent(in) :: cx, cy, tx, ty
    real, intent(in) :: sz
    real, dimension(3), intent(in) :: velocity
    character(len=*), dimension(3), intent(in) :: charge_name

    integer :: dx, dy, i
    real :: range, theta_rad, theta_low_deg, theta_high_deg
    real :: max_range, angle_factor
    logical :: found

    if (cx <= 0 .or. cy <= 0 .or. tx <= 0 .or. ty <= 0 .or. sz <= 0.0) return

    dx = tx - cx
    dy = ty - cy
    range = sz * sqrt(real(dx*dx + dy*dy))
    print *, 'Estimated range to target:', range, 'meters.'

    found = .false.
    do i = 1, 3
        max_range = velocity(i)**2 / g
        if (range <= max_range) then
            angle_factor = g * range / (velocity(i)**2)
            angle_factor = max(0.0, min(1.0, angle_factor))
            theta_rad = asin(angle_factor) / 2.0
            theta_low_deg = theta_rad * 180.0 / pi
            theta_high_deg = 90.0 - theta_low_deg

            print *, 'Recommended charge:', trim(charge_name(i))
            if (theta_low_deg < 27.5) then
                print *, 'Low arc elevation below 27.5 degrees; using high arc'
                print *, 'Elevation angle:', theta_high_deg, 'degrees.'
            else
                print *, 'Using low arc'
                print *, 'Elevation angle:', theta_low_deg, 'degrees.'
            end if

            found = .true.
            exit
        end if
    end do

    if (.not. found) then
        print *, 'Target is out of range for all charge types.'
    end if
end subroutine maybe_calculate

subroutine upcase(str)
    character(len=*), intent(inout) :: str
    integer :: i
    do i = 1, len_trim(str)
        if (iachar(str(i:i)) >= iachar('a') .and. iachar(str(i:i)) <= iachar('z')) then
            str(i:i) = achar(iachar(str(i:i)) - 32)
        end if
    end do
end subroutine upcase
