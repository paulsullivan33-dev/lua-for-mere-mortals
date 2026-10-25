# Coroutines

**Scope:** functions that can pause in the middle, hand a value
to their resumer, and later continue exactly where they stopped.
Output from `lua-lab/programs/coroutines.lua` (transcript t08).

## The idea

A coroutine is a function with a pause button. It runs when
*resumed*, and inside it, `coroutine.yield` suspends it and
returns values to the resumer. The next `resume` picks up where
the yield left off — locals intact, stack intact. Only one
coroutine runs at a time and control passes only at yields:
**cooperative** multitasking, with no preemption, no threads,
and no locks.

## Coroutines as iterators

The friendliest use: a producer written as straight-line code
that yields each item. `coroutine.wrap` turns a coroutine into a
plain function you call for the next item:

```lua
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
```

Compare chapter 8's closure iterator: same shape for the caller,
but the producer here doesn't have to be contorted into
"return one thing per call" form — it just runs, yielding as it
goes. Producers that walk trees, parse streams, or generate
sequences read far more naturally written this way.

## The explicit machinery

`create` makes a coroutine without starting it; `resume` runs
it; `status` reports where it stands. The lab traced all of it:

```text
status before:  suspended
  coroutine got:  3  4
resume returned:  true  7   | status:  suspended  (yielded a+b)
  coroutine resumed with:  10                     (yield's return)
resume returned:  true  20  | status:  dead
```

Read the mechanics off the trace:

- `resume` returns `true` plus whatever the coroutine yielded
  (or returned, at the end).
- Values passed to `resume` come back *as the return values of
  the pending `yield`* — the two sides are having a conversation.
- States: `suspended` (not started, or waiting at a yield),
  `running`, `dead` (finished or failed — and dead is final).
- An error inside a coroutine comes back as `false` plus the
  message from `resume` — like `pcall` (chapter 13), it doesn't
  throw through you. (`wrap` differs here: it re-throws. That
  asymmetry is a known wart; pick one style per program.)

## A toy scheduler

Because yields are voluntary and explicit, a few lines make a
round-robin scheduler — the lab interleaved two workers:

```text
A1 B1 A2 B2 A3 B3 (interleaved by hand)
```

Real Lua programs scale this idea up into the event loops and
task systems of their hosts: game update loops, network servers
in OpenResty, and generator pipelines are all this shape with
better tailoring.

## When not to reach for them

Coroutines don't make anything faster and can't use a second
core — they organise *waiting and producing*, not computing.
Blocking calls inside a coroutine block the whole program just
as surely as anywhere else; hosts that need non-blocking I/O
supply coroutines-aware libraries. And a suspended coroutine's
stack can confuse debugging: keep them shallow and named.

## Check

- [ ] You can say what `yield` returns when the coroutine resumes
- [ ] You know the three states and which transitions are one-way
- [ ] You can explain why `wrap` feels different from `resume`

Next: [Modules](modules.md).
