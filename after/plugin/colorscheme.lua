local vim = vim -- fix lsp warning

vim.opt.cursorline = true

require('rose-pine').setup({
	variant = 'auto',
	disable_italics = true,

    highlight_groups = {
        ColorColumn = { bg = 'rose' },

        CursorLine = { bg = 'foam', blend = 10 },
        StatusLine = { fg = 'love', bg = 'love', blend = 10 },

        -- visual-multi cursors
        VM_Cursors         = { bg = 'love', fg='#ffffff', blend=100 },
        VM_Selection       = { bg = 'pine', fg='#ffffff', blend=100 },
        VM_SelectionCursor = { bg = 'love', fg='#21202e', blend=100 },
        VM_InsertCursor    = { bg = '#ffffff', fg='#21202e', blend=100 },

        YankHighlight      = { bg = 'pine', fg="#20202e", blend = 80 },

        Search = { bg = 'gold', inherit = false },
    }
})

vim.cmd('colorscheme rose-pine')
