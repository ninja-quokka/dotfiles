-- https://github.com/redhat-developer/yaml-language-server
return {
  --NOTE: Have to add this for yamlls to understand that we support line folding
  capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  },
  settings = {
    yaml = {
      keyOrdering = false,
      format = {
        enable = true,
      },
      validate = true,
      schemas = require("schemastore").yaml.schemas(),
      schemaStore = {
        --NOTE: Must disable built-in schemaStore support to use
        -- schemas from SchemaStore.nvim plugin
        enable = false,
        --NOTE: Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = "",
      },
    },
  },
}
