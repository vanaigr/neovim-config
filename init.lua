local vim = vim -- fix lsp warning

local ok, config = pcall(require, 'localSettings')

if ok then
    _G.my_config = config
else
    _G.my_config = { low_perf = false }
end

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

--local counter = 0
--local ns = vim.api.nvim_create_namespace('jdlsfkjaeilfaska:SLNCwldnqiewqoperqeowuroeocnoicei')
--vim.api.nvim_set_decoration_provider(ns, {
--    on_win = function()
--        return true
--    end,
--    on_line = function(_, _, _, line)
--        counter = counter + 1
--        print('  line: '..line)
--    end,
--    on_end = function()
--        print('end', counter)
--    end
--})
--vim.api.nvim_buf_set_extmark(0, vim.api.nvim_create_namespace('abclfkdj'), 0, 0, { virt_text = { { 'a' }} })
