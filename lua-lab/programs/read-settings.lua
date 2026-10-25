-- read-settings.lua -- loading and checking the settings file.
-- Run: lua5.4 read-settings.lua
local cfg = dofile("settings.lua")

-- The host validates: the file is code, so trust nothing.
assert(type(cfg.title) == "string", "title must be a string")
assert(cfg.page_size == "A4" or cfg.page_size == "A5",
       "page_size must be A4 or A5")
assert(type(cfg.margins_mm) == "number" and cfg.margins_mm >= 0,
       "margins_mm must be a non-negative number")

print("title:", cfg.title)
print("page:", cfg.page_size, "margins:", cfg.margins_mm)
print("contributors:", table.concat(cfg.contributors, ", "))
print("settings accepted")
