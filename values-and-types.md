# Values and Types

**Scope:** the eight types, and the rules that surprise people:
one number type with two personalities, automatic conversion in
arithmetic, and a notion of "false" with only two members. All
output below is from `lua-lab/programs/values.lua` (transcript
t01), run for real.

## Eight types, and that's all

```lua
print("nil      ->", type(nil))
print("boolean  ->", type(true))
print("number   ->", type(42), "and", type(3.5))
print("string   ->", type("hello"))
print("function ->", type(print))
print("table    ->", type({ 10, 20 }))
print("userdata ->", type(io.stdout))
print("thread   ->", type(coroutine.create(function() end)))
```

```text
nil      ->  nil
boolean  ->  boolean
number   ->  number  and  number
string   ->  string
function ->  function
table    ->  table
userdata ->  userdata
thread   ->  thread
```

Variables don't have types in Lua; **values** do. A variable can
hold a number now and a string later, and nothing complains until
an operation doesn't make sense. The types:

| Type | What it is |
| --- | --- |
| nil | The absence of a value — one value, also called nil |
| boolean | `true` and `false` |
| number | All numbers (two subtypes since 5.3, below) |
| string | Text; immutable, and Lua strings are byte strings |
| function | Code as a value |
| table | The one data structure — chapter 6 |
| userdata | A blob owned by a C host (a file handle, a window) |
| thread | A coroutine — chapter 11 |

## Numbers: one type, two subtypes (since 5.3)

Before Lua 5.3 every number was a floating-point double. Since
5.3, a number is either an **integer** (a whole number, 64-bit)
or a **float**, and arithmetic respects the difference:

```text
math.type(42)  =  integer
math.type(3.5) =  float
math.type(3.0) =  float        (the .0 makes it a float)
7 / 2  =  3.5                  (/ always divides fully)
7 // 2 =  3                    (// is integer division, 5.3+)
math.maxinteger + 1 =  -9223372036854775808
```

That last line is worth staring at: integers **wrap around** at
the edge, exactly as in C, silently. Floats don't wrap — they
just lose precision far from zero. LuaJIT and Lua 5.1, having no
integers, blur big whole numbers instead; chapter 15 shows both
behaviours on the same expression.

Mixing subtypes in an operation gives a float, except `//`,
which floors. `%` is the remainder operator and follows the sign
of the divisor, so `-5 % 3` is `1`, not `-2`.

## Strings convert in arithmetic — and only there

```text
"10" + 5 =  15
tonumber('3.5') =  3.5
tostring(42) =  42    (a string now)
```

If a string looks like a number, arithmetic treats it as one.
Comparison does **not**: `"10" == 10` is `false`, always. When
you mean a conversion, say it with `tonumber`/`tostring` rather
than relying on the automatic kind — readers of your code will
thank you. Concatenation is `..`, and it converts numbers to
strings as needed: `"n=" .. 42` is `"n=42"`.

## Truthiness: only two things are false

```text
0 is true in Lua
"" (the empty string) is true in Lua
not nil =  true
```

Only `false` and `nil` are false. **Zero is true. The empty
string is true.** This is the single most common surprise for
people arriving from Python or JavaScript, where both are false.

## nil is an eraser

Assigning nil to a variable, a table field, or an array slot
removes it — there is no separate delete operation. It also
means a table cannot store nil, and an array with a nil in the
middle has a hole whose reported length is up to the
implementation:

```text
#t with a hole =  3    (for { "a", "b", "c" } with t[2] = nil;
                        1 would also have been a legal answer)
```

Chapter 6 returns to holes and how to live with them.

## local, or it didn't happen

One rule belongs in this chapter because every beginner meets it
in week one: assignment to a name that was never declared
creates a **global**, visible everywhere, silently:

```lua
count = 0        -- global. Probably not what you meant.
local count = 0  -- local to this chunk of code. Say this.
```

Globals are how Lua's own built-ins arrive (`print`, `type`),
but for your variables, `local` is the default you want. A whole
class of bugs in [Troubleshooting](troubleshooting.md) is just
this line, forgotten.

## Check

- [ ] You can name the eight types and say which two are false
- [ ] You can predict `math.type(7 // 2)` and why
- [ ] You know why `local` belongs on nearly every declaration

Next: [Control Flow](control-flow.md).
