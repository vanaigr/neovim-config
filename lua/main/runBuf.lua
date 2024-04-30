-- add mappings to execute text objects as lua/vim/keys

local vim = vim -- fix lsp warning
local destr = table.unpack or unpack

local function luaFunc(str)
    local func, err = load(str)
    if func then func()
    else vim.notify('Cannot execute Lua chunk: ' .. err, vim.log.levels.ERROR, {}) end
end
local function vimFunc(str) vim.cmd(str) end
local function keyFunc(str) vim.fn.feedkeys(str) end

local function runBufferCommand(args, coords)
    local func, delete = destr(args)

    local sl, sc, el, ec = destr(coords)

    local str = table.concat(vim.api.nvim_buf_get_text(0, sl, sc, el, ec, {}), '\n')
    if delete then vim.api.nvim_buf_set_text(0, sl, sc, el, ec, {}) end

    vim.cmd.redraw() -- https://stackoverflow.com/a/19206860/18704284
    func(str)
end

local selection = require('main.getSelection')
local m = require('mapping')

for _, delete in pairs({ false, true }) do
    local delSymbol
    if delete then delSymbol = 'd' else delSymbol = '' end
    local prefix = '<leader>r'..delSymbol

    for key, func in pairs({ l = luaFunc, v = vimFunc, k = keyFunc, }) do
        local args = { func, delete }
        m.n(prefix..key:upper(), function() selection.callLine  (runBufferCommand, args) end)
        m.n(prefix..key..key,    function() selection.callLine  (runBufferCommand, args) end)
        m.n(prefix..key,  function() return selection.callOpfunc(runBufferCommand, args) end, { expr = true })
        m.x(prefix..key,         function() selection.callVisual(runBufferCommand, args) end)
    end
end
