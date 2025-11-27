local utils = require("core.utils")

local cmd = vim.api.nvim_create_user_command

local M = {}

local methods = vim.lsp.protocol.Methods
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local open_floating_preview = vim.lsp.util.open_floating_preview

function M.lsp_code_lens_refresh(client, bufnr)
  if not client:supports_method(methods.textDocument_codeLens, bufnr) then
    return
  end

  autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
    buffer = bufnr,
    callback = vim.lsp.codelens.refresh,
  })
end

function M.set_lsp_buffer_keybindings(client, bufnr)
  local map = function(keys, func, desc, mode, nowait)
    mode = mode or "n"
    nowait = nowait or false
    desc = desc or ""
    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
  end

  if client:supports_method(methods.textDocument_signatureHelp) then
    map("<leader>cs", vim.lsp.buf.signature_help, "sighelp")
  end

  if client:supports_method(methods.textDocument_declaration) then
    map("gD", vim.lsp.buf.declaration)
  end

  if client:supports_method(methods.textDocument_declaration) then
    map("gd", vim.lsp.buf.definition)
  end

  map("<leader>ss", Snacks.picker.lsp_symbols, "Find lsp symbols (jump)")
  map("<leader>sS", Snacks.picker.lsp_workspace_symbols, "Find lsp workspace symbols (Jump)")
  map("<leade>sd", Snacks.picker.diagnostics_buffer, "Find diagnostics")
  map("<leader>sD", Snacks.picker.diagnostics, "Find workspace diagnostics")
  map("gd", Snacks.picker.lsp_definitions, "Goto Definition")
  map("gr", Snacks.picker.lsp_references, "References")
  map("gi", Snacks.picker.lsp_implementations, "Goto Implementation")
  map("gy", Snacks.picker.lsp_type_definitions, "Goto T[y]pe Definition")
end

function M.lazyLoadFastActions(client, bufnr)
  local map = function(keys, func, desc, mode, nowait)
    mode = mode or "n"
    nowait = nowait or false
    desc = desc or ""
    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
  end

  if client:supports_method("textDocument/codeAction") then
    local fastAction = require("fastaction")

    fastAction.setup({})
    map("<leader>a", fastAction.code_action, "FastAction")
  end
end

function M.override_floating_preview()
  local border = {
    { "┌", "FloatBorder" },
    { "─", "FloatBorder" },
    { "┐", "FloatBorder" },
    { "│", "FloatBorder" },
    { "┘", "FloatBorder" },
    { "─", "FloatBorder" },
    { "└", "FloatBorder" },
    { "│", "FloatBorder" },
  }

  ---@diagnostic disable-next-line: duplicate-set-field
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    local max_width = math.min(math.floor(vim.o.columns * 0.7), 100)
    local max_height = math.min(math.floor(vim.o.lines * 0.3), 30)

    local default_opts = {
      max_width = max_width,
      max_height = max_height,
      border = border,
    }

    local buf, win = open_floating_preview(contents, syntax, vim.tbl_extend("force", opts or {}, default_opts), ...)

    return buf, win
  end
end

function M.get_client_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))

  capabilities = vim.tbl_deep_extend("force", capabilities, {
    textDocument = {
      completion = {
        completionItem = {
          resolveSupport = {
            properties = {
              "documentation",
              "detail",
              "additionalTextEdits",
            },
          },
        },
      },
    },
  })

  return capabilities
end

function M.setup_lsp_kind()
  vim.lsp.protocol.CompletionItemKind = {
    "󰉿 (Text)",
    "󰆧 (Method)",
    "󰊕 (Function)",
    " (Constructor)",
    "󰜢 (Field)",
    "󰀫 (Variable)",
    "󰠱 (Class)",
    " (Interface)",
    " (Module)",
    "󰜢 (Property)",
    "󰑭 (Unit)",
    "󰎠 (Value)",
    " (Enum)",
    "󰌋 (Keyword)",
    " (Snippet)",
    "󰏘 (Color)",
    "󰈙 (File)",
    "󰈇 (Reference)",
    "󰉋 (Folder)",
    " (EnumMember)",
    "󰏿 (Constant)",
    "󰙅 (Struct)",
    " (Event)",
    "󰆕 (Operator)",
    "  (TypeParameter)",
  }
end

--- Sets up and configures Language Server Protocol (LSP) clients.
-- This function initializes the LSP system by:
-- 1. Configuring floating preview windows and completion item kinds
-- 2. Registering each server with enhanced capabilities
-- 3. Setting up buffer-local features (keybindings, highlights, code lenses) when LSP attaches
-- 4. Enabling automatic server startup for matching filetypes
--
-- Server configurations are automatically loaded from `lsp/<server_name>.lua` files
-- and merged with the capabilities provided here.
--
-- @param servers table List of LSP server names to configure (e.g., {"gopls", "lua_ls"})
-- @usage require("core.lsp").setup({"gopls", "lua_ls", "bashls"})
function M.setup(servers)

  -- Command to fully reload all LSPs
  cmd("LspReload", function()
    vim.lsp.stop_client(vim.lsp.get_clients())
    vim.cmd([[edit!]])
  end, {})

  M.override_floating_preview()
  M.setup_lsp_kind()

  for _, server_name in ipairs(servers) do
    vim.lsp.config(server_name, {
      capabilities = M.get_client_capabilities(),
    })
  end

  vim.lsp.enable(servers)

  -- This stuff happens when a lang file is opened.
  autocmd({ "LspAttach" }, {
    group = augroup("UserLspAttach", { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)

      if not client or not event.buf then
        return
      end

      utils.applySpec({
        M.lsp_code_lens_refresh,
        M.set_lsp_buffer_keybindings,
        M.lazyLoadFastActions,
      })(client, event.buf)

      if client:supports_method("textDocument/foldingRange") then
        local win = vim.api.nvim_get_current_win()
        vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
      end
    end,
  })
end

return M
