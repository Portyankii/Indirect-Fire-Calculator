# Compiler
FC = gfortran

# Compiler flags
FFLAGS = -O2 -Wall -Fno-charecter-truncation

# Target executable
TARGET = IndirectFireRange

# Source files
SRC = ballistics_constants.f90 IndirectFireRange.f90

# Default target
all: $(TARGET)

# Rule to build the program
$(TARGET): ballistics_constants.o IndirectFireRange.o
	$(FC) $(FFLAGS) -o $(TARGET) ballistics_constants.o IndirectFireRange.o

# Compile ballistics_constants module
ballistics_constants.o: ballistics_constants.f90
	$(FC) $(FFLAGS) -c ballistics_constants.f90

# Compile main program
IndirectFireRange.o: IndirectFireRange.f90 ballistics_constants.mod
	$(FC) $(FFLAGS) -c IndirectFireRange.f90

# Clean rule to remove compiled files
clean:
	rm -f $(TARGET) *.o *.mod

# Run rule to execute the program
run: $(TARGET)
	./$(TARGET)
