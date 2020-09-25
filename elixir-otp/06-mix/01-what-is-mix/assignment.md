# Assignment

Create a new application called `exercise`. Read the associated [mix intro reading material](../../reading-materials/mix/what-is-mix.md).

The goal of this exercise is to understand how mix works regardless of OTP aspects.

## Task 1

Create a module called `Exercise.Sage`. When you execute the `Exercise.Sage.say_wise_thing/0` function, it'll return the string "All life must be respected!".

Test this in your iex shell without manually compiling files!

```text
iex> Exercise.Sage.say_wise_thing
"All life must be respected!"
```

_Extra: without restarting your iex shell, adjust the return string with the `recompile` function._

## Task 2

Create a test that tests whether the above task is completed succesfully.

## Task 3

Let your sage read your secret that you defined in a config. Do not hard code this!

```text
iex> Exercise.Sage.spill_secret()
:secret_defined_in_config
```
