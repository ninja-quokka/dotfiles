vim.pack.add({
  "https://github.com/stevearc/conform.nvim",
})

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    rust = { "rustfmt" },
  },
  formatters = { shfmt = { prepend_args = { "-i", "2" } } },
  format_on_save = function()
    if vim.g.conform_format_on_save == false then
      return
    end
    return { timeout_ms = 2000, lsp_format = "fallback" }
  end,
  notify_on_error = true,
})

-- NOTE: Formatting can be configured via .nvim.lua file in project root
-- Override formatters for specific filetypes:
-- require("conform").formatters_by_ft.python = { "black" }
-- require("conform").formatters_by_ft.go = { "goimports", "gofmt" }
--
-- Disable format-on-save entirely:
-- vim.g.conform_format_on_save = false

-- Custom command to enalbe range formatting
vim.api.nvim_create_user_command("Format", function(args)
  local opts = { async = true, lsp_format = "fallback" }
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    opts.range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format(opts)
end, { range = true })
