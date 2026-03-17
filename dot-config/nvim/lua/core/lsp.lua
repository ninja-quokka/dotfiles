local M = {}

local methods = vim.lsp.protocol.Methods

function M.lsp_code_lens_refresh(client, bufnr)
  if not client:supports_method(methods.textDocument_codeLens, bufnr) then
    return
  end

  vim.lsp.codelens.enable(true, { bufnr = bufnr })
end

function M.set_lsp_buffer_keybindings(client, bufnr)
  local map = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. (desc or "") })
  end

  if client:supports_method(methods.textDocument_codeAction) then
    map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
  end

  -- Native LSP functions (use where Pickers aren't preferred)
  if client:supports_method(methods.textDocument_signatureHelp) then
    map("<leader>cs", vim.lsp.buf.signature_help, "Signature Help")
  end

  if client:supports_method(methods.textDocument_declaration) then
    map("gD", vim.lsp.buf.declaration, "Goto Declaration")
  end

  map("<leader>ss", Snacks.picker.lsp_symbols, "Find Symbols")
  map("<leader>sS", Snacks.picker.lsp_workspace_symbols, "Workspace Symbols")
  map("<leader>sd", Snacks.picker.diagnostics_buffer, "Buffer Diagnostics")
  map("<leader>sD", Snacks.picker.diagnostics, "Workspace Diagnostics")

  map("gd", Snacks.picker.lsp_definitions, "Goto Definition")
  map("gr", Snacks.picker.lsp_references, "References")
  map("gi", Snacks.picker.lsp_implementations, "Goto Implementation")
  map("gy", Snacks.picker.lsp_type_definitions, "Type Definition")
end

function M.get_client_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))

  return capabilities
end

function M.setup(servers)
  local base_config = {
    capabilities = M.get_client_capabilities(),
  }

  vim.lsp.config("*", base_config)

  vim.lsp.enable(servers)

  -- Show LSP progress in Ghostty's terminal progress bar (OSC 9;4)
  if vim.env.TERM_PROGRAM == "ghostty" then
    vim.api.nvim_create_autocmd("LspProgress", {
      group = vim.api.nvim_create_augroup("GhosttyLspProgress", { clear = true }),
      callback = function(event)
        local val = event.data.params.value
        if val.kind == "end" then
          vim.api.nvim_chan_send(2, "\27]9;4;0;0\007")
        elseif val.percentage then
          vim.api.nvim_chan_send(2, string.format("\27]9;4;1;%d\007", val.percentage))
        end
      end,
    })
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if not client then
        return
      end

      -- Apply your custom keybinds and features
      M.lsp_code_lens_refresh(client, event.buf)
      M.set_lsp_buffer_keybindings(client, event.buf)
    end,
  })
end

return M
