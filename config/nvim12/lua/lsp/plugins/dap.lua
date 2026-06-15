-- Debug Adapter Protocol client for Neovim
-- https://github.com/mfussenegger/nvim-dap

return {
  src = "https://github.com/mfussenegger/nvim-dap",
  name = "nvim-dap",
  cmd = {
    "DapContinue",
    "DapToggleBreakpoint",
    "DapStepOver",
    "DapStepInto",
    "DapStepOut",
    "DapTerminate",
    "DapDisconnect",
  },
  keys = {
    { "<F5>", desc = "DAP Continue" },
    { "<F10>", desc = "DAP Step Over" },
    { "<F11>", desc = "DAP Step Into" },
    { "<F12>", desc = "DAP Step Out" },
    { "<Leader>db", desc = "DAP Toggle Breakpoint" },
    { "<Leader>dB", desc = "DAP Conditional Breakpoint" },
    { "<Leader>dr", desc = "DAP REPL" },
    { "<Leader>dl", desc = "DAP Run Last" },
    { "<Leader>du", desc = "DAP UI Toggle" },
    { "<Leader>de", desc = "DAP Eval" },
  },
  lazy = true,

  setup = function()
    local dap = require("dap")

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
    vim.keymap.set("n", "<Leader>du", function()
      local ok_dapui, dapui = pcall(require, "dapui")
      if ok_dapui then
        dapui.toggle()
      end
    end, { desc = "DAP UI Toggle" })
    vim.keymap.set("n", "<Leader>de", function()
      local ok_dapui, dapui = pcall(require, "dapui")
      if ok_dapui then
        dapui.eval()
      end
    end, { desc = "DAP Eval" })

    -- Auto open/close dap-ui on session start/end
    dap.listeners.after.event_initialized["dapui_config"] = function()
      local ok_dapui, dapui = pcall(require, "dapui")
      if ok_dapui then
        dapui.open()
      end
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      local ok_dapui, dapui = pcall(require, "dapui")
      if ok_dapui then
        dapui.close()
      end
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      local ok_dapui, dapui = pcall(require, "dapui")
      if ok_dapui then
        dapui.close()
      end
    end
  end,
}
