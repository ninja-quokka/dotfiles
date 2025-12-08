-- equalize the size of all open windows in the current tab page
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    vim.cmd("wincmd =")
  end,
})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Shortcut for updating plugins
vim.api.nvim_create_user_command("UpdatePlugins", function()
  vim.pack.update()
end, { desc = "Update all plugins" })

