local vim = vim -- fix lsp warning

-- show highest diagnostic on the line
vim.diagnostic.config{ severity_sort = true }
-- there's also a different way, not sure what's the benefit
-- https://neovim.io/doc/user/diagnostic.html

-- see lsp-zero

local m = require('mapping')

local lualine_warned = false
local function lualine()
    local lualine_ok, err = pcall(function()
        require('lualine').refresh()
    end)
    if not lualine_ok and not lualine_warned then
        lualine_warned = true
        vim.notify_once('[MY] Lualine LSP notification error: ' .. vim.inspect(err), vim.log.levels.WARN)
    end
end

local g = vim.api.nvim_create_augroup('LSPGroup', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
    group = g,
    callback = function(event)
        local options = { buffer = event.buf }

        m.n('<A-;>a', function() vim.lsp.buf.code_action() end, options)
        m.n('<A-;>h', function() vim.lsp.buf.hover() end, options)
        m.n('<A-;>s', function() vim.lsp.buf.signature_help() end, options)
        m.n('<A-;>v', function() vim.lsp.buf.rename() end, options)
        m.n('<A-;>r', function() vim.lsp.buf.references() end, options)
        m.n('<A-;>d', function() vim.diagnostic.open_float() end, options)

        m.i('<A-;>h', function() vim.lsp.buf.hover() end, options)
        m.i('<A-;>s', function() vim.lsp.buf.signature_help() end, options)
        m.i('<A-;>d', function() vim.diagnostic.open_float() end, options)

        m.n('[d', function() vim.diagnostic.goto_prev() end, options)
        m.n(']d', function() vim.diagnostic.goto_next() end, options)

        m.n('gd', function() vim.cmd('tab split'); vim.lsp.buf.definition() end, options)
        m.n('gD', function() vim.cmd('tab split'); vim.lsp.buf.declaration() end, options)

        m.n('gi', function() vim.cmd('tab split'); vim.lsp.buf.implementation() end, options)

        lualine()
    end
})

vim.api.nvim_create_autocmd('LspDetach', {
    group = g,
    callback = function(event)
        lualine()
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
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover, { close_events = { 'CursorMoved' } }
)
-- TODO: add for hover and float

-- use mason path for lsps
local mason_path = vim.fn.stdpath('data') .. '/mason/bin'

-- Do this manually since Mason is slow
local lspconfig = require('lspconfig')

local function conf(name, f)
    if not name then
        vim.notify('SKIPPING: ' .. f, vim.log.levels.WARN, {})
        return
    end
    local ok, res = pcall(f)
    if not ok then
        vim.notify(name..' LSP ERROR: '..res, vim.log.levels.WARN, {})
    end
end

conf('lua', function()
    lspconfig.lua_ls.setup{
        cmd = { mason_path .. '/lua-language-server' },
        capabilities = capabilities,
        settings = {
            Lua = {
                workspace = {
                    library = vim.api.nvim_get_runtime_file('', true),
                    checkThirdParty = false, -- LoOk At Me I aM aNnoYiNg Af!!!!!!11!!!1!1!
                },
            }
        }
    }
end)
conf('clang', function()
    lspconfig.clangd.setup{
        cmd = { mason_path .. '/clangd' },
        capabilities = capabilities,
    }
end)

conf('typescript-tools', function()
    local api = require("typescript-tools.api")

    require("typescript-tools").setup{
        settings = {
            separate_diagnostic_server = false,
            publish_diagnostic_on = "insert_leave",
            expose_as_code_action = { "add_missing_imports" },
            tsserver_max_memory = "auto",
            tsserver_locale = "en",
            complete_function_calls = false,
            include_completions_with_insert_text = true,
            code_lens = "all",
            jsx_close_tag = {
                enable = false,
                filetypes = { "javascriptreact", "typescriptreact" },
            },
        },
        handlers = {
            ["textDocument/publishDiagnostics"] = api.filter_diagnostics{ 7016, 80001 },
        },
    }
end)

conf('css', function()
    lspconfig.cssls.setup{}
end)

conf('eslint', function()
    -- lspconfig.eslint.setup{ }
end)

conf('rust', function()
    lspconfig.rust_analyzer.setup{}
end)

conf('cmake', function()
    lspconfig.cmake.setup {
        cmd = { mason_path .. '/cmake-language-server' },
    }
end)

conf('tailwind', function()
    lspconfig.tailwindcss.setup {
        cmd = { mason_path .. '/tailwindcss-language-server' },
    }
end)

conf('csharp', function()
    -- https://github.com/OmniSharp/omnisharp-roslyn/issues/2577
    lspconfig.omnisharp.setup {
        cmd = { mason_path .. '/omnisharp' },
        handlers = {
            ['textDocument/definition'] = require('omnisharp_extended').handler,
        }
    }
end)
