local vim = vim

-- and this is multiple hundred lines across several files in Neogit...
local function git_root(dir)
    local stdout

    local job = vim.fn.jobstart(
        { 'git', 'rev-parse', '--show-toplevel' },
        {
            clear_env = true,
            cwd = dir,
            on_stdout = function(_, lines, _) stdout = lines end,
            stdout_buffered = true,
        }
    )

    local status = unpack(vim.fn.jobwait({ job }, 500))
    if status ~= 0 or #stdout < 1 then return end
    return stdout[1]
end

local function buffer_dir()
    return vim.fn.expand("%:p:h")
end

-- I LOVE USING TEXT FOR NON-TEXT THINGS
local function getProjectDir()
  local buf_dir = buffer_dir()
  local root = git_root(buf_dir)
  print(buf_dir, root)
  if root then return root
  else return buf_dir end
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
  local dir = getProjectDir()
  require('telescope.builtin').find_files{
    cwd = dir,
    no_ignore = false,
    hidden = false,
  }
end)
m.n('<leader>fo', function()
  setup()
  require('telescope.builtin').find_files{
    cwd = vim.fn.stdpath('config'),
    no_ignore = false,
    hidden = false,
  }
  --require('telescope.builtin').oldfiles{}
end)
m.n('<leader>fO', function()
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
m.n('<leader>fs', function()
  setup()
  require('telescope.builtin').lsp_workspace_symbols{}
end)
