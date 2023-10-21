vim.cmd 'packadd packer.nvim'

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    --[[ use {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        requires = { {'nvim-lua/plenary.nvim'} }
    } --]]

    use{ 
        'rose-pine/neovim',
        as = 'rose-pine'
    }

    --[[use({
        'Wansmer/treesj',
        requires = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require('treesj').setup({ your config })
        end,
    })--]]

    --use{'https://github.com/AndrewRadev/splitjoin.vim'}
    use{'mg979/vim-visual-multi'}
    use{'chentoast/marks.nvim'}
    --use{'justinmk/vim-sneak'}
    use{'/ggandor/lightspeed.nvim'}
    --use{'https://github.com/tpope/vim-surround'}
    --use{'https://github.com/tpope/vim-commentary'}
    use{'mbbill/undotree'}

    use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            {'neovim/nvim-lspconfig'},
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'L3MON4D3/LuaSnip'},
        }
    }
end)

