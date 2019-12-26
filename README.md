# DynamicTerminal.jl
Very minimal functionality for overwriting
multiple lines of the terminal in julia.

This is basically a result of tearing down the insides of the TerminalMenues
module in the standard REPL library since this was the best example i could
find of dynamically updating the terminal over multiple lines, that did not
rely on external dependencies (such as ncurses).


Examle of usage can be found in examples (comming soon) and my solution of
[![adventofcode 2019 day 13 part 2]](https://github.com/MarcusTL12/JuliaKalender/blob/master/AdventOfCode2019/13/main.jl)


## Usage

The general gist of how to use this package boils down to the `showandreset`
function.

Here is a quick example:

```julia

# This whole package is built around using a single IOBuffer (or some other
# similar structure)
buff = IOBuffer()

println(buff, "Some\n", "stuff") # Print some stuff to the buffer

# This now empties the buffer, writes the contents to the stdout and counts how
# many lines was just printed and prints a set of special character to the
# buffer. This way the buffer "knows" how many lines to move the cursor up
# to be at the start of the block it just printed.
showandreset(buff)

# Print some other stuff to the console
println(
    buff,
    """
    Some
    other
    stuff
    """
)

sleep(1) # To add some suspense

# Empties and prints to stdout as before, which now includes the special
# characters from before, moving the cursor up to the top and overwrites
# the previously printed messages.
showandreset(buff)

```
