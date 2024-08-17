# IndirectFireRange

## Overview

`IndirectFireRange` is a simple Fortran program that calculates the estimated range to a target square on a grid map. The program uses the size of each square in meters, the user's current square, and the target square to compute the range.

## Input Format

- **Square Size:** The size of each square in meters.
- **Current Square:** The user's current position on the grid (e.g., `A1`, `B4`).
- **Target Square:** The target's position on the grid (e.g., `C3`, `D5`).

## How to Compile

To compile the program, follow these steps:

1. Ensure you have `gfortran` installed on your system.
2. Use the provided `Makefile` to compile the program.

### Compiling the Program

Open a terminal in the directory containing the program files and run:

```sh
make

### TODO
gui (soon™)
