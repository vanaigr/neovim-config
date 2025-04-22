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
