local vim = vim -- fix lsp warning

vim.opt.cursorline = true

require('rose-pine').setup{
	variant = 'auto',
	disable_italics = true,

    highlight_groups = {
        CursorLine = { bg = 'foam', blend = 10 },

        Search = { bg = 'highlight_high', blend = 100 },
        IncSearch = { bg = 'rose', blend = 50 },

        YankHighlight      = { bg = 'pine', fg="#20202e", blend = 80 },
    }
}

vim.cmd('colorscheme rose-pine')
