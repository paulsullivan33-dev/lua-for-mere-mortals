/* embed.c -- a tiny C program that hosts the Lua interpreter.
 *
 * Build (pkg-config knows where liblua5.4-dev put everything):
 *   gcc embed.c -o embed $(pkg-config --cflags --libs lua5.4)
 *
 * The shape of every embedding: create a state, open the standard
 * libraries, hand Lua some code, read the results back off the stack.
 */
#include <stdio.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

/* A C function Lua can call: registered below as shout(). */
static int c_shout(lua_State *L) {
    const char *s = luaL_checkstring(L, 1);
    printf("[C heard Lua say: %s]\n", s);
    lua_pushinteger(L, 42);   /* one return value for Lua */
    return 1;
}

int main(void) {
    lua_State *L = luaL_newstate();   /* one interpreter state */
    luaL_openlibs(L);                 /* string, table, math, ... */

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

    /* Read a Lua global back from C. */
    lua_getglobal(L, "answer");
    printf("C read back: answer = %lld\n", (long long)lua_tointeger(L, -1));

    lua_close(L);
    return 0;
}
