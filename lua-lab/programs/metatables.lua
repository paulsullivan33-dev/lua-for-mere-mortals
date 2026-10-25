-- metatables.lua -- behaviour attached to tables, and an object pattern.
-- Run: lua5.4 metatables.lua

-- A fraction type, built from plain tables plus a metatable.
local Fraction = {}
Fraction.__index = Fraction   -- failed lookups in an instance land here

function Fraction.new(n, d)
  local self = { num = n, den = d }
  return setmetatable(self, Fraction)
end

-- Metamethods: teach Lua what + and tostring mean for fractions.
function Fraction.__add(a, b)
  return Fraction.new(a.num * b.den + b.num * a.den, a.den * b.den)
end

function Fraction.__tostring(f)
  return f.num .. "/" .. f.den
end

function Fraction:reciprocal()          -- the : syntax passes self
  return Fraction.new(self.den, self.num)
end

local half = Fraction.new(1, 2)
local third = Fraction.new(1, 3)
print("half + third =", half + third)          -- 5/6, via __add and __tostring
print("reciprocal of half:", half:reciprocal())
print("getmetatable(half) == Fraction:", getmetatable(half) == Fraction)

-- The object pattern this builds: instances are tables whose missing
-- keys are found in the class table, thanks to __index.
local Account = { balance = 0 }
Account.__index = Account

function Account.new(owner)
  return setmetatable({ owner = owner, balance = 0 }, Account)
end

function Account:deposit(n)
  self.balance = self.balance + n
end

function Account:describe()
  return self.owner .. " has " .. self.balance
end

local acc = Account.new("R. Rivera")
acc:deposit(75)
print(acc:describe())

-- Inheritance, such as it is: a subclass table whose __index is the parent.
local Savings = setmetatable({}, { __index = Account })
Savings.__index = Savings
function Savings.new(owner)
  return setmetatable({ owner = owner, balance = 0, rate = 0.02 }, Savings)
end
function Savings:interest()
  self.balance = self.balance * (1 + self.rate)
end

local sav = Savings.new("J. Chen")
sav:deposit(100)          -- method inherited from Account, found via two hops
sav:interest()
print(sav:describe())     -- 102 after interest
