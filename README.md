# Lua for Mere Mortals

A **small language** — deliberately small — that was designed to
live *inside* other programs: configuring them, scripting them,
modifying them. **Lua** is the scripting language inside game
engines, network equipment, media tools, and a long list of
software you may already use without knowing it. This guide
explains how Lua works in those terms: the eight value types, the
one data structure (the table), functions that remember where
they were made, behaviours attached to data through metatables,
cooperative coroutines, the little pattern language that is not
quite regular expressions — and, at the end, how the language
gets embedded into a C program, which is where it came from.

The lab behind this guide ran the real thing: **Lua 5.4.6**, the
version Ubuntu's repositories ship, plus **LuaJIT 2.1** and
**LuaRocks 3.8**, installed with apt on a small Linux machine.
Every claim that can be run was run: a dozen small programs cover
the language feature by feature, all kept in `lua-lab/programs/`
with their output in `lua-lab/transcripts/`. A real library
(Penlight) was installed with LuaRocks and used. A tiny C program
was compiled that hosts the interpreter, calls into Lua, and is
called back. The two interpreters were set side by side so the
guide's version claims — what LuaJIT can't parse, where big
numbers blur — come from the machines, not from memory.

What the lab could not do, it did not fake. Lua on Windows and
macOS, and inside the products that embed it (games, routers,
editors), is taught from the project's own documentation and
labelled as such wherever it appears. Nothing about speed is
claimed anywhere in this guide: the sandbox was shared and busy,
and Lua's reputation for quickness is stated as reputation, not
as a lab result. `criteria.md` keeps the full ledger of what was
run and what was only read.

## What this guide covers

- [**What Lua is**](what-lua-is.md) —
  the mental model: a language built to be
  embedded, why it is so small, and what it
  is not (a big application language, a
  Python rival)
- [**Installing Lua**](installing-lua.md) —
  the interpreter from your package manager,
  LuaJIT alongside it, and LuaRocks for
  libraries
- [**Your first program**](your-first-program.md) —
  the standalone interpreter: scripts, the
  interactive prompt, `-e` and `-l`, and the
  `arg` table
- [**Values and types**](values-and-types.md) —
  eight types, one number type with two
  subtypes, strings that convert, and the
  truth about truthiness
- [**Control flow**](control-flow.md) —
  `if`, `while`, `repeat`, the two `for`
  loops, `break`, and `goto` used sparingly
- [**Tables**](tables.md) —
  the one data structure: arrays,
  dictionaries and records are all the
  same thing wearing different keys
- [**Functions**](functions.md) —
  multiple return values, variable
  arguments, functions as values, and the
  nil-plus-message error convention
- [**Closures**](closures.md) —
  functions that remember: upvalues,
  counter factories, shared state, and
  iterators you build yourself
- [**Strings and patterns**](strings-and-patterns.md) —
  the string library and Lua patterns,
  the small matching language that is
  *not* regular expressions
- [**Metatables and objects**](metatables-and-objects.md) —
  behaviour attached to tables, and the
  class pattern the whole ecosystem
  builds from `__index`
- [**Coroutines**](coroutines.md) —
  cooperative multitasking: functions
  that pause, hand over a value, and
  resume where they left off
- [**Modules**](modules.md) —
  splitting code across files with
  `require`, how the search path works,
  and writing a module of your own
- [**Errors**](errors.md) —
  the two error mechanisms, `pcall` and
  `xpcall`, error levels, and catching a
  traceback for a log file
- [**Libraries and LuaRocks**](libraries-and-luarocks.md) —
  the package manager, installing a real
  library (Penlight), and reading what a
  library gives you that plain Lua doesn't
- [**Versions and LuaJIT**](versions-and-luajit.md) —
  what changed in 5.1–5.4 — integers in
  5.3 above all — and why LuaJIT speaks
  5.1, demonstrated side by side
- [**Embedding Lua in C**](embedding-lua.md) —
  the other direction: a C program that
  hosts the interpreter, runs a script,
  and trades values with it
- [**Recipes**](recipes.md) — a word
  counter, a configuration file that is
  Lua code, a tiny task scheduler, and a
  data file checked by the language itself
- [**The neighbours**](the-neighbours.md) —
  Python, JavaScript, Tcl and the other
  embeddables: what each trades against Lua
- [**Limits**](limits.md) — no classes
  built in, no integer type before 5.3,
  arrays that start at 1, one-based
  everything, stated plainly
- [**Troubleshooting**](troubleshooting.md) —
  the nil that came from nowhere, the
  global you didn't mean to make, patterns
  that aren't regex, and the traps this
  guide's lab fell into so you don't have to
- [**Glossary**](glossary.md) — the terms,
  collected in one place

## What it doesn't cover

Writing the large applications Lua
sometimes hosts — a full game, a window
manager configuration the size of a
codebase — is pointed at, not taught;
this guide covers the language itself.
The C API beyond the one chapter's taste
(linking details, building your own C
modules for Lua) is a book of its own,
and the manual is genuinely good.
Performance tuning and LuaJIT's tracing
internals are likewise named, not explored.

## How to use this guide

Read chapters 1 and 2, install Lua, and
from chapter 3 onward type the programs
in and run them — every load-bearing
example in this guide is a file in
`lua-lab/programs/` whose real output is
kept beside it. Chapters 6 (tables) and 7
(functions) are the load-bearing pair:
almost everything else in the language
is those two ideas combined. Chapter 10
(metatables) is the one to read slowly.
If you arrive with a version question —
*will this 5.1 script run on my 5.4?* —
chapter 15 answers it with the two
interpreters side by side. The lab's
transcripts live in `lua-lab/transcripts/`;
its notes are `examples/lab-notes.txt`.

---

## Part of the series

This guide is one of the [For Mere Mortals](https://paulsullivan33-dev.github.io/mere-mortals/) guides: plain-language guides to the tools programmers and makers use.

Related guides:

- [Python for Mere Mortals](https://paulsullivan33-dev.github.io/python-for-mere-mortals/)
- [C for Mere Mortals](https://paulsullivan33-dev.github.io/c-for-mere-mortals/)
- [MicroPython for Mere Mortals](https://paulsullivan33-dev.github.io/micropython-for-mere-mortals/)

## License

The writing in this guide is licensed under [CC BY 4.0](https://github.com/paulsullivan33-dev/lua-for-mere-mortals/blob/main/LICENSE). Code examples and lab scripts are licensed under the [MIT License](https://github.com/paulsullivan33-dev/lua-for-mere-mortals/blob/main/LICENSE-CODE).
