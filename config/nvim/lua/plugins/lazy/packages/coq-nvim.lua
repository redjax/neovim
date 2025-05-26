-- coq_nvim https://github.com/ms-jpq/coq_nvim

return {
    enabled = true,
    "ms-jpq/coq_nvim",
    branch = "coq",
    build = ":COQdeps",
    lazy = false,
    dependencies = {
      { "ms-jpq/coq.artifacts", branch = "artifacts" },
      { "ms-jpq/coq.thirdparty", branch = "3p" },
    },
    init = function()
        vim.g.coq_settings = {
            auto_start = true,
            clients = {
              snippets = { enabled = true },
              tree_sitter = { enabled = true },
              thirdparty = {
                enabled = true,
                sources = {
                  shell = { enabled = true },
                  lua = { enabled = true },
                  calc = { enabled = true },
                  banner = { enabled = true },
                },
              },
            },
        }
    end,
    config = function()
    end,
}
