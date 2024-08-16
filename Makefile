# Makefile for compiling the IndirectFireRange program

# Compiler
FC = gfortran

# Compiler flags
FFLAGS = -O2 -Wall

# Target executable
TARGET = IndirectFireRange

# Source files
SRC = IndirectFireRange.f90

# Default target
all: $(TARGET)

# Rule to build the program
$(TARGET): $(SRC)
	$(FC) $(FFLAGS) -o $(TARGET) $(SRC)

# Clean rule to remove compiled files
clean:
	rm -f $(TARGET) *.o *.mod

# Run rule to execute the program
run: $(TARGET)
	./$(TARGET)
