# Assignment

Something that might confuse you when you first encounter it
are predicate names. A predicate is simply a fancy
name for a function that returns a boolean value.
To improve readability, languages often have
a convention of having a function's name hint
at its predicate nature.

|Language|Convention|Example|
|-|-|-|
|C#|`Is...`|`IsOdd`|
|Java|`is...`|`isMale`|
|Python|`is...` or `has...` |`isupper`, `hasattr`|
|Canadian| `...Eh` | `primeEh` |
|Ruby|`...?`|`odd?`|
|Common Lisp|`...p`| `numberp` |
|Mathematica|`...Q`| `MemberQ` |

Elixir has adopted the same convention as Ruby:
predicate names end on `?`. You are probably
not used to see a question mark being
part of an identifier, since it is considered invalid
in most languages. Elixir, however, allows
`?` to appear at the end of identifiers, and only at the end.

(Note that `?a` is syntactically valid but can't be used
as a function's name. Instead, `?a` denotes
the character `a`. This is the equivalent of `'a'` in C#/Java/C++.)

## Task

Create a file `student.exs` and write two functions `odd?` and `even?`.
Let them be part of a module named `Numbers`.
You might have to look up the Elixir syntax for modulo: it differs
from most other languages.

Run the tests to check your work. Be sure to also look at the solution after you're done.
