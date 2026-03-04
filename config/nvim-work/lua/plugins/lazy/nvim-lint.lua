-- nvim-lint - Fast and async linting
-- https://github.com/mfussenegger/nvim-lint

return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")
        
        -- Helper function to check if a tool is available
        local function has_tool(tool)
            -- Check system PATH
            if vim.fn.executable(tool) == 1 then
                return true
            end
            -- Check Mason bin directory
            local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/" .. tool
            if vim.fn.executable(mason_bin) == 1 then
                return true
            end
            return false
        end
        
        -- Configure linters by filetype (only if tools are available)
        lint.linters_by_ft = {}
        
        -- Shell scripts
        if has_tool("shellcheck") then
            lint.linters_by_ft.sh = { "shellcheck" }
            lint.linters_by_ft.bash = { "shellcheck" }
        end
        
        -- Python
        if has_tool("flake8") then
            lint.linters_by_ft.python = { "flake8" }
        elseif has_tool("pylint") then
            lint.linters_by_ft.python = { "pylint" }
        elseif has_tool("ruff") then
            lint.linters_by_ft.python = { "ruff" }
        end
        
        -- JavaScript/TypeScript
        if has_tool("eslint") then
            lint.linters_by_ft.javascript = { "eslint" }
            lint.linters_by_ft.typescript = { "eslint" }
            lint.linters_by_ft.javascriptreact = { "eslint" }
            lint.linters_by_ft.typescriptreact = { "eslint" }
        end
        
        -- Docker (support both cases)
        lint.linters_by_ft.dockerfile = { "hadolint" }
        lint.linters_by_ft.Dockerfile = { "hadolint" }
        
        -- Configure hadolint for stricter checking (VSCode-like)
        local mason_hadolint = vim.fn.stdpath("data") .. "/mason/bin/hadolint"
        lint.linters.hadolint = {
            cmd = has_tool("hadolint") and "hadolint" or mason_hadolint,
            stdin = true,
            args = {
                "--format", "json",
                "-",
            },
            stream = "stdout",
            ignore_exitcode = true,
            parser = function(output, bufnr)
                local diagnostics = {}
                local ok, decoded = pcall(vim.json.decode, output)
                if not ok or not decoded then
                    return diagnostics
                end
                
                for _, item in ipairs(decoded) do
                    local severity = vim.diagnostic.severity.INFO
                    if item.level == "error" then
                        severity = vim.diagnostic.severity.ERROR
                    elseif item.level == "warning" then
                        severity = vim.diagnostic.severity.WARN
                    elseif item.level == "info" then
                        severity = vim.diagnostic.severity.INFO
                    elseif item.level == "style" then
                        severity = vim.diagnostic.severity.HINT
                    end
                    
                    table.insert(diagnostics, {
                        lnum = (item.line or 1) - 1,
                        col = (item.column or 1) - 1,
                        end_lnum = (item.line or 1) - 1,
                        end_col = (item.column or 1),
                        severity = severity,
                        source = "hadolint",
                        message = string.format("%s (%s)", item.message, item.code),
                        code = item.code,
                    })
                end
                
                return diagnostics
            end,
        }
        
        -- YAML
        if has_tool("yamllint") then
            lint.linters_by_ft.yaml = { "yamllint" }
        end
        
        -- Markdown
        if has_tool("markdownlint") then
            lint.linters_by_ft.markdown = { "markdownlint" }
        end
        
        -- GitHub Actions
        if has_tool("actionlint") then
            -- Smart detection for GitHub workflow files
            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = { "*.yml", "*.yaml" },
                callback = function()
                    local filepath = vim.fn.expand("%:p")
                    if filepath:match("%.github/workflows/") then
                        vim.b.current_linters = { "actionlint" }
                        lint.try_lint()
                    end
                end,
            })
        end
        
        -- Go: Rely on gopls LSP for linting (VSCode-style)
        -- golangci-lint is better suited for CI/CD pipelines
        -- Uncomment below if you want golangci-lint in the editor:
        -- if has_tool("golangci-lint") then
        --     lint.linters_by_ft.go = { "golangcilint" }
        -- elseif has_tool("staticcheck") then
        --     lint.linters_by_ft.go = { "staticcheck" }
        -- end
        
        -- Terraform
        if has_tool("tflint") then
            lint.linters_by_ft.terraform = { "tflint" }
        end
        
        -- PowerShell (if available)
        if has_tool("powershell") or has_tool("pwsh") then
            -- PSScriptAnalyzer integration would require additional setup
            -- Note: This typically works through PowerShell LSP instead
        end
        
        -- JSON
        if has_tool("jsonlint") then
            lint.linters_by_ft.json = { "jsonlint" }
        end
        
        -- SQL (if sqlfluff is available)
        if has_tool("sqlfluff") then
            lint.linters_by_ft.sql = { "sqlfluff" }
        end
        
        -- Auto-lint on specific events
        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
        
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                -- Skip linting for certain buffer types
                local buftype = vim.bo.buftype
                if buftype == "terminal" or buftype == "nofile" or buftype == "help" then
                    return
                end
                
                lint.try_lint()
            end,
        })
        
        -- Manual lint command
        vim.api.nvim_create_user_command("Lint", function()
            lint.try_lint()
        end, { desc = "Trigger linting for current file" })
        
        -- Toggle linting command
        local linting_enabled = true
        vim.api.nvim_create_user_command("LintToggle", function()
            linting_enabled = not linting_enabled
            if linting_enabled then
                print("Linting enabled")
                lint.try_lint()
            else
                print("Linting disabled")
                -- Clear current diagnostics
                vim.diagnostic.reset(vim.api.nvim_create_namespace("lint"))
            end
        end, { desc = "Toggle linting on/off" })
    end,
}