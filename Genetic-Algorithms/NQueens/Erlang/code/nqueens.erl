-module(nqueens).
-export([genetic_nqueens/0, genSize/0, boardSize/0, mutationProb/0]).


-define(MIGRATION_SIZE, 10).
-define(MIGRATION_INTERVAL, 1000).
-define(NUM_THREADS, 3).
-define(GEN_SIZE, 100).
-define(BOARD_SIZE, 25).
-define(MUTATION_PROB, 0.05).
genSize() -> ?GEN_SIZE.
boardSize() -> ?BOARD_SIZE.
mutationProb() -> ?MUTATION_PROB.


genetic_nqueens() -> start_threads(0, [util:make_gen() || _ <- lists:seq(1, ?NUM_THREADS)]).

start_threads(I, Ps) -> CID = spawn_link(fun() -> center(I) end), [spawn_link(fun() -> evolve(P, 0, CID) end) || P <- Ps].


center(I) ->
    P = receive_all(), [{E, F}] = util:elitism([H || [H|_] <- P], 1),
    if 
        F == 0.5 -> util:show_board([{E, F}]);
        true -> start_threads(I + 1, migrate(P))
    end.


receive_all() -> receive_all(0).
receive_all(?NUM_THREADS) -> [];
receive_all(I) -> receive Gen -> [Gen|receive_all(I+1)] end.

evolve(Gen, ?MIGRATION_INTERVAL, CID) -> CID ! Gen;
evolve(Gen, I, CID) -> evolve(util:reproduce(Gen), I+1, CID).

migrate(Pops) -> [P++T || P <- Pops, T <- [lists:sublist(Pop, ?MIGRATION_SIZE) || Pop <- util:shuffle(list_to_tuple(Pops), length(Pops))]].


