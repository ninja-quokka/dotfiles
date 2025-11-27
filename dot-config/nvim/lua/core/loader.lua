local M = {}

function M.start(groups)
    for _, files in ipairs(groups) do
      for _, path in ipairs(files) do
        loadfile(path)()
      end
    end

    -- Set up filetype-specific callbacks for both the current buffer and future buffers.
    --
    -- This code registers FileType autocommands for all callbacks in G.ftplugin.
    -- It also immediately applies the callback to the current buffer if its filetype
    -- matches, ensuring the current buffer gets configured right away.
    --
    -- Note: The immediate execution happens synchronously, which is fine for simple
    -- buffer-local options and keymaps. If you need async execution for heavy operations,
    -- wrap the callback in vim.schedule() or vim.defer_fn() in the ftplugin definition.
    --
    -- This pattern allows lazy-loading filetype configs (they're only loaded when
    -- the language files are loaded), unlike the traditional after/ftplugin/<filetype>.lua
    -- which Neovim loads automatically for every matching buffer.
    local cur_ft = vim.bo.filetype
    for ft, callback in pairs(G.ftplugin) do
      -- Create autocmd for future buffers
      vim.api.nvim_create_autocmd("FileType", {
        pattern = ft,
        callback = callback,
        once = false -- it runs for every buffer of this filetype
      })

      -- Apply to current buffer if it matches (only if filetype is already set)
      -- Note: This might cause double execution if FileType event fires again,
      -- but most ftplugin callbacks are idempotent (setting options/keymaps).
      if cur_ft ~= "" and ft == cur_ft then
        callback()
      end
    end
end

return M
