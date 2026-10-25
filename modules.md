# Modules

**Scope:** splitting a program across files — `require`, the
search path, and the write-a-module idiom. Output from
`lua-lab/programs/modules.lua` and `geometry.lua` (transcript
t09), run from their own directory.

## require: load once, cache, hand back

```lua
local geometry = require("geometry")

print(geometry.circle_area(3))            -- 28.274333882308
print(geometry.hypotenuse(3, 4))          -- 5.0

local again = require("geometry")
print(again == geometry)                  -- true
```

`require("geometry")` does four things:

1. Looks in `package.loaded` — if this name was loaded before,
   it returns the cached value and nothing re-runs.
2. Otherwise searches `package.path` for `geometry.lua`
   (each `?` in a path template is replaced by the module name).
3. Runs the file, which is expected to **return a value** —
   usually a table of functions. A file that returns nothing
   gives `true`.
4. Stores that value in `package.loaded.geometry` and returns it.

The lab confirmed the cache with identity: two requires, one
table. It also asked where the file came from:

```lua
package.searchpath("geometry", package.path)   -- "./geometry.lua"
```

The default path starts with `./?.lua` — the current directory
— which is why the lab's modules worked from their own folder,
and why running the same command from a different folder is a
classic "module not found" (see Troubleshooting). `LUA_PATH`
(chapter 3) extends the search; `./` first is a convenience and,
for programs that load modules by name from untrusted working
directories, worth a thought.

## Writing a module: the idiom

A module file is the closure idea at file scale — locals for
privacy, one table for the public face, returned at the end:

```lua
-- geometry.lua
local M = {}

M.pi = 3.141592653589793

function M.circle_area(r)
  return M.pi * r * r
end

local function square(x) return x * x end   -- not in M: private

function M.hypotenuse(a, b)
  return math.sqrt(square(a) + square(b))
end

return M
```

Everything not hung on `M` is invisible to users of the module.
Modern style avoids globals entirely; older code (and Lua 5.1's
`module()` function, long removed) set globals instead — if you
meet it in a legacy file, that's what it's doing.

Dotted names map to folders: `require("net.http")` searches for
`net/http.lua` in each path template. C modules (`.so`/`.dll`)
are searched on `package.cpath` the same way; LuaRocks
(chapter 14) installs both kinds.

## The standard library is modules all the way down

`string`, `table`, `math`, `io`, `os`, `coroutine`, `debug` are
tables of functions that exist as globals from the start — the
same shape as your own modules, which is why `string.upper`
feels just like `geometry.circle_area`. A program can even
replace them (don't, outside of sandboxing on purpose).

## dofile and loadfile, for completeness

`dofile("x.lua")` runs a file *now*, every time, ignoring the
cache — right for configuration files and one-off scripts,
wrong for libraries. `loadfile`/`load` compile a file or string
into a function without running it; hosts use them to load user
code as a value they control. Chapter 16 meets the same trio
from the C side.

## Check

- [ ] You can name the four steps of `require`
- [ ] You know why a module ends with `return M`
- [ ] You can find which file a module name resolved to

Next: [Errors](errors.md).
