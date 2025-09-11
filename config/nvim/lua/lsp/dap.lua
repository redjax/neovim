-- DAP and DAP-UI debug adapter
-- \ https://github.com/mfussenegger/nvim-dap
-- \ https://github.com/rcarriga/nvim-dap-ui

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- Mason (DAP installer/manager)
    { "mason-org/mason.nvim" },
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = { "mason-org/mason.nvim" },
      config = function()
        require("mason-nvim-dap").setup({
          automatic_installation = true,
          handlers = {}, -- default handlers
        })
      end,
    },
    -- DAP UI
    {
      "rcarriga/nvim-dap-ui",
      config = function()
        require("dapui").setup()
      end,
    },
    { "nvim-neotest/nvim-nio" },
    {
      "theHamsta/nvim-dap-virtual-text",
      config = function()
        require("nvim-dap-virtual-text").setup({
          enabled = true,
          enabled_commands = true,
          highlight_changed_variables = true,
          highlight_new_as_changed = false,
          show_stop_reason = true,
          commented = false,
          virt_text_pos = "eol",
        })
      end,
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- Keymaps for DAP
    vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP Continue" })
    vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP Step Over" })
    vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP Step Into" })
    vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP Step Out" })
    vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "DAP Toggle Breakpoint" })
    vim.keymap.set("n", "<Leader>dB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "DAP Set Conditional Breakpoint" })
    vim.keymap.set("n", "<Leader>dr", dap.repl.open, { desc = "DAP REPL" })
    vim.keymap.set("n", "<Leader>dl", dap.run_last, { desc = "DAP Run Last" })

    -- DAP UI
    vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "DAP UI Toggle" })
    vim.keymap.set("n", "<Leader>de", dapui.eval, { desc = "DAP Eval" })

    -- Auto open/close dap-ui on session start/end
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
  end,
}
