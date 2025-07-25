-- Auto-mkdir https://github.com/mateuszwieloch/automkdir.nvim

return {
    enabled = true,
    "mateuszwieloch/automkdir.nvim",
    lazy = false,
    config = function()
        require("automkdir").setup({
            blacklist = {
              filetype = {
                "help",
                "nofile",
                "quickfix",
                "gitcommit",
                "TelescopePrompt",
                "NvimTree",
                "dashboard",
                "alpha",
                "starter",
                "lazy",
                "lazygit",
                "oil",
                "netrw",
              },
              buftype = {
                "nofile",
                "terminal",
                "quickfix",
              },
              pattern = {
                -- Patterns for filenames you want to exclude
                -- Example: "^/tmp/" to exclude all files in /tmp/
              },
            }
          })
    end,
}
  