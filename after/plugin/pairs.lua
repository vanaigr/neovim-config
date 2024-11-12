local group = vim.api.nvim_create_augroup("my_autopairs", { clear = true })
local ns = vim.api.nvim_create_namespace('my_autopairs')
local buffers = {}

vim.api.nvim_create_autocmd('InsertEnter', {
    group = group,
    callback = function()
        print('insert enter')
    end
})

vim.api.nvim_set_hl(0, 'AutopairsCurrent', { reverse = true, bold = true })

local autopairs = {
    { '(', ')' },
    { '{', '}' },
    { '[', ']' },
    { '"', '"' },
    { "'", "'" },
    { '`', '`' },
}

-- globally unique prefix
local mapping = vim.api.nvim_exec2(
  "function s:a()\nendfun\nechon expand('<SID>')",
  { output = true }
).output .. 'autopairs'

local mapping_id = 0

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

vim.keymap.set('i', '<cr>', function()
    local pos = vim.api.nvim_win_get_cursor(0)
    if findAround(pos) then
        local marks = vim.api.nvim_buf_get_extmarks(vim.api.nvim_get_current_buf(), ns, { pos[1] - 1, pos[2] }, { pos[1] - 1, pos[2] }, {})
        for _, mark in ipairs(marks) do
            vim.api.nvim_buf_del_extmark(0, ns, mark[1])
            break
        end
        return '<cr><cr><up><C-f>'
    end

    return '<cr>'
end, { remap = false, expr = true })

vim.keymap.set('i', '<bs>', function()
    local pos = vim.api.nvim_win_get_cursor(0)
    local res = findAround(pos)
    if res then
        local marks = vim.api.nvim_buf_get_extmarks(vim.api.nvim_get_current_buf(), ns, { pos[1] - 1, pos[2] }, { pos[1] - 1, pos[2] }, {})
        if #marks ~= 0 then
            local count = vim.fn.strcharlen(res[2])
            return string.rep('<right>', count) .. string.rep('<bs>', count + 1)
        end
    end

    return '<bs>'
end, { remap = false, expr = true })

vim.api.nvim_create_autocmd('InsertCharPre', {
    group = group,
    callback = function()
        local pos = vim.api.nvim_win_get_cursor(0)
        local c = vim.v.char

        for _, v in ipairs(autopairs) do
            if c == v[2] then
                local count = vim.fn.strcharlen(v[2])
                local len = #v[2]

                local marks = vim.api.nvim_buf_get_extmarks(vim.api.nvim_get_current_buf(), ns, { pos[1] - 1, pos[2] }, { pos[1] - 1, pos[2] }, {})
                for _, mark in ipairs(marks) do
                    local ok, res = pcall(vim.api.nvim_buf_get_text, 0, mark[2], mark[3], mark[2], mark[3] + len, {})
                    if ok then
                        res = table.concat(res, '')
                        if res == v[2] then
                            vim.api.nvim_buf_del_extmark(0, ns, mark[1])
                            vim.v.char = ''
                            vim.api.nvim_feedkeys(string.rep(vim.api.nvim_replace_termcodes('<right>', true, false, true), count), 'n', false)
                            return
                        end
                    end
                end
            end

            if c == v[1] then
                local proceed = true
                local ok, res = pcall(vim.api.nvim_buf_get_text, 0, pos[1] - 1, pos[2], pos[1] - 1, pos[2] + 1, {})
                if ok then
                    res = res[1]
                    local chars = ' \t,;)}]'
                    proceed = chars:find(res) ~= nil
                end

                if proceed then
                    vim.v.char = v[1] .. v[2]
                    local count = vim.fn.strcharlen(v[2])
                    local len = #v[2]

                    local this_id = mapping_id
                    mapping_id = mapping_id + 1
                    local this_name = mapping .. this_id

                    vim.keymap.set('i', this_name, function()
                        vim.keymap.del('i', this_name)
                        local pos = vim.api.nvim_win_get_cursor(0)
                        buffers[vim.api.nvim_get_current_buf()] = true
                        vim.api.nvim_buf_set_extmark(0, ns, pos[1] - 1, pos[2], {
                            end_col = pos[2] + len,
                            hl_group = 'AutopairsCurrent'
                        })
                    end)

                    vim.api.nvim_feedkeys(string.rep(vim.api.nvim_replace_termcodes('<left>', true, false, true), count), 'n', false)
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(this_name, true, false, true), '', false)
                    break
                end
            end
        end
    end
})

vim.api.nvim_create_autocmd('InsertLeavePre', {
    group = group,
    callback = function()
        for buf in pairs(buffers) do
            pcall(vim.api.nvim_buf_clear_namespace, buf, ns, 0, -1)
        end
        buffers = {}
    end
})
