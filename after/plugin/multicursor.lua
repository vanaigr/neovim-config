local vim = vim -- fix lsp warning

local opt = { remap = true, silent = true }

local m = require('mapping')
m.n('<C-j>', '<C-down>', opt)
m.n('<C-k>', '<C-up>', opt)
m.n('<C-h>', '<S-left>', opt)
m.n('<C-l>', '<S-right>', opt)

vim.g.VM_Mono_hl   = 'VM_Cursors'
vim.g.VM_Extend_hl = 'VM_Selection'
vim.g.VM_Cursor_hl = 'VM_SelectionCursor'
vim.g.VM_Insert_hl = 'VM_InsertCursor'

local function initColors()
    local p = require('rose-pine.palette')
    vim.api.nvim_set_hl(0, 'VM_Cursors'        , { bg = p.love, fg='#ffffff', blend=100 })
    vim.api.nvim_set_hl(0, 'VM_Selection'      , { bg = p.pine, fg='#ffffff', blend=100 })
    vim.api.nvim_set_hl(0, 'VM_SelectionCursor', { bg = p.iris, fg='#21202e', blend=100 })
    vim.api.nvim_set_hl(0, 'VM_InsertCursor'   , { bg = '#ffffff', fg='#21202e', blend=100 })
end

initColors()

local group = vim.api.nvim_create_augroup('MulticursorHighlighting', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = initColors,
    group = group
})
