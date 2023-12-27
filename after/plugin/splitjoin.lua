local vim = vim

local group = vim.api.nvim_create_augroup('TreesjLoad', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
    pattern = '*',
    callback = function()
        local tsj = require('treesj')

        tsj.setup{
            use_default_keymaps = false,
            check_syntax_error = false,
            max_join_length = 500, -- if called erroneously
            cursor_behavior = 'hold',
            notify = true,
            dot_repeat = false,
        }

        local m = require('mapping')

        m.n('<leader>s', ":TSJToggle<cr>")
        m.n('<leader>S', ":TSJSplit<cr>")
    end,
    group = group,
})
