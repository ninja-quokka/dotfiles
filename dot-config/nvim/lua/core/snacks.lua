local map = require("core.utils").map

vim.pack.add({
  "https://github.com/folke/snacks.nvim",
})

require("snacks").setup({
  -- Detect large files and handle them
  bigfile = { enabled = true },
  quickfile = { enabled = true },

  picker = {
    enabled = true,
    picker = "fzf-lua",
    win = {
      input = {
        keys = {
          ["<C-j>"] = { "list_down", mode = { "i", "n" } },
          ["<C-k>"] = { "list_up", mode = { "i", "n" } },
        },
      },
    },
    sources = {
      gh_issue = {},
      gh_pr = {},
    },
  },

  indent = {
    enabled = true,
    animate = {
      enabled = true,
    },
    scope = {
      underline = true,
    },
    chunk = {
      enabled = true,
    },
    filter = function(buf)
      local b = vim.b[buf]
      local bo = vim.bo[buf]
      local excluded_filetypes = {
        markdown = true,
        text = true,
      }
      return vim.g.snacks_indent ~= false
        and b.snacks_indent ~= false
        and bo.buftype == ""
        and not excluded_filetypes[bo.filetype]
    end,
  },

  scope = { enabled = true },

  words = {
    enabled = true,
    debounce = 200,
  },

  gh = { enabled = true },
  git = { enabled = true },
  gitbrowse = { enabled = true },

  input = { enabled = false },

  rename = { enabled = true },

  bufdelete = {
    enabled = true,
  },

  scratch = {
    enabled = false,
    name = "Scratch",
    ft = "markdown", -- default filetype
    icon = "󰠮",
    autowrite = false,
  },

  terminal = {
    enabled = false,
    shell = vim.o.shell,
    win = {
      position = "bottom",
      height = 0.4,
    },
  },

  toggle = {
    enabled = false,
    -- Built-in toggle mappings
    which_key = true, -- integrate with which-key
  },

  image = { enabled = false },

  scroll = {
    enabled = true,
  },

  dim = {
    enabled = false,
  },

  animate = {
    enabled = false,
  },

  zen = {
    enabled = false,
  },

  statuscolumn = { enabled = false },

  debug = { enabled = false },

  profiler = { enabled = false },
})

-- stylua: ignore start
map("n", "<leader>sf", function() Snacks.picker.smart() end, { desc = "Find files" })
map("n", "<leader>sr", function() Snacks.picker.resume() end, { desc = "Find files" })
map("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Find string (livegrep)" })
map("n", "<leader>gI", function() Snacks.picker.gh_issue() end, { desc = "GitHub Issues (open)" })
map("n", "<leader>gp", function() Snacks.picker.gh_pr() end, { desc = "GitHub Pull Requests (open)" })
map("n", "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, { desc = "GitHub Pull Requests (all)" })
map("n", "<leader>go", function() Snacks.gitbrowse.open() end, { desc = "Open line in webbrowser" })


-- Let lsp know when files are renamed
local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
vim.api.nvim_create_autocmd("User", {
  pattern = "NvimTreeSetup",
  callback = function()
    local events = require("nvim-tree.api").events
    events.subscribe(events.Event.NodeRenamed, function(data)
      if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
        data = data
        Snacks.rename.on_rename_file(data.old_name, data.new_name)
      end
    end)
  end,
})
