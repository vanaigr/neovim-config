local vim = vim

local cmp = require('cmp')

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = false


local menus = {
    ['buffer'] = 'buf',
    ['nvim_lua'] = 'vim',
    ['nvim_lsp'] = 'lsp',
    ['cmdline'] = 'cmd',
}

local format = {
    fields = { 'abbr', 'kind', 'menu' },
    format = function(entry, item)
        item.menu = menus[entry.source.name]
        return item
  end
}

local mapping = {
    ['<A-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<A-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    -- <a-j> are remapped system-wide
    ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<A-l>'] = cmp.mapping.confirm({ select = true }),
    ['<A-h>'] = cmp.mapping.abort(),
}

local snippetKind = cmp.lsp.CompletionItemKind.Snippet

cmp.setup{
    sources = cmp.config.sources{
        { name = 'nvim_lua', max_item_count = 3 },
        {
            name = 'nvim_lsp',
            max_item_count = 3,
            entry_filter = function(entry)
                return entry:get_kind() ~= snippetKind
            end,
        },
        { name = 'buffer', max_item_count = 3 },
    },
    mapping = mapping,
    formatting = format,
}

cmp.setup.cmdline('/', {
    mapping = mapping,
    sources = { { name = 'buffer' } },
    formatting = {
        fields = { 'abbr' },
        format = function(_, item)
            return item
        end
    },
})

local group = vim.api.nvim_create_augroup('SetupCommandCMPGroup', { clear = true })
vim.api.nvim_create_autocmd('User', {
    group = group, pattern = 'SetupCommandCMP',
    callback = function(_)
        cmp.setup.buffer({
            sources = {
                {
                    name = 'cmdline',
                    option = { ignore_cmds = { 'Man', '!' } },
                    max_item_count = 3,
                },
                { name = 'nvim_lua', max_item_count = 3 },
                { name = 'buffer', max_item_count = 3 },
            }
        })
    end,
})
