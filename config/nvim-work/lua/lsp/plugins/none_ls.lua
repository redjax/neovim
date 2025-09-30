-- None-ls as a discrete plugin
return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")

    -- Helper function to check if a tool is available
    local function has_tool(tool)
      return vim.fn.executable(tool) == 1
    end

    -- Build sources list based on available tools
    local sources = {}

    -- Always available built-ins (no external dependencies)
    table.insert(sources, null_ls.builtins.hover.dictionary)
    table.insert(sources, null_ls.builtins.completion.spell)

    -- Conditionally add tools based on availability
    if has_tool("stylua") then
      table.insert(sources, null_ls.builtins.formatting.stylua)
    end

    if has_tool("prettier") then
      table.insert(sources, null_ls.builtins.formatting.prettier)
    end

    if has_tool("actionlint") then
      table.insert(sources, null_ls.builtins.diagnostics.actionlint)
    end

    if has_tool("shfmt") then
      table.insert(sources, null_ls.builtins.formatting.shfmt)
    end

    if has_tool("shellcheck") then
      table.insert(sources, null_ls.builtins.diagnostics.shellcheck)
    end

    -- Markdown tools (only if available)
    if has_tool("markdownlint") then
      table.insert(sources, null_ls.builtins.diagnostics.markdownlint)
    end

    if has_tool("textlint") then
      table.insert(sources, null_ls.builtins.diagnostics.textlint)
    end

    if has_tool("proselint") then
      table.insert(sources, null_ls.builtins.diagnostics.proselint)
    end

    -- Python tools
    if has_tool("black") then
      table.insert(sources, null_ls.builtins.formatting.black)
    end

    if has_tool("isort") then
      table.insert(sources, null_ls.builtins.formatting.isort)
    end

    -- Go tools
    if has_tool("gofmt") then
      table.insert(sources, null_ls.builtins.formatting.gofmt)
    end

    if has_tool("goimports") then
      table.insert(sources, null_ls.builtins.formatting.goimports)
    end

    if has_tool("golangci-lint") then
      table.insert(sources, null_ls.builtins.diagnostics.golangci_lint)
    end

    -- YAML tools
    if has_tool("yamllint") then
      table.insert(sources, null_ls.builtins.diagnostics.yamllint)
    end

    -- Terraform tools
    if has_tool("terraform") then
      table.insert(sources, null_ls.builtins.formatting.terraform_fmt)
      table.insert(sources, null_ls.builtins.diagnostics.terraform_validate)
    end

    if has_tool("tflint") then
      table.insert(sources, null_ls.builtins.diagnostics.tflint)
    end

    -- SQL tools
    if has_tool("sqlfmt") then
      table.insert(sources, null_ls.builtins.formatting.sqlfmt)
    end

    null_ls.setup({
      sources = sources,
      debug = false, -- Set to true if you want to see debug info
    })
  end,
}