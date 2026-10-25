-- values.lua -- the eight types, and how Lua tells them apart.
-- Run: lua5.4 values.lua

-- type() names the type of any value. There are eight types.
-- (Listed with plain print calls: a table cannot hold nil in a list,
-- because nil in a table means "no entry here" — see the end.)
print("nil      ->", type(nil))
print("boolean  ->", type(true))
print("number   ->", type(42), "and", type(3.5))
print("string   ->", type("hello"))
print("function ->", type(print))
print("table    ->", type({ 10, 20 }))
print("userdata ->", type(io.stdout))   -- a file handle is userdata
print("thread   ->", type(coroutine.create(function() end)))

-- Numbers: one type, two subtypes since Lua 5.3.
print("math.type(42)  =", math.type(42))
print("math.type(3.5) =", math.type(3.5))
print("math.type(3.0) =", math.type(3.0))   -- a float, even though it looks whole
print("7 / 2  =", 7 / 2)                   -- / always gives a float
print("7 // 2 =", 7 // 2)                  -- // is integer division (5.3+)
print("math.maxinteger + 1 =", math.maxinteger + 1)  -- integers wrap around

-- Strings convert to numbers in arithmetic, but not the other way round.
print('"10" + 5 =', "10" + 5)
print("tonumber('3.5') =", tonumber("3.5"))
print("tostring(42) =", tostring(42), type(tostring(42)))

-- Truthiness: only false and nil are false. 0 and "" are true.
if 0 then print("0 is true in Lua") end
if "" then print('"" (the empty string) is true in Lua') end
print("not nil =", not nil)

-- nil removes a table entry and ends an array.
local t = { "a", "b", "c" }
t[2] = nil
print("#t with a hole =", #t)  -- with a hole, the reported border is
                               -- not guaranteed: 1 and 3 are both legal
