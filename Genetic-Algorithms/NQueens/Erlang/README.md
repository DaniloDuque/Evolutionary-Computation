# N-Queens Genetic Algorithm with Island Model

This project solves the N-Queens problem using a genetic algorithm with an island model. Each island is represented by an independent process (thread) with its own population. Periodically, the top individuals from each population migrate to another island, enhancing genetic diversity and improving the overall solution.

## Overview

The N-Queens problem involves placing N queens on an N×N chessboard such that no two queens threaten each other. This implementation uses a genetic algorithm where multiple populations (islands) evolve concurrently, periodically exchanging their best individuals to promote diversity and optimize the solution process.

## Features

- **Concurrent Islands**: Each island runs as an independent process with its own population.
- **Periodic Migration**: Best individuals from each island migrate to other islands at set intervals.

## Running the Algorithm

1. Compile the Erlang source files:

   ```sh
   erlc *.erl
   ```

2. Start the Erlang shell:

   ```sh
   erl
   ```

3. Run the genetic algorithm:

   ```erlang
   1> nqueens:genetic_nqueens().
   ```
## Parameters

To change the board size, number of threads, migration intervals, and more, modify the macros at the top of nqueens.erl.

## License

This project is licensed under the MIT License.
