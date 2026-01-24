vim.pack.add({
  "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
})

require("tiny-inline-diagnostic").setup({
  preset = "modern",
  -- preset = "minimal",
  disabled_ft = {}, -- List of filetypes to disable the plugin
  options = {
    -- Show the source of the diagnostic.
    show_source = true,

    -- Configuration for multiline diagnostics
    multilines = {
      enabled = true,
      always_show = true,

      -- Trim whitespaces from the start/end of each line
      trim_whitespaces = true,
    },

    -- Use icons defined in the diagnostic configuration
    use_icons_from_diagnostic = true,

    -- Set the arrow icon to the same color as the first diagnostic severity
    set_arrow_to_diag_color = true,

    -- Add messages to diagnostics when multiline diagnostics are enabled
    -- If set to false, only signs will be displayed
    add_messages = false,

    -- Display all diagnostic messages on the cursor line
    show_all_diags_on_cursorline = true,

    -- Virtual text display priority
    -- Higher values appear above other plugins (e.g., GitBlame, LSP Codelens)
    virt_texts = {
      priority = 8048,
    },
  },
})

vim.diagnostic.config({ virtual_text = false })
