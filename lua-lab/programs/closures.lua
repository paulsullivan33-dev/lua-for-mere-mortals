-- closures.lua -- functions that remember the variables they were born with.
-- Run: lua5.4 closures.lua

-- A counter factory: each call to new_counter makes an independent counter.
local function new_counter(start)
  local count = start or 0        -- an "upvalue": captured by the inner function
  return function()
    count = count + 1
    return count
  end
end

local c1 = new_counter()
local c2 = new_counter(100)
print(c1(), c1(), c1())   -- 1 2 3
print(c2())               -- 101: c2 has its own count

-- Two closures can share one upvalue: a little bank account.
local function new_account()
  local balance = 0
  local function deposit(n) balance = balance + n; return balance end
  local function withdraw(n) balance = balance - n; return balance end
  return deposit, withdraw      -- both close over the same balance
end

local deposit, withdraw = new_account()
deposit(50)
print("after deposit 50, withdraw 20:", withdraw(20))

-- A closure makes a custom iterator for the generic for.
-- This one yields the running totals of a list.
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
