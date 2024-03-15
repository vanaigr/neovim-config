local p = require('rose-pine.palette')

local colors = {
  textLight = p.text,
  textDark = p.base,
  normalBg   = p.foam,
  insertBg  = p.gold,
  visualBg = p.iris,
  replaceBg   = p.pine,
  commandBg   = p.rose,
  background  = p.highlight_low,
  background2  = p.overlay,
}

local colorScheme = {
  normal = {
    a = { fg = colors.textDark, bg = colors.normalBg, gui = 'bold' },
    b = { fg = colors.textLight, bg = colors.background },
    c = { fg = colors.textLight, bg = colors.background2 },
  },
  insert = {
    a = { fg = colors.textDark, bg = colors.insertBg, gui = 'bold' },
    b = { fg = colors.textLight, bg = colors.background },
  },
  visual = {
    a = { fg = colors.textDark, bg = colors.visualBg, gui = 'bold' },
    b = { fg = colors.textLight, bg = colors.background },
  },
  replace = {
    a = { fg = colors.textDark, bg = colors.replaceBg, gui = 'bold' },
    b = { fg = colors.textLight, bg = colors.background },
  },
  inactive = {
    a = { fg = colors.textLight, bg = colors.textDark, gui = 'bold' },
    b = { fg = colors.textLight, bg = colors.textDark },
    c = { fg = colors.textLight, bg = colors.background2 },
  },
  command = {
    a = { fg = colors.textDark, bg = colors.commandBg, gui = 'bold' },
    b = { fg = colors.textLight, bg = colors.background },
    c = { fg = colors.textLight, bg = colors.background2 },
  },
}

require('lualine').setup{
  options = {
    icons_enabled = false,
    theme = colorScheme,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    globalstatus = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff'},
    lualine_c = { {'diagnostics', symbols = {error = 'E', warn = 'W', info = 'I', hint = 'H'}} },
    lualine_x = {},
    lualine_y = {'filename'},
    lualine_z = {'location', 'progress'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  }
}
