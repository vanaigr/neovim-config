local vim = vim -- fix lsp warning

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    print('Downloading Lazy.nvim')
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('main')

--local redraw = 0
--local ns = vim.api.nvim_create_namespace('NamespaceName123')
--vim.api.nvim_set_decoration_provider(ns, {
--    on_start = function() print(redraw); redraw = redraw + 1 end
--})
