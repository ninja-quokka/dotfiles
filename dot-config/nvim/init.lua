-- Create empty table assigned to the global variable G
-- to be used as a global namespace.
_G.Global = {}
G = _G.Global
G.ftplugin = {}

-- Leader must be set before any keymaps are defined
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable experimental "extended UI" (extui) features
require('vim._core.ui2').enable({})

-- Set theme:
require("themes.teide")

-- load plugins
local groups = {
  vim.api.nvim_get_runtime_file("lua/core/*.lua", true),
  vim.api.nvim_get_runtime_file("lua/plugins/*.lua", true),
  vim.api.nvim_get_runtime_file("lua/languages/*.lua", true),
}

require("core.loader").start(groups)

-- load LSPs
require("core.lsp").setup({
  "ansiblels",
  "basedpyright",
  "gopls",
  "golangci-lint-langserver",
  "lua_ls",
  "bashls",
  "ruff",
  "yamlls",
})
