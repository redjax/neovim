return {
  name = "powershell",
  servers = { "powershell_es" },
  tools = { "powershell-editor-services" },
  settings = {
    powershell = {
      codeFormatting = {
        preset = "OTBS",
        openBraceOnSameLine = true,
        newLineAfterOpenBrace = true,
        newLineAfterCloseBrace = true,
        pipelineIndentationStyle = "IncreaseIndentationForFirstPipeline",
        whitespaceBeforeOpenBrace = true,
        whitespaceBeforeOpenParen = true,
        whitespaceAroundOperator = true,
        whitespaceAfterSeparator = true,
        ignoreOneLineBlock = true,
        alignPropertyValuePairs = true,
      },
      scriptAnalysis = {
        enable = true,
        settingsPath = "",
      },
      developer = {
        editorServicesLogLevel = "Normal",
        bundledModulesPath = "",
      },
    },
  },
  filetypes = { "ps1", "psm1", "psd1" },
}