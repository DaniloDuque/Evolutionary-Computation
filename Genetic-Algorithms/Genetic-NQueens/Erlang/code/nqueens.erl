-module(nqueens).
-export([genetic_nqueens/0, genSize/0, boardSize/0, mutationProb/0]).

-define(MIGRATION_SIZE, 7).
-define(MIGRATION_INTERVAL, 100).
-define(MAX_MIGRATIONS, 5).
-define(NUM_THREADS, 6).
-define(GEN_SIZE, 5).
-define(BOARD_SIZE, 15).
-define(MUTATION_PROB, 0.05).
genSize() -> ?GEN_SIZE.
boardSize() -> ?BOARD_SIZE.
mutationProb() -> ?MUTATION_PROB.


rand(Min, Max) -> rand:uniform() * (Max - Min + 1) + Min - 1.

sum(Gen) -> lists:foldl(fun({_, X}, Acc) -> X + Acc end, 0, Gen).

reproduce(Gen) -> S = sum(Gen), util:elitism(Gen ++ lists:map(fun(_) -> util:cross_over(get_parent(rand(0, S), Gen), get_parent(rand(0, S), Gen)) end, lists:seq(1, ?BOARD_SIZE)), ?GEN_SIZE).

get_parent(R, Gen) -> tournament(R, Gen, 0).

tournament(_, [H | []], _) -> H;
tournament(R, [{E, F} | _], S) when S + F > R -> {E, F};
tournament(R, [_ | T], S) -> tournament(R, T, S).

make_gen() -> [util:seed() || _ <- lists:seq(1, ?GEN_SIZE)].

genetic_nqueens() -> start_threads(0, [make_gen() || _ <- lists:seq(1, ?NUM_THREADS)]).

start_threads(I, Ps) -> CID = spawn_link(fun() -> center(I) end), [spawn_link(fun() -> evolve(P, 0, CID) end) || P <- Ps].

center(?MAX_MIGRATIONS) -> [H|_] = receive_all(), util:show_board(util:elitism(H, 1));
center(I) -> start_threads(I+1, migrate(receive_all())).

receive_all() -> receive_all(0).
receive_all(?NUM_THREADS) -> [];
receive_all(I) -> receive Gen -> [Gen|receive_all(I+1)] end.

evolve(Gen, ?MIGRATION_INTERVAL, CID) -> CID ! Gen;
evolve(Gen, I, CID) -> evolve(reproduce(Gen), I+1, CID).

migrate(Pops) -> [P++T--lists:sublist(P, ?MIGRATION_SIZE) || P <- Pops, T <- [lists:sublist(Pop, ?MIGRATION_SIZE) || Pop <- util:shuffle(list_to_tuple(Pops), length(Pops))]].


