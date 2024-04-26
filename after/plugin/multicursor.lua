local vim = vim -- fix lsp warning

local done = false
local function setup()
    if done then return end
    done = true

    vim.api.nvim_exec_autocmds('User', { pattern = 'load-multicursor' })
end
local function map(keys) return function() setup(); return keys end end

local m = require('mapping')

local opt = { remap = true, silent = true, expr = true }
m.n('<C-j>', map('<C-down>'), opt)
m.n('<C-k>', map('<C-up>'), opt)
m.n('<C-h>', map('<S-left>'), opt)
m.n('<C-l>', map('<S-right>'), opt)
m.n('<C-n>', map('<Plug>I_LOVE_HACKS_3'), opt)

vim.api.nvim_exec2(
    [==[
    let g:VM_maps = {}
    let g:VM_maps['Find Under'] = '<Plug>I_LOVE_HACKS_3'
    ]==],
    { output = false }
)

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
