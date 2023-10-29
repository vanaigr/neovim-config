local vim = vim -- fix lsp warning

local lsp = require('lsp-zero')

local cmp = require('cmp')
cmp.setup{
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
    },
    mapping = cmp.mapping.preset.insert{
        ['<C-k>'] = cmp.mapping.select_prev_item({ bahavior = 'select' }),
        ['<C-j>'] = cmp.mapping.select_next_item({ bahavior = 'select' }),
        ['<tab>'] = cmp.mapping.confirm({ select = true }),
    },
    formatting = lsp.cmp_format() -- show source name in completion menu
}

local m = require('mapping')

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({buffer = bufnr})
    local options = { buffer = bufnr }

    m.n('<C-l>a', function() vim.lsp.buf.code_action() end, options)
    m.n('<C-l>h', function() vim.lsp.buf.hover() end, options)
    m.n('<C-l>vr', function() vim.lsp.buf.rename() end, options)
    m.n('<C-l>r', function() vim.lsp.buf.references() end, options)
    m.n('<C-l>p', function() vim.diagnostic.goto_prev() end, options)
    m.n('<C-l>n', function() vim.diagnostic.goto_next() end, options)
end)

require('mason').setup{}
require('mason-lspconfig').setup{
  ensure_installed = { 'clangd', 'pyre' },
  handlers = { lsp.default_setup },
}
