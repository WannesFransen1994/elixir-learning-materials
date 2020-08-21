# Lists

As explained elsewhere, tuples are similar to arrays:
they can hold an arbitrary number of elements
and retrieving them is quite fast.
However, given that Elixir is a purely
functional language, modifying a tuple is not allowed.
Instead, you need to replace the *entire* tuple with a new one.
This potentially involves a lot of copying.
For efficiency reasons, we'd like to avoid that.

A tuple is an all-or-nothing affair:
if you want to modify one element,
you need to make a *complete* copy.
Let's see if there's a way of
limiting this, see if we could somehow
reuse parts of the original data structure.

## Splitting

Let's start with a crazy idea: why not cut the tuple in two parts?
For example, instead of storing our data as `{1, 2, 3, 4, 5, 6}`,
we rearrange it as `{ {1, 2, 3}, {4, 5, 6} }`. Now, if
we need to modify an element, we only need to
replace the corresponding half.

For example, if we wish to replace the `2` by a `0`,
we get the new structure `{ {1, 0, 3}, {4, 5, 6} }`.
Here, we were able to salvage `{4, 5, 6}`.
The longer the tuple, the more elements we could reuse, i.e.,
the less data we have to copy from one tuple to another.

If we put it in numbers: given a tuple of size N of which
we need to modify one element, we get

* Single tuple approach
  * Creation of 1 tuple of size N
  * Copying of N-1 items
* Double tuple approach
  * Creation of 1 tuple of size 2
  * Creation of 1 tuple of size N/2
  * Copying of N/2+1 elements

## Going Further

The trick of splitting the tuple in two can be applied repeatedly.
There are multiple ways of doing so.

One approach consists of nicely splitting the tuples recursively in equal halves.

```elixir
{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 }
```

Splitting once gives

```elixir
{ { 1, 2, 3, 4, 5, 6, 7, 8},
  {9, 10, 11, 12, 13, 14, 15, 16 } }
```

Splitting again gives

```elixir
{ { { 1, 2, 3, 4 },
    { 5, 6, 7, 8 } },
  { { 9, 10, 11, 12 },
    { 13, 14, 15, 16 } } }
```

One more time:

```elixir
{ { { { 1, 2 },
      { 3, 4 } },
    { { 5, 6 },
      { 7, 8 } } },
  { { { 9, 10 },
      { 11, 12 } },
    { { 13, 14 },
      { 15, 16 } } } }
```

Going further has little use: we would end up with tuples containing one element. That's definitely not more efficient.

The structure above is known as a *perfectly balanced tree*,
because the left and right part contain the same number of elements.
At the risk of offending Thanos, we could also do the opposite:
an absurdly lopsided tree.

```elixir
{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 }
```

The most unbalanced split possible is

```elixir
{ 1, { 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 } }
```

We persevere:

```elixir
{ 1, { 2, { 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 } } }
```

We persevere some more:

```elixir
{ 1, { 2, { 3, { 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 } } } }
```

After a lot more perseverance, we end up with

```elixir
{ 1, { 2, { 3, { 4, { 5, { 6, { 7, { 8, { 9, { 10, { 11, { 12, { 13, { 14, { 15, 16 } } } } } } } } } } } } } } }
```

This is still a tree, but a terribly unbalanced one.
Perhaps because of this, people thought a rebranding was necessary
and started calling it a *linked list*.

## Linked Lists

Presented like this, linked list might look hard to wrap your head around.
Imagine having to define algorithms that operate on that.
Fortunately, if you make a slight mental shift, you'll see that
linked lists are actually quite simple.

First, let's reduce the size of the list to a more manageable 4:

```elixir
{ 1, { 2, { 3, 4 } } }
```

We focus on the first outer tuple:

* Its first component is `1`.
* Its second component is another tuple containing the rest of the items.

The second outermost tuple exhibits the same structure:

* Its first component is `2`.
* Its second component is another tuple containing the rest of the item.

Instead of seeing this as a complicated, nested data structure,
you can also view it as a chain of tuples, where
each tuple are structured as follows:

* the first component: a "payload", i.e., an item of the linked list.
* the second component: a link to the next tuple in the chain.

```text
1 ---> 2 ---> 3 ---> 4
```

Now, we have to admit, there's a slight inconsistency... The last tuple `{3, 4}`
is a bit of an odd duck: its two components are both list items. We can "fix" this
as follows:

```elixir
{ 1, { 2, { 3, { 4, :eol } } } }
```

or visualized as a chain:

```text
1 ---> 2 ---> 3 ---> 4 ---> end-of-list
```

## Balanced Trees vs Linked Lists

Which data organization is best depends mostly on your needs.
However, in practice, you often need a simple sequence
of items, one following the other. While it is
certainly possible to organize such sequential data into a tree,
a linked list is often both more efficient and practical,
which is why most functional programming languages
have linked lists support built into the language.

## Elixir's Linked List

In the explanation above, we have been building linked lists
by linking tuples together. Elixir does however
provide specialized syntax.
Instead of having to write

```elixir
{1, {2, {3, {4, :eol}}}}
```

you can simply write

```elixir
[1, 2, 3, 4]
```

Note that Elixir makes a distinction between both: they have different types.
All linked list related functionality in Elixir can only operate on the second version.

## Why All This Explanation

You might wonder why we put you through this long explanation,
whereas a simple "lists are written `[1, 2, 3, 4]`" would have sufficed.
Sheer sadism, I suppose. But also for reasons more relevant for you:

* Only by knowing how linked list operate internally will you be able
  to make educated guesses regarding the performance of your algorithms.
  If you work with linked lists as if they are arrays, you'll probably
  end up with very inefficient code.
* To operate on linked lists, you often need to descend
  to a lower abstraction level, i.e., writing algorithms
  for linked lists involves working with the chain-of-pairs structure.

## Comparison of Arrays vs Lists

Since graphical representations greatly help in the understanding
of linked lists, we made them as slides available to you from the course's website.
