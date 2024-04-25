local vim = vim

local g = require('neogit')
g.setup{}

local function buffer_dir()
    return vim.fn.expand("%:p:h")
end

require('mapping').n('<leader>gg', function()
    local dir = buffer_dir()
    g.open{ cwd = dir, no_expand = true, kind = 'split_above' }
end)
