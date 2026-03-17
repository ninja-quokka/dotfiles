return {
  on_init = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  settings = {
    gopls = {
      -- codelenses = {}, https://go.googlesource.com/tools/+/refs/heads/master/gopls/doc/codelenses.md
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      completeUnimported = true,
      usePlaceholders = true,
    },
  },
}
