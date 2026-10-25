-- args.lua -- how a script sees its command-line arguments.
-- Run: lua5.4 args.lua hello world
print("arg[0] (the script itself):", arg[0])
print("arg[1], arg[2]:", arg[1], arg[2])
print("arg[-1] (what came before):", arg[-1])
