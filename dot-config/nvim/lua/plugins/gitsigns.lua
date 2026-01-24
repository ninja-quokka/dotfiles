vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
})

local gitsigns = require("gitsigns")

gitsigns.setup({
  -- numhl = true,
  linehl = false,
  word_diff = false,
  attach_to_untracked = true,
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 500,
  },
  preview_config = {
    -- Options passed to nvim_open_win
    border = "solid",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  trouble = true,
  gh = true,
  count_chars = { "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹", ["+"] = ">" },
  signs = {
    add = { text = "▌" },
    change = { text = "▌" },
    untracked = { text = "▌" },
    delete = { show_count = true },
    topdelete = { show_count = true },
    changedelete = { show_count = true, text = "▌" },
  },
  signs_staged = {
    add = { text = "▌" },
    change = { text = "▌" },
    untracked = { text = "▌" },
    delete = { show_count = true },
    topdelete = { show_count = true },
    changedelete = { show_count = true, text = "▌" },
  },
  on_attach = function(bufnr)
    -- map is a helper function
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- These two functions allow the next and prev operations to be dot repeatable
    _G._next_hunk_func = function()
      gitsigns.nav_hunk("next")
    end

    _G.previous_hunk_func = function()
      gitsigns.nav_hunk("prev")
    end

    -- stylua: ignore start
    --g@ operator needs a textobject, l selects the character under the cursor but arn't using the selected textobject
    map("n", "<leader>hn", function() vim.o.operatorfunc = "v:lua._next_hunk_func" vim.cmd.normal "g@l" end, {desc = "git [n]ext hunk"})
    map("n", "<leader>hN", function() vim.o.operatorfunc = "v:lua.previous_hunk_func" vim.cmd.normal "g@l" end, {desc = "git previous hunk"})

    map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" })
    map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })
    map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage buffer" })
    map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" })
    map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [p]review hunk" })
    map("n", "<leader>hB", gitsigns.blame, { desc = "git [B]lame" })
    map("n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff against index" })
    map("n", "<leader>hq", gitsigns.setqflist, { desc = "send hunks to the quickfix list" })
    map("n", "<leader>hD", function() gitsigns.diffthis "@" end, { desc = "git [D]iff against last commit" })
    map("v", "<leader>hs", function() gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" } end, { desc = "git [s]tage selected lines" })
    map("v", "<leader>hr", function() gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" } end, { desc = "git [r]eset selected lines" })
    -- stylua: ignore end
  end,
})
