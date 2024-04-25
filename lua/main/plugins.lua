local vim = vim -- fix lsp warning

require('lazy').setup({
    { 'rose-pine/neovim', name = 'rose-pine' },
    {
        'Wansmer/treesj',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        event = 'User LoadTreesj'
    },
    { 'mg979/vim-visual-multi' }, -- multicursor

    { 'vanaigr/mark-signs.nvim' },
    { 'tpope/vim-fugitive', enabled = true }, -- git
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
        }
    },
    { 'vanaigr/targets.vim' }, -- replaced with unmerged bugfix
    { 'kylechui/nvim-surround' },
    { 'mbbill/undotree' },
    { 'numToStr/Comment.nvim' },
    { 'nvim-treesitter/nvim-treesitter' },
    { 'bkad/CamelCaseMotion' },
    { 'petertriho/nvim-scrollbar' },
    { 'nvim-lualine/lualine.nvim' },
    { 'HiPhish/rainbow-delimiters.nvim' },
    { 'echasnovski/mini.nvim' },

    { 'vanaigr/easyword.nvim' },

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
        event = 'User LoadTelescope', -- somehow LazyLoadTelescope doesn't work...
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
