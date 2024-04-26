local vim = vim -- fix lsp warning

local opt = { remap = true, silent = true }

local m = require('mapping')
m.n('<C-j>', '<C-down>', opt)
m.n('<C-k>', '<C-up>', opt)
m.n('<C-h>', '<S-left>', opt)
m.n('<C-l>', '<S-right>', opt)


local function initColors()
    local p = require('rose-pine.palette')
    vim.api.nvim_set_hl(0, 'VM_Mono'  , { bg = p.love, fg='#ffffff' })
    vim.api.nvim_set_hl(0, 'VM_Extend', { bg = p.pine, fg='#ffffff' })
    vim.api.nvim_set_hl(0, 'VM_Cursor', { bg = p.iris, fg='#21202e' })
    vim.api.nvim_set_hl(0, 'VM_Insert', { bg = '#ffffff', fg='#21202e' })
end

initColors()

local group = vim.api.nvim_create_augroup('MulticursorHighlighting', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = initColors,
    group = group
})
