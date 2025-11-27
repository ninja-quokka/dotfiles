--- https://github.com/bash-lsp/bash-language-server
---
--- Language server for bash, written using tree sitter in typescript.
return {
  cmd = { 'bash-language-server', 'start' },
  settings = {
    bashIde = {
      -- Glob pattern for finding and parsing shell script files in the workspace.
      -- Used by the background analysis features across files.

      -- Prevent recursive scanning which will cause issues when opening a file
      -- directly in the home directory (e.g. ~/foo.sh).
      --
      -- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
      -- Updated to include jinja template files: *.sh.j2, *.sh.jinja, *.sh.jinja2, etc.
      globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.sh.j2|.sh.jinja|.sh.jinja2|.bash|.bash.j2|.bash.jinja|.bash.jinja2|.inc|.command)',
      shfmt = {
        path = "", --NOTE: Disable and let Conform format
      },

    },
  },
  filetypes = { 'bash', 'sh', 'bash.jinja', 'sh.jinja'},
  root_markers = { '.git' },
}
