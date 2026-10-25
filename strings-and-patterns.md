# Strings and Patterns

**Scope:** the string library's working set, and Lua patterns —
the small matching language that is often mistaken for regular
expressions and isn't. Output from `lua-lab/programs/patterns.lua`
(transcript t06), all run.

## Strings, briefly

Lua strings are immutable byte strings: indexing gives bytes,
`#` counts bytes, and nothing in the standard library knows
about UTF-8 characters as such (libraries and hosts handle
that; Lua 5.4 ships a basic `utf8` library for codepoint work).
The working set:

| Function | What it does |
| --- | --- |
| `string.format(fmt, ...)` | printf-style formatting |
| `string.upper/lower` | case |
| `string.sub(s, i, j)` | substring, 1-based, negative counts from the end |
| `s:rep(n)`, `s .. t` | repeat, concatenate |
| `string.find/match/gmatch/gsub` | the pattern functions, below |

The colon syntax works on strings because strings share a
metatable whose `__index` is the `string` table: `"abc":upper()`
is `string.upper("abc")`.

## The four pattern functions

Patterns are matched by four functions, all in the string
library:

```lua
local line = "order 1234: 3 notebooks at 2.50 each"

string.find(line, "notebooks")   -- 15  23: where the match is
string.match(line, "%d+")        -- "1234": the match itself
```

- `find` returns start and end positions (or nil).
- `match` returns the match — or, with **captures**, the pieces
  in parentheses:

```lua
local qty, item, price = string.match(line, "(%d+) (%a+) at ([%d%.]+)")
-- qty "3", item "notebooks", price "2.50"
```

- `gmatch` returns an iterator over all matches:

```lua
for w in string.gmatch("the cat sat on the mat", "%a+") do ... end
-- the cat sat on the mat, word by word
```

- `gsub` substitutes and also returns the count:

```lua
local cleaned, n = string.gsub("a,b;;c", "[,;]", " ")
-- cleaned "a b  c", n 3
```

## Patterns are not regular expressions

This is the chapter's main event, and each difference below was
run, not asserted.

**1. There is no alternation.** The `|` character means nothing
special in a pattern — it is just a bar:

```text
string.match("cat|dog", "cat|dog")  ->  cat|dog  (the literal text)
string.match("cat", "cat|dog")      ->  nil      (the bar is not "or")
```

**2. Classes are spelled with `%`, not `\`.** `%d` digit, `%a`
letter, `%s` whitespace, `%w` alphanumeric, `%p` punctuation,
`%x` hex digit — and the capital letter negates (`%D` is a
non-digit). Sets work as in regex: `[%d%.]` is "a digit or a
dot". Magic characters are escaped with `%`: `%.` is a real dot.

**3. The quantifiers are `+  *  -  ?`.** The first three will be
familiar; `-` is the one regex users don't have: like `*` but
*lazy* — it matches as little as possible:

```lua
string.match("<one> and <two>", "<.->")   -- "<one>", not the whole line
```

**4. What isn't there.** No `(a|b)` grouping with choice, no
`\d` backslash classes, no counted repeats like `{3}`. Patterns
are deliberately weaker — they cover the common text jobs
(extract a number, split on a class, grab fields) in a few dozen
lines of C. If your problem needs real regex, the honest answer
is a library (LuaRocks has `lrexlib`) or a different tool; the
[Limits](limits.md) chapter says the same.

## A working example: fields from a log line

The lab's one-liner above is the pattern to copy: anchor the
fields you want in captures, let the literal text between them
match itself, and give each field a class tight enough to stop
at the right place. If `string.match` returns nil, the line
wasn't shaped as expected — check for that before using the
pieces.

## Check

- [ ] You can say which function returns positions, which the text
- [ ] You know `%d` in Lua is `\d` in regex — and that `\d` in
      Lua matches a backslash followed by "d"
- [ ] You can explain what `-` does that `*` doesn't

Next: [Metatables and Objects](metatables-and-objects.md).
