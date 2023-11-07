local vim = vim -- fix lsp warning

local leap = require('leap')

leap.add_default_mappings()

leap.opts.case_sensitive = false
leap.opts.special_keys = {
    next_target = '<tab>',
    prev_target = '<S-tab>',
    next_group = '<tab>',
    prev_group = '<S-tab>',
    multi_accept = '<enter>',
    multi_revert = '<backspace>',
}

--[[leap.opts.safe_labels = {
    "s", "f", "n", "u", "t", "/", 'q', ',', '.', ';', "'",
    "S", "F", "N", "J", "K", "L", "H", "M", "U", "G", "T", "?", "Z" 
}]] -- also doesn't work

--[[leap.opts.equivalence_classes = {
    'q{}()[]<>',
    ' \t\r\n',
    [=["'`]=]
}]] -- doesn't work at all/errors


require('mapping').n('s', function ()
    local focusable_windows_on_tabpage = vim.tbl_filter(
        function (win) return vim.api.nvim_win_get_config(win).focusable end,
        vim.api.nvim_tabpage_list_wins(0)
    )
    leap.leap { target_windows = focusable_windows_on_tabpage }
end)

leap.opts.highlight_unlabeled_phase_one_targets = true

vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment', nocombine=true })
vim.api.nvim_set_hl(0, 'LeapMatch', { fg='black', bg='white', bold=true, nocombine=true })
vim.api.nvim_set_hl(0, 'LeapLabelPrimary', { fg='white', bg='black', bold=true, nocombine=true })
vim.api.nvim_set_hl(0, 'LeapLabelSecondary', { fg='#99ccff', bg='black', bold=true, nocombine=true })
vim.api.nvim_set_hl(0, 'LeapLabelSelected', { fg='magenta', bg='white' })
