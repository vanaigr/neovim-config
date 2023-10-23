vim.api.nvim_exec2('language en_US', {})

function qnoremap(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        if opts.desc then
            opts.desc = "keymaps.lua: " .. opts.desc
        end
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

function LoadModule(name)
    local loaded, result = pcall(require, name)

    if not loaded then
        print("ERROR. `" .. name .. "` not loaded: " .. result .. '\n')
        return false, nil
    else
        return true, result
    end
end

require('main')
