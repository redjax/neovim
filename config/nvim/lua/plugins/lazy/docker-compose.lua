-- Docker Compose enhanced support
-- LSP: docker-compose-language-service
-- Schema validation via YAML LSP

return {
  "ekalinin/Dockerfile.vim", -- Also handles docker-compose syntax
  ft = { "yaml.docker-compose" },
  config = function()
    -- Detect docker-compose files
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = {
        "docker-compose*.yml",
        "docker-compose*.yaml",
        "compose*.yml",
        "compose*.yaml",
        "*docker-compose*.yml",
        "*docker-compose*.yaml",
      },
      callback = function()
        -- Set filetype to yaml with docker-compose variant
        vim.bo.filetype = "yaml.docker-compose"
      end,
    })

    -- Docker Compose-specific settings
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "yaml.docker-compose", "docker-compose" },
      callback = function()
        -- Use 2 spaces for indentation (Docker Compose convention)
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
        vim.bo.expandtab = true
        
        -- Enable format on save
        vim.b.autoformat = true
        
        -- Add useful keymaps
        local opts = { buffer = true, silent = true }
        
        -- Format the file
        vim.keymap.set("n", "<leader>df", function()
          vim.lsp.buf.format({ async = true })
        end, vim.tbl_extend("force", opts, { desc = "Format Docker Compose" }))
        
        -- Validate compose file (if docker/docker-compose is available)
        vim.keymap.set("n", "<leader>dv", function()
          local file = vim.fn.expand("%:p")
          local cmd = vim.fn.executable("docker") == 1 and "docker compose" or "docker-compose"
          
          if vim.fn.executable("docker") == 0 and vim.fn.executable("docker-compose") == 0 then
            vim.notify("Docker or docker-compose not found", vim.log.levels.WARN)
            return
          end
          
          vim.fn.jobstart(cmd .. " -f " .. vim.fn.shellescape(file) .. " config --quiet", {
            on_exit = function(_, exit_code)
              if exit_code == 0 then
                vim.notify("✓ Docker Compose file is valid", vim.log.levels.INFO)
              else
                vim.notify("✗ Docker Compose file has errors", vim.log.levels.ERROR)
              end
            end,
            stdout_buffered = true,
            stderr_buffered = true,
          })
        end, vim.tbl_extend("force", opts, { desc = "Validate Docker Compose" }))
        
        -- Show services in compose file
        vim.keymap.set("n", "<leader>ds", function()
          local file = vim.fn.expand("%:p")
          local cmd = vim.fn.executable("docker") == 1 and "docker compose" or "docker-compose"
          
          if vim.fn.executable("docker") == 0 and vim.fn.executable("docker-compose") == 0 then
            vim.notify("Docker or docker-compose not found", vim.log.levels.WARN)
            return
          end
          
          vim.fn.jobstart(cmd .. " -f " .. vim.fn.shellescape(file) .. " config --services", {
            on_stdout = function(_, data)
              if data and #data > 0 then
                local services = table.concat(data, "\n")
                if services:match("%S") then
                  vim.notify("Services:\n" .. services, vim.log.levels.INFO)
                end
              end
            end,
            stdout_buffered = true,
          })
        end, vim.tbl_extend("force", opts, { desc = "Show Docker Compose services" }))
      end,
    })
  end,
}
