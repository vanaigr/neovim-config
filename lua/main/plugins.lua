vim.cmd 'packadd packer.nvim'

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use{ 'rose-pine/neovim', as = 'rose-pine' }
    use({ 'Wansmer/treesj', requires = { 'nvim-treesitter/nvim-treesitter' } })
    use{'mg979/vim-visual-multi'}
    use{'chentoast/marks.nvim'}
    use{'ggandor/lightspeed.nvim'}
    use({ "kylechui/nvim-surround", tag = "*" })
    use{'mbbill/undotree'}
    use{'numToStr/Comment.nvim'}
    use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

    --[[ use {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        requires = { {'nvim-lua/plenary.nvim'} }
    } --]]
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
