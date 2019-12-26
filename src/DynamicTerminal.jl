module DynamicTerminal

using REPL

cursorreset(lines::Int) = "\x1b[999D\x1b[$(lines)A"

resetcursor(lines::Int) = resetcursor(stdout, lines)
resetcursor(io::IO, lines::Int) = print(io, cursorreset(lines))
clearline(io) = print(io, "\x1b[2K")
key() = REPL.TerminalMenus.readKey()

rawmode(b::Bool) = if b
    REPL.TerminalMenus.enableRawMode(
        REPL.TerminalMenus.terminal
    )
else
    REPL.TerminalMenus.disableRawMode(
        REPL.TerminalMenus.terminal
    )
end

export cursor
cursor(b::Bool) = print(b ? "\x1b[?25h" : "\x1b[?25l")
export enablecolor
enablecolor(io::IO, color) = print(io, Base.text_colors[color])
export disablecolor
disablecolor(io::IO) = print(io, Base.text_colors[:default])

export showandreset
function showandreset(buff)
    seekstart(buff)
    lines = countlines(buff)
    write(stdout, take!(buff))
    resetcursor(buff, lines)
end

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
