# rat
An Erlang RATional numbers library, supporting + (add), - (minus), * (mult), and / (divide).

A rational number is just a pair `{integer(),non_zero_nat()}`, i.e., `{x,y}` means `x/y` and `gcd(x,y) = 1`.

Examples:

    > c(rat).
    {ok,rat}
    > rat:rat(0.4444444444).
    {1111111111,2500000000}
    > rat:minus({2,3},{7,8}).
    {-5,24}
    > X = rat:rat(3,7).
    {3,7}
    > Y = rat:mult(X,X).
    {9,49}
    > Yinv = rat:divide(1,Y).
    {49,9}
    > rat:to_int(Yinv). 
    5
    > rat:mult(Yinv,X).
    {7,3}
    > rat:inverse(X) =:= rat:mult(Yinv,X).
    true
    > rat:floor(1/3,{1,100}).
    {33,100}
    > rat:to_float(rat:floor(-1/3,{1,1000})).
    -0.334
