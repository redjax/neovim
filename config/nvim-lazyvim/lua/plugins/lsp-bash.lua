-- Cross-platform Bash LSP configuration
-- Only configures Bash LSP when shell tools are available

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason.nvim",
    "mason-org/mason-lspconfig.nvim",
  },
  opts = function(_, opts)
    local function has(cmd)
      return vim.fn.executable(cmd) == 1
    end
    
    opts.servers = opts.servers or {}
    
    -- Bash LSP (only when shell is available)
    if has("bash") or has("sh") or has("zsh") then
      opts.servers.bashls = {
        filetypes = { "sh", "bash", "zsh" },
        settings = {
          bashIde = {
            globPattern = "*@(.sh|.inc|.bash|.command)",
          },
        },
      }
    end
    
    return opts
  end,
}