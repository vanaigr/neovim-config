-- add mappings to execute text objects as lua/vim/keys

local vim = vim -- fix lsp warning
local destr = table.unpack or unpack


local function luaFunc(str)
    local func, err = load(str)
    if func then
        func()
    else
        vim.api.nvim_call_function('PrintError', { 'Cannot execute Lua chunk: ' .. err })
    end
end

local function vimFunc(str)
    vim.cmd(str)
end

local function keyFunc(str)
    vim.fn.feedkeys(str)
end

local function printError(msg)
    vim.cmd.redraw() -- https://stackoverflow.com/a/19206860/18704284
    vim.api.nvim_echo({{ msg, 'ErrorMsg' }}, true, {})
end

local function runBufferCommand(func, delete, coords)
    local sl, sc, el, ec = destr(coords)

    local str = table.concat(vim.api.nvim_buf_get_text(0, sl, sc, el, ec, {}), '\n')
    if delete then vim.api.nvim_buf_set_text(0, sl, sc, el, ec, {}) end

    vim.cmd.redraw() -- https://stackoverflow.com/a/19206860/18704284
    func(str)
end

local function fixMarkerCoords(sl, sc, el, ec) -- pray that this will work
    sl = sl - 1
    el = el - 1
    sc = sc - 1
    ec = ec - 1

    local lastCharLen = vim.fn.len(vim.fn.strpart(vim.fn.getline(el+1), ec, 1, false))
    ec = ec + lastCharLen

    return { sl, sc, el, ec }
end

--run command with text object
local function callOpfunc(args)
    local cursorPos = vim.fn.getpos('.')
    _G.OpFunc = function(type)
        vim.fn.setpos('.', cursorPos)

        if type ~= 'line' and type ~= 'char' then printError('Opfunc type '..type..' is not supported'); return end
        local sl, sc = destr(vim.fn.getpos("'["), 2, 3)
        local el, ec = destr(vim.fn.getpos("']"), 2, 3)

        local t = { destr(args) }
        table.insert(t, fixMarkerCoords(sl, sc, el, ec))

        runBufferCommand(destr(t))
    end
    vim.cmd[=[set opfunc=v:lua.OpFunc]=]
    vim.fn.feedkeys('g@', 'n')
end

--run command with visual selection
local function callVisual(args)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', true)
    local type = vim.fn.visualmode()
    if type ~= 'v' and type ~= 'V' then printError('Visual mode '..type..' is not supported'); return end -- visual block

    local sl, sc = destr(vim.fn.getpos("'<"), 2, 3)
    local el, ec = destr(vim.fn.getpos("'>"), 2, 3)

    if vim.api.nvim_get_option('selection') == 'exclusive' then
        sl = sl - 1
        sc = sc - 1
        el = el - 1
        ec = ec - 1 -- end is already exclusive
    else
        sl, sc, el, ec = destr(fixMarkerCoords(sl, sc, el, ec))
    end

    local t = { destr(args) }
    table.insert(t, { sl, sc, el, ec })

    runBufferCommand(destr(t))
end

--run command with current line
local function callLine(args)
    local l = vim.fn.getpos('.')[2]
    local len = vim.fn.len(vim.fn.getline(l))

    local t = { destr(args) }
    table.insert(t, { l-1, 0, l-1, len })

    runBufferCommand(destr(t))
end


local m = require('mapping')

m.n('<leader>rl', function() callOpfunc({luaFunc, false}) end)
m.n('<leader>rv', function() callOpfunc({vimFunc, false}) end)
m.n('<leader>rk', function() callOpfunc({keyFunc, false}) end)

m.x('<leader>rl', function() callVisual({luaFunc, false}) end)
m.x('<leader>rv', function() callVisual({vimFunc, false}) end)
m.x('<leader>rk', function() callVisual({keyFunc, false}) end)

m.n('<leader>rll', function() callLine({luaFunc, false}) end)
m.n('<leader>rvv', function() callLine({vimFunc, false}) end)
m.n('<leader>rkk', function() callLine({keyFunc, false}) end)

m.n('<leader>rL', function() callLine({luaFunc, false}) end)
m.n('<leader>rV', function() callLine({vimFunc, false}) end)
m.n('<leader>rK', function() callLine({keyFunc, false}) end)


m.n('<leader>rdl', function() callOpfunc({luaFunc, true}) end)
m.n('<leader>rdv', function() callOpfunc({vimFunc, true}) end)
m.n('<leader>rdk', function() callOpfunc({keyFunc, true}) end)

m.x('<leader>rdl', function() callVisual({luaFunc, true}) end)
m.x('<leader>rdv', function() callVisual({vimFunc, true}) end)
m.x('<leader>rdk', function() callVisual({keyFunc, true}) end)

m.n('<leader>rdll', function() callLine({luaFunc, true}) end)
m.n('<leader>rdvv', function() callLine({vimFunc, true}) end)
m.n('<leader>rdkk', function() callLine({keyFunc, true}) end)

m.n('<leader>rdL', function() callLine({luaFunc, true}) end)
m.n('<leader>rdV', function() callLine({vimFunc, true}) end)
m.n('<leader>rdK', function() callLine({keyFunc, true}) end)
