-- PowerShell LSP configuration
-- Only configures PowerShell LSP when PowerShell is available (cross-platform)

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
    
    -- PowerShell LSP (only when PowerShell is available)
    if has("pwsh") or has("powershell") then
      opts.servers.powershell_es = {
        filetypes = { "ps1", "psm1", "psd1" },
        single_file_support = true,
        settings = {
          powershell = {
            codeFormatting = {
              Preset = "OTBS",
              openBraceOnSameLine = true,
              newLineAfterOpenBrace = true,
              newLineAfterCloseBrace = true,
              pipelineIndentationStyle = "IncreaseIndentationAfterEveryPipeline",
              whitespaceBeforeOpenBrace = true,
              whitespaceBeforeOpenParen = true,
              whitespaceAroundOperator = true,
              whitespaceAfterSeparator = true,
              ignoreOneLineBlock = true,
            },
            scriptAnalysis = {
              enable = true,
              settingsPath = "",
            },
            developer = {
              editorServicesLogLevel = "Normal",
            },
          },
        },
      }
    end
    
    return opts
  end,
}
