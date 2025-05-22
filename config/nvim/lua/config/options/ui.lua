-- Show line numbers
vim.opt.number = true
-- Show relative line numbers
vim.opt.relativenumber = false

-- Mouse support
vim.opt.mouse = "a"

-- UI tweaks
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Display invisible characters
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Show live preview of things like search & replace
vim.opt.inccommand = 'split'

-- Dark/light mode
vim.opt.background = 'dark'

local function set_256_colors_if_supported()
  -- Check $TERM for common 256-color suffixes
  local term = os.getenv("TERM") or ""
  local supports_256 = term:find("256color") or term:find("xterm%-color")
  -- Fallback: Use tput if available
  if not supports_256 then
    local handle = io.popen("tput colors 2>/dev/null")
    if handle then
      local result = handle:read("*a")
      handle:close()
      if tonumber(result) and tonumber(result) >= 256 then
        supports_256 = true
      end
    end
  end
  if supports_256 then
    vim.o.t_Co = 256
  end
end

set_256_colors_if_supported()