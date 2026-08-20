-- Treesitter https://github.com/nvim-treesitter/nvim-treesitter

return {
  src = "https://github.com/nvim-treesitter/nvim-treesitter",
  name = "nvim-treesitter",
  setup = function()
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then
      return
    end

    configs.setup({
      ensure_installed = {
        "bash",
        "bicep",
        "c_sharp",
        "caddy",
        "cmake",
        "comment",
        "commonlisp",
        "css",
        "csv",
        "diff",
        "dockerfile",
        "editorconfig",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "gotmpl",
        "gowork",
        "gpg",
        "graphql",
        "hcl",
        "html",
        "http",
        "ini",
        "javascript",
        "jinja",
        "json",
        "kusto",
        "lua",
        "luadoc",
        "markdown",
        "nginx",
        "nix",
        "php",
        "powershell",
        "properties",
        "python",
        "regex",
        "robots",
        "rust",
        "scss",
        "sql",
        "ssh_config",
        "svelte",
        "terraform",
        "tmux",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "vue",
        "xml",
        "yaml",
      },
      sync_install = false,
      auto_install = true,
      indent = { enable = true },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
      },
    })

    vim.treesitter.language.register("templ", "templ")
  end,
}
