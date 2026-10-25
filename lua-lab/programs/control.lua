-- control.lua -- if, while, repeat, and the two for loops.
-- Run: lua5.4 control.lua

-- if / elseif / else
local temp = 18
if temp < 10 then
  print("cold")
elseif temp < 22 then
  print("mild")
else
  print("warm")
end

-- Numeric for: start, stop, step. The loop variable is local to the loop.
local total = 0
for i = 1, 10 do total = total + i end
print("1..10 sums to", total)

for i = 10, 0, -3 do io.write(i, " ") end
print("(counting down by 3)")

-- while tests before; repeat tests after, so it always runs once.
local n = 1
while n < 100 do n = n * 2 end
print("doubling past 100 stops at", n)

local tries = 0
repeat
  tries = tries + 1
until tries >= 3
print("repeat ran", tries, "times")

-- break leaves the innermost loop. Lua has no continue;
-- the usual stand-in is a goto (added in 5.2) jumping to a label.
local words = { "oak", "maple", "ash", "birch" }
for _, w in ipairs(words) do
  if #w == 3 then goto skip end  -- pretend short words need no work
  print("long word:", w)
  ::skip::
end

-- Logic operators return values, not just booleans.
local name = nil
print(name or "anonymous")          -- or gives the first truthy value
print(5 > 3 and "yes" or "no")      -- the and/or idiom, an if in one line
