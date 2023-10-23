require('lightspeed').setup {
    ignore_case = true,
    exit_after_idle_msecs = { labeled = nil, unlabeled = nil },
    match_only_the_start_of_same_char_seqs = true,
    special_keys = { next_match_group = '<tab>' },
    repeat_ft_with_target_char = true,
    limit_ft_matches = 40,
}

vim.keymap.set('n', 's', '<Plug>Lightspeed_omni_s' , { remap = true })
vim.keymap.set('n', 'S', '<Plug>Lightspeed_omni_gs', { remap = true })
