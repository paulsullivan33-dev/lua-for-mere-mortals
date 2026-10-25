# Control Flow

**Scope:** choosing and repeating — `if`, the two pre/post-test
loops, both `for` loops, `break`, and the considered use of
`goto`. Output from `lua-lab/programs/control.lua` (transcript
t03).

## Choosing: if, elseif, else

```lua
local temp = 18
if temp < 10 then
  print("cold")
elseif temp < 22 then
  print("mild")     -- this one ran
else
  print("warm")
end
```

Note `elseif` is one word, and every `if` ends with `end`.
Comparisons are `==`, `~=`, `<`, `>`, `<=`, `>=` — the
not-equal operator is `~=` (a tilde), not `!=`. Values of
different types are never equal (`"10" == 10` is false), and
`==` on tables compares identity, not contents.

## The logic operators return values

`and` and `or` don't just test — they hand back one of their
operands, and Lua code leans on that:

```text
name or "anonymous"        ->  anonymous   (when name is nil)
5 > 3 and "yes" or "no"    ->  yes
```

The second line is the famous and/or idiom: a one-line
if-then-else. It has one sharp edge — it misfires if the "then"
value itself is `false` or `nil` — so use it for values that
can't be.

## Looping: while and repeat

```lua
local n = 1
while n < 100 do n = n * 2 end
print(n)        -- 128: tested before each round

local tries = 0
repeat
  tries = tries + 1
until tries >= 3
print(tries)    -- 3: repeat tests after, so it runs at least once
```

`repeat ... until` is Lua's do-while: the body runs once before
the condition is ever asked.

## The numeric for

```lua
local total = 0
for i = 1, 10 do total = total + i end
print(total)                    -- 55

for i = 10, 0, -3 do io.write(i, " ") end
-- 10 7 4 1   (start, stop, step)
```

The three numbers are start, stop, step (step defaults to 1).
The loop variable is **local to the loop** and read-only in
effect: assigning to it inside the body does not change the
sequence. The limits are evaluated once, before the loop starts.

## The generic for

`for k, v in pairs(t)` and `for i, v in ipairs(t)` walk a table
with an *iterator* — chapter 6 covers the two iterators and
chapter 8 shows how to write your own. It is the loop you will
use most.

## Leaving early: break, and goto

`break` leaves the innermost loop. There is deliberately no
`continue`. The sanctioned stand-in, since 5.2, is `goto` with a
label at the loop's end — the lab's example skips short words:

```lua
for _, w in ipairs({ "oak", "maple", "ash", "birch" }) do
  if #w == 3 then goto skip end
  print("long word:", w)
  ::skip::
end
-- long word: maple
-- long word: birch
```

`goto` exists in Lua largely for this and for one or two other
named situations (retrying an operation is the classic). It is
not a general program-structuring tool, and the label must sit
at the end of a block — Lua restricts jumps so the worst old
habits don't compile.

## Check

- [ ] You know `~=` is not-equal and `..` is concatenate
- [ ] You can say when `repeat` runs its body and `while` doesn't
- [ ] You can predict what `x or "default"` gives for x = 0
      (answer: 0 — zero is true in Lua)

Next: [Tables](tables.md).
