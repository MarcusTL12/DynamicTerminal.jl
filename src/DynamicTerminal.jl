module DynamicTerminal

using REPL


cursorreset(lines::Int) = "\x1b[999D\x1b[$(lines)A"
resetcursor(lines::Int) = resetcursor(stdout, lines)
resetcursor(io::IO, lines::Int) = print(io, cursorreset(lines))

# Clear the current line such that you do not need to overwrite the rest of it
# with spaces. Can have wierd behaviour when a lot of frames are drawn quickly.
export clearline
clearline(io) = print(io, "\x1b[2K")

# Returns the next key pressed in the terminal.
# Requires rawmode to work properly
export key
key() = REPL.TerminalMenus.readKey()

# Enables and disables rawmode for the terminal.
# Beware: in raw mode you can not Ctrl+C to interrupt out of an infinite loop.
export rawmode
rawmode(b::Bool) = if b
    REPL.TerminalMenus.enableRawMode(
        REPL.TerminalMenus.terminal
    )
else
    REPL.TerminalMenus.disableRawMode(
        REPL.TerminalMenus.terminal
    )
end

# Enable or disable the cursor showing. Call cursor(false) to hide cursor
# and cursor(true) to show again
export cursor
cursor(b::Bool) = print(b ? "\x1b[?25h" : "\x1b[?25l")

# Enables the specified color. enablecolor(io, :red) for example will
# make following text appear red until disablecolor is called.
export enablecolor
enablecolor(io::IO, color) = print(io, Base.text_colors[color])

# Disables color such that following text appears with the default color
export disablecolor
disablecolor(io::IO) = print(io, Base.text_colors[:default])

# The main meat of the package. This prints the contents of the buffer
# to stdout and then prints a special escape character to the now empty buffer.
# This makes it so that when printing the contents of the buffer the next time
# the cursor will move up the amount of lines printed last time, thereby
# overwriting the previous print.
export showandreset
function showandreset(buff)
    seekstart(buff)
    lines = countlines(buff)
    write(stdout, take!(buff))
    resetcursor(buff, lines)
end

# A useful utility for a lot of my usecases for this package.
# returns a function that when called will note the time and sleeps the
# appropriate amount of time such that the function is done exactly
# stime seconds later then last time it was called.
# This is useful for for example maintaining a constant and stable "framerate"
# which is useful when using the dynamic console for animation.
# example:
# this loop runs 10 times a second:
# sync10 = syncer(0.1)
# while true
#   # Dostuff
#   sync10()
# end
export syncer
function syncer(stime)
    ptime = time()
    
    function sync()
        t = time()
        Δt = t - ptime
        (stime - Δt) > 0 && sleep(stime - Δt)
        ptime = t + (stime - Δt)
    end
end

end # module
