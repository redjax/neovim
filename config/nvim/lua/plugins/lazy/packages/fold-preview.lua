-- Fold preview https://github.com/anuvyklack/fold-preview.nvim

return {
    enabled = true,
    'anuvyklack/fold-preview.nvim',
    dependencies = {
        'anuvyklack/keymap-amend.nvim'
    },
    config = function()
        require('fold-preview').setup({
            -- Your configuration goes here.
        })
    end
}