local s = require("spider")
s.setup { skipInsignificantPunctuation = true, subwordMovement = false }

local m = require('mapping')

local opts = { customPatterns = { patterns = { '$' }, overrideDefault = false } }
m.nxo("w", function() s.motion('w', opts) end)
m.nxo("e", function()
    -- breaks for 1 letter word at start of line
    vim.cmd([=[silent! normal! h]=])
    s.motion('e', opts)
    vim.cmd([=[silent! normal! l]=])
end)
m.nxo("b", function() s.motion('b') end)
