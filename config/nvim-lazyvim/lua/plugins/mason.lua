return {
    "mason-org/mason.nvim",
    opts = function(_, opts)
        -- Function to check if a command exists
        local function has(cmd)
            return vim.fn.executable(cmd) == 1
        end
        
        -- Base tools for all platforms
        local base_tools = {
            "stylua",        -- Lua formatter
            "shellcheck",    -- Shell script linter
            "shfmt",         -- Shell script formatter
        }
        
        -- Conditional tools based on what's available
        local conditional_tools = {}
        
        -- Python tools (if Python is available)
        if has("python") or has("python3") then
            table.insert(conditional_tools, "flake8")
            table.insert(conditional_tools, "black")
        end
        
        -- Bash LSP (if any shell is available)
        if has("bash") or has("sh") or has("zsh") then
            table.insert(conditional_tools, "bash-language-server")
        end
        
        -- PowerShell LSP (if PowerShell is available)
        if has("pwsh") or has("powershell") then
            table.insert(conditional_tools, "powershell-editor-services")
        end
        
        -- Node.js tools (if Node is available)
        if has("node") or has("npm") then
            table.insert(conditional_tools, "prettier")
            table.insert(conditional_tools, "eslint_d")
        end
        
        -- Go tools (if Go is available)
        if has("go") then
            table.insert(conditional_tools, "gopls")
            table.insert(conditional_tools, "gofumpt")
        end
        
        -- Rust tools (if Cargo is available)
        if has("cargo") then
            table.insert(conditional_tools, "rust-analyzer")
        end
        
        -- Combine all tools
        local ensure_installed = base_tools
        vim.list_extend(ensure_installed, conditional_tools)
        
        opts.ensure_installed = ensure_installed
        return opts
    end,
}