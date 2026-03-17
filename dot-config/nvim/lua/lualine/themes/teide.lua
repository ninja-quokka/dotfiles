local colors, config = require("teide.colors").setup()

local bg_inner = colors.bg_highlight

local function mode(accent)
  return {
    a = { bg = accent, fg = colors.bg_statusline, gui = "bold" },
    b = { fg = accent, bg = bg_inner },
    c = { fg = colors.dark7, bg = colors.bg_statusline },
    x = { fg = colors.dark7, bg = colors.bg_statusline },
    y = { fg = accent, bg = bg_inner },
    z = { bg = accent, fg = colors.bg_statusline, gui = "bold" },
  }
end

return {
  normal = mode(colors.blue),
  insert = mode(colors.green),
  command = mode(colors.yellow),
  visual = mode(colors.magenta),
  replace = mode(colors.red),
  terminal = mode(colors.green1),
  inactive = {
    a = { bg = colors.bg_statusline, fg = colors.fg_gutter },
    b = { fg = colors.fg_gutter, bg = colors.bg_statusline },
    c = { fg = colors.fg_gutter, bg = colors.bg_statusline },
    x = { fg = colors.fg_gutter, bg = colors.bg_statusline },
    y = { fg = colors.fg_gutter, bg = colors.bg_statusline },
    z = { bg = colors.bg_statusline, fg = colors.fg_gutter },
  },
}
