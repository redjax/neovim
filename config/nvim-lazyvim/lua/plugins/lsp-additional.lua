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
    if has("go") then
      opts.servers.gopls = {
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
            -- Environment settings
            env = {
              GOPATH = vim.env.GOPATH or vim.fn.expand("~/go"),
              GOROOT = vim.env.GOROOT or vim.fn.expand("~/.go"),
            },
            allowModfileModifications = true,
          },
        },
      }
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