vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-lualine/lualine.nvim",
})

-- Track DebugMode status
local dmode_enabled = false
vim.api.nvim_create_autocmd("User", {
  pattern = "DebugModeChanged",
  callback = function(args)
    dmode_enabled = args.data.enabled
    require("lualine").refresh()
  end,
})

local ll = require("lualine")

ll.setup({
  options = {
    theme = "teide",
    disabled_filetypes = {
      -- https://github.com/igorlfs/nvim-dap-view/issues/36
      winbar = {
        "dap-view",
        "dap-repl",
        "dap-view-term",
      },
    },
    globalstatus = true,
  },
  extensions = {
    "lazy",
    "toggleterm",
    "mason",
  },
  sections = {
    lualine_a = {
      {
        "mode",
        " ",
        { gui = "bold" },
        "mode",
        fmt = function()
          return dmode_enabled and "  DEBUG " or " "
        end,
        color = function()
          if dmode_enabled then
            if require("dap").status() ~= "" then
              return { bg = "#e06c75", gui = "bold" }
            end
          else
            return { gui = "bold" }
          end
        end,
      },
    },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = {
      { "filename", path = 1 },
    },
    lualine_x = { "filetype", "lsp_status" },
    lualine_y = { "progress" },
    lualine_z = { "location", "searchcount" },
  },
})
