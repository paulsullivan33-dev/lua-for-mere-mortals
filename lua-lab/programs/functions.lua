-- functions.lua -- multiple returns, varargs, functions as values.
-- Run: lua5.4 functions.lua

-- A function can return several values. minmax returns both extremes.
local function minmax(t)
  local lo, hi = math.huge, -math.huge
  for _, v in ipairs(t) do
    if v < lo then lo = v end
    if v > hi then hi = v end
  end
  return lo, hi
end

local lo, hi = minmax({ 4, 1, 9, 2 })
print("min", lo, "max", hi)

-- Extra values are dropped; missing ones become nil.
local only = minmax({ 4, 1, 9, 2 })
print("kept only the first:", only)

-- Varargs: ... collects any number of arguments; pack them with table.pack.
local function average(...)
  local args = table.pack(...)
  local sum = 0
  for i = 1, args.n do sum = sum + args[i] end
  return sum / args.n
end
print("average of 2, 4, 9:", average(2, 4, 9))

-- Functions are values: store them in tables, pass them around.
local ops = {
  add = function(a, b) return a + b end,
  mul = function(a, b) return a * b end,
}
print("ops.add(3, 4) =", ops.add(3, 4))

local function apply(f, a, b) return f(a, b) end
print("apply(ops.mul, 3, 4) =", apply(ops.mul, 3, 4))

-- Recursion works, and Lua does proper tail calls.
local function fib(n)
  if n < 2 then return n end
  return fib(n - 1) + fib(n - 2)
end
print("fib(15) =", fib(15))

-- The errors-as-values convention: return nil plus a message.
local function divide(a, b)
  if b == 0 then return nil, "division by zero" end
  return a / b
end
local result, err = divide(10, 0)
print("divide(10, 0):", result, err)
