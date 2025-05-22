-- Notify https://github.com/rcarriga/nvim-notify

return {
    enabled = true,
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
        require("notify").setup({
            -- Customizations (see :h notify.Config)
            stages = "fade_in_slide_out", -- animation style
            render = "default",           -- notification style
            timeout = 3000,               -- time in ms before notification disappears
            -- background_colour = "#1a1a1a",-- background color (set to "Normal" for default)
        })
        vim.notify = require("notify")
        -- If you lazy-load telescope, load the extension manually:
        pcall(function()
        require("telescope").load_extension("notify")
        end)
    end,
}
