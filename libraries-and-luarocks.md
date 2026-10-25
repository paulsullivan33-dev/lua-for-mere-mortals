# Libraries and LuaRocks

**Scope:** Lua's package manager — finding, installing, and
using third-party libraries — with Penlight installed and used
for real. Transcripts t13 (the install) and t14 (the program).

## Why a package manager at all

Lua ships a deliberately thin standard library. Everything
else — data structures, file utilities, networking, JSON, test
frameworks — lives in the ecosystem as **rocks**: packages
managed by **LuaRocks**, installable per-user or per-project,
for a chosen Lua version.

```console
$ luarocks --version
/usr/bin/luarocks 3.8.0
```

Two flags matter from the start. `--lua-version=5.4` chooses
which Lua the rock is for (a machine can have several, and rocks
are version-specific). `--local` installs into `~/.luarocks`
instead of system-wide — no root, and what you installed is
yours to delete.

## Installing a real library

The lab installed **Penlight**, the ecosystem's standard
utility library:

```console
$ luarocks --lua-version=5.4 install --local penlight
...
penlight 1.15.0-1 is now installed in /home/hatch/.luarocks (license: MIT/X11)

$ luarocks --lua-version=5.4 list --local

Rocks installed for Lua 5.4 in /home/hatch/.luarocks
----------------------------------------------------

luafilesystem
   1.9.0-1 (installed) - /home/hatch/.luarocks/lib/luarocks/rocks-5.4

penlight
   1.15.0-1 (installed) - /home/hatch/.luarocks/lib/luarocks/rocks-5.4
```

Two honest observations from that transcript. First, Penlight
itself is pure Lua, but it declared a dependency —
**luafilesystem**, a small *C* module — which LuaRocks
downloaded and compiled on the spot. That worked because a C
compiler and the Lua headers (chapter 2's `liblua5.4-dev`) were
installed; on a machine without them, rocks with C parts fail
at this step. Second, versions: Penlight 1.15.0, recorded here
because "install penlight" is a moving target and this guide
pins its claims to the run it made.

## Making the interpreter find them

`--local` rocks live outside the default `package.path`. The
bridge is LuaRocks' own path command:

```console
$ eval "$(luarocks --lua-version=5.4 path)"
```

That sets `LUA_PATH` and `LUA_CPATH` to include the local tree.
(Projects typically generate this once, or use
`luarocks path` output in a wrapper script. Inside a LuaRocks-
managed run, `luarocks` can also execute a script with the
environment set.)

## Using it: what a library buys you

`lua-lab/programs/penlight-demo.lua` (transcript t14) used three
pieces. `pl.List` — a table with methods, built on chapter 10's
exact pattern:

```text
scores:         72, 85, 91, 85, 64
sorted copy:    64, 72, 85, 85, 91
count of 85s:   2
mapped (+5):    77, 90, 96, 90, 69
filtered (>= 80): 85, 91, 85
```

`pl.pretty` prints a nested table readably (plain `print` would
show `table: 0x...`), and `pl.tablex` supplies the operations
the standard library leaves to you, like key-wise `merge` and
`keys`. None of this is magic — chapter 6 and 10 give you every
mechanism Penlight is built from — but it's *written once,
tested, and shared*, which is what a library is for.

## Reading the ecosystem honestly

- **The catalogue is broad but uneven.** Long-lived rocks
  (Penlight, luafilesystem, LuaSocket, busted for tests) are
  maintained; plenty of rocks are one person's finished
  experiment. Read the rock's page — last release, Lua versions
  supported, issue count — the way you'd read any dependency's.
- **Version targeting matters.** A rock "for Lua 5.1" may or
  may not run on 5.4; LuaRocks installs per version so you can
  hold both.
- **C rocks need a toolchain.** Pure-Lua rocks install anywhere
  Lua runs; C rocks need a compiler and headers *for your Lua
  version*, as the luafilesystem step showed.

## Check

- [ ] You can install a rock for a chosen Lua version, locally
- [ ] You know the two environment variables `luarocks path` sets
- [ ] You can name one thing a library gave you that plain Lua
      makes you write yourself

Next: [Versions and LuaJIT](versions-and-luajit.md).
