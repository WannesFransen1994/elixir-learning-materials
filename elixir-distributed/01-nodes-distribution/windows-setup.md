# Windows: Extra Setup

In order to be able to use the `epmd` application,
you need to update your system's `PATH`.

First, locate `epmd`. By default, you should
find it in the directory `C:\Program Files\erl10.1\erts-10.1\bin`.
Check if this directory does indeed contain `epmd.exe`, otherwise
you'll have to look for it yourself.

Next, add it to your `PATH` environment variable.

* Windows + R
* Enter `sysdm.cpl`.
* Go to the Advanced tab
* Click the Environment Variables button
* In the upper list, double click on Path (or create it first if it doesn't exist).
* Add `C:\Program Files\erl10.1\erts-10.1\bin` to the list (or whichever directory contains `epmd.exe` on your machine.)
