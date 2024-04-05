
local vim = vim -- fix lsp warning

vim.opt.cursorline = true

require('rose-pine').setup{
	variant = 'main',

    styles = {
        bold = false,
        italic = false,
        transparency = false,
    },

    enable = {
        terminal = false,
        legacy_highlights = false,
        migrations = false, -- Handle deprecated options automatically
    },

    highlight_groups = {
        --CursorLine = { bg = 'foam', blend = 10 },
        CursorLine = { bg = 'highlight_low' },

        YankHighlight = { bg = 'pine', fg="#20202e", blend = 80 },

        Pmenu = { bg = 'overlay' },
        PmenuSel = { reverse = true },
    }
}

vim.cmd('colorscheme rose-pine')
