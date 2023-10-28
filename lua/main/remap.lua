vim.g.mapleader = ' '

local function am(a, b, o) qnoremap('' , a, b, o) end
local function im(a, b, o) qnoremap('i', a, b, o) end
local function cm(a, b, o) qnoremap('c', a, b, o) end
local function nm(a, b, o) qnoremap('n', a, b, o) end
local function xm(a, b, o) qnoremap('x', a, b, o) end
local function om(a, b, o) qnoremap('o', a, b, o) end

--vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

nm('Q', '<Nop>')
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
nm('a', 'ea')

local function fixEnd(e) return function() vim.cmd('silent! normal! h'..e..'l') end end
nm('e' , fixEnd('e'))
nm('E' , fixEnd('E'))
nm('ge', fixEnd('ge'))
nm('gE', fixEnd('gE'))

--nm('<space>', 'i <esc>`^') -- treated as <leader>, long delay
nm('<space>', '<Nop>') -- treated as <leader>, long delay
nm('<C-space>', 'i <esc>`^')
nm('<bs>', 'i<bs><esc>`^')
nm('<enter>', 'i<enter><esc>`^')

nm('<C-u>', '<cmd>redo<cr>')
nm('<C-z>', '<cmd>undo<cr>')
nm('<C-S-z>', '<cmd>redo<cr>')

nm('<C-s>', ':%s//gc<left><left><left>') --replace on C-s
xm('<C-s>', ':s//gc<left><left><left>')

nm('>>', 'i<C-t><Esc>`^') --tabs keep cursor in the same place
nm('<<', 'i<C-d><Esc>`^')

nm(')', '<C-y>') -- move screen immediately without cursor
nm('(', '<C-e>')

nm('{', '_') -- move to start/end of line without leading/trailing spaces
xm('{', '_')
nm('}', 'g_')
xm('}', 'g_')

im('<C-bs>', '<C-w>')
im('<C-k>', '<up>') -- navigation in insert/command mode (instead of arrows)
im('<C-h>', '<left>')
im('<C-j>', '<down>')
im('<C-l>', '<right>')
cm('<C-k>', '<up>')
cm('<C-h>', '<left>')
cm('<C-j>', '<down>')
cm('<C-l>', '<right>')

vim.keymap.set('n', 'J', "winheight(0)/4.'j'", { expr = true })
vim.keymap.set('n', 'K', "winheight(0)/4.'k'", { expr = true }) 
--vim.keymap.set('x', 'J', "winheight(0)/4.'jzz'", { expr = true })
--vim.keymap.set('x', 'K', "winheight(0)/4.'kzz'", { expr = true })
vim.keymap.set('n', 'H', '10h', { remap = true })
vim.keymap.set('n', 'L', '10l', { remap = true })
vim.keymap.set('x', 'H', '10h', { remap = true })
vim.keymap.set('x', 'L', '10l', { remap = true })

-- join lines
nm('gj', 'J')
nm('gJ', 'kJ')

nm('<leader>u', "<cmd>UndotreeShow<cr>")

xm('gp', "\"_dP")
nm('d_', function() --delete from first printable char to cursor
    local destr = table.unpack or unpack
    local buf, line, col, offset = destr(vim.fn.getpos('.'))
    vim.cmd'keepjumps silent! normal! _'
    local _, startLine, startCol, _ = destr(vim.fn.getpos('.'))
    vim.fn.setpos('.', { buf, line, col, offset })
    if line ~= startLine or startCol >= col then
        print(line, startLine, startCol, col)
        return
    else
        vim.cmd("normal! d" .. startCol .. "|")
    end
end)

-- work with system clipboard without mentioning the register
nm('<leader>y', "\"+y")
nm('<leader>Y', "\"+Y")
xm('<leader>y', "\"+y")

nm('<leader>p', "\"+p")
nm('<leader>P', "\"+P")
xm('<leader>p', "\"+p")

nm('<leader>d', "\"+d")
nm('<leader>D', "\"+D")
xm('<leader>d', "\"+d")


local vimBindingsLoaded = pcall(require, 'main.vim')
if not vimBindingsLoaded then
    print "ERROR: vim bindings not loaded!"
else
    --change font size
    nm('<C-=>', '<cmd>call AdjustFontSize(1)<cr>')
    nm('<C-->', '<cmd>call AdjustFontSize(-1)<cr>')
    --execute current line/selection
    nm('<leader>rdk', "<cmd>call CallLine(v:true, function('ExecKeys'))<cr>")
    nm('<leader>rdv', "<cmd>call CallLine(v:true, function('ExecVim'))<cr>")
    nm('<leader>rdl', "<cmd>call CallLine(v:true, function('ExecLua'))<cr>")

    xm('<leader>rdk', "<esc><cmd>call CallSelection(v:true, function('ExecKeys'))<cr>")
    xm('<leader>rdv', "<esc><cmd>call CallSelection(v:true, function('ExecVim'))<cr>")
    xm('<leader>rdl', "<esc><cmd>call CallSelection(v:true, function('ExecLua') )<cr>")

    nm('<leader>rk', "<cmd>call CallLine(v:false, function('ExecKeys'))<cr>")
    nm('<leader>rv', "<cmd>call CallLine(v:false, function('ExecVim'))<cr>")
    nm('<leader>rl', "<cmd>call CallLine(v:false, function('ExecLua'))<cr>")

    xm('<leader>rk', "<esc><cmd>call CallSelection(v:false, function('ExecKeys'))<cr>")
    xm('<leader>rv', "<esc><cmd>call CallSelection(v:false, function('ExecVim'))<cr>")
    xm('<leader>rl', "<esc><cmd>call CallSelection(v:false, function('ExecLua') )<cr>")

    -- some old vim remappings that I have no idea how to replace
    -- line without indentation and newline
    om('<leader>l', "<cmd>normal! _vg_l<cr>")
    nm('d<leader>l', "_vg_d\"_dd")
    nm('y<leader>l', "_vg_y`^")
    xm('<leader>l', "<esc>_vg_")

    --variable/property left hand size
    nm('d<leader>v', "<cmd>call ExecDelLines(0)<cr>")
    nm('y<leader>v', "<cmd>call SelectVariableValue(0)<cr>y`^")
    xm('<leader>v', "<esc><cmd>call SelectVariableValue(0)<cr>")
    om('<leader>v', "<cmd>call SelectVariableValue(0)<cr>")

    --go to function declaration from where it is called
    nm('g<leader>f', "<cmd>call GoToFunctionDecl()<cr>")

    --select one part of camelCase word (special case if the word contains uppercase acronym/abbreviation, doesn't work with numbers etc.)
    nm('<leader>q', "<cmd>call MoveCapitalWord()<cr>")
    xm('<leader>q', "<esc><cmd>call SelectCapitalWord()<cr>")
    om('<leader>q', "<cmd>call SelectCapitalWord()<cr>")
end
