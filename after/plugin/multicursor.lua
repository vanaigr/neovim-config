local mc = require("multicursor-nvim")
mc.setup()

--[[
if _G.this_is then
    vim.keymap.set('n', 'a', function() mc.lineAddCursor(1) end)
    vim.cmd('norm aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')
end
_G.this_is = true
]]

--[[
test
t
test t
test
t

]]

--[[local function matchAddCursor(direction)
    mc.action(function(ctx)
        for _ = 1, vim.v.count1 do
            local mainCursor = ctx:mainCursor()
            if not mainCursor:hasSelection() then
                mainCursor:feedkeys('viw')
            end

            if mainCursor:atVisualStart() then
                mainCursor:feedkeys('o')
            end
            local search = table.concat(mainCursor:getVisualLines(), "\n")

            local cur = mainCursor:getPos()
            cur[1] = cur[1] - 1
            cur[2] = cur[2] - 1
            local begin_line = cur[1]

            mc.addCursor(function(cursor)
                while true do
                    local line
                    if cur[1] == begin_line then
                        line = vim.api.nvim_buf_get_text(
                            0, cur[1], cur[2], cur[1], 2147483647, {}
                        )[1]
                    else
                        line = vim.api.nvim_buf_get_lines(0, cur[1], cur[1] + 1, false)
                    end

                    string.find(line)
                end
            end)

            local cursorChar
            local cursorWord
            local searchWord
            if not mainCursor:hasSelection() then
                local c = mainCursor:col()
                cursorChar = string.sub(mainCursor:getLine(), c, c)
                cursorWord = mainCursor:getCursorWord()
                if cursorChar ~= ""
                    and isKeyword(cursorChar)
                    and string.find(cursorWord, cursorChar, 1, true)
                then
                    searchWord = true
                    mainCursor:feedkeys('"_yiw')
                end
            end
            addCursor(ctx, function(cursor)
                local regex
                local hasSelection = cursor:hasSelection()
                if hasSelection then
                    regex = "\\C\\V" .. escapeRegex(
                        table.concat(cursor:getVisualLines(), "\n"))
                    if vim.o.selection == "exclusive"  then
                        regex = regex .. "\\v.{-}\\n"
                    end
                    if cursor:mode() == "V" or cursor:mode() == "S" then
                        cursor:feedkeys(cursor:atVisualStart() and "0" or "o0")
                    elseif not cursor:atVisualStart() then
                        cursor:feedkeys("o")
                    end
                else
                    if cursorChar == "" then
                        regex = "\\v^$"
                    elseif searchWord then
                        regex = "\\v<\\C\\V" .. escapeRegex(cursorWord) .. "\\v>"
                    else
                        regex = "\\C\\V" .. escapeRegex(cursorChar)
                    end
                end
                cursor:perform(function()
                    print('fjdsfdjljfdsl', regex, vim.inspect(vim.api.nvim_win_get_cursor(0)))
                    vim.fn.search(regex, (direction == -1 and "b" or ""))
                    print('  fjdsfdjljfdsl', vim.inspect(vim.api.nvim_win_get_cursor(0)))
                end)
                if hasSelection then
                    cursor:feedkeys(TERM_CODES.ESC)
                end
            end)
        end
    end)
end]]

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

set('x', '<leader>n', function()
    local l1 = vim.fn.line('.')
    local l2 = vim.fn.line('v')
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, true, true), 'nx', false)

    if l1 > l2 then
        local tmp = l1
        l1 = l2
        l2 = tmp
    end

    --print('!', vim.inspect(vim.api.nvim_get_mode()))
    vim.api.nvim_win_set_cursor(0, { l1, 0 })
    vim.api.nvim_feedkeys('_', 'nx', false)
    for _ = l1, l2 - 1 do
        mc.addCursor('j_', { remap = false })
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
