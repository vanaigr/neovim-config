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

local function getProjectDir()
  local buf_dir = buffer_dir()
  local root = git_root(buf_dir)
  print(buf_dir, root)
  if root then return root
  else return buf_dir end
end

local m = require('mapping')

local builtin
local function setup()
    if builtin then return end
    vim.api.nvim_exec_autocmds('User', { pattern = 'load-telescope' })

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
            ['<A-q>'] = actions.close,
          },
          n = {
            ['<A-k>'] = actions.move_selection_previous,
            ['<A-j>'] = actions.move_selection_next,

            ['<A-l>'] = actions.select_tab,
            ['<A-o>'] = actions.select_default,

            ['<A-e>'] = actions.close,
            ['<A-h>'] = actions.close,
            ['<A-i>'] = actions.close,
            ['<A-q>'] = actions.close,
          },
        }
      }
    }
    builtin = require('telescope.builtin')
end

local slash_num = ('/'):byte(1)
local backslash_num = ('\\'):byte(1)

-- currently (04/2024) a bug in transform_path()
-- that plenary Path doesn't make_relative() if
-- if slashes are different
local function fix_path_display(opts, path) -- expects utf8
    local cwd = opts.cwd
    local last_pos = 0
    for i = 1, math.min(#cwd + 1, #path) do
        local cb = cwd:byte(i) or slash_num
        local pb = path:byte(i)
        if (cb == slash_num or cb == backslash_num)
            and (pb == slash_num or pb == backslash_num) then
            last_pos = i
        elseif cb ~= pb then break end -- don't bother w/ windows case folding
    end
    return path:sub(last_pos + 1)
end

m.n('<leader>ff', function()
  setup()
  builtin.find_files{
    cwd = getProjectDir(),
    path_display = fix_path_display,
    --no_ignore = false,
    --hidden = false,
  }
end)
m.n('<leader>fo', function()
  setup()
  builtin.find_files{
    cwd = vim.fn.stdpath('config'),
    no_ignore = false,
    hidden = false,
  }
end)
m.n('<leader>fO', function()
  setup()
  builtin.oldfiles{}
end)
m.n('<leader>fh', function()
  setup()
  builtin.help_tags{}
end)
m.n('<leader>fr', function()
  setup()
  builtin.reloader{}
end)
m.n('<leader>fw', function()
  setup()
  builtin.lsp_workspace_symbols{}
end)
m.n('<leader>fs', function()
  setup()
  builtin.live_grep{
      cwd = getProjectDir(),
      path_display = fix_path_display,
  }
end)
