# Troubleshooting

**Scope:** the failures every Lua beginner meets, as
symptom → cause → fix. Several are the lab's own.

## "attempt to index a nil value"

The most common Lua error in the world. Something you believed
was a table (or a table's field) was nil, and you indexed it
anyway. Causes, in order of likelihood: a multiple return whose
second value was an error message you didn't check
(`local f = io.open(...)` without looking), a misspelled key
(`book.titel`), a `require` that loaded a module returning
nothing you expected, or a method called with `.` where `:`
belonged (so `self` was the first *argument* instead).

## A variable that is nil "for no reason"

You read it in a scope where the `local` isn't visible, or the
`local` declaration came *after* the use, or — the classic —
the declaration is inside a block that ended. Lua resolves
locals by position in the file, not by name magic. And the
mirror-image bug: you *set* a variable without `local` and
silently created a global, so two parts of the program are
updating different variables with the same name. Print
`_G.name` when you're confused; if it's there, `local` went
missing somewhere.

## "module 'x' not found"

`require` searched `package.path` and found nothing. Print the
path (`lua5.4 -e 'print(package.path)'`) and ask three
questions: is the working directory where you think (the
default path starts `./?.lua`), is the file named exactly
`x.lua` (dotted names become folders: `a.b` → `a/b.lua`), and —
if a LuaRocks library — did this shell run the
`eval "$(luarocks path)"` step (chapter 14)?

## The loop that stops early, or the length that's wrong

A hole: nil inside your array. `ipairs` stops at it, `#` may
report either side of it. Print the table (Penlight's
`pl.pretty`, or a `pairs` loop) and look for the gap. Fixes:
keep the length yourself (`table.pack`'s `n`), or don't store
nils in arrays.

## The pattern that doesn't match

You're thinking in regex. Check, in order: did you write `\d`
(regex) instead of `%d` (Lua)? Did you rely on `|` meaning
"or" (it means a literal bar)? Did a `.` eat a character you
meant literally (escape it: `%.`)? Is `*` greedily eating past
your field (try the lazy `-`)? Chapter 9's side-by-side is the
reference; transcript t06 shows each failure as output.

## Numbers behaving strangely

- `5.0` where you wanted `5`: it's a float — `/` made it one,
  or the literal had a `.0`. Use `math.tointeger` or format
  with `%d` (whole-valued floats format as integers).
- Huge counts that stop changing: you're on LuaJIT or 5.1 and
  past 2^53 (chapter 15). If exact big integers matter, that's
  a 5.3+ interpreter or a library's job.
- `==` says equal when it shouldn't, or not when it should:
  tables compare by identity, floats by exact value, and
  `"10" == 10` is always false. Pick the comparison that
  matches the type.

## Code that ran yesterday, broken today under a different lua

Version skew: the other interpreter is LuaJIT or a different
series. Ask both `print(_VERSION)` and re-check chapter 15's
edges — `//`, `<const>`, bitwise operators, and `math.type`
are the usual parse-time landmines, and failing at parse time
(as they do) is the friendly outcome.

## "attempt to call a nil value (field 'x')"

The function version of the nil bug: the field doesn't exist
on that table. With objects (chapter 10), suspect the metatable
chain — was the instance actually given its metatable, and was
`__index` set on the *class* table itself, not only used to
create instances?

## The lab's own

This guide's values program originally built its type list as
a table beginning with nil — and printed nothing at all,
because `ipairs` stops at the first nil, which was entry one.
It is the perfect beginner bug (a constructor quietly refusing
to be a list), kept here rather than hidden: transcript t01 is
the corrected program, and the fix was to stop asking a table
to hold nothing at position 1.

Next: [Glossary](glossary.md).
