# Recipes

**Scope:** small complete programs that combine the chapters.
Each was run in the lab; transcripts are named where the
program lives.

## Count the words in a text

*Uses: patterns (9), tables (6), sorting with a function (7).*
`lua-lab/programs/wordcount.lua`, transcript t16.

```lua
local counts = {}
for word in string.gmatch(string.lower(text), "%a+") do
  counts[word] = (counts[word] or 0) + 1
end
```

The idiom to steal is `(counts[word] or 0) + 1`: a missing key
reads as nil, `or` substitutes 0. Then sort the keys by count
(tables promise no order), tie-broken alphabetically:

```text
the    4
dog    2
fox    2
quick  2
was    2
...
```

Case-folding with `string.lower` first is what merged "The"
into "the". Deciding what a "word" is — here, `%a+`, runs of
letters — is a patterns question; apostrophes and hyphens are
where real texts argue back.

## A configuration file that is Lua

*Uses: dofile (12), assert (13).* `settings.lua` +
`read-settings.lua`, transcript t17.

Because constructors build nested tables in one expression, a
Lua file that returns a table *is* a data format — comments,
trailing commas, and computed values included:

```lua
return {
  title = "Reading Group Notes",
  page_size = "A5",
  margins_mm = 15,
  contributors = { "Ana", "Ben", "Cleo" },
}
```

The host loads and then **validates**, because code is code:

```lua
local cfg = dofile("settings.lua")
assert(cfg.page_size == "A4" or cfg.page_size == "A5",
       "page_size must be A4 or A5")
```

This is Lua's most common real job, and the validation step is
the part tutorials skip. A stronger version loads the file
with a restricted environment (no `os`, no `io`) via `loadfile`'s
environment argument — worth doing before you load files other
people wrote.

## A round-robin task list

*Uses: coroutines (11).* Chapter 11's scheduler, verbatim in
spirit: keep a list of coroutines, resume each unfinished one
in turn until all report `dead`. The pattern scales from three
toy workers to a host's whole frame loop, and the code that
schedules never needs to know what a "task" is inside.

## Split a line of fields

*Uses: patterns (9) or a library (14).*

For comma-separated text without quoting rules,
`string.gmatch(line .. ",", "(.-),")` yields each field — the
lazy `-` quantifier doing the work. The moment fields can
*contain* quoted commas, stop: that's a parser, not a pattern,
and a library (or twenty honest lines) is the right tool. The
[Limits](limits.md) chapter holds this line firmly.

## Check

- [ ] Each recipe names the chapters it combines — you could
      rebuild each one from those chapters alone

Next: [The Neighbours](the-neighbours.md).
