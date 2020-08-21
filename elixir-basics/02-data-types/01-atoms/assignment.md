# Assignment

Start with reading up on [atoms](/elixir-basics/reading-materials/atoms.md).

As an example usage of atoms, let's implement the core functionality of rock-paper-scissors.
First we need to decide how to represent the three possible choices: rock, paper, and scissors.
We have many options:

* Strings: overkill. Too flexible and slow.
* Integers: too abstract. We'd have to remember which number represents which choice.
* Booleans: not enough of them.
* Functions: kudos if you manage to do this.
* Atoms: aha! Idiomatic and simple. Perfect!

Now, let's write a function `beats?(x, y)` that checks whether `x` beats `y`.

| `x` | `y` | `x` beats `y` |
|:-:|:-:|:-:|
|rock|rock|`false`|
|rock|paper|`false`|
|rock|scissors|`true`|
|paper|rock|`true`|
|paper|paper|`false`|
|paper|scissors|`false`|
|scissors|rock|`false`|
|scissors|paper|`true`|
|scissors|scissors|`false`|

According to this table, there are 9 possible input combinations,
for 3 of which `beats?` should return `true`. We can implement this
by picking out these 3 specific cases and implementing all others
using a catch all clause.

```elixir
defmodule RockPaperScissors  do
  def beats?(:rock    , :scissors), do: true
  def beats?(:scissors, :paper   ), do: true
  def beats?(:paper   , :rock    ), do: true
  def beats?(x, y) when is_atom(x) and is_atom(y), do: false
end
```

## Task

Implement a function `Cards.higher?(x, y)` that checks whether `x` is a higher card than `y`.
There are thirteen possible cards. They are, in increasing order of value: `2`, ..., `10`, `:jack`, `:queen`, `:king`, `:ace`.
