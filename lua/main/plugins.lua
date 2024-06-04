local vim = vim -- fix lsp warning

require('lazy').setup({
    { 'rose-pine/neovim', name = 'rose-pine' },
    {
        'Wansmer/treesj',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        event = 'User load-treesj'
    },
    { 'mg979/vim-visual-multi', event = 'User load-multicursor' }, -- multicursor

    { 'vanaigr/motion.nvim' },

    { 'vanaigr/mark-signs.nvim' },
    { 'chentoast/marks.nvim', enabled = false },

    -- better than neogit...
    { 'tpope/vim-fugitive', command = 'Git', event = 'User load-fugitive' }, -- git

    { 'vanaigr/targets.vim' }, -- replaced with unmerged bugfix
    { 'kylechui/nvim-surround' },
    { 'mbbill/undotree' },
    { 'numToStr/Comment.nvim', event = 'User load-comment' },
    { 'nvim-treesitter/nvim-treesitter' },
    { 'bkad/CamelCaseMotion' },
    { 'petertriho/nvim-scrollbar' },
    { 'nvim-lualine/lualine.nvim' },
    { 'HiPhish/rainbow-delimiters.nvim' },
    { 'echasnovski/mini.nvim' },

    { 'vanaigr/easyword.nvim' },
    { "chrisgrieser/nvim-spider" },

    { 'ggandor/leap.nvim', enabled = false, },
    { 'Sleepful/leap-by-word.nvim', enabled = false, },

    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-buffer' }, -- autocomplete without lsp
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/cmp-nvim-lua' },
    { 'hrsh7th/cmp-nvim-lsp' },

    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim', },
        event = 'User load-telescope',
    },

    { 'neovim/nvim-lspconfig' },

    { -- super slow (half the startup time)
        'williamboman/mason.nvim',
        cmd = {
            'Mason', 'MasonUpdate', 'MasonInstall',
            'MasonUninstall', 'MasonLog',
        },
        config = function() require('mason').setup{} end,
    },
}, {
    install = {
        missing = false,
        colorscheme = { "habamax" },
    },
    performance = {
        rtp = {
            disabled_plugins = {
                'gzip', 'matchit', 'matchparen',
                'tarPlugin', 'tohtml', 'tutor',
                'zipPlugin',
            },
        },
    },
    change_detection = { enabled = false },
})
