-- Sleuth heuristic buffer options https://github.com/tpope/vim-sleuth

return {
    enabled = true,
    "tpope/vim-sleuth",
    -- Loads when you open a file (efficient and fast)
    event = "BufReadPre",
}