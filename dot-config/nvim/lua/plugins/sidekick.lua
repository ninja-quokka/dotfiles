--- Sidekick.nvim - AI coding assistant integration
--- Provides AI-powered code suggestions and assistance through a CLI interface

vim.pack.add({ "https://github.com/folke/sidekick.nvim" })

local sidekick = require("sidekick")
local map = require("core.utils").map

sidekick.setup({})

-- Keymaps
local function toggle_cli()
  require("sidekick.cli").toggle({ name = "cursor", focus = true })
end

local function send_visual_selection()
  require("sidekick.cli").send({ msg = "{selection}" })
end

local function send_file()
  require("sidekick.cli").send({ msg = "{file}" })
end

map("n", "<leader>aa", toggle_cli, { desc = "Sidekick: Toggle CLI" })
map("x", "<leader>av", send_visual_selection, { desc = "Sidekick: Send Visual Selection" })
map("n", "<leader>af", send_file, { desc = "Sidekick: Send File" })
