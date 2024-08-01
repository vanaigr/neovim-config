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

                    ['<A-i>'] = { '<esc>', type = 'command' },
                    ['<A-q>'] = actions.close,
                },
                n = {
                    ['<A-k>'] = actions.move_selection_previous,
                    ['<A-j>'] = actions.move_selection_next,

                    ['<A-l>'] = actions.select_tab,
                    ['<A-o>'] = actions.select_default,

                    ['<esc>'] = { '', type = 'command' },
                    ['<A-q>'] = actions.close,

                    ['<leader>q'] = actions.send_to_qflist + actions.open_qflist,
                },
            }
        },
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
    results_title = 'project files',
  }
end)
m.n('<leader>fa', function()
  setup()
  builtin.find_files{
    cwd = getProjectDir(),
    path_display = fix_path_display,
    no_ignore = true,
    hidden = true,
    results_title = 'project files',
  }
end)
m.n('<leader>fo', function()
  setup()
  builtin.find_files{
    cwd = vim.fn.stdpath('config'),
    hidden = false,
    results_title = 'config files',
  }
end)

local function fn(num, dir, desc)
    m.n('<leader>f'..num, function()
      setup()
      builtin.find_files{
        cwd = dir,
        no_ignore = true,
        hidden = true,
        results_title = desc,
      }
    end)
end
fn(1, '~/.config', 'User config files')
fn(2, '~/CCC', 'User CCC')
fn(3, '~/.local/share/nvim/lazy', 'User nvim lazy')

m.n('<leader>fO', function()
  setup()
  builtin.oldfiles{ results_title = 'old files', }
end)
m.n('<leader>fh', function()
  setup()
  builtin.help_tags{ results_title = 'help', }
end)
m.n('<leader>fr', function()
  setup()
  builtin.reloader{ results_title = 'reload', }
end)
m.n('<leader>fw', function()
  setup()
  builtin.lsp_workspace_symbols{ results_title = 'symbols', }
end)
m.n('<leader>fs', function()
  setup()
  builtin.live_grep{
      cwd = getProjectDir(),
      path_display = fix_path_display,
      results_title = 'grep',
  }
end)
m.x('<leader>fs', function()
    setup()
    local p1 = vim.fn.getpos('v')
    local p2 = vim.fn.getpos('.')
    local text = table.concat(vim.api.nvim_buf_get_text(
        0,
        p1[2] - 1,
        p1[3] - 1,
        p2[2] - 1,
        p2[3] - 1,
        {}
    ), '\n') -- does telescope accept \n ?
    builtin.live_grep{
        cwd = getProjectDir(),
        default_text = text,
        path_display = fix_path_display,
        results_title = 'grep',
        -- additional args to show all ignored files + vcs ignore
        -- todo add .git to exclude
    }
end)

--require('telescope.builtin').find_files{ default_text = {} }
--require('telescope.builtin').find_files{ results_title = {1} }
