# Atoms

Atoms can be best compared to JavaScript's symbols,
which you are probably not familiar with... So let's try a different approach.

This is what an atom looks like: `:abc`.
Want another one? Here you go: `:hello`.
Still not satisfied? `:avff`.

It looks a lot like a string, but instead of being
surrounded by double quotes, there's a colon in front.
Every atom can be converted to a string and vice versa:

```elixir
iex(1)> String.to_atom("abc")
:abc

iex(2)> Atom.to_string(:abc)
"abc"
```

It appears atoms are redundant. Of course, there's more to it than that.

Atoms are used all over the place. For example, code has to be stored in memory.
Say you define the following module:

```elixir
# Elixir
defmodule Foo do
  def bar() do
    ...
  end
end
```

This code first needs to be parsed and then evaluated. In other words,
Elixir needs some data structure representing this code.
This is generally called an Abstract Syntax Tree (or AST for short).
You can see what it looks like as follows:

```elixir
iex(1)> quote do
...(1)>   defmodule Foo do
...(1)>     def bar() do
...(1)>     end
...(1)>   end
...(1)> end
{:defmodule, [context: Elixir, import: Kernel],
 [
   {:__aliases__, [alias: false], [:Foo]},
   [
     do: {:def, [context: Elixir, import: Kernel],
      [{:bar, [context: Elixir], []}, [do: {:__block__, [], []}]]}
   ]
 ]}
```

The details of this structure are not important, but you can
discern a few familiar details in it: the `defmodule` appears as an atom,
and so do `Foo`, `def` and `bar`. In fact, all essential parts
of the code are present in this structure.

Admittedly, atoms are not really necessary to make this possible: Elixir
could just as well have used strings for this. So, why atoms?
Well, it's all about efficiency.

Let's have a quick thought experiment. It's not very true to reality,
but it will suffice for explanatory purposes. Imagine we're writing
our own Elixir interpreter and we need to decide what to
use to represent identifiers, keywords, etc.
Say we opt for strings.

We have a module of hundreds of functions and we choose to call one of them, e.g., `foo`.
Elixir would then have to go through the module, looking for a function
with that name. Given that identifiers are represented by regular strings,
this involves many string comparisons, which are relatively slow:
both strings' characters have to be compared one by one.

There are plenty of other scenarios where strings are slow:
for example, say that a function resides on a different
machine (this is a distributed applications course after all),
we'd have to copy the full name to that other machine.
If many calls need to be made, copying all these strings
will amount to considerable overhead.

Strings are nice if you actually need related operations on strings
such as slicing or converting to uppercase. But none
of these is useful when dealing with identifiers. In fact, very
few operations are necessary: we want to be able to efficiently
compare and copy identifiers. Strings are slow for both these operations.

Instead of using strings, which provide you with a a lot
of unnecessary flexibility, let's find another data type
that is more restricted yet more efficient. A good choice would
be a simple integer. Comparing them is a simple operation (e.g., no loops involved)
and copying them is very fast.

The real Elixir does just that: atoms are actually integers.
Internally, a large table associating atoms to integers is kept.
Whenever you mention an atom, Elixir
will look it up in this table to see if it has been
encountered before. If that is the case, the associated integer
is returned. If not, the atom is added to the table and
linked to an as of yet unused integer. This table is also
kept synchronized across machines, allowing
atoms to be used to communicate efficiently between machines.

If you're still confused about why atoms are useful:
we'll be making plenty use of them in the exercises.
When you get there, think about what impact efficiency-wise it
would have on your program if you'd use strings instead of atoms.
In fact, you've already made use of atoms without realizing it:
in Elixir, `true` and `false` are actually atoms. Imagine
what it would mean in C#/Java/... if you were to have `"true"` and
`"false"` instead of the built-in booleans.
