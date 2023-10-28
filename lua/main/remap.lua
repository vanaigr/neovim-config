local m = require('mapping')

vim.g.mapleader = ' '

--vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

m.n('Q', '<Nop>')
m.n('ZZ', '<Nop>')
m.n(']]', '<Nop>')
m.n('[[', '<Nop>')
m.n('gg', '<Nop>')

m.a('<left>', '<Nop>')
m.a('<right>', '<Nop>')
m.a('<up>', '<Nop>')
m.a('<down>', '<Nop>')

m.a('<S-left>', '<Nop>')
m.a('<S-right>', '<Nop>')
m.a('<S-up>', '<Nop>')
m.a('<S-down>', '<Nop>')

m.a('<C-left>', '<Nop>')
m.a('<C-right>', '<Nop>')
m.a('<C-up>', '<Nop>')
m.a('<C-down>', '<Nop>')

-- absolute search diraction
local searchOpt = { expr = true, remap = false }
vim.keymap.set('n', 'n', "v:searchforward ? 'n' : 'N'", searchOpt)
vim.keymap.set('n', 'N', "v:searchforward ? 'N' : 'n'", searchOpt)

m.i('<esc>', '<esc>`^') -- prevent cursor from moving when exiting insert mode
m.i('<C-c>', '<C-c>`^')

m.n('$', '$l')
m.n('a', 'ea')

local function fixEnd(e) return function() vim.cmd('silent! normal! h'..e..'l') end end
m.n('e' , fixEnd('e'))
m.n('E' , fixEnd('E'))
m.n('ge', fixEnd('ge'))
m.n('gE', fixEnd('gE'))

--m.n('<space>', 'i <esc>`^') -- treated as <leader>, long delay
m.n('<space>', '<Nop>') -- treated as <leader>, long delay
m.n('<C-space>', 'i <esc>`^')
m.n('<bs>', 'i<bs><esc>`^')
m.n('<enter>', 'i<enter><esc>`^')

m.n('<C-u>', '<cmd>redo<cr>')
m.n('<C-z>', '<cmd>undo<cr>')
m.n('<C-S-z>', '<cmd>redo<cr>')

m.n('<C-s>', ':%s//gc<left><left><left>') --replace on C-s
m.x('<C-s>', ':s//gc<left><left><left>')

m.n('>>', 'i<C-t><Esc>`^') --tabs keep cursor in the same place
m.n('<<', 'i<C-d><Esc>`^')

m.n(')', '<C-y>') -- move screen immediately without cursor
m.n('(', '<C-e>')

m.n('{', '_') -- move to start/end of line without leading/trailing spaces
m.x('{', '_')
m.n('}', 'g_')
m.x('}', 'g_')

m.i('<C-bs>', '<C-w>')
m.i('<C-k>', '<up>') -- navigation in insert/command mode (instead of arrows)
m.i('<C-h>', '<left>')
m.i('<C-j>', '<down>')
m.i('<C-l>', '<right>')
m.c('<C-k>', '<up>')
m.c('<C-h>', '<left>')
m.c('<C-j>', '<down>')
m.c('<C-l>', '<right>')

vim.keymap.set('n', 'J', "winheight(0)/4.'j'", { expr = true })
vim.keymap.set('n', 'K', "winheight(0)/4.'k'", { expr = true }) 
--vim.keymap.set('x', 'J', "winheight(0)/4.'jzz'", { expr = true })
--vim.keymap.set('x', 'K', "winheight(0)/4.'kzz'", { expr = true })
vim.keymap.set('n', 'H', '10h', { remap = true })
vim.keymap.set('n', 'L', '10l', { remap = true })
vim.keymap.set('x', 'H', '10h', { remap = true })
vim.keymap.set('x', 'L', '10l', { remap = true })

-- join lines
m.n('gj', 'J')
m.n('gJ', 'kJ')

m.n('<leader>u', "<cmd>UndotreeShow<cr>")

m.x('gp', "\"_dP")
m.n('d_', function() --delete from first printable char to cursor
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
m.n('<leader>y', "\"+y")
m.n('<leader>Y', "\"+Y")
m.x('<leader>y', "\"+y")

m.n('<leader>p', "\"+p")
m.n('<leader>P', "\"+P")
m.x('<leader>p', "\"+p")

m.n('<leader>d', "\"+d")
m.n('<leader>D', "\"+D")
m.x('<leader>d', "\"+d")


local vimBindingsLoaded = pcall(require, 'main.vim')
if not vimBindingsLoaded then
    print "ERROR: vim bindings not loaded!"
else
    --change font size
    m.n('<C-=>', '<cmd>call AdjustFontSize(1)<cr>')
    m.n('<C-->', '<cmd>call AdjustFontSize(-1)<cr>')
    --execute current line/selection
    m.n('<leader>rdk', "<cmd>call CallLine(v:true, function('ExecKeys'))<cr>")
    m.n('<leader>rdv', "<cmd>call CallLine(v:true, function('ExecVim'))<cr>")
    m.n('<leader>rdl', "<cmd>call CallLine(v:true, function('ExecLua'))<cr>")

    m.x('<leader>rdk', "<esc><cmd>call CallSelection(v:true, function('ExecKeys'))<cr>")
    m.x('<leader>rdv', "<esc><cmd>call CallSelection(v:true, function('ExecVim'))<cr>")
    m.x('<leader>rdl', "<esc><cmd>call CallSelection(v:true, function('ExecLua') )<cr>")

    m.n('<leader>rk', "<cmd>call CallLine(v:false, function('ExecKeys'))<cr>")
    m.n('<leader>rv', "<cmd>call CallLine(v:false, function('ExecVim'))<cr>")
    m.n('<leader>rl', "<cmd>call CallLine(v:false, function('ExecLua'))<cr>")

    m.x('<leader>rk', "<esc><cmd>call CallSelection(v:false, function('ExecKeys'))<cr>")
    m.x('<leader>rv', "<esc><cmd>call CallSelection(v:false, function('ExecVim'))<cr>")
    m.x('<leader>rl', "<esc><cmd>call CallSelection(v:false, function('ExecLua') )<cr>")

    -- some old vim remappings that I have no idea how to replace
    -- line without indentation and newline
    m.o('<leader>l', "<cmd>normal! _vg_l<cr>")
    m.n('d<leader>l', "_vg_d\"_dd")
    m.n('y<leader>l', "_vg_y`^")
    m.x('<leader>l', "<esc>_vg_")

    --variable/property left hand size
    m.n('d<leader>v', "<cmd>call ExecDelLines(0)<cr>")
    m.n('y<leader>v', "<cmd>call SelectVariableValue(0)<cr>y`^")
    m.x('<leader>v', "<esc><cmd>call SelectVariableValue(0)<cr>")
    m.o('<leader>v', "<cmd>call SelectVariableValue(0)<cr>")

    --go to function declaration from where it is called
    m.n('g<leader>f', "<cmd>call GoToFunctionDecl()<cr>")

    --select one part of camelCase word (special case if the word contains uppercase acronym/abbreviation, doesn't work with numbers etc.)
    m.n('<leader>q', "<cmd>call MoveCapitalWord()<cr>")
    m.x('<leader>q', "<esc><cmd>call SelectCapitalWord()<cr>")
    m.o('<leader>q', "<cmd>call SelectCapitalWord()<cr>")
end
