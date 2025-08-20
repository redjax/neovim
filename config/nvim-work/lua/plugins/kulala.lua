-- Kulala HTTP client https://github.com/mistweaverco/kulala.nvim

return {
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" }, -- Loads when you open .http or .rest files
    version = "*",
    opts = {
      global_keymaps = true, -- Enable global key mappings for Kulala
      global_keymaps_prefix = "<leader>R", -- Prefix for keymaps (e.g. <leader>Rs to send request)
      kulala_keymaps_prefix = "", -- No extra prefix for kulala-specific keymaps
    },
    config = function(_, opts)
      require("kulala").setup(opts)
    end,
    keys = {
      { "<leader>Rs", desc = "Send request (Kulala)" },
      { "<leader>Ra", desc = "Send all requests (Kulala)" },
      { "<leader>Rb", desc = "Open scratchpad (Kulala)" },
    },
  },
}
