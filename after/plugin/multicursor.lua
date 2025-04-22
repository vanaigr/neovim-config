local mc = require("multicursor-nvim")
mc.setup()

--[[
if _G.this_is then
    vim.keymap.set('n', 'a', function() mc.lineAddCursor(1) end)
    vim.cmd('norm aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')
end
_G.this_is = true
]]

local set = vim.keymap.set

-- Add or skip cursor above/below the main cursor.
set({"n", "x"}, "<C-k>", function() mc.lineAddCursor(-1) end)
set({"n", "x"}, "<C-j>", function() mc.lineAddCursor(1) end)
set({"n", "x"}, "<leader><C-k>", function() mc.lineSkipCursor(-1) end)
set({"n", "x"}, "<leader><C-j>", function() mc.lineSkipCursor(1) end)

-- Add or skip adding a new cursor by matching word/selection
set({"n", "x"}, "<C-n>", function() mc.matchAddCursor(1) end)
set({"n", "x"}, "q", function() mc.matchSkipCursor(1) end)
--set({"n", "x"}, "<leader>N", function() mc.matchAddCursor(-1) end)
--set({"n", "x"}, "<leader>S", function() mc.matchSkipCursor(-1) end)

-- Add and remove cursors with control + left click.
--set("n", "<c-leftmouse>", mc.handleMouse)
--set("n", "<c-leftdrag>", mc.handleMouseDrag)
--set("n", "<c-leftrelease>", mc.handleMouseRelease)

-- Disable and enable cursors.
set({"n", "x"}, "<c-q>", function()
    if not mc.cursorsEnabled() then
        mc.enableCursors()
    else
        mc.disableCursors()
    end
end)

-- Mappings defined in a keymap layer only apply when there are
-- multiple cursors. This lets you have overlapping mappings.
mc.addKeymapLayer(function(layerSet)

    -- Select a different cursor as the main one.
    layerSet({"n", "x"}, "<leader>h", mc.prevCursor)
    layerSet({"n", "x"}, "<leader>l", mc.nextCursor)

    -- Delete the main cursor.
    layerSet({"n", "x"}, "<leader>x", mc.deleteCursor)

    -- Enable and clear cursors using escape.
    layerSet("n", "<esc>", function()
        mc.clearCursors()
    end)
end)

mc.onModeChanged(function(cursor, oldMode, newMode)
    if oldMode and string.find("iR", oldMode) and newMode == "n" then
        cursor:feedkeys("`^")
    end
end)

-- Customize how cursors look.
local hl = vim.api.nvim_set_hl
hl(0, "MultiCursorCursor", { link = "Cursor" })
hl(0, "MultiCursorVisual", { link = "Visual" })
hl(0, "MultiCursorSign", { link = "SignColumn"})
hl(0, "MultiCursorMatchPreview", { link = "Search" })
hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
hl(0, "MultiCursorDisabledSign", { link = "SignColumn"})

if true then return end

local vim = vim -- fix lsp warning

local done = false
local function setup()
    if done then return end
    done = true

    vim.api.nvim_exec_autocmds('User', { pattern = 'load-multicursor' })
end
local function map(keys) return function() setup(); return keys end end

local m = require('mapping')

local opt = { remap = true, silent = true, expr = true }
m.n('<C-j>', map('<C-down>'), opt)
m.n('<C-k>', map('<C-up>'), opt)
m.n('<C-h>', map('<S-left>'), opt)
m.n('<C-l>', map('<S-right>'), opt)
m.n('<C-n>', map('<Plug>I_LOVE_HACKS_3'), opt)
m.x('<C-n>', map('<Plug>I_LOVE_HACKS_3'), opt)

vim.api.nvim_exec2(
    [==[
    let g:VM_maps = {}
    let g:VM_maps['Find Under'] = '<Plug>I_LOVE_HACKS_3'
    ]==],
    { output = false }
)

local function initColors()
    local p = require('rose-pine.palette')
    vim.api.nvim_set_hl(0, 'VM_Mono'  , { bg = p.love, fg='#ffffff' })
    vim.api.nvim_set_hl(0, 'VM_Extend', { bg = p.pine, fg='#ffffff' })
    vim.api.nvim_set_hl(0, 'VM_Cursor', { bg = p.iris, fg='#21202e' })
    vim.api.nvim_set_hl(0, 'VM_Insert', { bg = '#ffffff', fg='#21202e' })
end

initColors()

local group = vim.api.nvim_create_augroup('MulticursorHighlighting', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = initColors,
    group = group
})
