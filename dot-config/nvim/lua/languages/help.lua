-- This function will only run on the buffer that opens this filetype
G.ftplugin.help = function()
  vim.keymap.set("n", "q", ":q<CR>", { buffer = true, desc = "Close help window" })
end
