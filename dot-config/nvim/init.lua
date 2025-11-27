-- Create empty table assigned to the global variable G
-- to be used as a global namespace.
_G.Gobal = {}
G = _G.Gobal
G.ftplugin = {}

-- Enable experimental “extended UI” (extui) features
require("vim._extui").enable({})

-- Set theme:
require("themes.onedarkpro")

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
  "gopls",
  "golangci-lint-langserver",
  "lua_ls",
  "bashls",
  "ruff",
  "yamlls",
})
