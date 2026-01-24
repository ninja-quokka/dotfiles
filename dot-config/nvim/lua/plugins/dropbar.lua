vim.pack.add({
  "https://github.com/Bekaboo/dropbar.nvim",
})

require("dropbar").setup({
  menu = {
    quick_navigation = false,
    preview = false,
    hover = false,
  },
})
