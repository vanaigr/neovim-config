local vim = vim

local _ = [==[
vim.keymap.set('n', 's', function ()
  require('leap').leap { target_windows = { vim.api.nvim_get_current_win() } }
end)

local function setColors()
  vim.api.nvim_set_hl(0, 'Cursor', { bg = 'white', fg = 'black' })
  vim.api.nvim_set_hl(0, 'LeapBackdrop', { bg = 'yellow' })
end

local group = vim.api.nvim_create_augroup('LeapHighlighting', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = setColors,
  group = group,
})

setColors()

if true then return end
]==]


--local easyword = require('easyword')
--easyword.apply_default_highlight()
--
--vim.keymap.set({ 'n' }, 's', function() easyword.jump{ recover_key = 's' } end)
--vim.keymap.set({ 'x', 'o' }, 'x', function() easyword.jump{ recover_key = 'x' } end)
--
--local group = vim.api.nvim_create_augroup('EasywordHighlighting', { clear = true })
--vim.api.nvim_create_autocmd('ColorScheme', {
--    callback = function() easyword.apply_default_highlight() end,
--    pattern = '*', group = group,
--})
--
--if true then return end

local isSetup = false
local norm

local labels = { -- qwerty
    's', 'j', 'k', 'd', 'l', 'f', 'c', 'n', 'i', 'e', 'w', 'r', 'o',
    'm', 'u', 'v', 'a', 'q', 'p', 'x', 'z', '/',
}

local function setup(easyword)

    local normRegex, normCache = {}, {}

    for i = 1, 8 do
        local ch = string.char(i)
        normCache[ch] = ch
    end
    normCache['\t'] = ' '
    normCache['\n'] = ' '
    for i = 11, 31 do
        local ch = string.char(i)
        normCache[ch] = ch
    end
    for i = 32, 64 do
        local ch = string.char(i)
        normRegex[ch] =  vim.regex('^[[='..ch..'=]]\\c$')
        normCache[ch] = ch
    end
    for i = 1, 26 do -- A-Z => a-z
        normCache[string.char(64 + i)] = string.char(96 + i)
    end
    for i = 91, 126 do
        local ch = string.char(i)
        normRegex[ch] = vim.regex('^[[='..ch..'=]]\\c$')
        normCache[ch] = ch
    end
    do
        local ch = string.char(127)
        normCache[ch] = ch
    end

    -- note: langmap doesn't work on getcharstr()
    local qwerty    = vim.fn.split([==[qwertyuiop[]asdfghjkl;'zxcvbnm,.]==], '\\zs')
    local cyrillic  = vim.fn.split([==[йцукенгшщзхъфывапролджэячсмитьбю]==], '\\zs')
    local cyrillicU = vim.fn.split([==[ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]==], '\\zs')

    -- no regex since vim doesn't support equivalence classes for cyrillic
    for i, ch in ipairs(cyrillic) do normCache[ch] = qwerty[i] end
    for i, ch in ipairs(cyrillicU) do normCache[ch] = qwerty[i] end
    normCache['ё'] = '`'
    normCache['Ё'] = '`'

    norm = function(char)
        local v = normCache[char]
        if v then return v end

        for k, pattern in pairs(normRegex) do
            if pattern:match_str(char) then
                normCache[char] = k
                return k
            end
        end

        return nil
    end

    easyword.apply_default_highlight()
end


local function jump(recover_key)
  local easyword = require('easyword')
  if not isSetup then
      isSetup = true
      setup(easyword)
  end

  easyword.jump({
    labels = labels,
    char_normalize = norm,
    recover_key = recover_key,
  })
end

vim.keymap.set({ 'n' }, 's', function() jump('s') end)
vim.keymap.set({ 'x', 'o' }, 'x', function() jump('x') end)

local group = vim.api.nvim_create_augroup('EasywordHighlighting', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = function()
        if isSetup then require('easyword').apply_default_highlight() end
    end,
    group = group
})
