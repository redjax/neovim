return {
    "mason-org/mason.nvim",
    opts = function(_, opts)
        -- Function to check if a command exists
        local function has(cmd)
            return vim.fn.executable(cmd) == 1
        end
        
        -- Essential tools for all platforms
        local base_tools = {
            "stylua",              -- Lua formatter
            "shellcheck",          -- Shell script linter
            "shfmt",               -- Shell script formatter
            "prettier",            -- Multi-language formatter (JSON, YAML, Markdown, etc.)
            "marksman",            -- Markdown LSP
            "yaml-language-server", -- YAML LSP
            "json-lsp",            -- JSON LSP
            "terraform-ls",        -- Terraform LSP
            "sqlls",               -- SQL LSP
        }
        
        -- Language-specific tools based on availability
        local conditional_tools = {}
        
        -- Python tools (if Python is available)
        if has("python") or has("python3") then
            table.insert(conditional_tools, "pyright")          -- Python LSP
            table.insert(conditional_tools, "flake8")           -- Python linter
            table.insert(conditional_tools, "black")            -- Python formatter
            table.insert(conditional_tools, "isort")            -- Python import sorter
            table.insert(conditional_tools, "mypy")             -- Python type checker
        end
        
        -- Shell tools (if any shell is available)
        if has("bash") or has("sh") or has("zsh") then
            table.insert(conditional_tools, "bash-language-server") -- Bash LSP
        end
        
        -- PowerShell tools (if PowerShell is available)
        if has("pwsh") or has("powershell") then
            table.insert(conditional_tools, "powershell-editor-services") -- PowerShell LSP
        end
        
        -- Node.js tools (if Node is available)
        if has("node") or has("npm") then
            table.insert(conditional_tools, "eslint_d")         -- JavaScript linter
            table.insert(conditional_tools, "typescript-language-server") -- TypeScript LSP
        end
        
        -- Go tools (if Go is available)
        if has("go") then
            table.insert(conditional_tools, "gopls")            -- Go LSP
            table.insert(conditional_tools, "gofumpt")          -- Go formatter
            table.insert(conditional_tools, "goimports")        -- Go import formatter
            table.insert(conditional_tools, "golines")          -- Go line length formatter
        end
        
        -- Rust tools (if Cargo is available)
        if has("cargo") then
            table.insert(conditional_tools, "rust-analyzer")    -- Rust LSP
        end
        
        -- Azure tools (if Azure CLI is available)
        if has("az") then
            table.insert(conditional_tools, "bicep-lsp")        -- Azure Bicep LSP
        end
        
        -- Docker tools (if Docker is available)
        if has("docker") then
            table.insert(conditional_tools, "dockerfile-language-server") -- Dockerfile LSP
            table.insert(conditional_tools, "hadolint")         -- Dockerfile linter
        end
        
        -- Additional formatters and linters
        table.insert(conditional_tools, "yamllint")            -- YAML linter
        table.insert(conditional_tools, "actionlint")          -- GitHub Actions linter
        table.insert(conditional_tools, "tflint")              -- Terraform linter
        
        -- Combine all tools
        local ensure_installed = base_tools
        vim.list_extend(ensure_installed, conditional_tools)
        
        opts.ensure_installed = ensure_installed
        return opts
    end,
}