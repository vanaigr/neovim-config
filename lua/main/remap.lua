local vim = vim -- fix lsp warning

local m = require('mapping')

m.i('<S-F1>', '<Esc>`^') -- I set up F1 somewhere and now it does Shift+F1 insead of opening help
m.c('<S-F1>', '<Esc>')   -- but I don't know where ...
m.n('Q', '')

m.i('<esc>', '<esc>`^') -- prevent cursor from moving when exiting insert mode
m.i('<C-c>', '<C-c>`^')

m.nx('<A-i>', '<esc>')
m.i('<A-i>', '<esc>`^')
m.c('<A-i>', '<C-c>')

m.n('<A-w>', '<C-w>')

m.n('<A-s>', '<cmd>w<cr>')
m.n('<A-q>', '<cmd>q<cr>')
m.n('<A-a>', '<cmd>so<cr>')

for _, key in ipairs{ 'E', 'gE' } do
  m.n(key, '<cmd>silent! normal! h'..key..'l<cr>')
end

-- make move-to-end mapping move one past end
m.n('$', 'g$') -- why does g$ already do 'l' with onemore ?? regular $ would be '$l'
m.n('_', 'g^')

m.n('r', 'gr')
m.n('a', 'A')
m.n('A', 'a')
m.n('x', '"_x')

-- add indentation when entering insert mode
m.n('i', function() -- https://stackoverflow.com/a/3020022/18704284
    if vim.v.count <= 1 and vim.fn.match(vim.fn.getline('.'), '\\v[^[:space:]]') == -1 then
        return '"_cc'
    else
        return 'i'
    end
end, { expr = true })

m.n('<space>', '')
m.n('<bs>', 'i<bs><esc>`^')
m.n('<enter>', 'i<enter><esc>`^')

m.n('<A-o>', 'o<Esc>')
m.i('<A-o>', '<Esc>`^o')
m.c('<A-o>', '<CR>')

m.n('<A-n>', '<cmd>noh<cr>')

m.n('<A-t>', 'gt')
m.n('<A-g>', 'gT')

m.ic('<C-bs>', '<C-w>')

m.n('<C-s>', ':%s//gc<left><left><left>') --replace on C-s
m.x('<C-s>', ':s//gc<left><left><left>')

m.n('>>', 'i<C-t><Esc>`^') --tabs keep cursor in the same place
m.n('<<', 'i<C-d><Esc>`^')
m.n('<A-.>', 'i<C-t><Esc>`^')
m.n('<A-,>', 'i<C-d><Esc>`^')
m.i('<Tab>', '<C-t>')
m.i('<S-Tab>', '<C-d>')

local ns = vim.api.nvim_create_namespace('')
local function keepSelection(command)
    local startPos = vim.fn.getpos('v')
    local endPos   = vim.fn.getpos('.')
    local sMark = vim.api.nvim_buf_set_extmark(0, ns, startPos[2]-1, startPos[3]-1, {})
    local eMark = vim.api.nvim_buf_set_extmark(0, ns, endPos  [2]-1, endPos  [3]-1, {})

    vim.cmd(command)

    local sPos = vim.api.nvim_buf_get_extmark_by_id(0, ns, sMark, {})
    local ePos = vim.api.nvim_buf_get_extmark_by_id(0, ns, eMark, {})
    vim.api.nvim_buf_del_extmark(0, ns, sMark)
    vim.api.nvim_buf_del_extmark(0, ns, eMark)

    vim.fn.setpos(".", { 0, sPos[1]+1, sPos[2]+1, 0 })
    vim.cmd('normal! '..vim.fn.visualmode())
    vim.fn.setpos(".", { 0, ePos[1]+1, ePos[2]+1, 0 })
end

-- keep visual selection when changing indentation
m.x('<A-.>', function() keepSelection('normal! >') end)
m.x('<A-,>', function() keepSelection('normal! <') end)

m.nx(')', '<C-y>') -- move screen but not cursor
m.nx('(', '<C-e>')
m.nx('<A-0>', '<C-y>')
m.nx('<A-9>', '<C-e>')

m.nx('{', '_') -- move to start/end of line without leading/trailing spaces
m.nx('}', 'g_l')

m.t('<C-q>', '<C-\\><C-n>') -- go to normal mode in terminal

m.n('n', '<cmd>keepjumps normal! n<cr>')
m.n('N', '<cmd>keepjumps normal! N<cr>')


-- add insert and normal modes to command mode
local commandGoup = vim.api.nvim_create_augroup('CommandGoup', { clear = true })

local function setup_cmd()
    local winId = vim.api.nvim_get_current_win()
    local bufId = vim.api.nvim_win_get_buf(winId)

    local cmdOpt = { scope = 'local' }
    local height = vim.api.nvim_get_option_value('cmdheight', cmdOpt)
    local newHeight = math.max(height-2, 0)
    vim.api.nvim_set_option_value('cmdheight', newHeight, cmdOpt)

    vim.api.nvim_create_autocmd('CmdwinLeave', {
        group = commandGoup, once = true,
        callback = function()
            if vim.api.nvim_get_option_value('cmdheight', cmdOpt) == newHeight then
                vim.api.nvim_set_option_value('cmdheight', height, cmdOpt)
            end
        end,
    })

    vim.api.nvim_exec_autocmds('User', { pattern = 'SetupCommandCMP' })

    -- nvim buf set opt backspace - eol

    vim.api.nvim_win_set_height(winId, 1)
    vim.api.nvim_win_set_option(winId, 'number', false)
    vim.api.nvim_win_set_option(winId, 'relativenumber', false)

    local mapOpts = { buffer = bufId }

    m.n(';', function() vim.api.nvim_feedkeys(':', 'n', false) end, mapOpts)
    m.n('<Esc>', function() vim.api.nvim_win_close(winId, true) end, mapOpts)
    m.n('<C-c>', function() vim.api.nvim_win_close(winId, true) end, mapOpts)
    m.n('<A-;>', function() vim.api.nvim_win_close(winId, true) end, mapOpts)
    m.n('<cr>', '<cr>', mapOpts) -- default cr behavior
    m.qnoremap({ 'i', 'n', }, '<A-;>', function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
      vim.api.nvim_win_close(winId, true)
    end, mapOpts)
    m.qnoremap({ 'i', 'n', }, '<A-e>', function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
      vim.api.nvim_win_close(winId, true)
    end, mapOpts)
    m.n('<A-o>', '<Enter>', mapOpts)
    m.i('<A-o>', '<Esc><Enter>', mapOpts)

    vim.cmd.startinsert()
end

local function command_mode()
    vim.api.nvim_create_autocmd('CmdwinEnter', { group = commandGoup, once = true, callback = setup_cmd })
    return 'q:'
end
local cmd_opts = { expr = true }

m.nx('<A-e>', command_mode, cmd_opts)
m.i('<A-e>', function() return '<Esc>' .. command_mode() end, cmd_opts)


-- scroll
local ctrlY = vim.api.nvim_replace_termcodes('<C-y>', true, false, true)
local ctrlE = vim.api.nvim_replace_termcodes('<C-e>', true, false, true)

local function scroll(m1)
    return function()
        local start_row = vim.fn.winline()

        local distance = math.floor(vim.fn.winheight(0) * 0.25)
        vim.api.nvim_feedkeys(distance .. m1, 'nx', false)

        local seen = { [start_row] = true }
        while true do
            local cur_row = vim.fn.winline()
            if seen[cur_row] then break end
            seen[cur_row] = true
            if cur_row < start_row then
                vim.api.nvim_feedkeys(ctrlY, 'nx', false)
            else
                vim.api.nvim_feedkeys(ctrlE, 'nx', false)
            end
        end
    end
end

m.nx('<A-k>', scroll('gk'))
m.nx('<A-j>', scroll('gj'))

-- <A-j> and <A-k> are remapped system-wide to these keys
m.nx('<Up>', scroll('gk'))
m.nx('<Down>', scroll('gj'))


m.nx('<A-h>', '_')
m.nx('<A-l>', 'g_l')

m.nx('j', 'gj')
m.nx('k', 'gk')

m.nxo('J', '5j')
m.nxo('K', '5k')

m.n('gj', 'J')

m.n('<leader>u', "<cmd>UndotreeShow<cr>")

m.o('_', function() vim.cmd'keepjumps silent! normal! _' end)

-- work with system clipboard without mentioning the register
m.nx('<leader>y', "\"+y")
m.nx('<leader>d', "\"+d")

-- line without indentation and newline
m.n('d<leader>l', "_vg_d\"_dd")
m.n('y<leader>l', "_vg_y`^")
m.o('<leader>l', "<cmd>normal! _vg_l<cr>")
m.x('<leader>l', "<esc>_vg_")

m.ic('<A-u>', '<bs>')
m.n('<A-u>', 'i<bs><esc>`^')

m.n('<A-y>', 'yy')
m.n('<A-d>', '"_dd')
m.x('<A-d>', '"_d')


-- paste
m.o('gp', function()
    --local pos = vim.fn.getpos('.')
    --vim.api.nvim_buf_set_mark(0, '`', pos[2], pos[3], {})
    local s = vim.api.nvim_buf_get_mark(0, '[')
    local e = vim.api.nvim_buf_get_mark(0, ']')
    print(vim.inspect({ s=s, e=e }))
    --vim.api.nvim_win_set_cursor(0, { s[1], s[2] })
    --vim.cmd('normal! v')
end)

m.n('gp', function() -- select last changed area
    local pos = vim.fn.getpos('.')
    vim.api.nvim_buf_set_mark(0, '`', pos[2], pos[3], {})
    local s = vim.api.nvim_buf_get_mark(0, '[')
    local e = vim.api.nvim_buf_get_mark(0, ']')
    vim.api.nvim_win_set_cursor(0, { s[1], s[2] })
    vim.cmd('normal! v')
    if vim.opt.selection._value == 'exclusive' and e[2] < 2147483647 then e[2] = e[2] + 1 end -- vim's position is inconsistent between yank/paste and insert https://superuser.com/q/1465550
    vim.api.nvim_win_set_cursor(0, { e[1], e[2] })
end)

m.n('<leader>p', function()
    local register = '+'
    --local regInfo = vim.fn.getreginfo(register)
    local regValue = vim.fn.getreg(register)
    vim.fn.setreg(register, regValue, 'V')
    vim.cmd([=[normal! m`]=])
    vim.cmd([=[keepjumps normal! "]=]..register.."p`]l")
    --vim.fn.setreg(register, regInfo) -- doesn't work work for some reason, regtype stays V, even though regInfo.type is 'v'
end)
m.x('<leader>p', function()
    local visualMode = vim.fn.mode():sub(1, 1)
    local register = '+'
    local regInfo = vim.fn.getreginfo(register)
    vim.fn.setreg(register, regInfo.regcontents, visualMode)
    vim.cmd([=[normal! m`]=])
    vim.cmd([=[keepjumps normal! "]=]..register.."p`]l")
    vim.fn.setreg(register, regInfo)
end)

m.n('<A-p>', function()
    local register = vim.api.nvim_get_vvar('register')
    local regType = vim.fn.getregtype(register)
    if regType == '' then --empty or unknown
        return ''
    else
        local line = vim.fn.getline('.')
        if line == '' then
            vim.cmd('put! '..register)
            vim.cmd([=[keepjumps normal! `]l]=])
        else
            vim.cmd('put '..register)
            vim.cmd([=[keepjumps normal! `]l]=])
        end
    end
end)

m.n('p', function()
    local register = vim.api.nvim_get_vvar('register')
    local regType = vim.fn.getregtype(register)
    if regType == '' then --empty or unknown
        return ''
    elseif regType == 'v' then -- charwise
		vim.cmd([=[keepjumps normal! "]=]..register..'P`]l')
	elseif string.byte(regType, 1) == 0x16 then -- blockwise
        vim.cmd([=[keepjumps normal! "]=]..register..'P')
    else
		vim.cmd([=[keepjumps normal! "]=]..register.."p`]l")
    end
end)

m.x('p', function()
    local register = vim.api.nvim_get_vvar('register')
    local regType = vim.fn.getregtype(register)
    if regType == '' then --empty or unknown
        return ''
	else
        local regContent = vim.fn.getreg(register)
		vim.cmd([=[normal! "]=]..register..'p`]l')
        vim.fn.setreg(register, regContent, regType)
    end
end)

m.o('f', '<cmd>norm! gg0vG$<cr>')
m.x('f', '<esc>gg0vG$')

m.n('<A-f>', '==')
m.x('<A-f>', function() keepSelection('norm! =') end)


local function adjustFontSize(amount)
    if not vim.fn.has('gui_running') then return end

    local orig_font = vim.api.nvim_get_option_value('guifont', {})
    local parts = vim.split(orig_font, ':h')
    assert(#parts == 2)

    local font_size = tonumber(parts[2])
    local new_size = font_size + amount
    if new_size < 4 then new_size = 4
    elseif new_size > 40 then new_size = 40 end

    vim.opt.guifont = parts[1] .. ':h' .. new_size
end

m.n('<C-=>', function() adjustFontSize( 1) end)
m.n('<C-->', function() adjustFontSize(-1) end)


local quickfixGroup = vim.api.nvim_create_augroup('QuickfixListMappings', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'qf',
    callback = function()
        m.n('<cr>', '<cmd>.cc<cr><C-w>p', { buffer = true })
        m.n('o', '<cmd>.cc<cr>', { buffer = true })
    end,
    group = quickfixGroup
})


do -- help
    local selection = require('main.getSelection')

    local function getHelp(args, s)
        local str = table.concat(vim.api.nvim_buf_get_text(0, s[1], s[2], s[3], s[4], {}), '\n')
        vim.cmd('help '..str)
    end

    m.n('<leader>H', 'K')
    m.n('<leader>h', function() return selection.callOpfunc(getHelp, nil) end, { expr = true })
    m.x('<leader>h', function() selection.callVisual(getHelp, nil) end)
    m.n('<leader>hh', function() return selection.callOpfunc(getHelp, nil)..'iw' end, { expr = true })
end


LoadModule('main.runBuf')

if LoadModule('main.vim') then
    -- some old vim remappings
    -- TODO: redo with treesitter
    --variable/property left hand size
    m.n('d<leader>v', "<cmd>call ExecDelLines(0)<cr>")
    m.n('y<leader>v', "<cmd>call SelectVariableValue(0)<cr>y`^")
    m.x('<leader>v', "<esc><cmd>call SelectVariableValue(0)<cr>")
    m.o('<leader>v', "<cmd>call SelectVariableValue(0)<cr>")
end


-- alt is now shift

m.ic('<A-9>', '(')
m.ic('<A-0>', ')')

m.ic('<A-[>', '{')
m.ic('<A-]>', '}')

m.ic('<A-,>', '<')
m.ic('<A-.>', '>')

m.ic('<A-->', '_')
m.ic('<A-=>', '+')

m.n('<A-3>', '#')
m.n('<A-8>', '*')
