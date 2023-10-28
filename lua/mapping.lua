local map = {}

function map.qnoremap(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        if opts.desc then
            opts.desc = "keymaps.lua: " .. opts.desc
        end
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

function map.a(a, b, o) map.qnoremap('' , a, b, o) end
function map.i(a, b, o) map.qnoremap('i', a, b, o) end
function map.c(a, b, o) map.qnoremap('c', a, b, o) end
function map.n(a, b, o) map.qnoremap('n', a, b, o) end
function map.x(a, b, o) map.qnoremap('x', a, b, o) end
function map.o(a, b, o) map.qnoremap('o', a, b, o) end

return map
