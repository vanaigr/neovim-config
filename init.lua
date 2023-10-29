local vim = vim -- fix lsp warning

vim.api.nvim_exec2('language en_US', {})

function LoadModule(name)
    local loaded, result = pcall(require, name)

    if not loaded then
        print("ERROR. `" .. name .. "` not loaded: " .. result .. '\n')
        return false, result
    else
        return true, result
    end
end

require('main')
