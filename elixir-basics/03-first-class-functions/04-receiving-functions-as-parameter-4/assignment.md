# Assignment

Write a function `Functions.fixedpoint(f, x)` that repeatedly applies the given unary function `f` on `x`
until a *fixed point* is reached, i.e., that it finds a `y` such that `y == f(y)`.

For example, take the square root function and start at 10.

* Taking the square root of 10 gives 3.16
* Taking the square root of 3.16 gives 1.78
* Taking the square root of 1.78 gives 1.33
* Taking the square root of 1.33 gives 1.15
* ...
* Taking the square root of 1.000004 gives 1.000002

After an infinite number of steps, this will converge to 1.
The tests will of course not lead to infinite series.

An example of a fixed point computation "in the wild" is a solver
for puzzles like Sudoku or nonograms. First, you develop a
number of solving techniques, i.e., a single step in the
solving process of the puzzle. For example, one of the techniques
you could implement for Sudoku is looking for a row
which is entirely filled but for one square that is still empty: determining this
square's number is simple.

Each such technique would be implemented
as its own function. Their signatures would look like

```csharp
Puzzle TryTechniqueX(Puzzle puzzle) { ... }
Puzzle TryTechniqueY(Puzzle puzzle) { ... }
Puzzle TryTechniqueZ(Puzzle puzzle) { ... }
```

Then, you combine all these techniques using function composition.
In C#, the composition of multiple technique functions yields
another technique function:

```csharp
Puzzle TryAllTechniques(Puzzle puzzle)
{
    return TryTechniqueX(TryTechniqueY(TryTechniqueZ(puzzle)));
}
```

Lastly, you want to repeatedly apply these techniques
until either the puzzle is solved or you're stuck.
This is known as the fixed point; you can also
interpret it as the "point of no progress."

Another example of a fixed point (according to my interpretation that is) is [the movie Predestination](https://www.imdb.com/title/tt2397535/?ref_=nv_sr_1?ref_=nv_sr_1).
