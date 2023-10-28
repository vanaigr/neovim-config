local tsj = require('treesj')

tsj.setup({
  use_default_keymaps = false,
  check_syntax_error = false,
  max_join_length = 200, -- if called erroneously
  cursor_behavior = 'hold',
  notify = true,
  dot_repeat = false,
})

qnoremap('n', '<leader>s', ":TSJToggle<cr>")
qnoremap('n', '<leader>S', ":TSJSplit<cr>")
