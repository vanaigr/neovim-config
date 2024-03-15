local vim = vim

local function getProjectDir()
  local utils = require("telescope.utils")

  local bufDir = vim.fn.fnameescape(utils.buffer_dir())
  local handle = io.popen('git -C '..bufDir..' rev-parse --show-toplevel 2>&1', 'r')

  if handle == nil then
    vim.api.nvim_echo({{ "Couldn't launch git rev-parse to get toplevel directory", 'ErrorMsg' }}, true, {})
    return bufDir
  end -- portable ?handle:close()

  local out = handle:read('*a')
  if not handle:close() then
    vim.api.nvim_echo({{ out, 'ErrorMsg' }}, true, {})
    return bufDir
  end

  out = out:gsub('^%s*(.-)%s*$', '%1') -- thanks to someone who put platworm-specific newline in there
  if out == '' then
    vim.api.nvim_echo({{ 'empty git path', 'ErrorMsg' }}, true, {})
    return bufDir
  end
  return out
end

local m = require('mapping')

local load = true
local function setup(fLoad)
  if load then
    load = fLoad

    vim.api.nvim_exec_autocmds('User', { pattern = 'LoadTelescope' })

    local actions = require('telescope.actions')
    require('telescope').setup{
      defaults = {
        mappings = {
          i = {
            ['<A-k>'] = actions.move_selection_previous,
            ['<A-j>'] = actions.move_selection_next,

            ['<A-l>'] = actions.select_tab,
            ['<A-o>'] = actions.select_default,

            ['<A-e>'] = actions.close,
            ['<A-h>'] = actions.close,
            ['<A-i>'] = actions.close,
          },
          n = {
            ['<A-k>'] = actions.move_selection_previous,
            ['<A-j>'] = actions.move_selection_next,

            ['<A-l>'] = actions.select_tab,
            ['<A-o>'] = actions.select_default,

            ['<A-e>'] = actions.close,
            ['<A-h>'] = actions.close,
            ['<A-i>'] = actions.close,
          },
        }
      }
    }
  else
    load = fLoad
  end
end

m.n('<leader>ff', function()
  setup()
  require('telescope.builtin').find_files{
    cwd = getProjectDir(),
    no_ignore = false,
    hidden = false,
  }
end)
m.n('<leader>fO', function()
  setup()
  require('telescope.builtin').find_files{
    cwd = vim.fn.stdpath('config'),
    no_ignore = false,
    hidden = false,
  }
  --require('telescope.builtin').oldfiles{}
end)
m.n('<leader>fo', function()
  setup()
  require('telescope.builtin').oldfiles{}
end)
m.n('<leader>fh', function()
  setup()
  require('telescope.builtin').help_tags{}
end)
m.n('<leader>fr', function()
  setup()
  require('telescope.builtin').reloader{}
end)
