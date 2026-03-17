--- https://github.com/astral-sh/ruff
---
--- A Language Server Protocol implementation for Ruff, an extremely fast Python linter and code formatter, written in Rust.
---
--- Refer to the [documentation](https://docs.astral.sh/ruff/editors/) for more details.
return {
  settings = {
    -- Whether to register the server as capable of handling source.fixAll code actions.
    fixAll = true,
    -- Whether to register the server as capable of handling source.organizeImports code actions.
    organizeImports = true,
    -- Ruff in Conform is handling linting
    lint = { enable = false },
  },
}
