vim.g.mapleader = ' '

local function am(a, b) qnoremap('', a, b) end
local function im(a, b) qnoremap('i', a, b) end
local function cm(a, b) qnoremap('c', a, b) end
local function nm(a, b) qnoremap('n', a, b) end
local function xm(a, b) qnoremap('x', a, b) end
local function om(a, b) qnoremap('o', a, b) end

--vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

vim.api.nvim_create_user_command('OpenConfig', function()
    vim.cmd('tabe ' .. vim.fn.stdpath('config')) 
end, {})

nm('ZZ', '<Nop>')
nm(']]', '<Nop>')
nm('[[', '<Nop>')
nm('gg', '<Nop>')

am('<left>', '<Nop>')
am('<right>', '<Nop>')
am('<up>', '<Nop>')
am('<down>', '<Nop>')

am('<S-left>', '<Nop>')
am('<S-right>', '<Nop>')
am('<S-up>', '<Nop>')
am('<S-down>', '<Nop>')

am('<C-left>', '<Nop>')
am('<C-right>', '<Nop>')
am('<C-up>', '<Nop>')
am('<C-down>', '<Nop>')

-- absolute search diraction
local searchOpt = { expr = true, remap = false }

vim.keymap.set('n', 'n', "v:searchforward ? 'n' : 'N'", searchOpt)
vim.keymap.set('n', 'N', "v:searchforward ? 'N' : 'n'", searchOpt)


im('<esc>', '<esc>`^') -- prevent cursor from moving when exiting insert mode
im('<C-c>', '<C-c>`^')

nm('$', '$l')

nm('<space>', 'i <esc>`^')
nm('<bs>', 'i<bs><esc>`^')
nm('<enter>', 'i<enter><esc>`^')

nm('<C-z>', ':undo<cr>')
nm('<C-S-z>', ':redo<cr>')

nm('<C-s>', ':%s//gc<left><left><left>') --replace on C-s
xm('<C-s>', ':%s//gc<left><left><left>')

nm('>>', 'i<C-t><Esc>`^') --tabs keep cursor in the same place
nm('<<', 'i<C-d><Esc>`^')

nm(')', '<C-y>')
nm('(', '<C-e>')

nm('{', '_')
xm('{', '_')
nm('}', 'g_')
xm('}', 'g_')

im('<C-k>', '<up>')
im('<C-h>', '<left>')
im('<C-j>', '<down>')
im('<C-l>', '<right>')
cm('<C-k>', '<up>')
cm('<C-h>', '<left>')
cm('<C-j>', '<down>')
cm('<C-l>', '<right>')

vim.keymap.set('n', 'J', "winheight(0)/4.'jzz'", { expr = true })
vim.keymap.set('n', 'K', "winheight(0)/4.'kzz'", { expr = true }) 
vim.keymap.set('x', 'J', "winheight(0)/4.'jzz'", { expr = true })
vim.keymap.set('x', 'K', "winheight(0)/4.'kzz'", { expr = true })


-- some old vim remappings that I have no idea how to replace
require('main.oldVim')

-- line without indentation and newline
om('<leader>l', ":<C-u>normal! _vg_l<cr>")
nm('d<leader>l', "_vg_d\"_dd")
nm('y<leader>l', "_vg_y`^")
xm('<leader>l', "<esc>_vg_")

--variable/property left hand size
om('<leader>v', ":<C-u>call SelectVariableValue(0)<cr>")
nm('d<leader>v', ":call ExecDelLines(0)<cr>")
xm('<leader>v', "<Esc>: call SelectVariableValue(0)<cr>")
nm('y<leader>v', ":call SelectVariableValue(0)<cr>y`^")

om('<leader>V', ":<C-u>call SelectVariableValue(1)<cr>")
nm('d<leader>V', ":call ExecDelLines(1)<cr>")
xm('<leader>V', "<Esc>:call SelectVariableValue(1)<cr>")
nm('y<leader>V', ":call SelectVariableValue(1)<cr>y`^")

om('<leader><C-v>', ":<C-u>call SelectVariableValue(2)<cr>")
nm('d<leader><C-v>', ":call ExecDelLines(2)<cr>")
xm('<leader><C-v>', "<Esc>:call SelectVariableValue(2)<cr>")
nm('y<leader><C-v>', ":call SelectVariableValue(2)<cr>y`^")

nm('g<leader>f', ":call GoToFunctionDecl(0)<cr>")


--[[
vim.keymap.set('n', ';', "getcharsearch().forward ? ';' : ','", searchOpt)
vim.keymap.set('n', ',', "getcharsearch().forward ? ',' : ';'", searchOpt)

local function t(cont, a, b) 
    if cond then
        vim.api.nvim_feedkeys(a, 'n', true)
    else 
        vim.api.nvim_feedkeys(b, 'n', true)
    end
end

nm('n', function() t(vim.v.searchforward, 'n', 'N') end)
nm('N', function() t(vim.v.searchforward, 'N', 'n') end)
--]]
