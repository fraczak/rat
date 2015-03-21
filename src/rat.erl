%%%-------------------------------------------------------------------
%%% @author wojtek
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Mar 2015 11:34 AM
%%%-------------------------------------------------------------------
-module(rat).
-author("wojtek").

%% A rational number is a pair {L,M}, where L is an integer, and
%% M is a non zero natural number (positive integer).

-export_type([rat/0,pos_rat/0,non_zero_rat/0]).
%% API
-export(
   [
    gcd/2, lcm/2,
    rat/1, rat/2,
    add/2,
    minus/1, minus/2,
    mult/2,
    inverse/1,
    divide/2,
    ge/2,
    is_rational/1,
    to_float/1,
    to_int/1,
    round/2
   ]).
-type rat() :: {integer(), pos_integer()}
             | integer().
-type pos_rat() :: {pos_integer(),pos_integer()}
                 | pos_integer().
-type non_zero_rat() :: {neg_integer()|pos_integer(),pos_integer()}
                      | neg_integer()
                      | pos_integer().

%% Greatest common divider of X and Y
-spec gcd(X::pos_integer(),Y::pos_integer()) -> pos_integer().
gcd(X,Y) when (X < Y) ->
  gcd(Y,X);
gcd(X,Y) ->
  case (X rem Y) of
    0 -> Y;
    R -> gcd(Y,R)
  end.

%% Least common multiplier of X and Y
-spec lcm(X::pos_integer(),Y::pos_integer()) -> pos_integer().
lcm(X,Y) ->
  G = gcd(X,Y),
  (X div G) * Y.

%% generates a `rat` number
-spec rat(L::integer(),M::pos_integer()) -> rat().
rat(X,Y) ->
  rat({X,Y}).

%% normalize a rational number
-spec rat(I::rat()) -> rat().
rat({0,_M}) ->
  {0,1};
rat({L,M}) when L > 0 ->
  G = gcd(L,M),
  {L div G, M div G};
rat({L,M}) ->
  {Lr,Mr} = rat({-L,M}),
  {-Lr,Mr};
rat(I) when is_integer(I) ->
  rat(I,1).

-spec add(X::rat(), Y::rat()) -> rat().
add({L1,M1},{L2,M2}) ->
  G = gcd(M1,M2),
  K1 = M1 div G,
  K2 = M2 div G,
    rat({L1 * K2 + L2 * K1,lcm(M1,M2)});
add(X,Y) ->
    add(rat(X),rat(Y)).

-spec minus(X::rat()) -> rat().
minus({L,M}) ->
    {-L,M};
minus(X) ->
    minus(rat(X)).

-spec minus(X::rat(), Y::rat()) -> rat().
minus(X,Y) ->
  add(X, minus(Y)).

-spec mult(X::rat(), Y::rat()) -> rat().
mult({L1,M1},{L2,M2}) ->
    rat({L1*L2,M1*M2});
mult(X,Y) ->
    mult(rat(X),rat(Y)).

-spec inverse(X::non_zero_rat()) -> rat().
inverse({L,M}) when L > 0 ->
  {M,L};
inverse({L,M}) when L < 0 ->
    {-M,-L};
inverse(X) ->
    inverse(rat(X)).

-spec divide(X::rat(), Y::non_zero_rat()) -> rat().
divide(X,Y) ->
  mult(X,inverse(Y)).

-spec ge(X::rat(), Y::rat()) -> boolean().
ge({L1,M1},{L2,M2}) ->
    L1 * M2 >= L2 * M1;
ge(X,Y) ->
    ge(rat(X),rat(Y)).

-spec is_rational(any()) -> rat().
is_rational(X={L,M}) when is_integer(L), is_integer(M), M > 0 ->
  X =:= rat(X);
is_rational(_) ->
  false.

-spec to_float(X::rat()) -> float().
to_float({L,M}) ->
    L / M;
to_float(X) ->
    to_float(rat(X)).

-spec to_int(X::rat()) -> integer().
to_int({L,M}) ->
  L div M.

%% round to Prec
-spec round(X::rat(), Prec::rat()) -> rat().
round(X = {L,_M},Prec) when L >= 0 ->
    mult(to_int(divide(X,Prec)),Prec);
round(X,Prec) ->
    E = round(minus(X),Prec),
    case minus(E) of
        X -> X;
        R -> minus(R,Prec)
    end.
