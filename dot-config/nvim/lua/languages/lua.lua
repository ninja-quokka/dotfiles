vim.pack.add({
	"https://github.com/folke/lazydev.nvim",
})

if vim.g.lazydev_enabled then
  require("lazydev").setup()
end

-- This function will only run on buffers of this filetype
G.ftplugin.lua = function()
	vim.keymap.set("v", "r", ":'<,'>lua<CR>", { buffer = true, silent = true })
end
