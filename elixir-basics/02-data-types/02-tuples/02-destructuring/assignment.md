# Assignment

Given a tuple, you'll probably want to access its elements.
Tuples are much like arrays, which to a C#/Java/C++ programmer means
writing the following code:

```C#
// C#
int[] xs = new int[] { 1, 2, 3 };

int size = xs.Length;
int first = xs[0];
int second = xs[1];
int third = xs[2];
```

This approach is certainly valid and supported
by Elixir, although it has a somewhat verbose syntax:

```elixir
xs = { 1, 2, 3 }

size = tuple_size(xs)
first = elem(xs, 0)
second = elem(xs, 1)
third = elem(xs, 2)
```

If you use tuples as a substitute for arrays,
then this is the way to go. However,
tuples are also used to group related
data together, such as objects do in OO-languages.
For example, say you want to represent
a card, which consists of a value (ace, 2...10, jack, queen, king)
and a suit (hearts, clubs, spades and diamonds),
you would use a tuple and
introduce the convention to
have the tuple's first element be the value and the
second the suit: `{value, suit}`. The other way around would work
as well, you only need to be consistent about it.

When tuples are used this way, it makes little sense
to ask for the length (when have you ever
asked for the length of a `Person` object, i.e., the number of fields?)
You don't ask for it simply because you already know there's two (in the case of a card.)
Indexing to get access to the card's value and suit
would be awkwardly clumsy:

```elixir
# So much code...
value = elem(card, 0)
suit = elem(card, 1)
```

It would be simpler to adopt the Python or JavaScript approach,
namely using a destructuring assignment:

```python
# Python
(value, suit) = card
```

```javascript
// JavaScript
const [value, suit] = card;
```

Destructuring is also available in Elixir:

```elixir
# Elixir
def doSomethingWithCard(card) do
    # Retrieve card components
    {value, suit} = card
    ...
end
```

You can also leverage the parameter pattern matching mechanism:

```elixir
# Elixir
def doSomethingWithCard( { value, suit } ) do
    ...
end
```

## Ignoring Parameters

Say your function receives a tuple but is not interested in all its value:

```elixir
# Elixir
def caresOnlyAboutValue( { value, suit } ) do
    # Ignores suit
end
```

Elixir will think you made a mistake: you took the trouble
of declaring a variable `suit` but failed to use it!
Not using a parameter value is in general indicative of a mistake,
so Elixir is quite right to point this out.

In order to ignore a value, you need to do so explicitly:

```elixir
# Elixir
def caresOnlyAboutValue( { value, _ } ) do
    ...
end
```

The `_` means "I know there's something here, but I don't care what it is."

## Task

Write a function `Cards.same_suit?(card1, card2)` that checks whether
the cards have the same suit. Do *not* rely on `==` or `!=`;
instead, make solely use of pattern matching.
(This is solely for educational purposes;
in practice, there's nothing wrong with relying on equality.)
