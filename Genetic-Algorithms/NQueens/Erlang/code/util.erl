-module(util).
-export([make_gen/0, reproduce/1, shuffle/2, elitism/2, show_board/1, cross_over/2, seed/0]).


shuffle(L) -> shuffle(list_to_tuple(L), nqueens:boardSize()).

shuffle(T, 0)-> tuple_to_list(T);
shuffle(T, Len)-> Rand = rand:uniform(Len), A = element(Len, T), B = element(Rand, T), T1 = setelement(Len, T,  B), T2 = setelement(Rand,  T1, A), shuffle(T2, Len - 1).

seed() -> E = shuffle(lists:seq(0, nqueens:boardSize()-1)), {E, fitness(E)}.



fitness(B) -> F = fitness(B, 0, nqueens:boardSize()-1), 1/(F * F + 2).
fitness(_, L, L) -> 0;
fitness([H|T], I, L) -> collisions(H, I, T, I+1) + fitness(T, I+1, L).

collisions(_, _, [], _) -> 0;
collisions(C, I, [H|T], J) -> Coll = if abs(C - H) =:= abs(I - J) -> 1; true -> 0 end, Coll + collisions(C, I, T, J+1).



swap([], _, _) -> [];
swap([X|T], X, Y) -> [Y|swap(T, X, Y)];
swap([Y|T], X, Y) -> [X|swap(T, X, Y)];
swap([H|T], X, Y) -> [H|swap(T, X, Y)].


%mutation probability is 5%
mutation(E, R) when R < 0.05 -> E;
mutation(E, _) -> L = nqueens:boardSize(), swap(E, lists:nth(rand:uniform(L), E), lists:nth(rand:uniform(L), E)).


cross_over({P1, _}, {P2, _}) ->
    F = lists:sublist(P1, rand:uniform(nqueens:boardSize())),
    R = mutation(lists:sublist(F++lists:filter(fun(X) -> not lists:member(X, F) end, P2), nqueens:boardSize()), rand:uniform()),
    {R, fitness(R)}.
   


show_board([{Board, Fitness}]) ->
    Size = nqueens:boardSize(),
    lists:foreach(fun(I) -> 
        lists:foreach(fun(J) -> 
            io:format("~ts", [print(Board, I, J)])
        end, lists:seq(1, Size)),
        io:format("~n", [])
    end, lists:seq(0, Size-1)),
    io:format("Collisions: ~p~n", [math:sqrt(1/Fitness + 2) - 2]).



print(Board, I, J) -> print_h(lists:nth(J, Board), I, J).
print_h(Q, I, _) when Q =:= I -> "👑";
print_h(_, I, J) when (I+J) rem 2 == 1 -> "⬛";
print_h(_, _, _) -> "⬜".
    


sort(Gen) -> lists:sort(fun({_, F1}, {_, F2}) -> F1 > F2 end, Gen).

elitism(Gen, N) -> lists:sublist(sort(Gen), N).

rand(Min, Max) -> rand:uniform() * (Max - Min + 1) + Min - 1.

sum(Gen) -> lists:foldl(fun({_, X}, Acc) -> X + Acc end, 0, Gen).

reproduce(Gen) -> S = sum(Gen), util:elitism(Gen++lists:map(fun(_) -> util:cross_over(get_parent(rand(0, S), Gen), get_parent(rand(0, S), Gen)) end, lists:seq(1, nqueens:boardSize())), nqueens:genSize()).

get_parent(R, Gen) -> tournament(R, Gen, 0).
tournament(_, [H | []], _) -> H;
tournament(R, [{E, F} | _], S) when S + F > R -> {E, F};
tournament(R, [_ | T], S) -> tournament(R, T, S).

make_gen() -> [util:seed() || _ <- lists:seq(1, nqueens:genSize())].


