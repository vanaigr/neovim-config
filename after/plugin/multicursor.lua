local opt = { remap = true, silent = true }

vim.keymap.set('n', '<C-j>', '<C-down>', opt)
vim.keymap.set('n', '<C-k>', '<C-up>', opt)
vim.keymap.set('n', '<C-h>', '<S-left>', opt)
vim.keymap.set('n', '<C-l>', '<S-right>', opt) 

vim.g.VM_Mono_hl   = 'VM_Cursors'
vim.g.VM_Extend_hl = 'VM_Selection'
vim.g.VM_Cursor_hl = 'VM_SelectionCursor'
vim.g.VM_Insert_hl = 'VM_InsertCursor'
