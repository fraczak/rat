-module(rat_eqc).
-include_lib("eqc/include/eqc.hrl").
-include_lib("eunit/include/eunit.hrl").
-compile(export_all).

non_zero_nat() ->
    ?SUCHTHAT(N, nat(), N > 0).

rat() ->
    ?SUCHTHAT({L,M}, {int(),non_zero_nat()}, rat:is_rational({L,M})).

non_zero_rat() ->
    ?SUCHTHAT(R, rat(), R /= {0,1}).

gcd_1() ->
    ?FORALL( X, non_zero_nat(),
             rat:gcd(X,X+1) =:= 1).

gcd_2() ->
    ?FORALL( {X,Y}, { non_zero_nat(), non_zero_nat() },
             rat:gcd(X,Y) =:= rat:gcd(Y,X)).

gcd_3() ->
    ?FORALL( {X,K}, {nat(),nat()},
             ?IMPLIES(X > K,
                      begin
                          Y = X * (K+1),
                          rat:gcd(X,Y) > K
                      end)).

lcm_1() ->
    ?FORALL( {X,Y}, {non_zero_nat(),non_zero_nat()},
             begin
                 rat:gcd(X,Y)*rat:lcm(X,Y) =:= X*Y
             end).

rat_1() ->
    ?FORALL( {X,Y}, {int(),non_zero_nat()},
             begin
                 rat:is_rational(rat:rat(X,Y))
             end).
rat_2() ->
    ?FORALL( X, int(),
             rat:to_int(rat:rat(X)) =:= X).

minus_1() ->
    ?FORALL( R, rat(),
             begin
                 rat:minus(rat:minus(R)) =:= R
             end).
minus_2() ->
    ?FORALL( R, rat(),
             begin
                 rat:minus(R,R) =:= rat:rat(0)
             end).

add_1() ->
    ?FORALL( {X,Y}, {rat(),rat()},
             begin
                 rat:add(X,Y) =:= rat:add(Y,X)
             end).
add_2() ->
    ?FORALL( {X,Y,Z}, {rat(),rat(),rat()},
             begin
                 rat:add(rat:add(X,Y),Z) =:= 
                     rat:add(X,rat:add(Y,Z))
             end).

mult_1() ->
    ?FORALL( {X,Y}, {rat(),rat()},
             begin
                 rat:mult(X,Y) =:= rat:mult(Y,X)
             end).
mult_2() ->
    ?FORALL( {X,Y,Z}, {rat(),rat(),rat()},
             begin
                 rat:mult(rat:mult(X,Y),Z) =:=
                     rat:mult(X,rat:mult(Y,Z))
             end).
mult_3() ->
    ?FORALL( X, rat(),
             ?IMPLIES(rat:rat(X) /= {0,1},
             begin
                 rat:mult(X,rat:inverse(X)) =:= rat:rat(1,1)
             end)).

add_mult_1() ->
    ?FORALL( {X,Y,Z}, {rat(),rat(),rat()},
             begin
                 rat:mult(X,rat:add(Y,Z))
                     =:= 
                     rat:add(rat:mult(X,Y),rat:mult(X,Z))
             end).

ge_1() ->
    ?FORALL( X, rat(),
             rat:ge(rat:mult(X,X), {0,1})
           ).
ge_2() ->
    ?FORALL( {X,Y,Z}, {rat(),rat(),rat()},
             ?IMPLIES( rat:ge(X,Y) ,
                       ?IMPLIES( rat:ge(Y,Z),
                                 rat:ge(X,Z) ))).
is_rational_1() ->
    ?FORALL({L,M} , rat(),
            ?IMPLIES( L > 0,
                      rat:is_rational({L,M}) =:= (rat:gcd(L,M) =:= 1)
                    )).

inverse_1() ->
    ?FORALL(X, non_zero_rat(),
            rat:inverse(rat:inverse(X)) =:= X).
inverse_2() ->
    ?FORALL(X, non_zero_rat(),
            case rat:mult(X,rat:inverse(X)) of
                {S,1} ->
                    S*S =:= 1;
                _ ->
                    false
            end
           ).

round_1() ->
    ?FORALL({X,D} , {rat(), non_zero_nat()},
            begin
                Prec = rat:rat(1,D),
                Round = rat:round(X,Prec),
                rat:ge(X,Round)
                    and
                    rat:ge(rat:add(X,Prec),X)
            end).
round_2() ->
    ?FORALL(R={_,M} , rat(),
            rat:round(R,{1,M}) =:= R).

eqc_test_() ->
    [ { atom_to_list(F),
        {timeout, 20,
         ?_assert(
            eqc:quickcheck(
              eqc:numtests(2000,
                           ?MODULE:F())))}} 
      || F <- [
               gcd_1,gcd_2,gcd_3,lcm_1,
               rat_1,rat_2,
               minus_1,minus_2,
               add_1,add_2,
               inverse_1, inverse_2,
               mult_1,mult_2,mult_3,
               add_mult_1,
               ge_1, ge_2,
               is_rational_1,
               round_1, round_2
              ]].
