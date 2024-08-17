local mason_path = vim.fn.stdpath('data') .. '/mason/bin'
print(mason_path)

require("typescript-tools").setup {
  settings = {
    separate_diagnostic_server = false,
    publish_diagnostic_on = "insert_leave",
    expose_as_code_action = { "add_missing_imports" },
    tsserver_path = mason_path .. 'typescript-language-server',
    tsserver_plugins = {},
    tsserver_max_memory = "auto",
    tsserver_format_options = {},
    tsserver_file_preferences = {},
    tsserver_locale = "en",
    complete_function_calls = false,
    include_completions_with_insert_text = true,
    code_lens = "off",
    disable_member_code_lens = true,
    jsx_close_tag = {
        enable = true,
        filetypes = { "javascriptreact", "typescriptreact" },
    }
  },
}
