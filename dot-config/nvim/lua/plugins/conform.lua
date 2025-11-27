vim.pack.add({
  "https://github.com/stevearc/conform.nvim",
})

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    rust = { "rustfmt", lsp_format = "fallback" },
  },
  formatters = { shfmt = { prepend_args = { "-i", "2" } } },
  notify_on_error = true,
})

-- Create a custom user command "Format" that can format code using conform.nvim
-- This command supports both formatting the entire buffer and formatting a selected range
vim.api.nvim_create_user_command("Format", function(args)
  local range = nil

  -- args.count ~= -1 means the user provided a range (e.g., :Format 10,20 or visual selection)
  if args.count ~= -1 then
    -- Get the text of the last line in the range (line2 is 1-indexed, so subtract 1 for API)
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]

    -- Build the range table with start and end positions
    -- Format: { start = {line, column}, end = {line, column} }
    -- Start at the beginning of line1 (column 0)
    -- End at the end of line2 (last character position)
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end

  -- Call conform.format with options:
  -- async = true: Format asynchronously so it doesn't block the editor
  -- lsp_format = "fallback": Use LSP formatting if available, otherwise use formatters
  -- range = range: Format the specified range (or entire buffer if nil)
  require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true }) -- Enable range support for this command
