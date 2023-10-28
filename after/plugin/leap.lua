local leap = require('leap')

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


vim.keymap.set('n', 's', function ()
  leap.leap { target_windows = { vim.fn.win_getid() } }
end)
--vim.keymap.set('n', 'f', '<Plug>(leap-forward-to)', { silent = true, remap = true })

leap.opts.highlight_unlabeled_phase_one_targets = true

local _ = [=[ vim.keymap.set('n', 'S', function ()
  leap.leap { target_windows = { vim.fn.win_getid() }, action = function(target)
      print(vim.inspect(target))
      vim.fn.setpos('.', { 0, target.pos[1], target.pos[2] })
      vim.cmd[[silent! normal! hel]]
    end }
end)]=]

vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment', nocombine=true })
vim.api.nvim_set_hl(0, 'LeapMatch', { fg='white', bg='black', bold=true, nocombine=true })
vim.api.nvim_set_hl(0, 'LeapLabelPrimary', { fg='white', bg='magenta', bold=true, nocombine=true })
vim.api.nvim_set_hl(0, 'LeapLabelSecondary', { fg='#99ccff', bg='black', bold=true, nocombine=true })
vim.api.nvim_set_hl(0, 'LeapLabelSelected', { fg='magenta', bg='white' })


-- ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab 
