# Errors

**Scope:** Lua's two error styles — the nil-plus-message
convention and thrown errors — and the catching machinery:
`pcall`, `xpcall`, error levels, and tracebacks. Output from
`lua-lab/programs/errors.lua` (transcript t10), all run.

## Two mechanisms, two kinds of failure

Lua code signals failure two ways, and knowing which you're
looking at is most of the skill:

- **Expected failure** — a file that doesn't exist, a port
  number typed wrong: return `nil` plus a message and let the
  caller decide. Chapter 7 showed the shape; the standard
  library's I/O functions all work this way.
- **Something wrong** — a bug, a broken assumption: throw with
  `error()`. An uncaught error ends the program and prints the
  message with a traceback.

## Throwing: error() and levels

```lua
local function parse_port(text)
  local n = tonumber(text)
  if n == nil then
    error("not a number: " .. tostring(text))
  end
  if n < 1 or n > 65535 then
    error("port out of range: " .. n, 2)   -- level 2
  end
  return n
end
```

The optional second argument is the **error level**: whose
position the message blames. Level 1 (the default) names the
line inside the function that called `error` — right when the
raiser knows best. Level 2 names the *caller* of that function —
right when a helper is validating its caller's input, as here:
the bug is in the value the caller passed, not in `parse_port`.

## Catching: pcall

`pcall(f, args...)` calls `f` in *protected mode* and reports
instead of propagating:

```text
pcall('8080'):    true   8080
pcall('banana'):  false  errors.lua:10: not a number: banana
pcall('99999'):   false  port out of range: 99999
```

Note the level-2 error carries no `file:line` prefix pointing
into `parse_port` — the blame was deliberately aimed outward.
Runtime errors are ordinary citizens here: indexing nil inside
a protected call comes back the same way
(`false, "attempt to index a nil value ..."`). The error object
is usually a string, but `error` can throw **any value**, and
structured error tables are how bigger programs carry codes
alongside messages.

`assert` is the compact form: `assert(io.open(name))` returns
the value if truthy, and throws the message (or the second
return value) if not — the lab used it to open a file it then
verified was userdata.

## xpcall: catching with the stack still standing

`pcall` unwinds before you can look. `xpcall(f, handler)` runs
`handler` *while the failing stack still exists*, which makes
it the place to capture a traceback for a log:

```lua
local function handler(e)
  return "handled: " .. e .. "\n" .. debug.traceback("", 2)
end
local ok, report = xpcall(failing_function, handler)
```

The lab's handler output included `handled: errors.lua:42: the
kettle boiled dry` and a traceback that named the file — the
shape of every "email me the crash report" feature in a Lua
host. (The message argument to `debug.traceback` and its level
are worth a careful read in the manual when you build one for
real; off-by-one levels put *your handler* in the trace instead
of the failure.)

## Habits that hold up

- Library code: return nil-plus-message for failures a caller
  can reasonably handle; throw for contract violations.
- Program boundaries (a host calling a user script, a script's
  main chunk): wrap in `xpcall`, log the trace, show the user
  one clean line.
- Never `pcall` to silence: catching and ignoring converts a
  findable bug into a mysterious wrong answer.

## Check

- [ ] You can say when nil-plus-message beats `error()`
- [ ] You know what `pcall`'s two return values are in each case
- [ ] You can explain why `xpcall` exists when `pcall` already does

Next: [Libraries and LuaRocks](libraries-and-luarocks.md).
