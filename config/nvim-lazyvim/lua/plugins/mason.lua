return {
    "mason-org/mason.nvim",
    opts = function(_, opts)
        -- Detect platform
        local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
        
        -- Base tools for all platforms
        local base_tools = {
            "stylua",
            "shellcheck",
            "shfmt",
            "flake8",
            "bash-language-server", -- Bash LSP for all platforms
        }
        
        -- Windows-specific tools
        local windows_tools = {
            "powershell-editor-services", -- PowerShell LSP
        }
        
        -- Combine tools based on platform
        local ensure_installed = base_tools
        if is_windows then
            vim.list_extend(ensure_installed, windows_tools)
        end
        
        opts.ensure_installed = ensure_installed
        return opts
    end,
}