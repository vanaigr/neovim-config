local s = require("spider")

s.setup {
    skipInsignificantPunctuation = true,
    subwordMovement = false,
    consistentOperatorPending = true,
}

local m = require('mapping')

local opts = { customPatterns = { patterns = { '$' }, overrideDefault = false } }
m.nxo('w', function() s.motion('w', opts) end)
m.nx('e', function()
    -- breaks for 1 letter word at start of line
    vim.cmd([=[silent! normal! h]=])
    s.motion('e', opts)
    vim.cmd([=[silent! normal! l]=])
end)
m.o('e', function() s.motion('e', opts) end)
m.nxo('b', function() s.motion('b') end)
