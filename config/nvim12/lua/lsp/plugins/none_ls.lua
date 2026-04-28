return {
  src = "https://github.com/nvimtools/none-ls.nvim",
  name = "none-ls.nvim",
  setup = function()
    local ok, null_ls = pcall(require, "null-ls")
    if not ok then
      return
    end

    local function has_tool(tool)
      return vim.fn.executable(tool) == 1
    end

    local sources = {
      null_ls.builtins.hover.dictionary,
      null_ls.builtins.completion.spell,
    }

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

    if has_tool("markdownlint") then
      table.insert(sources, null_ls.builtins.diagnostics.markdownlint)
    end

    if has_tool("textlint") then
      table.insert(sources, null_ls.builtins.diagnostics.textlint)
    end

    if has_tool("proselint") then
      table.insert(sources, null_ls.builtins.diagnostics.proselint)
    end

    if has_tool("black") then
      table.insert(sources, null_ls.builtins.formatting.black)
    end

    if has_tool("isort") then
      table.insert(sources, null_ls.builtins.formatting.isort)
    end

    if has_tool("gofmt") then
      table.insert(sources, null_ls.builtins.formatting.gofmt)
    end

    if has_tool("goimports") then
      table.insert(sources, null_ls.builtins.formatting.goimports)
    end

    if has_tool("golangci-lint") then
      table.insert(sources, null_ls.builtins.diagnostics.golangci_lint)
    end

    if has_tool("yamllint") then
      table.insert(sources, null_ls.builtins.diagnostics.yamllint)
    end

    if has_tool("terraform") then
      table.insert(sources, null_ls.builtins.formatting.terraform_fmt)
      table.insert(sources, null_ls.builtins.diagnostics.terraform_validate)
    end

    if has_tool("tflint") then
      table.insert(sources, null_ls.builtins.diagnostics.tflint)
    end

    if has_tool("sqlfmt") then
      table.insert(sources, null_ls.builtins.formatting.sqlfmt)
    end

    null_ls.setup({
      sources = sources,
      debug = false,
    })
  end,
}
