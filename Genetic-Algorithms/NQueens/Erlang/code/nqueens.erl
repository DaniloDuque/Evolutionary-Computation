-module(nqueens).
-export([genetic_nqueens/0, genSize/0, boardSize/0]).


-define(MIGRATION_SIZE, 10).
-define(MIGRATION_INTERVAL, 1000).
-define(NUM_THREADS, 6).
-define(GEN_SIZE, 100).
-define(BOARD_SIZE, 100).
genSize() -> ?GEN_SIZE.
boardSize() -> ?BOARD_SIZE.


genetic_nqueens() -> start_threads(spawn_link(fun() -> center() end), [util:make_gen() || _ <- lists:seq(1, ?NUM_THREADS)]).

start_threads(CID, Ps) -> [spawn_link(fun() -> evolve(P, 0, CID) end) || P <- Ps].
update_threads(Ps) -> [Thr ! P || {Thr, P} <- Ps].


center() ->
    P = receive_all(), [{E, F}] = util:elitism([H || {_, [H|_]} <- P], 1),
    if 
        F == 0.5 -> util:show_board([{E, F}]);
        true -> update_threads(migrate(P)), center()
    end.

receive_all() -> receive_all(0).
receive_all(?NUM_THREADS) -> [];
receive_all(I) -> receive {Thr, Gen} -> [{Thr, Gen} | receive_all(I+1)] end.

evolve(Gen, ?MIGRATION_INTERVAL, CID) -> CID ! {self(), Gen}, receive P -> evolve(P, 0, CID) end;
evolve(Gen, I, CID) -> evolve(util:reproduce(Gen), I+1, CID).

migrate(Pops) -> [{Thr, P++T} || {Thr, P} <- Pops, T <- [lists:sublist(Pop, ?MIGRATION_SIZE) || {_, Pop} <- util:shuffle(list_to_tuple(Pops), length(Pops))]].

