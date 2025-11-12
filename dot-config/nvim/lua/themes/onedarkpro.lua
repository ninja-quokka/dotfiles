vim.pack.add({
  "https://github.com/olimorris/onedarkpro.nvim",
})

local ikea_yellow = "#ffd800" -- Thanks Ikea

local odp = require("onedarkpro")

odp.setup({
  filetypes = {
    markdown = false,
  },

  styles = {
    tags = "italic",
    methods = "bold",
    functions = "bold",
    keywords = "italic",
    comments = "italic",
    parameters = "italic",
    conditionals = "italic",
    virtual_text = "italic",
    NvimDapVirtualText = "italic",
    DiagnosticHint = "italic",
  },

  colors = {
    onedark = {
      cursorline = "#ffffff",
      color_column = "#ffffff",
    },
  },

  --Override highlight options for plugins
  highlights = {
    RenderMarkdownChecked = { bg = "#282c34", fg = "#98c379" },
    CustomCybuFocus = { fg = ikea_yellow },
    CustomCybuBackground = { bg = "#282c34" },
    CustomCybuBorder = { bg = "#282c34" },
    NvimTreeOpenedFolderName = { fg = ikea_yellow },
    NvimTreeFolderIcon = { fg = "#abb2c0" },
    NvimTreeRootFolder = { fg = ikea_yellow },
    NvimTreeGitDirtyIcon = { fg = ikea_yellow },
    NvimTreeFolderName = { fg = "#abb2c0" },
    DiagnosticHint = { italic = true, bold = true },
  },
})

vim.cmd("colorscheme onedark_vivid")
