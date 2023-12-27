vim.keymap.set({ 'n' }, 's', function() require('nvim-easyword').jump({}) end)
vim.keymap.set({ 'x', 'o' }, 'x', function() require('nvim-easyword').jump() end)


local group = vim.api.nvim_create_augroup('EasywordHighlighting', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = function() require('nvim-easyword').apply_default_highlight() end,
    group = group
})
