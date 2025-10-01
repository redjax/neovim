-- Scretch https://github.com/0xJohnnyboy/scretch.nvim

return {
  {
    "0xJohnnyboy/scretch.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" }, -- or 'ibhagwan/fzf-lua'
    config = function()
      require("scretch").setup({
        scretch_dir = vim.fn.stdpath('data') .. '/scretch/', 
        template_dir = vim.fn.stdpath('data') .. '/scretch/templates',
        use_project_dir = {
          auto_create_project_dir = false,
          scretch = false,
          scretch_project_dir = ".scretch/",
          template = false,
          template_project_dir = ".scretch/templates/",
        },
        default_name = "scretch_",
        default_type = "txt",
        split_cmd = "vsplit",
        backend = "telescope.builtin",
      })

      -- Keymaps go here
      local s = require("scretch")
      vim.keymap.set("n", "<leader>sn", s.new, { desc = "New scratch file" })
      vim.keymap.set("n", "<leader>snn", s.new_named, { desc = "New named scratch" })
      vim.keymap.set("n", "<leader>sft", s.new_from_template, { desc = "New scratch from template" })
      vim.keymap.set("n", "<leader>sl", s.last, { desc = "Last scratch" })
      vim.keymap.set("n", "<leader>ss", s.search, { desc = "Search scratches" })
      vim.keymap.set("n", "<leader>st", s.edit_template, { desc = "Edit templates" })
      vim.keymap.set("n", "<leader>sg", s.grep, { desc = "Grep scratches" })
      vim.keymap.set("n", "<leader>sv", s.explore, { desc = "Explore scratches" })
      vim.keymap.set("n", "<leader>sat", s.save_as_template, { desc = "Save as scratch template" })

      vim.keymap.set("n", "<leader>smsp", s.scretch_use_project_mode, { desc = "Use project mode for scratches" })
      vim.keymap.set("n", "<leader>smsa", s.scretch_use_auto_mode, { desc = "Use auto mode for scratches" })
      vim.keymap.set("n", "<leader>smsg", s.scretch_use_global_mode, { desc = "Use global mode for scratches" })
      vim.keymap.set("n", "<leader>smtp", s.template_use_project_mode, { desc = "Use project mode for templates" })
      vim.keymap.set("n", "<leader>smta", s.template_use_auto_mode, { desc = "Use auto mode for templates" })
      vim.keymap.set("n", "<leader>smtg", s.template_use_global_mode, { desc = "Use global mode for templates" })
    end,
  },
}
