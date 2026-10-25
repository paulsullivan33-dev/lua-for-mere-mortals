# Functions

**Scope:** declaring functions, the two features that define
Lua's style — multiple return values and first-class functions —
plus variable arguments. Output from `lua-lab/programs/functions.lua`
(transcript t04); every example there was run.

## The basics

```lua
local function add(a, b)
  return a + b
end
```

Types come nowhere — neither on parameters nor on the result.
Names are resolved when the function *runs*, not when it's
written. Declare your functions `local`, or they become globals
(the chapter 4 warning applies to functions most of all).

## Multiple return values

A Lua function can return any number of values, and callers pick
up as many as they ask for:

```lua
local lo, hi = minmax({ 4, 1, 9, 2 })
print(lo, hi)              -- 1   9

local only = minmax({ 4, 1, 9, 2 })
print(only)                -- 1: extras are quietly dropped
```

Missing values arrive as nil. A multiple return used in the
middle of an expression list is trimmed to one value; only in
last position does it expand. This is not a footnote — it's how
`return f()` passes everything through while `return f(), 1`
doesn't, and it catches everyone once.

## Variable arguments: ...

```lua
local function average(...)
  local args = table.pack(...)
  local sum = 0
  for i = 1, args.n do sum = sum + args[i] end
  return sum / args.n
end

print(average(2, 4, 9))    -- 5.0
```

`...` is the function's extra arguments. `table.pack` gathers
them into a table *with* an `n` field — necessary because the
arguments may contain nils, which a plain `{...}` constructor
would lose track of. (The `5.0`, not `5`: `/` always yields a
float, chapter 4.)

## Functions are values

A function is a value like any other: store it in a table, pass
it to another function, return it from one (chapter 8 lives on
this):

```lua
local ops = {
  add = function(a, b) return a + b end,
  mul = function(a, b) return a * b end,
}
print(apply(ops.mul, 3, 4))   -- 12
```

The `function name(...)` form is sugar for assigning an anonymous
function to a name; the `local function` form additionally lets
the function call itself — which is how recursion works:

```lua
local function fib(n)
  if n < 2 then return n end
  return fib(n - 1) + fib(n - 2)
end
print(fib(15))    -- 610
```

Lua also performs **proper tail calls**: a call in the exact
form `return f(...)` reuses the current stack frame, so a
tail-recursive loop runs in constant stack. This is a guarantee
of the language, not an optimisation that might happen.

## The error convention: nil plus a message

Lua has exceptions (`error`/`pcall`, chapter 13), but the
everyday convention for *expected* failure is Go-like: return nil
and a message, and let the caller check:

```lua
local function divide(a, b)
  if b == 0 then return nil, "division by zero" end
  return a / b
end

local result, err = divide(10, 0)
print(result, err)    -- nil   division by zero
```

Most of the standard library works this way — `io.open` on a
missing file returns nil plus the reason, rather than throwing.
Which mechanism a given function uses is part of its contract;
chapter 13 shows both and when each fits.

## Method syntax preview

`function t:m(a)` and calls like `obj:m(a)` — the colon defines
and calls a function with an extra first argument, `self`.
That's the whole of Lua's "methods"; chapter 10 builds objects
from it.

## Check

- [ ] You can explain what happens to extra and missing returns
- [ ] You know why `table.pack` records `n`
- [ ] You can say which error style `io.open` uses, and why

Next: [Closures](closures.md).
