vim.opt.cursorline = true

require('rose-pine').setup({
	variant = 'auto',
	disable_italics = true,

    highlight_groups = {
        ColorColumn = { bg = 'rose' },

        -- Blend colours against the "base" background
        CursorLine = { bg = 'foam', blend = 10 },
        StatusLine = { fg = 'love', bg = 'love', blend = 10 },

        -- visual-multi cursors
        VM_Cursors         = { bg = 'love', fg='#ffffff', blend=100 },
        VM_Selection       = { bg = 'pine', fg='#ffffff', blend=100 },
        VM_SelectionCursor = { bg = 'love', fg='#21202e', blend=100 },
        VM_InsertCursor    = { bg = '#ffffff', fg='#21202e', blend=100 },

        -- By default each group adds to the existing config.
        -- If you only want to set what is written in this config exactly,
        -- you can set the inherit option:
        Search = { bg = 'gold', inherit = false },


    }
})

vim.cmd('colorscheme rose-pine')


