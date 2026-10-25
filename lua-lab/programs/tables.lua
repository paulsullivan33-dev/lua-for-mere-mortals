-- tables.lua -- one structure: arrays, dictionaries, records, all tables.
-- Run: lua5.4 tables.lua

-- An array: values at integer keys 1, 2, 3, ...
local fruit = { "apple", "pear", "plum" }
print("first fruit:", fruit[1])      -- Lua counts from 1
print("how many:", #fruit)           -- the # operator: length of the array part
fruit[#fruit + 1] = "fig"            -- the standard way to append
print("now:", #fruit, fruit[4])

table.insert(fruit, "date")
table.sort(fruit)
print("sorted:", table.concat(fruit, ", "))

-- A dictionary: string keys.
local prices = { apple = 30, pear = 45, plum = 60 }
print("a pear costs", prices.pear)        -- dot sugar for prices["pear"]
print("a plum costs", prices["plum"])
prices.fig = 90                            -- adding a key is just assignment

-- pairs walks every key; ipairs walks 1, 2, 3... until the first nil.
print("-- ipairs (array order):")
for i, v in ipairs(fruit) do print(i, v) end
print("-- pairs (any order):")
for k, v in pairs(prices) do print(k, v) end

-- A record: a table used like a struct.
local book = { title = "The Left Hand of Darkness", author = "Le Guin", year = 1969 }
print(book.title, "by", book.author, "(" .. book.year .. ")")

-- Tables nest, and tables are references, not copies.
local shelf = { book, { title = "The Dispossessed", author = "Le Guin", year = 1974 } }
local same = shelf[1]
same.year = 1970                            -- change it through either name...
print("shelf sees:", shelf[1].year)         -- ...because both name the same table
print("shelf[1] == book:", shelf[1] == book)
