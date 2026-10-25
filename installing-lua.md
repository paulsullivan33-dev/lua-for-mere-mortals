# Installing Lua

**Scope:** getting the standalone interpreter, LuaJIT, and the
LuaRocks package manager onto a machine, and checking each one.
The lab installed all three from Ubuntu's repositories with apt;
the other platforms' routes are labelled as documented.

## On Linux: your package manager

On Debian and Ubuntu:

```sh
sudo apt install lua5.4 luajit luarocks
```

That one line is the whole lab install. What it gives you:

| Package | What it is |
| --- | --- |
| `lua5.4` | The standalone interpreter, `lua5.4` |
| `luajit` | The just-in-time compiler's interpreter, `luajit` |
| `luarocks` | The package manager for Lua libraries |

Other distributions carry the same three under the same or
nearby names (Fedora: `lua`, `luajit`, `luarocks`; Arch: `lua`,
`luajit`, `luarocks`).

One wrinkle worth knowing: many systems also have a plain `lua`
command, but which version it points at varies by distribution
and by what else is installed. This guide always calls `lua5.4`
by its full name, and you should too when it matters.

## Check

```console
$ lua5.4 -v
Lua 5.4.6  Copyright (C) 1994-2023 Lua.org, PUC-Rio

$ luajit -v
LuaJIT 2.1.1703358377 -- Copyright (C) 2005-2023 Mike Pall. https://luajit.org/

$ luarocks --version
/usr/bin/luarocks 3.8.0
LuaRocks main command-line interface
```

(Transcript t00.) Note the second check already teaches you
something: ask LuaJIT what language it speaks and it answers
"Lua 5.1":

```console
$ luajit -e "print(_VERSION); print(jit.version)"
Lua 5.1
LuaJIT 2.1.1703358377
```

That gap between the two interpreters is real and matters;
[Versions and LuaJIT](versions-and-luajit.md) is devoted to it.

## For embedding later: the development package

If you plan to follow [chapter 16](embedding-lua.md) and host
Lua inside a C program, add the headers and library:

```sh
sudo apt install liblua5.4-dev gcc pkg-config
```

The lab did, and chapter 16's C program compiled cleanly against
them.

## On Windows and macOS (documented, not lab-verified)

Lua is distributed as source from lua.org; most people don't
build it themselves.

- **Windows:** the LuaBinaries project publishes ready-made
  builds of the interpreter and libraries. LuaRocks offers a
  Windows installer that bundles its own Lua.
- **macOS:** with Homebrew, `brew install lua luajit luarocks`
  gives the same trio as the apt line above.

The language itself is identical across platforms — it is the
same ANSI C source — so everything from chapter 3 onward applies
unchanged once an interpreter answers `-v`.

## A note on versions you'll meet in the wild

Lua 5.4 is the current series this guide teaches. You will also
meet 5.1 (kept alive by LuaJIT and by long-lived hosts), 5.3
(where integers arrived), and occasionally 5.2. Most code in
this guide runs on all four; every place where it wouldn't is
called out, and chapter 15 shows the actual differences on the
actual interpreters.

Next: [Your First Program](your-first-program.md).
