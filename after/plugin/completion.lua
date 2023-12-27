local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

local lsp = require('lsp-zero')

--local luasnip = require('luasnip')

cmp.setup{
    --snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
    sources = cmp.config.sources{
        { name = 'nvim-lua', max_item_count = 10 },
        --{ name = 'luasnip', max_item_count = 5 },
        { name = 'nvim_lsp', max_item_count = 5 },
        --{ name = 'path', max_item_count = 5 }, -- deletes my // comments even if I typed other characters without undo :/
        { name = 'buffer', max_item_count = 5 },
    },
    mapping = {
        ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<tab>'] = cmp.mapping.confirm({ select = true }),
        --[[['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),]]

        ['<A-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<A-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<A-l>'] = cmp.mapping.confirm({ select = true }),
        ['<A-h>'] = cmp.mapping.abort(),
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    formatting = lsp.cmp_format(),
    experimental = {
        ghost_text = true
    }
}
cmp.setup.cmdline('/', {
    mapping = {
        ['<C-k>'] = { c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }) },
        ['<C-j>'] = { c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }) },
        ['<tab>'] = { c = cmp.mapping.confirm({ select = true }) },

        ['<A-k>'] = { c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }) },
        ['<A-j>'] = { c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }) },
        ['<A-l>'] = { c = cmp.mapping.confirm({ select = true }) },
        ['<A-h>'] = { c = cmp.mapping.abort() },
    },
    sources = { { name = 'buffer', max_item_count = 3 } }
})

cmp.setup.cmdline(':', {
    mapping = {
        ['<C-k>'] = { c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }) },
        ['<C-j>'] = { c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }) },
        ['<tab>'] = { c = cmp.mapping.confirm({ select = true }) },

        ['<A-k>'] = { c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }) },
        ['<A-j>'] = { c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }) },
        ['<A-l>'] = { c = cmp.mapping.confirm({ select = true }) },
        ['<A-h>'] = { c = cmp.mapping.abort() },
    },
    sources = cmp.config.sources{
        {
            name = 'cmdline',
            option = { ignore_cmds = { 'Man', '!' } },
            max_item_count = 10,
        },
        {
            name = 'path',
            max_item_count = 5,
        },
    }
})
