-- Virtual text display for DAP variables
-- https://github.com/theHamsta/nvim-dap-virtual-text

return {
  src = "https://github.com/theHamsta/nvim-dap-virtual-text",
  name = "nvim-dap-virtual-text",

  setup = function()
    require("nvim-dap-virtual-text").setup({
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      virt_text_pos = "eol",
    })
  end,
}
