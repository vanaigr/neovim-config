require("scrollbar").setup{
    max_lines = 10000,
    handle = {
        text = " ",
        blend = 10,
        highlight = "CursorColumn",
        hide_if_all_visible = false,
    },
    marks = {
        Search = { priority = 1 },
        Error = { priority = 2 },
        Warn = { priority = 3 },
        Info = { priority = 5 },
        Hint = { priority = 4 },
        Misc = { priority = 6 },
    },
    excluded_buftypes = { },
    handlers = {
        cursor = false,
        diagnostic = true,
        gitsigns = false,
        handle = true,
        search = false,
        ale = false,
    },
}
