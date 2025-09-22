-- Aura theme https://github.com/daltonmenezes/aura-theme

return {
    "daltonmenezes/aura-theme",
    name = "aura-theme",
    lazy = false,  -- Need to load immediately for special rtp setup
    priority = 1000,
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
    end
}
