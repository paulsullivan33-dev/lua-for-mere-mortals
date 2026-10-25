-- penlight-demo.lua -- using a real library installed with LuaRocks.
-- Set up the paths first (luarocks path prints them):
--   eval "$(luarocks --lua-version=5.4 path)"
-- Run: lua5.4 penlight-demo.lua

local List = require("pl.List")
local pretty = require("pl.pretty")
local tablex = require("pl.tablex")

-- pl.List: a table with methods, built on Lua's plain tables.
local scores = List { 72, 85, 91, 85, 64 }
print("scores:", scores:join(", "))
print("sorted copy:", (scores:sorted()):join(", "))
print("count of 85s:", scores:count(85))
print("mapped (+5):", (scores:map(function(x) return x + 5 end)):join(", "))
print("filtered (>= 80):", (scores:filter(function(x) return x >= 80 end)):join(", "))

-- pl.pretty: readable printing of nested tables.
local record = { name = "field notes", tags = { "work", "draft" }, pages = 12 }
print("pretty record:")
print(pretty.write(record))

-- pl.tablex: the operations plain Lua makes you write by hand.
local a = { x = 1, y = 2 }
local b = { y = 20, z = 30 }
print("tablex.merge (b wins):", pretty.write(tablex.merge(a, b, true)))
print("tablex.keys of a:", table.concat(tablex.keys(a), ", "))
