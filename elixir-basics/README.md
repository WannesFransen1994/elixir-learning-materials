# Elixir basics

## Goal

In this course we'll cover the basics of Elixir. We'll start with some fundamentals and a script-based approach (more about this in [Usage](#usage)). The topics are listed under [Topics](#topics), which will be a short summary of what is covered in this repository.

## Usage

First install Elixir. It is recommended to use ASDF, but you can also go to the website elixir-lang.org and follow the download instructions. Verify you've installed elixir with `elixir -v` and opening an interactive shell with the `iex` command.

Now that you can start executing elixir code, we'll often provide an `student.exs`, `solution.exs` and `tests.exs`. As the names imply, a possible / recommended solution will be written in the `solution.exs` file, `student.exs` will contain your code and when you run `elixir tests.exs`, this code is executed to see if it works correctly. Sometimes no `tests.exs` is provided, this can be the case when it is complex to write the tests (in this case check the solution), or it might not be applicable (e.g. [01-hello-world](01-basics/01-hello-world/)).

Happy learning!

## Topics

- [X] Modules and (private) functions
- [X] String operations (interpolation)
- [X] Function arity & default parameter values
- [X] Control flow (if / cond)
- [X] Guards clauses
- [X] Data types (tuples, atoms, lists, maps)
- [X] Pattern matching
- [X] Functions as first class citizens, lamdas & closures
- [X] Higher order functions + piping
- [X] Recursion

## Roadmap / missing topics

- [ ] Debugging information
- [ ] IDE setup (VS Code)

## Credit

Thanks to [Frederic Vogels](https://github.com/fvogels) for all the effort in creating these exercises. Due to restructuring, the commits are no longer in the commit log, but will not be forgotten.

These exercises were originally created for the course Distributed Applications / Internet Programming major at [UCLL](https://www.ucll.be/). Most of this content is thus sponsored by UCLL.

Extra thanks to every contributor, student and the Elixir community.

## Note

This project is part of the [elixir learning materials](https://github.com/WannesFransen1994/elixir-learning-materials) repository. The same license, code of conduct and contributing guidelines are applicable!

```txt
Elixir learning materials, submodule Elixir basics (c) by Wannes Fransen

Elixir learning materials, submodule Elixir basics is licensed under a
Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0).

You should have received a copy of the license along with this
work.  If not, see https://creativecommons.org/licenses/by-nc-sa/4.0/ .
```
