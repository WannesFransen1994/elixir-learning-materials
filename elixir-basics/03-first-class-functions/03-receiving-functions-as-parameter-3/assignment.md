# Assignment

Write a function `Functions.compose(fs, x)` that, given a list of unary functions `fs`, applies each in turn on `x`.

~~For example, `compose([f, g, h], x)` returns `f(g(h(x)))`.~~

For example, `compose([f, g, h], x)` returns `h(g(f(x)))`.

While this exercise might seem overly mathematical, you'll find later that function composition is
a very common operation. Elixir even has a special operator for it, which we'll discuss later on.
