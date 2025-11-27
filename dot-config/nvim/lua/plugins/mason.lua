vim.pack.add {
  "https://github.com/williamboman/mason.nvim",
}

require("mason").setup {
  ui = {
    backdrop = 100,
    border = "none",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
}

local M = {}

-- List of executables to check and install via Mason if missing
M.executables_to_check = {
  "bash-language-server",
  "copilot-language-server",
  "gofumpt",
  "goimports",
  "golangci-lint",
  "golangci-lint-langserver",
  "gopls",
  "lua-language-server",
  "ruff",
  "shfmt",
  "stylua",
  "yaml-language-server"
}

-- Configuration
local config = {
  max_retries = 10,
  retry_delay_ms = 500,
  debug = false,
}

--- Check if executables are available and install missing ones via Mason
--- @param retry_count number? Number of retry attempts (internal use)
function M.check_and_install_executables(retry_count)
  retry_count = retry_count or 0

  if config.debug then
    vim.notify(
      string.format("Mason: Checking executables (retry: %d)", retry_count),
      vim.log.levels.INFO
    )
  end

  -- Find missing executables
  local missing_executables = {}
  for _, exe in ipairs(M.executables_to_check) do
    if vim.fn.executable(exe) == 0 then
      table.insert(missing_executables, exe)
    end
  end

  -- If nothing is missing, we're done
  if #missing_executables == 0 then
    if config.debug then
    vim.notify(
      string.format("Mason: Exiting, no missing executables", retry_count),
      vim.log.levels.INFO
    )
  end

    return
  end

  -- Try to get Mason registry
  local mason_registry_ok, mason_registry = pcall(require, "mason-registry")

  if not mason_registry_ok or not mason_registry then
    -- Mason registry not ready yet, retry with exponential backoff
    if retry_count < config.max_retries then
      local delay = config.retry_delay_ms * (retry_count + 1)
      vim.defer_fn(function()
        M.check_and_install_executables(retry_count + 1)
      end, delay)
    else
      vim.notify(
        string.format(
          "Mason: Registry failed to load after %d attempts. Please ensure Mason is installed correctly.",
          config.max_retries
        ),
        vim.log.levels.ERROR
      )
    end
    return
  end

  -- Install missing packages
  local missing_list = table.concat(missing_executables, ", ")
  vim.notify(
    string.format("Mason: Installing missing executables: %s", missing_list),
    vim.log.levels.INFO
  )

  local installed_count = 0
  local skipped_count = 0

  for _, package_name in ipairs(missing_executables) do
    local package = mason_registry.get_package(package_name)

    if not package then
      vim.notify(
        string.format("Mason: Package '%s' not found in registry. Skipping.", package_name),
        vim.log.levels.WARN
      )
      skipped_count = skipped_count + 1
    elseif package:is_installed() then
      -- Already installed (might have been installed between checks)
      if config.debug then
        vim.notify(
          string.format("Mason: '%s' is already installed.", package_name),
          vim.log.levels.INFO
        )
      end
    else
      -- Install the package
      package:install()
      installed_count = installed_count + 1

      -- Optional: Handle installation completion
      package:on("install:success", function()
        vim.notify(
          string.format("Mason: Successfully installed '%s'", package_name),
          vim.log.levels.INFO
        )
      end)

      package:on("install:failed", function()
        vim.notify(
          string.format("Mason: Failed to install '%s'", package_name),
          vim.log.levels.ERROR
        )
      end)
    end
  end

  if config.debug then
    vim.notify(
      string.format(
        "Mason: Installation initiated for %d package(s), %d skipped",
        installed_count,
        skipped_count
      ),
      vim.log.levels.INFO
    )
  end
end

-- Initialize executable checking on VimEnter
local augroup = vim.api.nvim_create_augroup("MasonExecutableInstaller", { clear = true })

if vim.v.vim_did_enter == 1 then
  -- VimEnter already fired, run immediately with a delay
  vim.defer_fn(M.check_and_install_executables, config.retry_delay_ms)
else
  -- Create autocommand for VimEnter
  vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup,
    callback = function()
      vim.defer_fn(M.check_and_install_executables, config.retry_delay_ms)
    end,
    once = true,
  })
end

return M
