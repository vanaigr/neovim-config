local vim = vim -- fix lsp warning

-- see lsp-zero

local separator
if vim.fn.has('win32') or vim.fn.has('win64') then separator = ';'
else separator = ':' end

-- use mason path
local mason_path = vim.fn.stdpath('data') .. '/mason/bin'
vim.env.PATH = mason_path .. separator .. vim.env.PATH

local m = require('mapping')

local g = vim.api.nvim_create_augroup('LSPGroup', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
    group = g,
    callback = function(event)
        local options = { buffer = event.buf }

        m.n('<A-l>a', function() vim.lsp.buf.code_action() end, options)
        m.n('<A-l>h', function() vim.lsp.buf.hover() end, options)
        m.n('<A-l>s', function() vim.lsp.buf.signature_help() end, options)
        m.n('<A-l>v', function() vim.lsp.buf.rename() end, options)
        m.n('<A-l>r', function() vim.lsp.buf.references() end, options)
        m.n('<A-l>d', function() vim.diagnostic.open_float() end, options)

        m.i('<A-l>h', function() vim.lsp.buf.hover() end, options)
        m.i('<A-l>s', function() vim.lsp.buf.signature_help() end, options)
        m.i('<A-l>d', function() vim.diagnostic.open_float() end, options)

        m.n('[d', function() vim.diagnostic.goto_prev() end, options)
        m.n(']d', function() vim.diagnostic.goto_next() end, options)

        m.n('gd', function() vim.lsp.buf.definition() end, options)
        m.n('gD', function() vim.lsp.buf.declaration() end, options)
    end
})

local ok, capabilities = pcall(function()
    -- This is not enough for some servers (lua_ls). So also check for them on cmp side
    return require('cmp_nvim_lsp').default_capabilities{ snippet_support = false }
end)
if not ok then capabilities = nil end

-- still going to close after exiting insert mode bc of vim putting cursor
-- one char to the left and me resetting it back
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help, { close_events = { 'CursorMoved' } }
)
-- TODO: add for hover and float

-- Do this manually since Mason is slow
local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup{ capabilities = capabilities }
lspconfig.clangd.setup{ capabilities = capabilities }
