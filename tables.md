# Tables

**Scope:** the one data structure. Arrays, dictionaries, and
records are all tables; this chapter shows each shape and the
handful of operations that matter. Output from
`lua-lab/programs/tables.lua` (transcript t02).

## One structure to learn

A table is a set of key–value pairs. *Any* value except nil can
be a key; any value except nil can be stored. There is no
separate list type, map type, or object type — the table does
all three jobs, and most of Lua is learning to see which job a
given table is doing.

## As an array: keys 1, 2, 3, …

```lua
local fruit = { "apple", "pear", "plum" }
print(fruit[1])            -- apple: Lua counts from 1
print(#fruit)              -- 3: the length operator
fruit[#fruit + 1] = "fig"  -- the standard append
```

```text
first fruit:  apple
how many:     3
now:          4   fig
```

The table library adds the rest (`lua-lab/programs/tables.lua`
shows each):

```lua
table.insert(fruit, "date")
table.sort(fruit)
print(table.concat(fruit, ", "))   -- apple, date, fig, pear, plum
```

`ipairs` walks an array in order, stopping at the first nil:

```lua
for i, v in ipairs(fruit) do print(i, v) end
```

**Holes.** An array with a nil in the middle is a table with a
*border problem*: `#` may report either side of the hole, and
`ipairs` stops at it. The rule of thumb is plain — if it has
holes, it isn't an array any more; either keep a separate count
(`table.pack` stores one in its `n` field) or use a different
shape.

## As a dictionary: string keys

```lua
local prices = { apple = 30, pear = 45, plum = 60 }
print(prices.pear)         -- 45: dot sugar for prices["pear"]
print(prices["plum"])      -- 60
prices.fig = 90            -- adding a key is just assignment
```

`pairs` walks **every** key, in no promised order:

```text
-- pairs (any order):
apple  30
pear   45
fig    90
plum   60
```

Dot access works only when the key is a string that looks like
a name; anything else needs brackets: `prices["in season"]`.

## As a record

```lua
local book = { title = "The Left Hand of Darkness",
               author = "Le Guin", year = 1969 }
print(book.title, "by", book.author)
```

This is the shape objects are built from in chapter 10: named
fields, read with dots. There is no way to declare "a book has
exactly these fields" — Lua trusts you, and a missing field is
just nil, not an error. That looseness is the price of having
one structure; [Limits](limits.md) counts it.

## Tables are references

```text
shelf sees:        1970
shelf[1] == book:  true
```

Assigning a table copies the *reference*, never the table. Two
names, one table: change it through either and both see it. To
copy the contents you must do it on purpose (a loop, or a
library function like Penlight's `tablex.deepcopy`, chapter 14).
`==` compares identity: two tables with identical contents are
not equal unless they are the same table.

## Constructors, briefly

`{ ... }` builds a table in one expression. Entries can be
positional (array style), `key = value`, or `[expression] = value`,
mixed freely:

```lua
local mixed = { "first", name = "second kind", [100] = "far out" }
```

Constructors are how most tables are born; nested constructors
(`{ { ... }, { ... } }`) are Lua's native way to write structured
data — which is why Lua configuration files and data files are
just Lua code that returns a table.

## Check

- [ ] You can say what `#`, `ipairs`, and `pairs` each promise
- [ ] You know `t.x` and `t["x"]` are the same lookup
- [ ] You can explain why `same.year = 1970` changed `shelf`

Next: [Functions](functions.md).
