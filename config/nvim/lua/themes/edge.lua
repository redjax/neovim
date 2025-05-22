-- Edge theme https://github.com/sainnhe/edge

return {
    enabled = true,
    "sainnhe/edge",
    name = "edge",
    init = function()
        -- Options: aura, neon, aura_dim, light
        vim.g.edge_style = 'aura'
    end,
}