local group = vim.api.nvim_create_augroup("my_autopairs", { clear = true })
local ns = vim.api.nvim_create_namespace('my_autopairs')
local buffers = {}

vim.api.nvim_set_hl(0, 'AutopairsCurrent', { reverse = true, bold = true })

local autopairs = {
    { '(', ')' },
    { '{', '}' },
    { '[', ']' },
    { '"', '"' },
    { "'", "'" },
    { '`', '`' },
}

local function findAround(pos)
    local lens_bef = {}
    local lens_aft = {}
    for _, v in ipairs(autopairs) do
        local len_b = #v[1]
        local len_a = #v[2]

        if lens_bef[len_b] == nil then
            local final = 0
            local ok_b, res_b = pcall(vim.api.nvim_buf_get_text, 0, pos[1] - 1, pos[2] - len_b, pos[1] - 1, pos[2], {})
            if ok_b then final = table.concat(res_b, '') end
            lens_bef[len_b] = final
        end
        if lens_aft[len_a] == nil then
            local final = 0
            local ok_b, res_b = pcall(vim.api.nvim_buf_get_text, 0, pos[1] - 1, pos[2], pos[1] - 1, pos[2] + len_a, {})
            if ok_b then final = table.concat(res_b, '') end
            lens_aft[len_a] = final
        end

        local lb = lens_bef[len_b]
        local la = lens_aft[len_a]
        if lb == v[1] and la == v[2] then
            return v
        end
    end
end

local function mapCr(key)
    vim.keymap.set('i', key, function()
        if vim.api.nvim_get_mode().mode == 'i' then
            local pos = vim.api.nvim_win_get_cursor(0)
            if findAround(pos) then
                local marks = vim.api.nvim_buf_get_extmarks(vim.api.nvim_get_current_buf(), ns, { pos[1] - 1, pos[2] }, { pos[1] - 1, pos[2] }, {})
                for _, mark in ipairs(marks) do
                    vim.api.nvim_buf_del_extmark(0, ns, mark[1])
                    break
                end
                return '<cr><cr><up><esc>"_cc'
            end
        end

        return '<cr>'
    end, { remap = false, expr = true })
end
mapCr('<cr>')
mapCr('<S-cr>')

local function mapBs(key)
    vim.keymap.set('i', key, function()
        if vim.api.nvim_get_mode().mode == 'i' then
            local pos = vim.api.nvim_win_get_cursor(0)
            local res = findAround(pos)
            if res then
                local marks = vim.api.nvim_buf_get_extmarks(vim.api.nvim_get_current_buf(), ns, { pos[1] - 1, pos[2] }, { pos[1] - 1, pos[2] }, {})
                if #marks ~= 0 then
                    local count = vim.fn.strcharlen(res[2])
                    return string.rep('<right>', count) .. string.rep('<bs>', count + 1)
                end
            end
        end

        return '<bs>'
    end, { remap = false, expr = true })
end
mapBs('<bs>')
mapBs('<A-w>')

local ii = 0
local function mapPair(index)
    local open, close = unpack(autopairs[index])
    local o_len = #open
    local c_len = #close
    local c_count = vim.fn.strcharlen(close)

    vim.keymap.set('i', close, function()
        local pos = vim.api.nvim_win_get_cursor(0)
                    ii = ii + 1

        local marks = vim.api.nvim_buf_get_extmarks(vim.api.nvim_get_current_buf(), ns, { pos[1] - 1, pos[2] }, { pos[1] - 1, pos[2] }, {})
        for _, mark in ipairs(marks) do
            local ok, res = pcall(vim.api.nvim_buf_get_text, 0, mark[2], mark[3], mark[2], mark[3] + c_len, {})
            if ok then
                res = table.concat(res, '')
                if res == close then
                    vim.api.nvim_buf_del_extmark(0, ns, mark[1])
                    vim.api.nvim_feedkeys(string.rep(vim.api.nvim_replace_termcodes('<right>', true, false, true), c_count), 'n', false)
                    return
                end
            end
        end
        vim.api.nvim_feedkeys(close, 'n', false)
    end)

    vim.keymap.set('i', open, function()
        local pos = vim.api.nvim_win_get_cursor(0)

        local ok, res = pcall(vim.api.nvim_buf_get_text, 0, pos[1] - 1, pos[2], pos[1] - 1, pos[2] + 1, {})
        if ok then
            res = res[1]
            local chars = ' \t,;()(}[]'
            if chars:find(res, 0, true) == nil then
                vim.api.nvim_feedkeys(open, 'n', false)
                return
            end
        end

        vim.api.nvim_buf_set_text(0, pos[1] - 1, pos[2], pos[1] - 1, pos[2], { open .. close })
        vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + o_len })

        buffers[vim.api.nvim_get_current_buf()] = true
        vim.api.nvim_buf_set_extmark(0, ns, pos[1] - 1, pos[2] + o_len, {
            end_col = pos[2] + o_len + c_len,
            hl_group = 'AutopairsCurrent'
        })
   end)
end

for i in ipairs(autopairs) do
    mapPair(i)
end

vim.api.nvim_create_autocmd('InsertLeavePre', {
    group = group,
    callback = function()
        for buf in pairs(buffers) do
            pcall(vim.api.nvim_buf_clear_namespace, buf, ns, 0, -1)
        end
        buffers = {}
    end
})
