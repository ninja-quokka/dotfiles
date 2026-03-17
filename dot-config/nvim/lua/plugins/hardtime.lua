vim.pack.add({
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/m4xshen/hardtime.nvim",
})

require("hardtime").setup({
  disabled_keys = {
    ["<Up>"] = false,
    ["<Down>"] = false,
    ["<Left>"] = false,
    ["<Right>"] = false,
  },
  disable_mouse = false,
  max_count = 10,
  restriction_mode = "hint"
})
