local vim = vim -- fix lsp warning

vim.cmd 'packadd packer.nvim'

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use{ 'rose-pine/neovim', as = 'rose-pine' } -- theme
    use{ 'Wansmer/treesj', requires = { 'nvim-treesitter/nvim-treesitter' } } -- split/join
    use{ 'mg979/vim-visual-multi' } -- multicursor
    use{ 'chentoast/marks.nvim' }
    use{ 'ggandor/leap.nvim' } -- sneak
    use{ 'tpope/vim-fugitive' } -- git 
    --use{ 'wellle/targets.vim' } -- replaced with local bugfix
    use{ 'kylechui/nvim-surround', tag = "*" }
    use{ 'mbbill/undotree' }
    use{ 'numToStr/Comment.nvim' }
    use{ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use{ 'bkad/CamelCaseMotion' }
    use{ 'petertriho/nvim-scrollbar' }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

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
            --{'L3MON4D3/LuaSnip'},
        }
    }
end)

