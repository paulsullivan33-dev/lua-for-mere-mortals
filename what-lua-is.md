# What Lua Is

**Scope:** what the language is, where it lives, and whether it's
worth your time. Not a tutorial — that starts in
[Your First Program](your-first-program.md).

## The one-sentence version

Lua is a small scripting language designed to be **embedded** —
built into a bigger program so that program can be configured,
extended, and scripted by its users.

## The problem it solves

Every substantial program eventually grows things its author
didn't foresee: settings, plugins, user automation, levels, rules.
The author then has three choices: hard-code them all, invent a
configuration format (which slowly grows into a bad programming
language), or build in a real language and let users write in it.

Lua is the third choice, engineered for it. It was created in 1993
at PUC-Rio in Brazil by Roberto Ierusalimschy, Luiz Henrique de
Figueiredo, and Waldemar Celes, and it has been refined since
toward a few hard goals:

- **Small.** The whole interpreter is a few hundred kilobytes,
  with a C library a host program can link in an afternoon.
- **Portable.** It is written in clean ANSI C and runs on
  essentially anything with a C compiler.
- **Fast for a scripting language.** Fast enough that hosts use
  it in per-frame and per-request paths. (This guide claims no
  benchmarks of its own; that's the reputation, earned elsewhere.)
- **Simple.** One data structure (the table), functions as
  values, and a keyword list you can learn in an hour.

## Where Lua actually lives

- **Games:** World of Warcraft's interface, Roblox, and many
  game engines expose Lua to players and modders.
- **Tools you may already run:** Redis has Lua scripting built
  in; nginx (via OpenResty), Wireshark, VLC, OBS, and the Apache
  web server all embed it or offer it as their extension language.
- **Configuration that outgrew config files:** the Awesome window
  manager and the Hammerspoon automation tool are configured in
  Lua, because their "configuration" really is programming.
- **Hardware and networks:** NodeMCU firmware for ESP8266 chips,
  and a long history in routers and industrial equipment — places
  where a few hundred kilobytes matters.

## What Lua is not

- **Not a batteries-included application language.** The standard
  library is deliberately thin: no sockets, no threads, no GUI,
  no regular expressions. Hosts and libraries supply those.
- **Not class-based.** There are no classes or inheritance in the
  language. Objects are an idiom built from tables and
  metatables ([chapter 10](metatables-and-objects.md)) — many
  Lua programmers build one small pattern and use it everywhere.
- **Not numbered like the others.** Arrays start at index **1**,
  strings' first character is position 1, and `#` is the length
  operator. One-based indexing is a deliberate choice for a
  language aimed at end users, and it is the first thing
  programmers from other languages trip over.
- **Not typed in advance.** Values carry types; variables don't.
  Nothing is checked until it runs.

## Should you learn it?

Worth it if you:

- Use a tool that embeds it (a game, Redis, a router, an editor)
  and want its scripting to stop being magic
- Are building something of your own that users should be able
  to configure or extend
- Want a second language that is small enough to finish

Probably not your tool if you:

- Want one language for large standalone programs with a big
  standard library — that's Python or JavaScript territory
- Need libraries for everything imaginable, maintained centrally

## Check

You can explain, in your own words:

- [ ] What "embedded" means and why a host program wants it
- [ ] One product you have used that contains Lua
- [ ] Why Lua has exactly one data structure

Next: [Installing Lua](installing-lua.md).
