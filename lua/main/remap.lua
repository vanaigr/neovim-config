local vim = vim -- fix lsp warning

local m = require('mapping')

vim.g.mapleader = ' '

m.i('<S-F1>', '<Esc>`^') -- I set up F1 somewhere and now it does Shift+F1 insead of opening help
m.c('<S-F1>', '<Esc>')   -- but I don't know where ...

m.n('Q', '<Nop>')
m.n('ZZ', '<Nop>')
--m.n('gg', '<Nop>') -- accidentally press gg insead of hh

m.i('<esc>', '<esc>`^') -- prevent cursor from moving when exiting insert mode
m.i('<C-c>', '<C-c>`^')
m.a('<A-i>', '<esc>')
m.i('<A-i>', '<esc>`^')
m.c('<A-i>', '<C-c>')
m.n('<A-w>', '<C-w>')
m.n('<A-s>', '<cmd>w<cr>')
m.n('<A-q>', '<cmd>q<cr>')
m.n('<A-a>', '<cmd>so<cr>')

local alphanumeric = vim.regex('[[:upper:][:lower:][:digit:]]\\C')
local function doMotion(command)
  local prev_pos = vim.api.nvim_win_get_cursor(0)
  for i = 1, 100 do
    for j = 1, 100 do
      vim.api.nvim_feedkeys(command, 'nx', false)

      local new_pos = vim.api.nvim_win_get_cursor(0)
      local char = vim.api.nvim_buf_get_text(
        0, new_pos[1] - 1, new_pos[2],
        new_pos[1] - 1, new_pos[2] + 1, {}
      )[1]
      if alphanumeric:match_str(char) then break end
    end

    break
    --local new_pos = vim.api.nvim_win_get_cursor(0)
    --if new_pos[1] ~= prev_pos[1] or math.abs(new_pos[2] - prev_pos[2]) > 1 then
    --  break
    --end
    --prev_pos = new_pos
  end
end

m.n('w', function() doMotion('w') end)
m.n('b', function() doMotion('b') end)
m.n('e', function()
  vim.cmd([=[silent! normal! h]=])
  doMotion('e')
  vim.cmd([=[silent! normal! l]=])
end)
m.n('ge', function()
  vim.cmd([=[silent! normal! h]=])
  doMotion('ge')
  vim.cmd([=[silent! normal! l]=])
end)
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

m.n('<space>', '<Nop>') -- treated as <leader>, long delay
m.n('<C-space>', 'i <esc>`^')
m.n('<bs>', 'i<bs><esc>`^')
m.n('<enter>', 'i<enter><esc>`^')

m.n('<A-o>', 'o<Esc>')
m.i('<A-o>', '<Esc>`^o')
m.c('<A-o>', '<CR>')

m.n('<A-t>', 'gt')
m.n('<A-g>', 'gT')

m.i('<C-bs>', '<C-w>')
m.c('<C-bs>', '<C-w>')

m.n('<C-z>', '<cmd>undo<cr>')
m.n('<C-S-z>', '<cmd>redo<cr>')
m.n('<A-u>', '<cmd>redo<cr>')

m.n('<C-s>', ':%s//gc<left><left><left>') --replace on C-s
m.x('<C-s>', ':s//gc<left><left><left>')

m.n('>>', 'i<C-t><Esc>`^') --tabs keep cursor in the same place
m.n('<<', 'i<C-d><Esc>`^')
m.n('<A-.>', 'i<C-t><Esc>`^')
m.n('<A-,>', 'i<C-d><Esc>`^')
m.i('<Tab>', '<C-t>')
m.i('<S-Tab>', '<C-d>')
--m.i('<A-.>', '<C-t>')
--m.i('<A-,>', '<C-d>')

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

m.n(')', '<C-y>') -- move screen but not cursor
m.n('(', '<C-e>')
m.n('<A-0>', '<C-y>')
m.n('<A-9>', '<C-e>')
--m.i('<A-0>', '<Esc><C-y>`^i')
--m.i('<A-9>', '<Esc><C-e>`^i')
m.x('<A-0>', '<C-y>')
m.x('<A-9>', '<C-e>')
m.c('<A-o>', '<Enter>')

m.n('{', '_') -- move to start/end of line without leading/trailing spaces
m.n('}', 'g_l')
m.x('{', '_')
m.x('}', 'g_l')
m.o('{', function() vim.cmd'keepjumps silent! normal! _' end)
m.o('}', 'g_')

m.n('[[', '{')
m.x('[[', '{')
m.n(']]', '}')
m.x(']]', '}')

local function command_mode()
    local openGroup = vim.api.nvim_create_augroup('CommandGoup', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'vim',
        callback = function()
            vim.api.nvim_del_augroup_by_id(openGroup)

            local winId = vim.api.nvim_get_current_win()
            local bufId = vim.api.nvim_win_get_buf(winId)

            local cmdOpt = { scope = 'local' }
            local oldHeight = vim.api.nvim_get_option_value('cmdheight', cmdOpt)
            local height = vim.api.nvim_get_option_value('cmdheight', {})
            vim.api.nvim_set_option_value('cmdheight', math.max(height-2, 0), cmdOpt)

            local closeGroup = vim.api.nvim_create_augroup('CommandGoup', { clear = true })
            vim.api.nvim_create_autocmd('WinClosed', {
                pattern = ''..winId,
                callback = function()
                    vim.api.nvim_set_option_value('cmdheight', oldHeight, cmdOpt)
                end,
                group = closeGroup
            })

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
            --[[local pos = vim.fn.getpos('.')
            pos[5] = 2147483647
            vim.fn.setpos('.', pos)]]
        end,
        group = openGroup
    })
    local cf = vim.api.nvim_replace_termcodes('<C-f>', true, false, true)
    -- feedkeys is neccessary as otherwise display is not updated
    vim.api.nvim_feedkeys(':'..cf, 'n', false)
end

-- add insert and normal modes to command mode
m.n(';', command_mode)
m.x(';', command_mode)
m.n(':', '<Nop>')
m.n('<A-e>', command_mode)
m.x('<A-e>', command_mode)
m.i('<A-e>', function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
  command_mode()
end)

m.t('<C-q>', '<C-\\><C-n>') -- go to normal mode in terminal

local expr = { expr = true }
m.n('<A-j>', 'winheight(0)/4."<C-d>"', expr)
m.n('<A-k>', 'winheight(0)/4."<C-u>"', expr)
m.x('<A-j>', 'winheight(0)/4."<C-d>"', expr)
m.x('<A-k>', 'winheight(0)/4."<C-u>"', expr)

-- <A-j> and <A-k> are remapped system-wide to these keys
m.n('<Up>', 'winheight(0)/4."<C-u>"', expr)
m.n('<Down>', 'winheight(0)/4."<C-d>"', expr)
m.x('<Up>', 'winheight(0)/4."<C-u>"', expr)
m.x('<Down>', 'winheight(0)/4."<C-d>"', expr)

m.n('<A-h>', '_')
m.n('<A-l>', 'g_l')
m.x('<A-h>', '_')
m.x('<A-l>', 'g_l')

m.n('j', 'gj')
m.n('k', 'gk')
m.x('j', 'gj')
m.x('k', 'gk')

m.n('J', '5j')
m.n('K', '5k')
m.x('J', '5j')
m.x('K', '5k')
m.o('J', '5j')
m.o('K', '5k')

-- join lines
m.n('gj', 'J')
m.n('gJ', 'kJ')

m.n('<leader>u', "<cmd>UndotreeShow<cr>")

m.o('_', function() vim.cmd'keepjumps silent! normal! _' end)

-- work with system clipboard without mentioning the register
m.n('<leader>y', "\"+y")
m.n('<leader>Y', "\"+Y")
m.x('<leader>y', "\"+y")

m.n('<leader>d', "\"+d")
m.n('<leader>D', "\"+D")
m.x('<leader>d', "\"+d")

-- line without indentation and newline
m.n('d<leader>l', "_vg_d\"_dd")
m.n('y<leader>l', "_vg_y`^")
m.o('<leader>l', "<cmd>normal! _vg_l<cr>")
m.x('<leader>l', "<esc>_vg_")

m.n('<leader><Esc>', '<Nop>')
m.x('<leader><Esc>', '<Nop>')

m.i('<A-9>', '(')
m.i('<A-0>', ')')

m.i('<A-[>', '{')
m.i('<A-]>', '}')

m.i('<A-,>', '<')
m.i('<A-.>', '>')

m.i('<A-->', '_')
m.i('<A-=>', '+')

m.c('<A-9>', '(')
m.c('<A-0>', ')')

m.c('<A-[>', '{')
m.c('<A-]>', '}')

m.c('<A-,>', '<')
m.c('<A-.>', '>')

m.c('<A-->', '_')
m.c('<A-=>', '+')

m.i('<A-u>', '<bs>')
m.c('<A-u>', '<bs>')

m.n('<A-y>', 'yy')
m.n('<A-v>', 'V')
m.n('<A-d>', '"_dd')
m.x('<A-d>', '"_dd')

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
m.n('<leader>P', function()
    local register = '+'
    local regValue = vim.fn.getreg(register)
    vim.cmd([=[normal! m`]=])
    vim.cmd([=[keepjumps normal! "]=]..register.."p`]l")
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
m.n('P', function()
    local register = vim.api.nvim_get_vvar('register')
    local regType = vim.fn.getregtype(register)
    if regType == '' then --empty or unknown
        return ''
	elseif string.byte(regType, 1) == 0x16 then -- blockwise
        vim.cmd([=[keepjumps normal! "]=]..register..'P')
    else
		vim.cmd([=[keepjumps normal! "]=]..register.."P`[")
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
m.x('P', function()
    local register = vim.api.nvim_get_vvar('register')
    local regType = vim.fn.getregtype(register)
    if regType == '' then --empty or unknown
        return ''
	else
        local regContent = vim.fn.getreg(register)
		vim.cmd([=[keepjumps normal! "]=]..register..'P`[')
        vim.fn.setreg(register, regContent, regType)
    end
end)

m.o('f', '<cmd>norm! gg0vG$<cr>')
m.x('f', '<esc>gg0vG$')

local function cmp2(p1, p2) -- pos >= pos2
    return p1[1] > p2[1] or (p1[1] == p2[1] and p1[2] >= p2[2])
end

m.n('<A-f>', '==')
m.x('<A-f>', function() keepSelection('norm! =') end)

local quickfixGroup = vim.api.nvim_create_augroup('QuickfixListMappings', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'qf',
    callback = function()
        m.n('<cr>', '<cmd>.cc<cr><C-w>p', { buffer = true })
        m.n('o', '<cmd>.cc<cr>', { buffer = true })
    end,
    group = quickfixGroup
})


do
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
    --change font size
    m.n('<C-=>', '<cmd>call AdjustFontSize(1)<cr>')
    m.n('<C-->', '<cmd>call AdjustFontSize(-1)<cr>')

    -- some old vim remappings
    -- TODO: redo with treesitter

    --variable/property left hand size
    m.n('d<leader>v', "<cmd>call ExecDelLines(0)<cr>")
    m.n('y<leader>v', "<cmd>call SelectVariableValue(0)<cr>y`^")
    m.x('<leader>v', "<esc><cmd>call SelectVariableValue(0)<cr>")
    m.o('<leader>v', "<cmd>call SelectVariableValue(0)<cr>")

    --go to function declaration from where it is called
    m.n('g<leader>f', "<cmd>call GoToFunctionDecl()<cr>")
end
