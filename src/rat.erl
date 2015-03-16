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
    to_float/1
   ]).

gcd(X,Y) when (X < Y) ->
  gcd(Y,X);
gcd(X,Y) ->
  case (X rem Y) of
    0 -> Y;
    R -> gcd(Y,R)
  end.

lcm(X,Y) ->
  G = gcd(X,Y),
  (X div G) * Y.

rat(X,Y) ->
  rat({X,Y}).

rat({0,_M}) ->
  {0,1};
rat({L,M}) when L > 0 ->
  G = gcd(L,M),
  {L div G, M div G};
rat({L,M}) ->
  {Lr,Mr} = rat({-L,M}),
  {-Lr,Mr}.

add({L1,M1},{L2,M2}) ->
  G = gcd(M1,M2),
  K1 = M1 div G,
  K2 = M2 div G,
  rat({L1 * K2 + L2 * K1,lcm(M1,M2)}).

minus({L,M}) ->
  {-L,M}.

minus(X,Y) ->
  add(X, minus(Y)).

mult({L1,M1},{L2,M2}) ->
  rat({L1*L2,M1*M2}).

inverse({L,M}) when L > 0 ->
  {M,L};
inverse({L,M}) when L < 0 ->
  {-M,-L}.

divide(X,Y) ->
  mult(X,inverse(Y)).

non_negative({L,M}) when L >= 0, M > 0 ->
  true;
non_negative(_) ->
  false.

ge(X,Y) ->
  non_negative(minus(X,Y)).

is_rational(X={L,M}) when is_integer(L), is_integer(M), M > 0 ->
  X =:= rat(X);
is_rational(_) ->
  false.

to_float({L,M}) ->
  L / M.

