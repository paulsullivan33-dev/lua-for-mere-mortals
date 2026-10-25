-- errors.lua -- raising errors and catching them with pcall.
-- Run: lua5.4 errors.lua

-- The everyday convention: return nil plus a message (see functions.lua).
-- The other mechanism: throw with error(), catch with pcall.

local function parse_port(text)
  local n = tonumber(text)
  if n == nil then
    error("not a number: " .. tostring(text))       -- throws
  end
  if n < 1 or n > 65535 then
    error("port out of range: " .. n, 2)            -- level 2 blames the caller
  end
  return n
end

-- pcall returns true plus the results, or false plus the error object.
local ok, result = pcall(parse_port, "8080")
print("pcall('8080'):", ok, result)

local ok2, err = pcall(parse_port, "banana")
print("pcall('banana'):", ok2, err)

local ok3, err3 = pcall(parse_port, "99999")
print("pcall('99999'):", ok3, err3)

-- Runtime errors are catchable the same way.
local ok4, err4 = pcall(function() return ({})[1].field end)
print("pcall(index nil):", ok4, err4)

-- assert is error() with the condition built in.
local f = assert(io.open("geometry.lua", "r"))  -- would throw if missing
print("assert + io.open opened a file of type:", type(f))
f:close()

-- xpcall takes a handler, which runs while the stack is still there:
-- the place to capture a traceback for a log file.
local function handler(e)
  return "handled: " .. e .. "\n" .. debug.traceback("", 2)
end
local ok5, report = xpcall(function() error("the kettle boiled dry") end, handler)
print("xpcall caught ok =", ok5)
print(report:match("handled: [^\n]+"))   -- first line of the report
print("traceback mentions this file:", report:find("errors%.lua") ~= nil)
