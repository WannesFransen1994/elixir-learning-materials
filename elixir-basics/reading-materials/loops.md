# Loops in Functional Languages

As mentioned repeatedly, Elixir is a purely functional language,
meaning it is forbidden to modify anything.

Loops, however, are constructs that inherently relate on state:
there's some loop variable that changes at every iteration.
This means that there are no loops in Elixir.

But good news everyone, there's an alternative: recursion!

Actually, that's only half of the good news. Even
to the functional programming purists, recursion
is considered too low level and something to be avoided.
So what is the alternative?

## Faking Loops

Let's take a closer look at the `while` loop:

```javascript
// JavaScript
while ( condition )
{
    body
}
```

The question now is, how would you be able to
achieve the same as this loop but without relying on a loop?

Well, easy, we gave it away earlier: recursion.

```javascript
function myWhile()
{
    body;

    if ( condition )
    {
        MyFakeLoop();
    }
}
```

So, now, everywhere we have a `while` loop,
we can replace it with a function that calls itself.
It's not clear how this is an improvement.
Also, as explained above, we wish to steer clear
of recursion.

What if we could turn the loop-construct
into a regular function, that
if given the right parameters will behave
exactly the same as the original loop.

We first focus on the parameters this magical
function would receive. What characterizes
a specific `while` loop?

* The condition.
* The body.

So, a `while` loop is in essence nothing
more than a function with two parameters:

```javascript
function myWhile(condition, body)
{
    ???
}
```

We now need to fill in the body...

```javascript
function myWhile(condition, body)
{
    execute body;

    if ( condition )
    {
        my_while(condition, body);
    }
}
```

Okay, we cheated a bit: `execute body` isn't valid code.
We should really fix this. What is this `body` thing? It's a series of instructions.
Is there a way to somehow package instructions into
some object? There sure is: functions!

Instead of `execute body`, we can say that `body`
is actually a function, which contains the actual loop body.
We know the syntax for calling a function:

```javascript
function myWhile(condition, body)
{
    body();

    if ( condition )
    {
        myWhile(condition, body);
    }
}
```

Let's see if we can use this to print a range:

```javascript
let i = 0;

function body()
{
    console.log(i);
    i++;
}

myWhile( i < 10, body );
```

If you run this code, you'll see that it never ends and keeps on printing increasing numbers forever.
What went wrong? Think about it for a minute before going further.

The first argument is `i < 10`, which evaluates to `true`. This value is reused at each "iteration".
Instead, `i < 10` should be reevaluated each time. A simple trick to accomplish this is
to update the condition to a function:

```javascript
function myWhile(condition, body)
{
    body();

    if ( condition() ) // <-- !! Extra ()
    {
        myWhile(condition, body)
    }
}
```

Second attempt:

```javascript
let i = 0;

function condition()
{
    return i < 10;
}

function body()
{
    console.log(i);
    i++;
}

myWhile(condition, body);
```

Hey! It works!

One might complain about the verbosity of it all: a simple `while` is replaced
by two functions. Hardly elegant. Luckily, things can be improved
thanks to *lambdas*. The idea is very simple: a lambda is nothing more
than an anonymous function. When you write

```javascript
function condition()
{
    return i < 10;
}
```

you are in fact creating a lambda and assigning it to the variable `condition`:

```javascript
const condition = () => i < 10;
```

Thus we can simplify the above code:

```javascript
let i = 0;

myWhile(() => i < 10, () => { console.log(i); i++; });
```

We must admit that faking a `while` does not really make much sense for two reasons,
the first being it feels rather forced. Even with lambdas, having
to pass two functions feels arduous.

Secondly, in a purely functional language, a function always returns the same results when given
the same inputs. Since `condition` is a function without parameters,
it is bound to always return the same value. Our example above relies
on state (`i`), but this is not an option in Elixir.
So we better take a look at some useful loops.

## Filtering

Instead of trying to emulate a general purpose loop, why
not focus on *what* a loop accomplishes. In practice,
loops tend to perform the same basic tasks or a combination thereof.
An example of such a basic task is filtering:

```javascript
const selection = [];

for ( const x of xs )
{
    if ( condition(x) )
    {
        selection.push(x);
    }
}
```

This filtering code has two parameters:

* `xs`, the list being filtered;
* `condition` deciding which items must be selected.

We make this explicit by turning it into a function:

```javascript
function filter(xs, condition)
{
    const selection = [];

    for ( const x of xs )
    {
        if ( condition(x) )
        {
            selection.push(x);
        }
    }

    return selection;
}
```

Turning this into a recursive function gives

```javascript
function filter(xs, condition)
{
    if ( xs.length > 0 )
    {
        const [ head, ...tail ] = xs;
        const filteredTail = filter(tail, condition);

        if ( condition(head) )
        {
            return [ head, ...filteredTail ];
        }
        else
        {
            return filteredTail;
        }
    }
    else
    {
        return [];
    }
}
```

Note that `condition` now takes a parameter: it is a function
that receives an element of `xs` and returns `true` if it should be selected.

Let's try it out:

```javascript
// Select even numbers
const selection = filter([1, 2, 3, 4, 5], x => x % 2 === 0);
```

`selection` is now equal to `[2, 4]`.

We've got more good news: `filter` actually already exists in JavaScript:

```javascript
const selection = [1, 2, 3, 4, 5].filter(x => x % 2 === 0);
```

In other words, you don't need to perform recursion yourself,
it's already been done for you. Of course, the same applies
to Elixir:

```elixir
iex(1)> Enum.filter(1..10, fn x -> rem(x, 2) === 0 end)
[2, 4, 6, 8, 10]
```

## Other Loops

There are other similar loop constructs that
have been implemented as functions.
`map` often comes in handy. An iterative JavaScript implementation could be

```javascript
function map(xs, f)
{
    const result = [];

    for ( const x of xs )
    {
        result.push( f(x) );
    }

    return result;
}
```

`map` takes a list `xs` and a function `f`, applies `f`
to each element of `xs` in turn and collects
the results in a new list. Like `filter`,
`map` is readily available to you as an array method:

```javascript
> [1, 2, 3, 4, 5].map(x => x ** 2);
[1, 4, 9, 16, 25]
```

For example, if you have a list of `Person` objects, you can use map to retrieve their names:

```javascript
const names = people.map( x => x.getName() );
```

or, in Elixir:

```elixir
Enum.map(people, fn person -> getName(person) end)
```

Examples of other "loop functions" from the [`Enum` module](https://hexdocs.pm/elixir/Enum.html) are

* `reduce`: reduces all items to just one value according to a specified rule. Can be used to take sums, count elements, etc.
* `find`: finds the first element satisfying a given condition.
* `all?`: checks if all elements satisfy a given condition.
* `any?`: checks if any element satisfies a given condition.
* `count`: counts the number of elements satisfying a given condition.

## Advantages

There are multiple advantages of using these "loop-functions".

### Readability

The intent (filtering, counting, mapping, ...) is explicitly stated in the code. In the case of loops, one has to study the code
in order to determine what it accomplishes.

Compare this code:

```javascript
function foo(students)
{
    let result = null;

    for ( const student of students )
    {
        let count = 0;

        for ( const course of student.courses )
        {
            if ( student.gradeFor(course) >= 10 )
            {
                count++;
            }
        }

        if ( result !== null && result > count )
        {
            result = student;
        }
    }
}
```

with the functional equivalent:

```javascript
function foo(students)
{
    return students.max_by( student => student.courses.count( course => student.gradeFor(course) >= 10 ) );
}
```

Some students claim that fully written loops are more easily understood, but that is merely because it consists of low level
building blocks that they are already familiar with. While there is nothing wrong to dislike solutions one deems inferior,
disliking the unfamiliar will only lead one to become obsolete, especially in a field like IT.

### Reuse and Robustness

Loop replacing functions spare you the burden of having to repeat the same code over and over again.
Instead, the loop logic is written once and you needn't bother with it ever again. You
only need to write down what is essential to the problem at hand. The less boilerplate code you write, the better.

Correctness is directly related to code size: the less code you write, the less opportunity you have to write bugs.

### Smart Loops

Many loops can be optimized to make use of parallelism: `map`, `count`, `reduce`, `all?` can all easily be
parallelized. This is much harder with regular loops: the compiler is supposed to "understand"
what you're doing and realize that your algorithm can actually be rewritten to
leverage parallelism. Sadly, compilers are not that smart yet.

However, by using function-loops like `map`, `count`, etc. you are giving them a clear hint
of what you're trying to achieve, allowing them to perform all kinds of advanced optimizations.

An example of this is [Google's MapReduce](https://ai.google/research/pubs/pub62),
which is a combination of two "loops". Code whose structure
follows this MapReduce pattern can be made to run automatically on multiple machines in parallel.
