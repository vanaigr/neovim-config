local vim = vim -- fix lsp warning

local map = {}

local stats_path = vim.fn.stdpath('data') .. '/map_stats/'
local stats_fp = stats_path .. 'stats.txt'

map.__stats = {}

local function write(force)
    -- technically there can be new keymaps that weren't used
    -- which wouln't be written
    if not force and not map.__added then return end

    local prev_stats

    local f = io.open(stats_fp, 'r+b')
    if f then
        local prev_stats_s = f:read('a')
        if prev_stats_s ~= '' then
            local ok
            ok, prev_stats = pcall(function()
                return vim.json.decode(prev_stats_s)
            end)
            if not ok then
                -- who is going to see this??
                print("Warning: stats file is corrupded:", prev_stats)
                local msg = prev_stats
                prev_stats = nil
                pcall(function()
                    local bkp_fp = stats_path .. 'bkp' .. vim.loop.hrtime() .. '.txt'
                    local bkp_fd = io.open(bkp_fp, 'w+b')
                    bkp_fd:write(prev_stats_s)
                    bkp_fd:write('\n')
                    bkp_fd:write(msg)
                    bkp_fd:close()
                end)
            end
        end
    else
        print("Create the file yourself!")
        return
    end

    if prev_stats then
        for k, dv in pairs(map.__stats) do
            local v = prev_stats[k]
            prev_stats[k] = v and v + dv or dv
        end
    else
        prev_stats = map.__stats
    end
    map.__stats = {}

    f:seek("set")
    f:write(vim.json.encode(prev_stats))
    f:close()

    print("Written!")
end

pcall(function()
    local group = vim.api.nvim_create_augroup('KeymapsStats', { clear = true })
    vim.api.nvim_create_autocmd("VimLeavePre", {
        pattern = '*', group = group, callback = function() write() end,
    })

    vim.api.nvim_create_autocmd("User", {
        pattern = 'WriteKeymapStats',
        group = group,
        callback = function() write(true) end ,
    })

    local period = 5 * 60 * 1000

    if KeymapsTimer then KeymapsTimer:stop() end
    KeymapsTimer = vim.loop.new_timer()
    KeymapsTimer:start(period, period, vim.schedule_wrap(function()
        local ok, msg = pcall(function() write() end)
        if not ok then
            KeymapsTimer:stop()
            vim.api.nvim_echo({{ 'keymap stats error: ' .. msg, 'ErrorMsg' }}, true, {})
        end
    end))
end)

function map.__profile(key)
    map.__added = true
    local s = map.__stats[key]
    if s then map.__stats[key] = s + 1
    else map.__stats[key] = 1 end
end

function map.__start_profile(key)
    if not map.__stats[key] then map.__stats[key] = 0 end
end

function map.qnoremap(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then options = vim.tbl_extend('keep', opts, options) end


    if type(rhs) == 'string' and options.expr then
        local mode_s = mode
        if type(mode_s) == 'table' then mode_s = vim.inspect(mode_s) end

        --print('Warning: not recordable keymap ' .. mode_s .. '-' .. lhs)
        vim.keymap.set(mode, lhs, rhs, opts)
        return
    end

    if type(mode) == 'string' then
        local key = mode .. '-' .. lhs
        map.__start_profile(key)
        if type(rhs) == 'string' then
            options.expr = true
            vim.keymap.set(mode, lhs, function()
                map.__profile(key)
                return rhs
            end, options)
        else
            vim.keymap.set(mode, lhs, function()
                map.__profile(key)
                return rhs()
            end, options)
        end
    else
        for _, m in ipairs(mode) do
            map.__start_profile(m .. '-' .. lhs)
        end
        if type(rhs) == 'string' then
            options.expr = true
            vim.keymap.set(mode, lhs, function()
                map.__profile(vim.fn.mode() .. '-' .. lhs)
                return rhs
            end, options)
        else
            vim.keymap.set(mode, lhs, function()
                map.__profile(vim.fn.mode() .. '-' .. lhs)
                return rhs()
            end, options)
        end
    end
end

--function map.a(a, b, o) map.qnoremap('' , a, b, o) end
--function map.i(a, b, o) map.qnoremap('i', a, b, o) end
--function map.c(a, b, o) map.qnoremap('c', a, b, o) end
--function map.n(a, b, o) map.qnoremap('n', a, b, o) end
--function map.x(a, b, o) map.qnoremap('x', a, b, o) end
--function map.o(a, b, o) map.qnoremap('o', a, b, o) end
--function map.t(a, b, o) map.qnoremap('t', a, b, o) end

setmetatable(map, {
    __index = function(tab, key)
        local modes = vim.split(key, '')
        local func = function(...) map.qnoremap(modes, ...) end
        rawset(tab, key, func)
        return func
    end
})

return map
