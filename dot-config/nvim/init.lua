-- Enable experimental Lua module loader that reduces
-- startup time by caching byte-compiled Lua files.
vim.loader.enable()

-- Enable experimental “extended UI” (extui) features
require("vim._extui").enable({})
vim.o.cmdheight = 0

-- Set theme:
require("themes.onedarkpro")

-- Create empty table assigned to the global variable G
-- to be used as a global namespace.
_G.G = {}

-- Load core files on startup
require("core.options")
require("core.autocommands")
require("core.keymaps")
require("core.statusline")
require("core.auto-session") -- Requires to run early on VimEnter
require("core.blink")
require("core.tiny-inline-diagnostic")
require("core.lsp").setup({
  "gopls",
  "golangci-lint-langserver",
  "lua_ls",
  "bashls",
  "ruff",
  "yamlls",
})

-- Lazy load plugins
local groups = {
  vim.api.nvim_get_runtime_file("lua/plugins/*.lua", true),
  vim.api.nvim_get_runtime_file("lua/core/std.lua", true),
  vim.api.nvim_get_runtime_file("lua/languages/*.lua", true),
}

require("core.loader").start(groups)
