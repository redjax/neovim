-- Floaterm https://github.com/

return {
    "voldikss/vim-floaterm",
    cmd = { "FloatermToggle", "FloatermNew", "FloatermNext", "FloatermPrev", "FloatermKill" }, -- lazy-load on command
    keys = {
        { "<leader>ft", "<cmd>FloatermToggle<CR>", desc = "Toggle Floaterm" },
        { "<leader>fn", "<cmd>FloatermNew<CR>",    desc = "New Floaterm" },
        { "<leader>fj", "<cmd>FloatermNext<CR>",   desc = "Next Floaterm" },
        { "<leader>fk", "<cmd>FloatermPrev<CR>",   desc = "Prev Floaterm" },
        { "<leader>fx", "<cmd>FloatermKill<CR>",   desc = "Kill Floaterm" },
    },
    init = function()
        -- Detect Windows properly using vim.fn.has()
        local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
        
        if is_windows then
            -- Use pwsh if available, otherwise fallback to powershell
            local shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
            vim.opt.shell = shell
            vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
            vim.opt.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
            vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
            vim.opt.shellquote = ""
            vim.opt.shellxquote = ""
            -- Floaterm settings
            vim.g.floaterm_shell = shell
        else
            vim.opt.shell = "bash"
            vim.g.floaterm_shell = "bash"
        end
        vim.g.floaterm_position = 'center'
        vim.g.floaterm_width = 0.8
        vim.g.floaterm_height = 0.8
    end,
}
