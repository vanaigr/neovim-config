local vim = vim -- fix lsp warning

local lsp = require('lsp-zero')

local m = require('mapping')

lsp.on_attach(function(client, bufnr)
    local options = { buffer = bufnr }

    m.n('<C-l>a', function() vim.lsp.buf.code_action() end, options)
    m.n('<C-l>h', function() vim.lsp.buf.hover() end, options)
    m.n('<C-l>s', function() vim.lsp.buf.signature_help() end, options)
    m.n('<C-l>v', function() vim.lsp.buf.rename() end, options)
    m.n('<C-l>r', function() vim.lsp.buf.references() end, options)

    m.n('<C-l>d', function() vim.diagnostic.open_float() end, options)
    m.n('[d', function() vim.diagnostic.goto_prev() end, options)
    m.n(']d', function() vim.diagnostic.goto_next() end, options)

    m.n('gd', function() vim.lsp.buf.definition() end, options)
    m.n('gD', function() vim.lsp.buf.declaration() end, options)
end)
