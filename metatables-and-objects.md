# Metatables and Objects

**Scope:** the mechanism under most of Lua's power — a table that
describes how another table behaves — and the object pattern the
whole ecosystem builds on it. Output from
`lua-lab/programs/metatables.lua` (transcript t07), all run.

## The idea

Every table can have a **metatable**: another table, attached
with `setmetatable`, whose special keys (always starting with
`__`) answer questions the plain table can't:

- What happens when I index a key this table doesn't have?
  → `__index`
- What do `+`, `==`, `#` mean for this table? → `__add`,
  `__eq`, `__len`, and friends, called **metamethods**
- What does `tostring` show? → `__tostring`
- What happens when I call it like a function? → `__call`

This is Lua's whole object system, operator system, and
class system, in one mechanism.

## Teaching arithmetic to a table

The lab's fractions:

```lua
local Fraction = {}
Fraction.__index = Fraction

function Fraction.new(n, d)
  return setmetatable({ num = n, den = d }, Fraction)
end

function Fraction.__add(a, b)
  return Fraction.new(a.num * b.den + b.num * a.den, a.den * b.den)
end

function Fraction.__tostring(f)
  return f.num .. "/" .. f.den
end

local half, third = Fraction.new(1, 2), Fraction.new(1, 3)
print(half + third)     -- 5/6
```

`half + third` works because both operands share a metatable
with an `__add`; `print` shows `5/6` because `__tostring` says
so. `getmetatable(half) == Fraction` is `true`: the metatable
*is* the Fraction table, doubling as the method shelf.

## __index and the object pattern

Look up a missing key in a table and Lua consults `__index`:
if it's a table, the lookup continues there. That one rule is
the object pattern:

```lua
local Account = { balance = 0 }
Account.__index = Account

function Account.new(owner)
  return setmetatable({ owner = owner, balance = 0 }, Account)
end

function Account:deposit(n)          -- : puts self in as arg 1
  self.balance = self.balance + n
end

local acc = Account.new("R. Rivera")
acc:deposit(75)
```

An instance is a plain table holding its own fields. A method
call `acc:deposit(75)` finds no `deposit` in `acc`, follows
`__index` to `Account`, finds the function there, and calls it
with `acc` as `self`. No classes, no keywords — a convention,
held by one metamethod.

## Inheritance, such as it is

Give a new class-table a metatable whose `__index` is the parent
class, and lookups chain: instance → Savings → Account:

```lua
local Savings = setmetatable({}, { __index = Account })
Savings.__index = Savings
-- Savings.new sets rate = 0.02 and adds an interest() method
local sav = Savings.new("J. Chen")
sav:deposit(100)     -- Account's method, found two hops away
sav:interest()
print(sav:describe())  -- "J. Chen has 102.0"
```

(The `102.0` is a float because the 0.02 rate made it one —
chapter 4's rule, visible in the wild.) This chaining is as much
inheritance as Lua has or needs for most programs; multiple
inheritance and mixins are done by copying fields or chaining
differently, by hand, on purpose.

## The honest assessment

What metatables buy: operators that work on your types, objects
without ceremony, and control over what a table *means*. What
they cost: every design is home-made. Two Lua libraries may
build objects two different ways, method lookup failures say
"attempt to index nil" rather than "no such method", and
nothing stops a program from redefining behaviour you relied
on. Libraries like Penlight (chapter 14) exist partly to give
everyone the *same* class pattern.

Other metamethods worth knowing exist: `__index` can also be a
*function* (compute the value on demand), `__newindex` intercepts
writes to missing keys, `__len` defines `#`, `__call` makes a
table callable, and `__pairs` controls iteration.

## Check

- [ ] You can trace `acc:deposit(75)` through the `__index` chain
- [ ] You know what `:` adds at a definition and at a call
- [ ] You can name the metamethods behind `+`, `tostring`, and `#`

Next: [Coroutines](coroutines.md).
