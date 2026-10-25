-- coroutines.lua -- cooperative multitasking: one runs until it yields.
-- Run: lua5.4 coroutines.lua

-- A producer that yields items one at a time, as an iterator.
local function producer(items)
  return coroutine.wrap(function()
    for _, v in ipairs(items) do
      coroutine.yield(v)
    end
  end)
end

local next_item = producer({ "flour", "sugar", "salt" })
print(next_item())   -- flour
print(next_item())   -- sugar

-- The explicit form shows the states a coroutine passes through.
local co = coroutine.create(function(a, b)
  print("  coroutine got:", a, b)
  local c = coroutine.yield(a + b)   -- hand a+b back, pause here
  print("  coroutine resumed with:", c)
  return c * 2
end)

print("status before:", coroutine.status(co))          -- suspended
local ok, sum = coroutine.resume(co, 3, 4)              -- starts it
print("resume returned:", ok, sum, "| status:", coroutine.status(co))
local ok2, doubled = coroutine.resume(co, 10)           -- yield returns 10
print("resume returned:", ok2, doubled, "| status:", coroutine.status(co))  -- dead

-- A round-robin of small jobs, each yielding after its turn:
-- cooperative scheduling with no threads and no locks.
local function worker(name, steps)
  return coroutine.create(function()
    for i = 1, steps do
      io.write(name, i, " ")
      coroutine.yield()
    end
  end)
end

local jobs = { worker("A", 3), worker("B", 3) }
local alive = true
while alive do
  alive = false
  for _, job in ipairs(jobs) do
    if coroutine.status(job) ~= "dead" then
      coroutine.resume(job)
      alive = true
    end
  end
end
print("(interleaved by hand)")
