-- Bufferline https://github.com/akinsho/bufferline.nvim

return {
  src = "https://github.com/akinsho/bufferline.nvim",
  name = "bufferline.nvim",
  version = "main",

  setup = function()
    local opts = { noremap = true, silent = true }

    require("bufferline").setup({
      -- You can add bufferline options here if you want; leave empty for defaults
    })

    -- Cycle between buffers with Shift + h/l
    vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", opts)
    vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", opts)

    -- Go to specific buffer by number with <leader>{1-9}
    vim.keymap.set("n", "<leader>1", "<cmd>BufferLineGoToBuffer 1<cr>", opts)
    vim.keymap.set("n", "<leader>2", "<cmd>BufferLineGoToBuffer 2<cr>", opts)
    vim.keymap.set("n", "<leader>3", "<cmd>BufferLineGoToBuffer 3<cr>", opts)
    vim.keymap.set("n", "<leader>4", "<cmd>BufferLineGoToBuffer 4<cr>", opts)
    vim.keymap.set("n", "<leader>5", "<cmd>BufferLineGoToBuffer 5<cr>", opts)
    vim.keymap.set("n", "<leader>6", "<cmd>BufferLineGoToBuffer 6<cr>", opts)
    vim.keymap.set("n", "<leader>7", "<cmd>BufferLineGoToBuffer 7<cr>", opts)
    vim.keymap.set("n", "<leader>8", "<cmd>BufferLineGoToBuffer 8<cr>", opts)
    vim.keymap.set("n", "<leader>9", "<cmd>BufferLineGoToBuffer 9<cr>", opts)

    -- Optional: close current buffer with <leader>bd
    vim.keymap.set("n", "<leader>bd", "<cmd>bd<cr>", opts)
  end,
}
