# Your First Program

**Scope:** the standalone interpreter as a tool — running files,
running one-liners, the interactive prompt, and how a script sees
its arguments. Every command here was run in the lab
(transcript t11).

## A file, run

Save this as `hello.lua`:

```lua
print("Hello from Lua " .. _VERSION)
```

and run it:

```console
$ lua5.4 hello.lua
Hello from Lua Lua 5.4
```

`print` is the built-in that writes values to the terminal,
separating them with tabs. The `..` operator glues strings
together. `_VERSION` is a built-in global string every
interpreter carries.

## One line, no file: -e

```console
$ lua5.4 -e "print(2 + 3)"
5
```

`-e` executes the code you give it. Handy for asking the
interpreter questions — this guide's version checks are mostly
`-e` one-liners.

## Loading a library first: -l

`-l name` requires a library (chapter 12's `require`) *before*
your code runs, and leaves it in a global of the same name:

```console
$ lua5.4 -l geometry -e "print(geometry.circle_area(1))"
3.1415926535898
```

## Interactive mode: -i

`lua5.4 -i` (or just `lua5.4` with no file) opens the prompt,
where each line is run as you type it. Fed from a pipe, the lab
saw:

```console
$ echo "print(6 * 7)" | lua5.4 -i
Lua 5.4.6  Copyright (C) 1994-2023 Lua.org, PUC-Rio
> print(6 * 7)
42
```

At the real prompt you can also type expressions and inspect
values with `= expr` in Lua 5.1-era style — in 5.4, use `print`.
Leave with Ctrl-D (or Ctrl-C twice).

## How a script sees its arguments: the arg table

Everything after the script's name lands in a global table
called `arg`. `arg[0]` is the script itself; negative indexes
hold what came before it (transcript t11, running
`lua-lab/programs/args.lua`):

```console
$ lua5.4 args.lua hello world
arg[0] (the script itself):     args.lua
arg[1], arg[2]:                 hello   world
arg[-1] (what came before):     lua5.4
```

## Two more flags worth knowing

- **`-E`** ignores environment variables (see below), so the
  interpreter behaves exactly as its defaults say. The lab used
  it to show a clean `package.path`.
- **`-v`** prints the version banner and exits — the check from
  chapter 2.

## Environment variables

The interpreter reads `LUA_PATH` (where `require` looks for Lua
files) and `LUA_CPATH` (where it looks for C libraries). In
`LUA_PATH`, a double semicolon `;;` stands for "the default path
goes here" — the lab used it to put the current directory first:

```console
$ LUA_PATH="./?.lua;;" lua5.4 -e "print(package.path)"
./?.lua;/usr/local/share/lua/5.4/?.lua;...
```

Chapter 12 picks this thread up properly.

## Check

- [ ] `lua5.4 yourfile.lua` runs a file end to end
- [ ] You can explain what `-e`, `-l`, and `-i` each do
- [ ] You know arguments arrive in the `arg` table, from `arg[1]`

Next: [Values and Types](values-and-types.md).
