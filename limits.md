# Limits

**Scope:** what Lua won't do, stated as plainly as the guide
can — most of it follows from the smallness Lua chose on
purpose.

## The standard library is thin on purpose

No sockets, no threads, no filesystem beyond single files, no
dates beyond `os.date`/`os.time` basics, no JSON. Each absence
is filled by the *host* (which already has these things) or by
LuaRocks libraries (which vary in upkeep, chapter 14). A
standalone Lua installation is a language, not a platform —
arriving expecting Python's batteries is the commonest
disappointment.

## No classes, no types, no safety net

- **No built-in classes or inheritance.** The pattern in
  chapter 10 is a convention; the language won't check it, two
  libraries may do it differently, and error messages point at
  tables and nils, not at "methods".
- **No static checking.** Misspelled field names and forgotten
  `local`s (globals!) fail silently or late. External linters
  (luacheck) exist and serious projects use them; the language
  itself offers nothing.
- **Tables don't enforce their shape.** A "record" accepts any
  key at any time. Large programs feel this and build
  conventions; the language stays out of it.

## Patterns are not regular expressions

No alternation, no counted repeats, no backslash classes
(chapter 9). This is a designed limit — patterns stay small
and predictable — but text work beyond field-grabbing wants a
real regex library or another tool.

## Numbers have edges

Integers exist only from 5.3, wrap silently at their limits
(chapter 4), and are absent entirely under LuaJIT/5.1, where
large whole numbers lose precision past 2^53 (chapter 15, both
shown). Floats print as `5.0`, not `5`, and comparing floats for
equality is the usual trap. Money and IDs need the same care
they need everywhere — more, if your code must run on both
sides of the 5.3 line.

## Arrays start at 1, and arrays have holes

One-based indexing is a permanent culture shock for programmers
from 0-based languages; it also means C-facing code translates
every index at the border. Holes (nil inside an array) make
`#` unreliable by design (chapter 6) — a real sharp edge in a
language otherwise short on them.

## Concurrency is cooperative only

Coroutines don't use multiple cores and don't preempt; the
interpreter itself has no threads. Hosts add their own (Lanes,
or the host's threading with separate `lua_State`s). If you
need parallel computation, Lua is the coordinator in someone
else's design, never the engine.

## Speed, honestly

Lua is quick among scripting languages and LuaJIT is famously
quicker — but this guide measured neither, because its lab was
a shared sandbox, and numbers from a loaded 2-CPU box would be
fiction dressed as data. The claim Lua makes is relative and
well-attested elsewhere; if speed decides your project, measure
on your hardware, with your workload.

Next: [Troubleshooting](troubleshooting.md).
