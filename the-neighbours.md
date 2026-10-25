# The Neighbours

**Scope:** the languages Lua is chosen over, and chosen
against — stated as trades, not rankings. This chapter is
judgement from the guide's reading, not lab work.

## Python

The usual alternative for "a language users can script us with".
Python brings an enormous standard library and ecosystem, and
costs hundreds of megabytes and a heavier embedding story. Hosts
that pick Lua over Python are buying size and sandboxability;
programs that are mostly library calls should pick Python
without a second thought. For standalone programs, Python is
the default Lua programmers themselves reach for.

## JavaScript

The other embeddable everyone knows, carried by browsers and
Node. Bigger language, bigger engines, JSON built into its
bones, and an object model (prototypes) that is Lua's tables'
close cousin. If your host already contains a JS engine, Lua
has nothing to sell it. If it doesn't, the size comparison runs
the other way.

## Tcl

Lua's ancestor in the embedding niche: an even smaller language
where everything is a string and the host integration is
superb. Tcl survives happily in EDA tools and testing rigs.
Lua is what a generation chose when they wanted Tcl's embedding
shape with a more conventional language inside.

## Scheme and Lisp

The connoisseur's embeddables (Guile is the GNU project's).
More powerful metaprogramming than Lua will ever offer, paid
for with syntax its intended audience — end users of your
program — may not accept. Lua's authors chose the audience over
the power, every time; that's a values decision you can agree
or disagree with, but it is *the* decision that made Lua Lua.

## The specialists

- **Wren, Janet, AngelScript:** newer small/embeddable languages
  with classes or Lisp flavour built in. Worth knowing; smaller
  ecosystems, less host adoption.
- **Your host's own config format (INI/JSON/TOML):** if the
  "scripting" is really just settings with no logic, a data
  format plus validation beats a language — chapter 17's recipe
  shows Lua volunteering for the job, but the honest engineer
  checks whether the job needs doing.

## The short version

Lua wins where the language is a *guest*: it must be small,
portable, safe to hand to users, and pleasant for small
programs. It loses where the language is the *house*: big
programs, big libraries, big teams. Most bad Lua experiences
are a guest asked to be the house, or the reverse.

Next: [Limits](limits.md).
