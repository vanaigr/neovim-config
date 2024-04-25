vim.opt.signcolumn = 'yes:1'

local ms = require('mark-signs')

ms.mark_builtin_options({ priority = 10, sign_hl = 'Comment' })
ms.mark_lower_options  ({ priority = 11, sign_hl = 'Normal', number_hl = 'CursorLineNr' })
ms.mark_upper_options  ({ priority = 12, sign_hl = 'Normal', number_hl = 'CursorLineNr' })
ms.mark_options('.', { hidden = true })

if MarkSignsTimer then MarkSignsTimer:stop() end
MarkSignsTimer = vim.uv.new_timer()
MarkSignsTimer:start(0, 400, vim.schedule_wrap(function()
    local ok, msg = pcall(function()
        -- don't display marks in cmdwin
        if vim.fn.getcmdwintype() ~= '' then return end

        ms.update_marks()
    end)
    if not ok then
        MarkSignsTimer:stop()
        vim.api.nvim_echo({{ 'mark-signs error: ' .. msg, 'ErrorMsg' }}, true, {})
    end
end))
