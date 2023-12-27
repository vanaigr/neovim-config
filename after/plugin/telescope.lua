local actions = require('telescope.actions')
require('telescope').setup{
    defaults = {
        mappings = {
            i = {
                ['<C-k>'] = actions.move_selection_previous,
                ['<C-j>'] = actions.move_selection_next,
                ['<A-k>'] = actions.move_selection_previous,
                ['<A-j>'] = actions.move_selection_next,
                ['<A-l>'] = actions.select_tab,
                ['<A-h>'] = actions.close,
            },
        }
    }
}

local builtin = require('telescope.builtin')
local utils = require("telescope.utils")

local function getProjectDir()
    local bufDir = vim.fn.fnameescape(utils.buffer_dir())
    local handle = io.popen('git -C '..bufDir..' rev-parse --show-toplevel 2>&1', 'r')

    if handle == nil then
        vim.api.nvim_echo({{ "Couldn't launch git rev-parse to get toplevel directory", 'ErrorMsg' }}, true, {})
        return bufDir
    end -- portable ?handle:close()

    local out = handle:read('*a')
    if not handle:close() then
        vim.api.nvim_echo({{ out, 'ErrorMsg' }}, true, {})
        return bufDir
    end

    out = out:gsub('^%s*(.-)%s*$', '%1') -- thanks to someone who put platworm-specific newline in there
    if out == '' then
        vim.api.nvim_echo({{ 'empty git path', 'ErrorMsg' }}, true, {})
        return bufDir
    end
    return out
end

local m = require('mapping')
m.n('<leader>ff', function() builtin.find_files{ cwd = getProjectDir(), no_ignore = true, hidden = false } end)
m.n('<leader>fo', function() builtin.oldfiles{} end)
