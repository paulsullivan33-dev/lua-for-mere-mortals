-- settings.lua -- a configuration file that is Lua code.
-- A host loads it with dofile (or loadfile + a sandboxed
-- environment) and reads the table it leaves behind.
return {
  title = "Reading Group Notes",
  page_size = "A5",
  margins_mm = 15,
  show_page_numbers = true,
  contributors = { "Ana", "Ben", "Cleo" },
}
