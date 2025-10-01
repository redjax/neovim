-- Messages https://github.com/AckslD/messages.nvim

local function clip_val(min, val, max)
  if val < min then
    return min
  elseif val > max then
    return max
  else
    return val
  end
end

return {
  {
    'AckslD/messages.nvim',
    config = function()
      require('messages').setup({
        command_name = 'Messages',
        -- should prepare a new buffer and return the winid
        -- by default opens a floating window
        -- provide a different callback to change this behaviour
        -- @param opts: the return value from float_opts
        prepare_buffer = function(opts)
            local buf = vim.api.nvim_create_buf(false, true)
            return vim.api.nvim_open_win(buf, true, opts)
        end,
        -- should return options passed to prepare_buffer
        -- @param lines: a list of the lines of text
        buffer_opts = function(lines)
            local gheight = vim.api.nvim_list_uis()[1].height
            local gwidth = vim.api.nvim_list_uis()[1].width
            return {
            relative = 'editor',
            width = gwidth - 2,
            height = clip_val(1, #lines, gheight * 0.5),
            anchor = 'SW',
            row = gheight - 1,
            col = 0,
            style = 'minimal',
            border = 'rounded',
            zindex = 1,
            }
        end,
        -- what to do after opening the float
        post_open_float = function(winnr)
        end
        })
    end,
  }
}
