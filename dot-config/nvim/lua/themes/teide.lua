vim.pack.add({
  "https://github.com/serhez/teide.nvim",
})

require("teide").setup({
  style = "darker",
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
  plugins = {
    all = true,
  },
})

vim.cmd("colorscheme teide-darker")
