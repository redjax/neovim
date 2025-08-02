-- Notify https://github.com/rcarriga/nvim-notify

return {
    enabled = false,
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
        require("notify").setup({
            -- Customizations (see :h notify.Config)

            -- Max column size
            max_width = 50,
            -- Max row size
            max_height = 10,
            -- Higher number = faster animation/higher CPU usage. Default = 60
            fps = 120,
            -- true = open messages at top of screen false = open messages at bottom
            top_down = false,
            -- Log level (debug, error, info, trace, warn, off)
            -- level = "trace",
            -- Animation style
            -- \ Options: fade_in_slide_out, fade, slide, static
            stages = "fade",
            -- Notification style
            -- \ Options: default, minimal, simple, compact, wrapped-compact
            render = "wrapped-compact",
            -- Time in ms before notification disappears. Default = 3000
            timeout = 3000,
            -- background_colour = "#1a1a1a",-- background color (set to "Normal" for default)
        })
        vim.notify = require("notify")
        -- If you lazy-load telescope, load the extension manually:
        pcall(function()
        require("telescope").load_extension("notify")
        end)
    end,
}
