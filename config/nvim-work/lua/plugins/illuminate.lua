-- Illuminate https://github.com/RRethy/vim-illuminate
return {
  "RRethy/vim-illuminate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local ok, illuminate = pcall(require, "illuminate")
    if not ok or not illuminate.configure then
      vim.notify("[illuminate] failed to load, skipping configuration", vim.log.levels.WARN)
      return
    end

    -- Build providers list dynamically: include only ones that are likely available
    local providers = {}

    -- LSP provider: only if any LSP client is attached or lsp module exists
    do
      local has_lsp = false
      -- quick sanity check: see if lsp is available in runtime
      if pcall(require, "vim.lsp") then
        has_lsp = true
      end
      if has_lsp then
        table.insert(providers, "lsp")
      end
    end

    -- Treesitter provider: only if treesitter is installed and loaded
    do
      local has_ts, _ = pcall(require, "nvim-treesitter.parsers")
      if has_ts then
        table.insert(providers, "treesitter")
      end
    end

    -- Regex as fallback (always safe)
    table.insert(providers, "regex")

    -- Configure with guarded options
    local success, err = pcall(function()
      illuminate.configure({
        providers = providers,
        delay = 100,
        filetypes_denylist = { "dirbuf", "dirvish", "fugitive" },
        under_cursor = true,
        min_count_to_highlight = 1,
      })
    end)
    if not success then
      vim.notify("[illuminate] configuration failed: " .. tostring(err), vim.log.levels.WARN)
    end
  end,
}
