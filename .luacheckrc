-- Neovim configuration uses LuaJIT globals.
std = "luajit"

-- Allow access to vim and its fields, but not reassignment of vim itself.
-- Allow configuration assignments beneath vim.g, vim.opt, and vim.o.
read_globals = {
  vim = {
    other_fields = true,

    fields = {
      g = {
        read_only = false,
        other_fields = true,
      },

      opt = {
        read_only = false,
        other_fields = true,
      },

      o = {
        read_only = false,
        other_fields = true,
      },
    },
  },
}

-- Let StyLua own line wrapping and layout.
max_line_length = false
