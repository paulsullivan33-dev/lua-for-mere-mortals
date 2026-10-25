-- modules.lua -- using require; run from the programs/ directory:
--   cd lua-lab/programs && lua5.4 modules.lua

-- require searches package.path, loads the file once, and caches the
-- value it returns in package.loaded.
local geometry = require("geometry")

print("area of r=3:", geometry.circle_area(3))
print("circumference of r=3:", geometry.circle_circumference(3))
print("hypotenuse 3-4:", geometry.hypotenuse(3, 4))

local again = require("geometry")
print("second require is the same table:", again == geometry)
print("module came from:", package.searchpath("geometry", package.path))

-- The standard library is also a set of tables of functions.
print("string.upper:", string.upper("shouted quietly"))
print("table.concat:", table.concat({ "a", "b", "c" }, "-"))
print("os.date:", os.date("%Y-%m-%d"))
