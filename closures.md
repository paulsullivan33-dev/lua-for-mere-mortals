# Closures

**Scope:** functions that keep the local variables of the place
they were written — upvalues — and the three things Lua builds
from them: factories, private state, and iterators. Output from
`lua-lab/programs/closures.lua` (transcript t05).

## The idea

A function written inside another function can use the outer
function's local variables. When the inner function outlives the
outer one — because it was returned, or stored — those variables
stay alive, attached to the function. The variables are called
**upvalues**; the function carrying them is a **closure**.

## A counter factory

```lua
local function new_counter(start)
  local count = start or 0
  return function()
    count = count + 1      -- count is an upvalue
    return count
  end
end

local c1 = new_counter()
local c2 = new_counter(100)
print(c1(), c1(), c1())    -- 1 2 3
print(c2())                -- 101
```

Each call to `new_counter` makes a *new* `count`, so each
returned counter keeps its own. Nothing here is an object or a
class — it's a function plus a variable only it can see. That is
private state, for free.

## Sharing one upvalue between two functions

Return two functions written in the same scope and they share
its locals:

```lua
local function new_account()
  local balance = 0
  local function deposit(n) balance = balance + n; return balance end
  local function withdraw(n) balance = balance - n; return balance end
  return deposit, withdraw
end

local deposit, withdraw = new_account()
deposit(50)
print(withdraw(20))    -- 30
```

The balance cannot be reached from outside at all — not
"conventionally private", actually private. Much of Lua's
module style (chapter 12) is this idea at file scale: locals in
the file, a returned table of functions that close over them.

## Building an iterator

The generic `for` needs a function it can call repeatedly until
it returns nil. A closure is the natural way to write one,
because the closure remembers where it got to:

```lua
local function running_totals(t)
  local i, sum = 0, 0
  return function()
    i = i + 1
    if t[i] == nil then return nil end
    sum = sum + t[i]
    return i, sum
  end
end

for i, s in running_totals({ 5, 10, 15 }) do
  print("after item", i, "the total is", s)
end
```

```text
after item  1  the total is  5
after item  2  the total is  15
after item  3  the total is  30
```

`ipairs` and `pairs` themselves work this way under the hood,
and chapter 11 shows a second iterator technology — coroutines —
for the cases where the producer is easier to write as a
straight-line program with pauses in it.

## One warning: loop variables

Each iteration of a loop creates fresh locals in Lua, so
closures made in a loop body each capture *that* round's
variable — the behaviour programmers from JavaScript's old `var`
days feared is simply correct here. Closures over a variable
declared *outside* the loop share it, as you'd expect.

## Check

- [ ] You can say what an upvalue is without using the word
- [ ] You know why `c1` and `c2` above don't interfere
- [ ] You can sketch an iterator as a closure returning nil at the end

Next: [Strings and Patterns](strings-and-patterns.md).
