-- patterns.lua -- Lua patterns are their own small language, NOT regex.
-- Run: lua5.4 patterns.lua

local line = "order 1234: 3 notebooks at 2.50 each"

-- find returns where the match starts and ends; match returns the match.
print(string.find(line, "notebooks"))          -- positions
print(string.match(line, "%d+"))               -- %d is "a digit" in Lua patterns

-- Captures: parentheses pick out pieces; match returns them all.
local qty, item, price = string.match(line, "(%d+) (%a+) at ([%d%.]+)")
print("qty", qty, "item", item, "price", price)

-- gmatch iterates over every match.
local sentence = "the cat sat on the mat"
io.write("words: ")
for w in string.gmatch(sentence, "%a+") do io.write(w, " ") end
print()

-- gsub substitutes, and reports how many it made.
local cleaned, n = string.gsub("a,b;;c", "[,;]", " ")
print("cleaned:", cleaned, "replacements:", n)

-- How patterns differ from regular expressions:
-- 1. There is no alternation. The | in a pattern is just a bar character.
print(string.match("cat|dog", "cat|dog"))     -- matches the literal text "cat|dog"
print(string.match("cat", "cat|dog"))          -- nil: the bar is not "or"

-- 2. The magic characters are fewer, and classes use % not backslash.
print(string.match("abc123", "%a+%d+"))       -- letters then digits
print(string.match("a.c", "a%.c"))            -- %. escapes the magic dot

-- 3. Quantifiers: + * - ? -- and - is the lazy one (shortest match).
print(string.match("<one> and <two>", "<.->")) -- "<one>", not the whole string
