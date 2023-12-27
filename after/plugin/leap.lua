local vim = vim -- fix lsp warning

local leap = require('leap')

leap.opts.highlight_input = true
leap.opts.equivalence_classes = { ' \t\r\n' }
leap.opts.substitute_chars = { ['\r'] = '¬', ['\n'] = '¬', [' '] = '·' }
leap.opts.case_sensitive = false
leap.opts.special_keys = {
    next_target = '<tab>',
    prev_target = '<S-tab>',
    next_group = '<tab>',
    prev_group = '<S-tab>',
    multi_accept = '<enter>',
    multi_revert = '<backspace>',
}

--[[require('mapping').n('s', function ()
    local focusable_windows_on_tabpage = vim.tbl_filter(
        function (win) return vim.api.nvim_win_get_config(win).focusable end,
        vim.api.nvim_tabpage_list_wins(0)
    )
    leap.leap { target_windows = focusable_windows_on_tabpage }
end)]]

local labels = {
    's', 'j', 'k', 'd', 'l', 'f', 'c', 'n', 'i', 'e', 'w', 'r', 'o', "'",
    "h", "m", "u", "y", "v", "g", "t", "a", "q", "p", "x", "z", "/",
    'S', 'J', 'K', 'D', 'L', 'F', 'C', 'N', 'I', 'E', 'W', 'R', 'O', '"',
    "H", "M", "U", "Y", "V", "G", "T", "A", "Q", "P", "X", "Z", "?",
}

--[[vim.keymap.set({ 'n', 'x', 'o' }, 's', function() require('leap-by-word').leap(
    { test_function = 'split_identifiers' }, { opts = { labels = labels } }
) end, {})]]

vim.keymap.set('n', 'f', function()
    vim.cmd('normal! v')
    require'leap-ast'.leap({}, { opts = { safe_labels = labels, labels = labels } })
end)

vim.keymap.set({'x', 'o'}, 'f', function()
    -- custom, original doesn't have opts
    require'leap-ast'.leap({}, { opts = { safe_labels = labels, labels = labels } })
    -- add this to have options
    local _ = [==[
        local function leap(opts, leap_override_opts)
          require('leap').leap(vim.tbl_extend('force', {
            targets = get_ast_nodes(),
            action = api.nvim_get_mode().mode ~= 'n' and select_range,  -- or jump
            backward = true
          }, leap_override_opts or {}))
        end

        and

        ts_utils.is_selecton_end_exclusive()
    ]==]
end, {})

leap.opts.highlight_unlabeled_phase_one_targets = true

local function initColors()
    vim.api.nvim_set_hl(0, 'LeapBackdrop',       { link = 'Comment', nocombine=true })
    --vim.api.nvim_set_hl(0, 'LeapInputTyped',     { sp = 'magenta', underline = true, nocombine=true })
    --vim.api.nvim_set_hl(0, 'LeapInputRemainder', { fg = 'magenta', bg = 'black', sp = 'magenta', underline = true, nocombine=true })
    vim.api.nvim_set_hl(0, 'LeapMatch',          { fg='black', bg='white', bold=true, nocombine=true })
    vim.api.nvim_set_hl(0, 'LeapLabelPrimary',   { fg='white', bg='black', bold=true, nocombine=true })
    vim.api.nvim_set_hl(0, 'LeapLabelSecondary', { fg='#99ccff', bg='black', bold=true, nocombine=true })
    vim.api.nvim_set_hl(0, 'LeapLabelSelected',  { fg='magenta', bg='white', bold = true, nocombine = true })
end

initColors()

local group = vim.api.nvim_create_augroup('LeapHighlighting', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = initColors,
    group = group
})
