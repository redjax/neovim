-- Data viewer (CSV, TSV) https://github.com/VidocqH/data-viewer.nvim

return {
  src = "https://github.com/VidocqH/data-viewer.nvim",
  name = "data-viewer.nvim",
  setup = function()
    require("data-viewer").setup({
      autoDisplayWhenOpenFile = false,
      maxLineEachTable = 100,
      columnColorEnable = true,
      columnColorRoulette = {
        "DataViewerColumn0",
        "DataViewerColumn1",
        "DataViewerColumn2",
      },
      view = {
        float = true,
        width = 0.8,
        height = 0.8,
        zindex = 50,
      },
      keymap = {
        quit = "q",
        next_table = "<C-l>",
        prev_table = "<C-h>",
      },
    })
  end,
}
