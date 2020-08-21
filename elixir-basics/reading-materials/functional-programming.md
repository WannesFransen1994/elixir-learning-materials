# Functional Programming

## Definition

The idea behind functional programming is simple:
everything is *immutable*, i.e., unchangeable. This entails the following:

* Every variable remains forever equal to its initial value.
  These is no assignment, no incrementing, etc.
* All data structures are readonly: you cannot
  add items to a list or overwrite its current contents.

Basically, it's as if you declare everything `readonly` in C#,
or `final` in Java, or `const` in C++.

A bit of terminology: another word for immutable is *stateless*.
Something that can be modified during its lifetime
is *stateful*, while something that remains
forever the same is *stateless*.
Functional programming consists
of working only stateless.
The opposite of functional programming is
imperative programming.

| Imperative Programming | Functional Programming |
|-|-|
| Stateful | Stateless |
| Mutable values | Immutable values |

## Functional vs Imperative

Quick disclaimer: the text below is a rather simplified view of things,
but an accurate treatise on the topic would lead us far away from
the actual goals set by this course.

We can distinguish two philosophies:

* A computer is a valuable machine. We should make optimal use of it which
  is done by accommodating to it. We humans should adjust to the machine's whims.
* A computer has been created as an aid to humans. It does not make sense
  that we have to adjust ourselves to the machine. It should adjust to us!

Imperative programming primarily follows the first school of thought,
while functional programming adheres to the second.
Languages used in the industry (C, C++, Cobol, Java, C#, JavaScript, ...)
are generally more pragmatic and lean towards the imperative side.
Conversely, academic languages (Haskell, Prolog, Agda, ...) tend
to be functional in nature.

However, the general trend in programming language evolution is clearly
towards the functional style: as research advances and CPUs grow more powerful,
functional programming becomes a viable alternative.

For example, the quintessential programming "language" is assembly,
where you write instructions that can be directly understood by the CPU.
Its syntax, however, is abominable. FORTRAN (portmanteau of formula and translator)
was the first language to sport a more readable syntax, i.e.,
it allowed you to write `a + b` instead of `ADD AX, BX`.
This development can be seen as a first step towards the philosophy behind
functional programming: the task of parsing of code and its translation to assembly
has moved from humans to machine.

Similarly, CPUs have grown quite complex and its become humanly
infeasible to write code that fully leverages the capabilities of the CPU.
Again, the job of micro-optimization has also moved from humans to machine (compilers.)

Another fine example of the tension between the two philosophies
is exemplified in the contradictory opinions held by different types of programmers:

* Memory management is too important to be left over to the machine (C/C++).
* Memory management is too important to be left over to humans (any other language with garbage collection).

As you can see, more and more aspects of programming were relegated to the machine
so that humans could focus more on specifying the desired behavior of the program
and less on low level minutiae.

## Rationale

The ideal of letting the machine do all the programming work is of course
an appealing one, and perhaps, one day, it will be taken over
in full by the machine, possibly thanks to developments in AI.
However, until the day comes when we can have machines program themselves,
we still carry the responsibility of performing the job of
~~bullying~~ programming our machines as well as possible.

In the previous section, however, we seemingly suggested
that functional programming is somehow the holy grail,
the pinnacle of software engineering, the divine culmination
of computer science. A bold statement if there ever was one.

Functional programming certainly has its advantages,
but, as with all things in life, it also
comes with its share of frustrating shortcomings.
We will not claim that functional programming
is a panacea. It has its place, and
it will be up to you to decide when
to go stateless and when to go stateful.

Unfortunately, as thrilling as an in-depth
discussion may sound, there's little use for
it within the boundaries of this course.
Elixir, the language in which we'll code,
has made the choice for you: it is a
*purely functional language*, which means
it leaves you no choice but to go stateless.
The best we can do is to explain
why the designers chose to take such
an "extreme" stance.

### A Kitchen Story

You're probably used to writing single-threaded code:
you write a bunch of instructions and expect
them to be executed sequentially.
This is similar to having a single cook in the kitchen:
he does not have to worry about other cooks
and has got all kitchen equipment available to him.

Things quickly become much more complex when we
introduce a second thread of execution. Suddenly,
there are two cooks in the kitchen working at once,
and you have to ensure they don't accidentally
use the same cooking pot at the same time,
lest both their dishes be ruined.

You might expect cooks to be observant enough
to notice that the pot they intend
to make their soup in already has a stew in it.
In the case of human cooks, you'd be right,
but (plot twist!) these are robotic cooks we are talking about,
and those blindly follow the instructions you set out for them. This means
*you* have to tell them how
to ensure that whatever one robotic cook does,
it must not interfere with the other cooks' work.
This is known as *synchronization*.

Let us be frank: synchronization is *hard*.

* You have to make sure every kitchen utensil is used by one cook at a time.
* You have to prevent cooks waiting indefinitely for each other's tools (deadlock).
* You have to ensure the entire process scales: when you add too many cooks,
  they'll start impeding on each other. A kitchen with a thousand cooks will probably
  make less progress than a kitchen with just one cook.

We can mitigate this issue by instituting the following rule:
Whenever a cook needs some tool (an over, a skillet, a knife, ...)
it always takes a new one from the cupboard. No attempt at reusing pots is made.
This way, two cooks will never use the same piece of equipment.

The rule may seem a bit problematic to enforce: it basically requires you
to have an infinite amount of each kitchen utensil, otherwise
the cooks will surely run out by the end of their shift.
This is where the dishwasher comes in: like a regular [Tobias Fünke](https://www.youtube.com/watch?v=JhNSWJWYI8s),
he surreptitiously moves around the kitchen, unnoticed by the cooks,
and collects all dirty pots and pans, cleans them and puts
them back in the cupboard, ready to be fetched by the cooks.
But as far as the cooks are aware, there's an infinite amount of kitchen equipment
in the cupboard. In the computer world, the garbage collector takes the place of the dishwasher.
Its job is to pretend that there's an infinite amount of memory.

### Back to the Software World

The kitchen utensils of course correspond to values/objects in the software world.
Data can be similarly shared among ~~cooks~~ threads, and herein lies the danger:
if by any chance two or more threads happen to modify the same data at the same time (= cooking in each other's pots),
incorrect results ensue (= soupstew). It is therefore necessary
to introduce synchronization (locks, monitors, semaphores, ...)
which mediates access to this shared data.
A good rule of thumb is that you want only one thread to be able to modify data at a time,
but there is no risk in allowing multiple threads to read the same data in parallel.

We say that threads *share state* if there is mutable data
that can be modified by both threads. Whenever shared state
exists, the necessary safeguards need to be implemented.
However, doing so correctly is quite complex.
In short, like [premature optimization](http://wiki.c2.com/?PrematureOptimization=), shared state is
the root of all evil.

But what if we were to simply prohibit shared state?
This is more or less what kitchen rule 1 accomplishes:
only tools fresh from the cupboard are allowed,
guaranteeing that no two cooks share the same equipment.
Similarly, if all data is immutable, no variables are written to, only read from,
meaning there is no state and consequently no shared state, rendering synchronization superfluous.

So, in summary, functional programming enables parallelism without
having to worry about synchronization. That's definitely a good thing.

## Distributed Applications

Distributed applications is multi-threading on steroids.
It is clearly multi-threaded, as the process runs on two different machines
All difficulties of regular multi-threaded are therefore inherited,
but fortunately, so is our solution.

Multi-threaded applications running on a single machine
have the advantage that memory is shared: once one
thread has created or modified some data,
it is automatically accessible to all other threads.
There's no need to copy data from one thread to another.

However, in the case of distributed applications,
there is no shared memory. All relevant data
must be duplicated across all machines and kept
up to date: if one machine decides to change the data,
these updates must be propagated to all other machines.
This complicates things greatly.

Lucky for us, stateless programming saves the day again:
no mutations means no need to update data across machines.
Data generated on one machine only needs to be sent
once to all other interested machines and it'll remain
up to date forever by definition.

Admittedly, we're cheating a bit here: if no mutations
are allowed, it means that functional programs
will simply generated more fresh data.
So, instead of sending updates about mutations,
we're simply sending updates about data creation.
It's robbing Peter to pay Paul.
For this reason, it is still important
to distribute your application sensibly over multiple machines.

So what's the conclusion of all this? Did we simply
substitute one problem (synchronization) for
another (finding the optimal distribution)?
Well, yes and no.

If mistakes are made with regard to the distribution,
you still get correct results, albeit somewhat inefficiently.
If your synchronization is done wrong, you get
wrong results, and in the end,
your number one priority should always be correctness.
In other words: the punishment for errors
is less harsh in the case of functional programming.
