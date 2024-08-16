program IndirectFireRange
    implicit none

    ! Variables
    real :: square_size, range
    integer :: current_x, current_y, target_x, target_y
    integer :: dx, dy
    character(2) :: current_square, target_square

    ! Input the size of each square in meters
    print *, 'Enter the size of each square in meters:'
    read *, square_size

    ! Input the current square (e.g., A1, B4)
    print *, 'Enter your current square (e.g., A1):'
    read *, current_square

    ! Convert current square to numeric coordinates
    current_x = ichar(current_square(1:1)) - ichar('A') + 1
    read(current_square(2:2), *) current_y

    ! Input the target square (e.g., C3, D5)
    print *, 'Enter the target square (e.g., C3):'
    read *, target_square

    ! Convert target square to numeric coordinates
    target_x = ichar(target_square(1:1)) - ichar('A') + 1
    read(target_square(2:2), *) target_y

    ! Calculate the difference in x and y
    dx = target_x - current_x
    dy = target_y - current_y

    ! Calculate the range using the Pythagorean theorem
    range = square_size * sqrt(real(dx*dx + dy*dy))

    ! Output the estimated range
    print *, 'Estimated range to the target is', range, 'meters.'

end program IndirectFireRange
