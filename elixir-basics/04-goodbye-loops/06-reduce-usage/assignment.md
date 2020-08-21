# Assignment

## Task

Write a function `Util.size(xs)` that returns the number of elements in `xs`.
Make use of Elixir's `reduce` function.

For those in need of some clues:

* The initial value for `acc` should correspond to the expected result for an empty list.
* Try to determine a few "facts" about the combiner function. From these you can try to build it.
  * The actual values in the list does not affect a list size, only how many there are. This indicates that the combiner function should ignore its first parameter.
    In other words, it should take the form `fn _, acc -> ... end`.
  * In this context, `acc` corresponds to the number of items already processed. This value should increase by one per element. So, given an `acc`, the combiner
    function should return `acc + 1`.
