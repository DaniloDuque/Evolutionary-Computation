# N-Queens Genetic Algorithm Solution

This repository contains a Java implementation of a genetic algorithm to solve the N-Queens problem. The N-Queens problem involves placing N chess queens on an N×N chessboard in such a way that no two queens threaten each other.

## Overview

### Problem Description

The N-Queens problem is a classic chess puzzle where the goal is to place N queens on an N×N chessboard in such a way that no two queens threaten each other. In other words, no two queens should be in the same row, column, or diagonal.

### Solution Approach

The solution provided uses a genetic algorithm to find a satisfactory arrangement of queens on the chessboard. The genetic algorithm involves generating a population of candidate solutions (entities representing different arrangements of queens), evaluating their fitness, and iteratively evolving the population to converge towards a solution.

## Code Explanation

### `entity` Class

The `entity` class represents a candidate solution, where each instance corresponds to a possible arrangement of queens on the chessboard.

#### Constructors

- `entity(int size)`: Creates a random arrangement of queens on the chessboard of the given size.
- `entity(entity f1, entity f2, int size)`: Performs crossover between two parent entities (`f1` and `f2`) to create a new entity.

#### Methods

- `mutation()`: Performs a random mutation on the arrangement of queens.
- `Fitness()`: Calculates the fitness of the entity based on the number of non-attacking pairs of queens.
- `compareTo(entity x)`: Implements the `Comparable` interface for comparing entities based on fitness.
- `equals(Object obj)`: Overrides the `equals` method to compare entities based on fitness.
- `showBoard()`: Displays the chessboard representation of the entity.

### `NQueens` Class

The `NQueens` class orchestrates the genetic algorithm.

#### Constructors

- `NQueens(int size)`: Initializes the genetic algorithm with a population of entities for the given board size.

#### Methods

- `fitness(entity x)`: Calculates the fitness of an entity based on the overall population's fitness.
- `updateBest()`: Updates the best entity based on the current population.
- `GeneticNQueens(int show)`: Performs the genetic algorithm to find a solution. The `show` parameter controls whether to display intermediate solutions.
- `main(String[] args)`: Reads the board size from the user and executes the genetic algorithm, displaying the final solution.


## How to Use

1. Compile the Java files:

    ```bash
    javac *.java
    ```

2. Run the program:

    ```bash
    java NQueens
    ```

3. Enter the size of the chessboard when prompted.

4. Optionally, enter `1` to display intermediate solutions or `0` otherwise.

5. View the final solution displayed on the chessboard.

Feel free to experiment with different board sizes and observe how the genetic algorithm converges towards a solution!
