require "nvchad.options"

local o = vim.o
o.cursorlineopt = "both"

-- Default indent (2 spaces), overridden per-filetype in after/ftplugin/
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.expandtab = true
o.smartindent = true
