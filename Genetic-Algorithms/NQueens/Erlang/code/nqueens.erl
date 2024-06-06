-module(nqueens).
-export([genetic_nqueens/0, genSize/0, boardSize/0, mutationProb/0]).


-define(MIGRATION_SIZE, 10).
-define(MIGRATION_INTERVAL, 1500).
-define(NUM_THREADS, 3).
-define(GEN_SIZE, 100).
-define(BOARD_SIZE, 100).
-define(MUTATION_PROB, 0.05).
genSize() -> ?GEN_SIZE.
boardSize() -> ?BOARD_SIZE.
mutationProb() -> ?MUTATION_PROB.


genetic_nqueens() -> start_threads([util:make_gen() || _ <- lists:seq(1, ?NUM_THREADS)]).

start_threads(Ps) -> CID = spawn_link(fun() -> center(0) end), [spawn_link(fun() -> evolve(P, 0, CID) end) || P <- Ps].
start_threads(CID, Ps) -> [spawn_link(fun() -> evolve(P, 0, CID) end) || P <- Ps].

center(I) ->
    P = receive_all(), [{E, F}] = util:elitism([H || [H|_] <- P], 1),
    if 
        F == 0.5 -> util:show_board([{E, F}]);
        true -> start_threads(self(), migrate(P)), center(I+1)
    end.


receive_all() -> receive_all(0).
receive_all(?NUM_THREADS) -> [];
receive_all(I) -> receive Gen -> [Gen|receive_all(I+1)] end.

evolve(Gen, ?MIGRATION_INTERVAL, CID) -> CID ! Gen;
evolve(Gen, I, CID) -> evolve(util:reproduce(Gen), I+1, CID).

migrate(Pops) -> [P++T || P <- Pops, T <- [lists:sublist(Pop, ?MIGRATION_SIZE) || Pop <- util:shuffle(list_to_tuple(Pops), length(Pops))]].


