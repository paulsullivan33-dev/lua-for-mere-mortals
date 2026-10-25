# Embedding Lua in C

**Scope:** the direction Lua was built for — a C program that
hosts the interpreter. The lab compiled and ran a real example
(`lua-lab/programs/embed.c`, transcript t15). This is a taste
with working code, not a C API course.

## Why this chapter exists

Every other chapter used Lua from the outside, as a language
you run. Most Lua in the world runs the other way: inside a
host program whose authors chose Lua as their scripting layer
(chapter 1's list). Embedding is how the host does it, and the
core of it fits on one page — which is, in a sense, the point
of Lua.

## The program

The lab's host does four things: create a state, open the
standard libraries, register one C function as a Lua global,
and run a Lua snippet that computes something and calls back
into C:

```c
#include <stdio.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

static int c_shout(lua_State *L) {
    const char *s = luaL_checkstring(L, 1);
    printf("[C heard Lua say: %s]\n", s);
    lua_pushinteger(L, 42);   /* one return value for Lua */
    return 1;
}

int main(void) {
    lua_State *L = luaL_newstate();   /* one interpreter state */
    luaL_openlibs(L);                 /* string, table, math... */

    lua_pushcfunction(L, c_shout);
    lua_setglobal(L, "shout");

    const char *program =
        "local total = 0\n"
        "for i = 1, 10 do total = total + i end\n"
        "print('Lua computed 1..10 =', total)\n"
        "answer = shout('hello from inside Lua')\n";

    if (luaL_dostring(L, program) != LUA_OK) {
        fprintf(stderr, "Lua error: %s\n", lua_tostring(L, -1));
        lua_close(L);
        return 1;
    }

    lua_getglobal(L, "answer");
    printf("C read back: answer = %lld\n",
           (long long)lua_tointeger(L, -1));
    lua_close(L);
    return 0;
}
```

Built with the distribution's headers (chapter 2) and run:

```text
$ pkg-config --cflags --libs lua5.4
-I/usr/include/lua/5.4 -llua5.4
$ gcc embed.c -o embed $(pkg-config --cflags --libs lua5.4)
(compiled cleanly)
$ ./embed
Lua computed 1..10 =  55
[C heard Lua say: hello from inside Lua]
C read back: answer = 42
```

## The three ideas to take away

**The state.** `lua_State` is one whole interpreter: its own
globals, stack, and loaded modules. A host can run several,
isolated from each other — this is how a game scripts a
thousand NPCs or a server scripts a thousand requests.

**The stack.** C and Lua exchange almost everything through a
value stack: C pushes arguments, calls, and reads results off
the top (`lua_tointeger(L, -1)` reads the topmost). Nearly
every embedding bug is an off-by-one in stack bookkeeping, so
the API's convention — negative indexes from the top, positive
from the bottom — is worth learning slowly and exactly.

**Checked calls.** `luaL_dostring` returns a status; on error
the message is on the stack. Hosts that run user code wrap it
exactly this way (and usually with the protected-call machinery
of chapter 13, which exists in the C API as `lua_pcall`).

## Where hosts go from here (documented)

Real embeddings add: loading script files instead of strings,
exposing whole C APIs as Lua tables by registering function
sets, wrapping C objects as userdata (chapter 4's mysterious
eighth type — now demystified: it's how a host hands Lua a
thing only C understands), and sandboxing by simply *not*
opening libraries the script shouldn't have. The reference
manual's C API chapters and the book *Programming in Lua* are
the honest next step; this guide's claim ends at the working
program above.

## Check

- [ ] You can name the three steps every embedding starts with
- [ ] You know what the stack is for
- [ ] You can say what userdata is, now that you've seen its job

Next: [Recipes](recipes.md).
