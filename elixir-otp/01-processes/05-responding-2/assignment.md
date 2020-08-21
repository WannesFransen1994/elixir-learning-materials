# Assignment

Right now, the parent process send a meaningful message to the `print` child
process, which in turn sends back an arbitrary value to indicate
it's done printing. Let's have the child process actually respond something interesting.

Let's create a magic eight ball process. It works as follows:
when you send it a question (a string), it answers with either `:yes`, `:no`, or `:maybe`.
Since it is outside the scope of this course to develop future predicting software,
we'll limit ourselves to a simpler -- yet still just as convincing -- implementation.
To determine what to answer, compute the length of the question and divide it by three.

* If the remainder is `0`, answer `:yes`.
* If the remainder is `1`, answer `:maybe`.
* If the remainder is `2`, answer `:no`.

## Task

Create a function `magic_eight_ball` which, upon receiving a question (a string)
sends back `:yes`, `:maybe` or `:no`, following the rules laid out above.

Test your implementation by

* spawning the `magic_eight_ball` process;
* sending it multiple questions ;
* receiving the answers and printing them out.
