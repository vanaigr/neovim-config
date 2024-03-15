local vim = vim -- fix lsp warning

LoadModule('main.plugins')
LoadModule('main.remap')

LoadModule('main.lua_explorer')

vim.api.nvim_create_user_command('OpenConfig', function()
    vim.cmd('tabe ' .. vim.fn.stdpath('config'))
end, {})

vim.api.nvim_create_user_command('UP' , "call search('[A-Z][A-Z]', 'besW')", {})
vim.api.nvim_create_user_command('UPN', "call search('[A-Z][A-Z]', 'esW')", {})

vim.opt.fileformat = 'unix'


vim.opt.langmap = "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"
vim.opt.langremap = false

vim.opt.nu = true
vim.opt.relativenumber = true

if true then
  vim.opt.tabstop = 4
  vim.opt.softtabstop = 4
  vim.opt.shiftwidth = 4
else
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2
  vim.opt.shiftwidth = 2
end
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.smarttab = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 4

vim.opt.virtualedit = 'onemore,block'
vim.opt.selection = 'exclusive'

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.cmdheight = 2 -- for remapping ; to open c_CTRL-f

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions - { "c","r","o" }
    end
})
vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = { '*' },
    callback = function()
        require('vim.highlight').on_yank({ higroup = "YankHighlight", timeout = 1000 })
    end
})

-- remove trailing whitespace
local cursorNs = vim.api.nvim_create_namespace("Cursor@init.lua")
local group = vim.api.nvim_create_augroup('FormatOnWrite', { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = group, pattern = { "*" },
    callback = function(ev)
        local bufId = ev.buf
        vim.api.nvim_buf_call(bufId, function()
            local lastCursor = vim.api.nvim_win_get_cursor(0)
            local id = vim.api.nvim_buf_set_extmark(
                0, cursorNs, lastCursor[1]-1, lastCursor[2], {}
            )
            vim.cmd[=[%s/\s\+$//e]=]
            local newPos = vim.api.nvim_buf_get_extmark_by_id(0, cursorNs, id, {})
            newPos[1] = newPos[1] + 1
            vim.api.nvim_win_set_cursor(0, newPos)
            vim.api.nvim_buf_clear_namespace(0, cursorNs, 0, -1)
        end)
    end,
})

--vim.opt.breakindent = true -- breakindent will forever be slow :(
