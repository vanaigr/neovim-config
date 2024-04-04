local vim = vim -- fix lsp warning

local separator
if vim.fn.has('win32') or vim.fn.has('win64') then separator = ';'
else separator = ':' end

-- use mason path
local mason_path = vim.fn.stdpath('data') .. '/mason/bin'
vim.env.PATH = mason_path .. separator .. vim.env.PATH

local m = require('mapping')

local lsp = require('lsp-zero')

lsp.on_attach(function(client, bufnr)
    local options = { buffer = bufnr }

    m.n('<A-l>a', function() vim.lsp.buf.code_action() end, options)
    m.n('<A-l>h', function() vim.lsp.buf.hover() end, options)
    m.n('<A-l>s', function() vim.lsp.buf.signature_help() end, options)
    m.n('<A-l>v', function() vim.lsp.buf.rename() end, options)
    m.n('<A-l>r', function() vim.lsp.buf.references() end, options)

    m.n('<A-l>d', function() vim.diagnostic.open_float() end, options)

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

-- Do this manually since Mason is slow
lsp.default_setup('lua_ls')
lsp.default_setup('clangd')
