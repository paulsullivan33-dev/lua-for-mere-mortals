-- geometry.lua -- a module: a file that returns a table of functions.
-- The idiom: build a local table, fill it, return it at the end.

local M = {}

M.pi = 3.141592653589793

function M.circle_area(r)
  return M.pi * r * r
end

function M.circle_circumference(r)
  return 2 * M.pi * r
end

-- Locals that are not in M stay private to the file.
local function square(x) return x * x end

function M.hypotenuse(a, b)
  return math.sqrt(square(a) + square(b))
end

return M
