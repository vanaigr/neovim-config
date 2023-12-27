local vim = vim -- fix lsp warning

vim.cmd 'packadd packer.nvim'

local packer = require('packer')

packer.init{ max_jobs = 8 }

return packer.startup(function(use)
    use 'wbthomason/packer.nvim'

    use{ 'rose-pine/neovim', as = 'rose-pine' } -- theme
    use{ 'Wansmer/treesj', requires = { 'VanaIgr/nvim-treesitter' } } -- split/join
                                        -- ^ bugfix
    use{ 'mg979/vim-visual-multi' } -- multicursor
    use{ 'chentoast/marks.nvim' }
    use{ 'tpope/vim-fugitive' } -- git 
    use{ 'VanaIgr/targets.vim' } -- replaced with unmerged bugfix
    use{ 'kylechui/nvim-surround', tag = "*" }
    use{ 'mbbill/undotree' }
    use{ 'numToStr/Comment.nvim' }
    use{ 'VanaIgr/nvim-treesitter', run = ':TSUpdate' } -- bugfix
    use{ 'bkad/CamelCaseMotion' }
    use{ 'petertriho/nvim-scrollbar' }
    use{ 'nvim-lualine/lualine.nvim' }
    use{ 'HiPhish/rainbow-delimiters.nvim' }
    use{ 'echasnovski/mini.nvim' }

    use{ 'ggandor/leap.nvim' } -- sneak
    use{ 'VanaIgr/leap-by-word.nvim', requires = { 'ggandor/leap.nvim' } } -- unmerged bugfix
    use{ 'ggandor/leap-ast.nvim', requires = { 'ggandor/leap.nvim' } }
    use{ 'VanaIgr/nvim-easyword' }

    use{ 'hrsh7th/cmp-buffer' } -- autocomplete without lsp
    use{ 'hrsh7th/cmp-path' }
    use{ 'hrsh7th/cmp-cmdline' }
    use{ 'hrsh7th/cmp-nvim-lua' }


    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            {'neovim/nvim-lspconfig'},
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'L3MON4D3/LuaSnip'},
        }
    }
end)

