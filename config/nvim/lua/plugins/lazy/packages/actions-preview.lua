-- Actions preview https://github.com/aznhe21/actions-preview.nvim

return {
    enabled = true,
    "aznhe21/actions-preview.nvim",
    event = "VeryLazy",

    config = function()
        vim.keymap.set({ "v", "n" }, "<leader>la", require("actions-preview").code_actions)

    require("actions-preview").setup {

        -- nui = {
        --     layout = {
        --         size = {
        --             width = "80%"
        --         }
        --     }
        -- }

        telescope = {
            sorting_strategy = "ascending",
            layout_strategy = "vertical",
            layout_config = {
                width = 0.8,
                height = 0.9,
                prompt_position = "top",
                preview_cutoff = 20,
                preview_height = function(_, _, max_lines)
                    return max_lines - 15
                    end,
            },
        },
      }
    end, 
}