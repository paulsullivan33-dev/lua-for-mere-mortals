-- wordcount.lua -- the word-frequency recipe: patterns walk the
-- text, a table counts. Run: lua5.4 wordcount.lua
local text = "the quick brown fox jumps over the lazy dog. " ..
             "The dog was not amused; the fox was quick."

local counts = {}
for word in string.gmatch(string.lower(text), "%a+") do
  counts[word] = (counts[word] or 0) + 1
end

-- Tables don't promise an order, so sort the keys to print.
local words = {}
for w in pairs(counts) do words[#words + 1] = w end
table.sort(words, function(a, b)
  if counts[a] ~= counts[b] then return counts[a] > counts[b] end
  return a < b
end)

for _, w in ipairs(words) do
  print(w, counts[w])
end
