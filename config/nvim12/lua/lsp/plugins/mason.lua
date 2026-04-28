return {
  src = "https://github.com/mason-org/mason.nvim",
  name = "mason.nvim",
  setup = function()
    local ok, mason = pcall(require, "mason")
    if not ok then
      return
    end

    mason.setup({
      registries = {
        "github:mason-org/mason-registry",
        "github:crashdummyy/mason-registry",
      },
    })
  end,
}
