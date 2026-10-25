# Versions and LuaJIT

**Scope:** what actually differs between Lua 5.1, 5.2, 5.3, and
5.4 — and between all of them and LuaJIT — with the differences
that bite demonstrated on both installed interpreters
(transcripts t00 and t12).

## The shape of the problem

Lua's versions are *mostly* compatible, and the differences are
*mostly* small — which is exactly why they ambush people. Four
series matter:

| Series | The headline change |
| --- | --- |
| 5.1 (2006) | The baseline LuaJIT and many hosts still speak |
| 5.2 (2011) | `goto`, `_ENV` replaces setfenv, bit32 library |
| 5.3 (2015) | **Integers**, native bitwise operators, `utf8` library |
| 5.4 (2020) | Generational GC, `<const>`/`<close>` variable attributes |

Lua's authors number conservatively: a "minor" version can and
does change semantics (the number change in 5.3 is the proof).
Treat code written for another series as *probably* fine and
*verify the sharp edges* — they're the rest of this chapter.

## Integers: the difference you can see

Before 5.3, every number was a double, and whole numbers beyond
2^53 quietly blurred. With integers, 5.4 keeps them exact.
Same expression, both interpreters (t12):

```text
lua5.4:  9007199254740993 == 9007199254740992   ->  false
luajit:  9007199254740993 == 9007199254740992   ->  true
```

And the syntax that goes with integers simply doesn't exist in
5.1-land:

```text
lua5.4:  print(7 // 2, math.type(7 // 2))   ->  3  integer
luajit:  print(7 // 2)                      ->  error: unexpected symbol near '/'
luajit:  print(math.type)                   ->  nil  (there is no subtype to ask about)
```

Bitwise work splits the same way: 5.3+ has operators
(`5 & 3, 5 | 3, 1 << 4` → `1 7 16`), while LuaJIT supplies the
same answers through its `bit` library
(`bit.band(5,3), bit.bor(5,3), bit.lshift(1,4)` → `1 7 16` —
both runs in t12). Lua 5.2 put them in a `bit32` library. Code
that must run everywhere picks the route at runtime or avoids
the feature.

## 5.4's variable attributes

```text
lua5.4:  local x <const> = 5; x = 6   ->  error: attempt to assign to const variable 'x'
luajit:  local x <const> = 5          ->  error: unexpected symbol near '<'
```

`<const>` makes a local read-only; `<close>` runs a `__close`
metamethod when the variable leaves scope (Lua's answer to
"close the file even if this errors"). Both are 5.4-only syntax.

## LuaJIT itself

LuaJIT is an independent, very fast just-in-time implementation
of **Lua 5.1**, with selected later features as extensions
(`goto` works, for instance). It reports `_VERSION` as
"Lua 5.1" (t00) because that's the language it implements —
*plus* its own `jit` table and FFI (a foreign-function interface
for calling C libraries directly, which is LuaJIT's other big
feature and beyond this guide's scope). The practical rules:

- Code written *for* LuaJIT or 5.1 usually runs on 5.4 after
  checking the edges in this chapter — syntax first, numbers
  second.
- Code written *for* 5.4 (this guide) that uses `//`, integers,
  `<const>`, or native bitwise operators **will not run on
  LuaJIT**, and fails at parse time, loudly — the kind failure
  you want.
- Hosts pin the version: Redis, nginx/OpenResty, and many games
  are LuaJIT/5.1 worlds regardless of what your OS installs.
  Ask your host which Lua it carries (`print(_VERSION)`) before
  writing a line.

Some smaller things also moved: `unpack` lives at `table.unpack`
from 5.2 (5.1 has it global; LuaJIT likewise), `string.format`'s
`%d` accepts whole-valued floats since 5.3 (the lab's t12
appendix shows `string.format("%d", 7.0)` → `7` on 5.4), and
`math.random`'s seeding improved in 5.4. The manual's appendix
("Incompatibilities with the Previous Version") for each release
is the authoritative list, and for once it's short enough to
actually read.

## Check

- [ ] You can explain the 2^53 surprise and which side you're on
- [ ] You know why `//` failing under LuaJIT is the good outcome
- [ ] You can ask any Lua host its version in one line

Next: [Embedding Lua in C](embedding-lua.md).
