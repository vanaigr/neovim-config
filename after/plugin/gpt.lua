local template = [====[
# topic: ?

- file: {{filename}}
{{optional_headers}}
<C-g> sends. <C-c> cancels

{{user_prefix}}
]====]

local m = require('mapping')

require("gp").setup{
    openai_api_key = _G.my_config.openai_api_key,
    chat_template = template,
    chat_conceal_model_params = false,

 	chat_shortcut_respond = { modes = {}, shortcut = "" },
 	chat_shortcut_delete = { modes = {}, shortcut = "" },
 	chat_shortcut_stop = { modes = {}, shortcut = "" },
 	chat_shortcut_new = { modes = {}, shortcut = "" },
}

vim.api.nvim_create_autocmd("User", {
    pattern = "GpChatPrepare",
    callback = function(event)
        local opts = { buffer = event.data.buf }
        m.n('<C-g>', function() vim.cmd('GpChatRespond') end, opts)
        m.i('<C-g>', function() vim.cmd('GpChatRespond') end, opts)

        m.n('<C-c>', function() vim.cmd('GpChatStop') end, opts)
    end,
})

m.n('<leader>c', function() vim.cmd('GpChatNew tabnew') end)
