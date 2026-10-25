# Glossary

**arg** — the global table the standalone interpreter fills
with the command line: `arg[0]` is the script, `arg[1]`, …
its arguments.

**border** — the length `#` reports for a table: the edge
between the array part and the rest. A table with holes has
more than one defensible border.

**capture** — in patterns, a parenthesised piece of the match
that `string.match` returns separately.

**chunk** — Lua's unit of compilation: a file, a string given
to `load`, or one interactive line.

**closure** — a function plus the upvalues it captured from the
scope where it was written.

**coroutine** — a function that can suspend at `yield` and
resume later with its stack intact; Lua's cooperative
multitasking.

**dofile** — run a file immediately, every time, without the
module cache. **loadfile** compiles a file into a function
without running it.

**embedding** — hosting the Lua interpreter inside a bigger
program, which supplies libraries and decides what the script
may touch.

**generic for** — `for k, v in iterator do`, driven by an
iterator function such as `pairs` or `ipairs`.

**global** — a variable not declared `local`; lives in the
environment table and is visible everywhere. Easy to create
by accident.

**hole** — a nil inside the array part of a table, where an
index has no value. Breaks `#` and `ipairs` expectations.

**ipairs / pairs** — the two built-in iterators: `ipairs`
walks integer keys 1, 2, 3… until the first nil; `pairs` walks
every key in no promised order.

**LuaJIT** — the independent just-in-time implementation of
Lua 5.1, plus extensions; very fast, parses a slightly older
language.

**LuaRocks** — the package manager for Lua libraries ("rocks"),
installing per Lua version.

**metatable** — a table attached to another value that answers
behaviour questions: how to index it, add it, print it.

**metamethod** — one of those answers, stored under a key like
`__index`, `__add`, `__tostring`.

**module** — a file (or C library) loaded by `require`, whose
return value — usually a table of functions — is cached in
`package.loaded`.

**nil** — the type, and only value, meaning "nothing here".
Also the eraser: assigning nil removes.

**numeric for** — `for i = start, stop, step do`, counting.

**pattern** — Lua's small text-matching language for
`find`/`match`/`gmatch`/`gsub`. Not a regular expression: no
alternation, classes spelled with `%`.

**pcall / xpcall** — protected calls: run a function and return
success plus results (or failure plus the error) instead of
letting an error escape. `xpcall` runs a handler while the
stack still exists.

**rock** — a package in the LuaRocks ecosystem.

**stack (C API)** — the value stack through which C and Lua
exchange arguments and results when embedding.

**table** — Lua's one data structure: a key–value mapping used
as array, dictionary, record, module, and object.

**upvalue** — a local variable from an enclosing scope that a
closure captures and keeps alive.

**userdata** — a value owned by a C host (a file handle is
one), opaque to Lua itself.

Next: [Writing Criteria](criteria.md).
