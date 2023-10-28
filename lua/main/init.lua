LoadModule('main.plugins')
LoadModule('main.remap')

LoadModule('main.lua_explorer')

vim.api.nvim_create_user_command('OpenConfig', function()
    vim.cmd('tabe ' .. vim.fn.stdpath('config'))
end, {})

vim.api.nvim_create_user_command('UP' , "call search('[A-Z][A-Z]', 'besW')", {})
vim.api.nvim_create_user_command('UPN', "call search('[A-Z][A-Z]', 'esW')", {})


vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 4

vim.opt.virtualedit = 'onemore,block'
vim.opt.selection = 'exclusive'

vim.opt.ignorecase = true
vim.opt.smartcase = true                                                       


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
