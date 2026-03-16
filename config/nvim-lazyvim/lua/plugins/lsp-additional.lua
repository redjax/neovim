-- Additional cross-platform LSP configurations
-- Auto-detects available tools and only configures relevant LSPs

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
    
    -- Go LSP (only when Go is available)
    -- Deep-merge with LazyVim Go extra's gopls config to preserve its root_dir,
    -- workspace filters, and setup function that are required for proper initialization.
    if has("go") then
      opts.servers.gopls = vim.tbl_deep_extend("force", opts.servers.gopls or {}, {
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              shadow = true,
              nilness = true,
              unusedwrite = true,
              useany = true,
            },
            staticcheck = true,
            gofumpt = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            allowModfileModifications = true,
          },
        },
      })
    end
    
    -- Rust LSP (only when Cargo is available)
    if has("cargo") then
      opts.servers.rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
            },
          },
        },
      }
    end
    
    -- Python LSP (only when Python is available)
    if has("python") or has("python3") then
      opts.servers.pyright = {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
            },
          },
        },
      }
    end
    
    return opts
  end,
}