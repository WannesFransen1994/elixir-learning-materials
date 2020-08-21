# Assignment

Computing a square root is not easy if you can't rely on a built-in
square root function. In fact, as far as we know, the only way
to compute a square root using only more basic operations (`+`, `-`, `*` and `/`)
is to implement an algorithm that starts with a "guess"
which is then gradually improved. You can compare it to a game of higher/lower:
if you have to guess a number between 0 and 100, you first guess 50, which
is then "verified", which tells you if you have to look further
in the interval 0-49 or 51-100. The difference with the square root operation
is that you aren't looking for an integer, but for an infinitely long real number.
This means that, if the actual square root does not happen to be an integer, you'll actually
never be able to find the exact square root: you can only get arbitrarily close.

The reason a computer seems to be able to compute a square root is simply
because it only keeps track of a limited number of digits in a real number.
In other words, a processor can compute a square number that is precise up to this
number of digits.

## Task

You are given the function `Functions.fixedpoint(f, x)` which works as described in a previous exercise.
Write a function `Math.sqrt(x)` that computes the square root making use of `fixedpoint`.
For this you should rely on the [Newton-Rhapson method](https://en.wikipedia.org/wiki/Newton%27s_method).

Say you want to compute the square root of `x`. The method works by computing a series
of numbers `y0`, `y1`, `y2`, ... which, as it goes on, converges to the square root of `x`.
In other words, you found the square root when you encounter two consecutive `y` values equal to each other.

The formula to find the next `y` in line is

```text
               y^2 - x
 next_y = y - ---------
                2 * x
```

Make sure not to confuse the meaning of the variables:

* `y` is the most recently computed value of `y`
* `next_y` is the next `y` in line.
* `x` is the *original* value whose square root you're trying to determine.

The very first `y`-value is simply `x` itself.

For example, let's compute the square root of 100.
We get the successive values for `y`:

* 100
* 50.5 = 100 - (100^2 - 100) / (2 * 100)
* 38.2488 = 50.5 - (50.5^2 - 100) / (2 * 100)
* 31.4339 = 38.2488 - (38.2488^2 - 100) / (2 * 100)
* 26.9935
* 23.8502
* 21.5061
* 19.6935
* 18.2543
* 17.0882
* 16.1282
* 15.3276
* 14.6529
* 14.0794
* 13.5882
* 13.165
* 12.7984
* 12.4794
* 12.2008
* 11.9565
* 11.7417
* 11.5523
* 11.3851
* 11.237
* 11.1056
* 10.9889
* 10.8852
* 10.7927
* 10.7103
* 10.6368
* 10.5711
* 10.5123
* 10.4598
* 10.4127
* 10.3706
* 10.3329
* 10.299
* 10.2687
* 10.2414
* 10.217
* 10.1951
* 10.1754
* 10.1577
* 10.1418
* 10.1275
* 10.1147
* 10.1031
* 10.0928
* 10.0835
* 10.0751
* 10.0675
* 10.0608
* 10.0547
* 10.0492
* 10.0443
* 10.0398
* 10.0358
* 10.0322
* 10.029
* 10.0261
* 10.0235
* 10.0211
* 10.019
* 10.0171
* 10.0154
* 10.0139
* 10.0125
* 10.0112
* 10.0101
* 10.0091
* 10.0082
* 10.0074
* 10.0066
* 10.006
* 10.0054
* 10.0048
* 10.0043
* 10.0039
* 10.0035
* 10.0032
* 10.0029
* 10.0026
* 10.0023
* 10.0021
* 10.0019
* 10.0017
* 10.0015
* 10.0014
* 10.0012
* 10.0011
* 10.001
* 10.0009
* 10.0008
* 10.0007
* 10.0007
* 10.0006
* 10.0005
* 10.0005
* 10.0004
* 10.0004
* 10.0003
* ...
* 10
* 10 = 10 - (10^2 - 100) / (2 * 100)

Eventually, you'll arrive at a point where you reach `10`, and the next in line is also `10`. This is called the fixed point,
and you have found the square root of 10.
