# Writing Criteria

Every guide in this repo is written to the same
standard. If you're adding or editing a guide —
human or AI — hold it to these.

1. **Plain words, real ideas.** Simple language,
   never dumbed-down concepts. Explain jargon on
   first use; collect terms in the glossary.
2. **No hype.** No marketing adjectives, no
   "revolutionary," no promises about what
   something will do for the reader.
3. **Honest about limits.** Say what the thing
   *can't* do. State uncertainty instead of
   smoothing it over. Validation notes include
   what remains unverified.
4. **No invented numbers.** Benchmarks, defaults,
   and specs are either measured or qualified with
   "depends on your setup." If it wasn't tested,
   say so.
5. **Checkable.** Commands are meant to be run,
   with "Check:" blocks showing what success looks
   like. Sources are linked, not asserted.
6. **Respect the reader's setup.** Call out
   Windows/Mac/Linux differences. Don't assume a
   GPU, a budget, or prior experience.
7. **Safety isn't skipped.** Real risks get
   stated plainly, not buried.
8. **Scoped.** Each guide says what it covers and
   points elsewhere for the rest. No guide
   pretends to be the whole subject.
9. **Structure over prose.** Tables, before/after
   examples, symptom → fix. Scannable beats essay.

## Verification notes for this guide

Built and verified 2026-10-24/25 against **Lua
5.4.6** (Ubuntu package 5.4.6-3build2) with
**LuaJIT 2.1** (package 2.1.0+git20231223,
language level 5.1) and **LuaRocks 3.8.0**, on a
2-CPU, 7.7 GB sandbox machine running Ubuntu
24.04.

**Primary sources read, not remembered:** the
Lua 5.4 reference manual for the pattern
character classes and quantifiers (chapter 9),
error levels and `xpcall` semantics (chapter 13),
the `require`/`package` search rules (chapter
12), and the version-incompatibility summaries
used in chapter 15; the LuaJIT project's own
documentation for its language level and `bit`
library.

**Ran for real** (programs in
`lua-lab/programs/`, output in
`lua-lab/transcripts/`):

- t00 — versions from all three tools, and
  `_VERSION` from both interpreters: 5.4
  answers "Lua 5.4", LuaJIT answers "Lua 5.1".
- t01 — values: all eight `type()` results;
  `math.type` on integer, float and 3.0;
  `7 / 2` vs `7 // 2`; integer wraparound at
  `math.maxinteger + 1`; string arithmetic
  coercion; 0 and "" truthy; `#` reporting 3
  for an array holed at index 2.
- t02 — tables as array (append, insert,
  sort, concat), dictionary (dot and bracket
  access, `pairs`), and record; mutation
  through an alias proving reference
  semantics; `==` identity.
- t03 — control flow: if/elseif, numeric for
  up and down, while, repeat, goto-as-
  continue over a mixed list, and/or values.
- t04 — functions: multiple returns and
  dropped extras, varargs average via
  `table.pack`, functions stored and passed,
  fib(15) = 610, nil-plus-message division.
- t05 — closures: two independent counters
  (1,2,3 and 101), a shared-upvalue account
  (deposit 50, withdraw 20 → 30), a running-
  totals iterator (5, 15, 30).
- t06 — patterns: find positions, captures
  from a sample line, gmatch iteration, gsub
  with count, the literal `|` (no
  alternation), `%a+%d+`, `%.` escaping, the
  lazy `-` quantifier.
- t07 — metatables: Fraction with `__add`,
  `__tostring`, `__index` and `reciprocal`
  (1/2 + 1/3 prints "5/6"); an Account class;
  a Savings subclass inheriting methods
  through a two-hop `__index` chain,
  finishing at "102.0" after interest.
- t08 — coroutines: wrap-based producer;
  the create/resume/status lifecycle
  (suspended → suspended → dead), values
  exchanged in both directions; a two-worker
  round-robin interleaving A1 B1 A2 B2 A3 B3.
- t09 — modules: `require` of the lab's own
  geometry module, cache identity across two
  requires, `package.searchpath` answering
  `./geometry.lua`.
- t10 — errors: `pcall` for success, a
  non-number, an out-of-range port raised at
  level 2, and a nil-index runtime error;
  `assert` with `io.open`; an `xpcall`
  handler whose returned report contains a
  traceback naming the failing file.
- t11 — the standalone interpreter: `-e`,
  `-l`, `-i` fed from a pipe, `-E` (clean
  package.path), `LUA_PATH` with the `;;`
  default marker; the `arg` table under
  arguments.
- t12 — the interpreters side by side:
  `7 // 2` parses on 5.4, is a syntax error
  on LuaJIT; `math.type` exists on one, is
  nil on the other; `9007199254740993 ==
  9007199254740992` is false with integers,
  true with LuaJIT's doubles; native bitwise
  operators and LuaJIT's `bit` library
  return the same triple (1, 7, 16);
  `<const>` accepted on 5.4, rejected by
  LuaJIT's parser; `string.format("%d", 7.0)`
  prints 7 on 5.4.
- t13/t14 — LuaRocks: penlight 1.15.0
  installed with `--lua-version=5.4
  --local`, pulling luafilesystem 1.9.0,
  which compiled in place; then a program
  using pl.List (sorted, counted, mapped,
  filtered), pl.pretty and pl.tablex ran
  against it.
- t15 — embedding: a C host compiled with
  `gcc` and `pkg-config` flags for lua5.4;
  it registered a C function, ran a Lua
  snippet (sum 1..10), was called back from
  Lua, and read the returned 42 from the
  stack.
- t16/t17 — the recipe programs: a word-
  frequency counter over a fixed paragraph,
  and a Lua settings file loaded with
  `dofile`, validated with `assert`, and
  printed back.

**Errors hit and kept:** the lab's first
values program listed the eight types in a
table beginning with nil, and `ipairs`
stopped before the first entry — nothing
printed at all. The corrected program lists
the types with plain print calls, and the
bug is written up in Troubleshooting as the
canonical hole-in-the-array lesson.

**Documented only, and labelled as such in
the chapters:** installing Lua on Windows
and macOS (routes named, not walked); Lua as
embedded inside its famous hosts (games,
Redis, nginx, routers) — the embedding
chapter itself is verified from the C side,
but no third-party host was run; LuaJIT's
FFI; performance comparisons of any kind —
the sandbox was shared and loaded, so this
guide claims no timings or speeds anywhere;
and the Neighbours chapter, which is labelled
judgement rather than lab work.

**Fixtures:** every program is small and
generic — fruit and prices, two novels by
one author, fractions, a geometry module, a
word-count paragraph, a reading-group
settings file — written for any reader to
reproduce. Nothing in the lab is modelled on
any real person, organisation or event.
