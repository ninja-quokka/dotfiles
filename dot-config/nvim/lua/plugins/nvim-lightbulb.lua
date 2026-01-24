vim.pack.add({
  "https://github.com/kosayoda/nvim-lightbulb",
})

require("nvim-lightbulb").setup({
  autocmd = { enabled = true },
  ignore = {
    -- LSP client names to ignore.
    -- Example: {"null-ls", "lua_ls"}
    clients = {},
    -- Filetypes to ignore.
    -- Example: {"neo-tree", "lua"}
    ft = {},
  },
})
