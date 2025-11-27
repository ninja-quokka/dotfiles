-- Helper
local map = vim.keymap.set

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Keybinds to make split navigation easier.
-- Use CTRL+<hjkl> to switch between windows
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Yank the contents of the current buffer
map("n", "<leader>y", "<cmd>%y+<CR>", { desc = "Yank whole file" })

-- Enter command mode with either ; or :
map("n", ";", ":", { desc = "CMD enter command mode" })

-- Change the annoying cut behaviour but allow it via shift
map({ "n", "x" }, "d", '"_d', { noremap = true })
map({ "n", "x" }, "D", "d", { noremap = true })
map({ "n", "x" }, "x", '"_x', { noremap = true })
map({ "n", "x" }, "X", "x", { noremap = true })
map("n", "dd", '"_dd', { noremap = true })
map("n", "DD", "dd", { noremap = true })
map({ "n", "x" }, "p", "P", { noremap = true })

-- Mouse menu options
vim.cmd.amenu [[PopUp.Code\ action <Cmd>lua vim.lsp.buf.code_action()<CR>]]
vim.cmd.amenu [[PopUp.LSP\ Hover <Cmd>lua vvim.lsp.buf.hoverim.lsp.buf.hover()<CR>]]

map("n", "<leader>w", function() vim.cmd("silent! w") end, { desc = "Write buffer" })
map("n", "<leader>q", function() vim.cmd("silent! q") end, { desc = "Quit window" })
map("n", "ga", "<cmd>b#<CR>", { desc = "Go to last Accessed file (Ctrl + ^ synonim)" })
map("x", "R", ":s###g<left><left><left>", { desc = "Start replacement in selected range" })
map("n", "<C-n>", "<cmd>cnext<CR>")
map("n", "<C-p>", "<cmd>cprev<CR>")

-- Improved motions (Visual mode)
map('v', '<', '<gv', { noremap = true, silent = true })
map('v', '>', '>gv', { noremap = true, silent = true })
vim.keymap.del("s", "<")
vim.keymap.del("s", ">")

map('n', '<leader>ld', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { noremap = true, silent = true, desc = "Toggle vim diagnostics" })

map("n", "<leader>lh", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle lsp inlay hints" })

map({ "n", "t" }, "<C-t>", (function()
  local buf, win = nil, nil
  local was_insert = true
  local cfg = function()
    return {
      relative = 'editor',
      width = math.floor(vim.o.columns * 0.8),
      height = math.floor(vim.o.lines * 0.8),
      row = math.floor(vim.o.lines * 0.1),
      col = math.floor(vim.o.columns * 0.1),
      style = 'minimal',
      border = 'rounded',
    }
  end
  return function()
    buf = (buf and vim.api.nvim_buf_is_valid(buf)) and buf or nil
    win = (win and vim.api.nvim_win_is_valid(win)) and win or nil
    if not buf and not win then
      vim.cmd("split | terminal")
      buf = vim.api.nvim_get_current_buf()
      vim.api.nvim_win_close(vim.api.nvim_get_current_win(), true)
      win = vim.api.nvim_open_win(buf, true, cfg())
    elseif not win and buf then
      win = vim.api.nvim_open_win(buf, true, cfg())
    elseif win then
      was_insert = vim.api.nvim_get_mode().mode == "t"
      return vim.api.nvim_win_close(win, true)
    end
    if was_insert then vim.cmd("startinsert") end
  end
end)(), { desc = "Toggle float terminal" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

map("n", "<leader>rn", vim.lsp.buf.rename)
map("n", "M", vim.diagnostic.open_float)
map("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end)
map("n", "<leader>lf", vim.lsp.buf.format, { desc = "Lsp format buffer" })
map("n", "<leader>;", "<CMD>:noh<CR>", { desc = "clear search hl", silent = true })

