-- PowerShell LSP server configuration
-- Cross-platform: works on Windows, Linux, and macOS when PowerShell is installed

local M = {}

function M.powershell_es()
  -- Only configure if PowerShell is actually available
  local pwsh_available = vim.fn.executable("pwsh") == 1
  local powershell_available = vim.fn.executable("powershell") == 1
  
  if not (pwsh_available or powershell_available) then
    return nil
  end

  return {
    filetypes = { "ps1", "psm1", "psd1" },
    root_dir = function(fname)
      return require("lspconfig.util").find_git_ancestor(fname) or vim.fn.getcwd()
    end,
    single_file_support = true,
    settings = {
      powershell = {
        codeFormatting = {
          Preset = "OTBS", -- One True Brace Style
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

return M