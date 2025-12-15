vim.pack.add({
  "https://github.com/folke/tokyonight.nvim",
})

local tn = require("tokyonight")

tn.setup({
  style = "night",
  styles = {
    tags = { italic = true },
    methods = { bold = true },
    functions = { bold = true },
    parameters = { italic = true },
    conditionals = { italic = true },
    virtual_text = { italic = true },
    NvimDapVirtualText = { italic = true },
    DiagnosticHint = { italic = true },
  },
  --Override highlight options for plugins
  -- highlights = {
  --   RenderMarkdownChecked = { bg = "#282c34", fg = "#98c379" },
  --   CustomCybuFocus = { fg = ikea_yellow },
  --   CustomCybuBackground = { bg = "#282c34" },
  --   CustomCybuBorder = { bg = "#282c34" },
  --   NvimTreeOpenedFolderName = { fg = ikea_yellow },
  --   NvimTreeFolderIcon = { fg = "#abb2c0" },
  --   NvimTreeRootFolder = { fg = ikea_yellow },
  --   NvimTreeGitDirtyIcon = { fg = ikea_yellow },
  --   NvimTreeFolderName = { fg = "#abb2c0" },
  --   DiagnosticHint = { italic = true, bold = true },
  -- },
})

vim.cmd("colorscheme tokyonight-night")
