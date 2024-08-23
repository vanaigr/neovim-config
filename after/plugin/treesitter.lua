local vim = vim -- fix lsp warning

require'nvim-treesitter.configs'.setup{
    -- warning from lua-language-server for not having these fields which are optional (but config type says are required)
    modules = {}, ignore_install = {}, ensure_installed = {},

    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        disable = function(lang, buf)
            local max_filesize = 1000 * 1024
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
        additional_vim_regex_highlighting = false,
    },
    -- note: pressing cc inside <style> inside .html moves the screen
    -- Check runtime/indent/html.vim func s:CSSIndent()  at  if below_end_brace
    -- It moves the cursor offscreen!
    indent = { enable = true },
    -- would be broken soon ...
    incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "'",
          node_incremental = "'",
          scope_incremental = "<Nop>",
          node_decremental = "<A-'>",
        },
    },
}
