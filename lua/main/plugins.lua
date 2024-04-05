local vim = vim -- fix lsp warning

vim.cmd 'packadd packer.nvim'

local packer = require('packer')

packer.init{ max_jobs = 8 }

return packer.startup(function(use)
    use 'wbthomason/packer.nvim'

    use{ 'rose-pine/neovim', as = 'rose-pine' } -- theme

    use{
        'Wansmer/treesj',
        requires = { 'nvim-treesitter/nvim-treesitter' },
        event = 'User LoadTreesj',
    } -- split/join

    use{ 'mg979/vim-visual-multi' } -- multicursor

    use{ 'chentoast/marks.nvim' }
    use{ 'tpope/vim-fugitive' } -- git
    use{ 'vanaigr/targets.vim' } -- replaced with unmerged bugfix
    use{ 'kylechui/nvim-surround' }
    use{ 'mbbill/undotree' }
    use{ 'numToStr/Comment.nvim' }
    use{ 'nvim-treesitter/nvim-treesitter' }
    use{ 'bkad/CamelCaseMotion' }
    use{ 'petertriho/nvim-scrollbar' }
    use{ 'nvim-lualine/lualine.nvim' }
    use{ 'HiPhish/rainbow-delimiters.nvim' }
    use{ 'echasnovski/mini.nvim' }

    use{ 'vanaigr/easyword.nvim' }

    use{ 'ggandor/leap.nvim' }
    use{ 'Sleepful/leap-by-word.nvim' }

    use{ 'hrsh7th/nvim-cmp' }
    use{ 'hrsh7th/cmp-buffer' } -- autocomplete without lsp
    use{ 'hrsh7th/cmp-cmdline' }
    use{ 'hrsh7th/cmp-nvim-lua' }
    use{ 'hrsh7th/cmp-nvim-lsp' }

    use{
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} },
        event = 'User LoadTelescope', -- somehow LazyLoadTelescope doesn't work...
    }

    use{ 'neovim/nvim-lspconfig' }

    use{ -- super slow (half the startup time)
        'williamboman/mason.nvim',
        cmd = {
            'Mason', 'MasonUpdate', 'MasonInstall',
            'MasonUninstall', 'MasonLog',
        },
        config = function()
            require('mason').setup{}
        end,
    }
end)
