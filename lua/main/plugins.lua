local vim = vim -- fix lsp warning

require('lazy').setup({
    { 'brenoprata10/nvim-highlight-colors' },

    { 'rose-pine/neovim', name = 'rose-pine' },
    {
        'Wansmer/treesj',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        event = 'User load-treesj'
    },
    { 'jake-stewart/multicursor.nvim' },

    { 'vanaigr/motion.nvim' },
    { 'vanaigr/mark-signs.nvim' },

    -- better than neogit...
    { 'tpope/vim-fugitive', command = 'Git', event = 'User load-fugitive' }, -- git

    { 'vanaigr/targets.vim' }, -- replaced with unmerged bugfix
    { 'kylechui/nvim-surround' },
    { 'mbbill/undotree' },
    { 'numToStr/Comment.nvim', event = 'User load-comment' },
    { 'nvim-treesitter/nvim-treesitter' },
    { 'bkad/CamelCaseMotion' },
    { 'dstein64/nvim-scrollview' },
    { 'nvim-lualine/lualine.nvim' },
    { 'HiPhish/rainbow-delimiters.nvim' },
    { 'echasnovski/mini.nvim' },

    { 'vanaigr/easyword.nvim' },
    { 'chrisgrieser/nvim-spider' },
    { 'simonmclean/triptych.nvim' },

    { 'FabijanZulj/blame.nvim' },

    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-buffer' }, -- autocomplete without lsp
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/cmp-nvim-lua' },
    { 'hrsh7th/cmp-nvim-lsp' },

    { 'Hoffs/omnisharp-extended-lsp.nvim' },

    {
        "luckasRanarison/tailwind-tools.nvim",
        name = "tailwind-tools",
        build = ":UpdateRemotePlugins",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            -- optional
            "nvim-telescope/telescope.nvim",
            "neovim/nvim-lspconfig",
        },
    },

    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
    },

    {
        'vanaigr/telescope.nvim',
        branch='help-tags-perf-11',
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
