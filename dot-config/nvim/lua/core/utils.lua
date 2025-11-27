local M = {}

function G.P(...)
  print(vim.inspect(...))

  return ...
end

function G.get_mason_bin(name)
  local mason_bin = vim.fs.joinpath(vim.fn.stdpath('data'), "mason/bin")
  return vim.fs.joinpath(mason_bin, name)
end

function G.root_dir(markers)
  return function(bufnr, cb)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local project_root = vim.fs.root(fname, markers)

    if not project_root then return end

    cb(project_root)
  end
end

function M.toggle_qf()
  local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
  local action = qf_winid > 0 and 'cclose' or 'copen'

  vim.cmd('botright ' .. action)
end

--- Returns a function which applies `specs` on args. This function produces an object having
-- the same structure than `specs` by mapping each property to the result of calling its
-- associated function with the supplied arguments
-- @name applySpec
-- @param specs a table
-- @return a function
function M.applySpec(specs)
  return function(...)
    local spec = {}
    for i, f in pairs(specs) do
      spec[i] = f(...)
    end
    return spec
  end
end

--- Keymap abstraction for plugins
-- Provides a consistent API for setting keymaps across plugins
-- @param mode string|table: vim mode(s) ('n', 'v', 'i', etc. or table of modes)
-- @param lhs string: left-hand side (key sequence)
-- @param rhs string|function: right-hand side (command or function)
-- @param opts table: optional keymap options (buffer, desc, silent, etc.)
-- @param bufnr number|nil: optional buffer number for buffer-local mappings
-- @usage
--   local map = require("core.utils").map
--   map("n", "<leader>aa", function() ... end, { desc = "Description" })
--   map("n", "<leader>bb", ":Command<CR>", { desc = "Command" }, bufnr) -- buffer-local
function M.map(mode, lhs, rhs, opts, bufnr)
  opts = opts or {}
  if bufnr then
    opts.buffer = bufnr
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

G.icons = setmetatable({
  -- Exact Match
  ['init.lua'] = '',
  ['gruntfile.coffee'] = '',
  ['gruntfile.js'] = '',
  ['gruntfile.ls'] = '',
  ['gulpfile.coffee'] = '',
  ['gulpfile.js'] = '',
  ['gulpfile.ls'] = '',
  ['mix.lock'] = '',
  ['dropbox'] = '',
  ['.ds_store'] = '',
  ['.gitconfig'] = '',
  ['.gitignore'] = '',
  ['.env'] = '',
  ['.gitlab-ci.yml'] = '',
  ['.bashrc'] = '',
  ['.profile'] = '',
  ['.zprofile'] = '',
  ['.zshenv'] = '',
  ['.zshrc'] = '',
  ['.vimrc'] = '',
  ['.gvimrc'] = '',
  ['_vimrc'] = '',
  ['_gvimrc'] = '',
  ['.bashprofile'] = '',
  ['favicon.ico'] = '',
  ['license'] = '',
  ['node_modules'] = '',
  ['react.jsx'] = '󰜈',
  ['procfile'] = '',
  ['dockerfile'] = '󰡨',
  ['docker-compose.yml'] = '󰡨',
  ['compose.yml'] = '󰡨',
  ['bun.lock'] = '',
  -- Extension
  ['styl'] = '',
  ['sass'] = '',
  ['scss'] = '',
  ['htm'] = '',
  ['html'] = '',
  ['edge'] = '',
  ['slim'] = '',
  ['ejs'] = '',
  ['css'] = '',
  ['less'] = '',
  ['md'] = '',
  ['mdx'] = '',
  ['markdown'] = '',
  ['rmd'] = '',
  ['json'] = '',
  ['jsonc'] = '',
  ['js'] = '',
  ['mjs'] = '',
  ['jsx'] = '',
  ['rb'] = '',
  ['astro'] = '',
  ['php'] = '',
  ['py'] = '',
  ['pyc'] = '',
  ['pyo'] = '',
  ['pyd'] = '',
  ['coffee'] = '',
  ['mustache'] = '',
  ['hbs'] = '',
  ['conf'] = '',
  ['ini'] = '',
  ['yml'] = '',
  ['yaml'] = '',
  ['toml'] = '',
  ['bat'] = '',
  ['jpg'] = '',
  ['jpeg'] = '',
  ['bmp'] = '',
  ['png'] = '',
  ['gif'] = '',
  ['ico'] = '',
  ['twig'] = '',
  ['cpp'] = '',
  ['c++'] = '',
  ['cxx'] = '',
  ['cc'] = '',
  ['cp'] = '',
  ['c'] = '',
  ['cs'] = '',
  ['h'] = '',
  ['hh'] = '',
  ['hpp'] = '',
  ['hxx'] = '',
  ['hs'] = '',
  ['lhs'] = '',
  ['lua'] = '',
  ['java'] = '',
  ['sh'] = '',
  ['fish'] = '',
  ['bash'] = '',
  ['zsh'] = '',
  ['ksh'] = '',
  ['csh'] = '',
  ['awk'] = '',
  ['ps1'] = '',
  ['ml'] = 'λ',
  ['mli'] = 'λ',
  ['diff'] = '',
  ['db'] = '',
  ['sql'] = '',
  ['dump'] = '',
  ['clj'] = '',
  ['cljc'] = '',
  ['cljs'] = '',
  ['edn'] = '',
  ['scala'] = '',
  ['go'] = '',
  ['dart'] = '',
  ['xul'] = '',
  ['sln'] = '',
  ['suo'] = '',
  ['pl'] = '',
  ['pm'] = '',
  ['t'] = '',
  ['rss'] = '',
  ['f#'] = '',
  ['fsscript'] = '',
  ['fsx'] = '',
  ['fs'] = '',
  ['fsi'] = '',
  ['rs'] = '',
  ['rlib'] = '',
  ['d'] = '',
  ['erl'] = '',
  ['hrl'] = '',
  ['ex'] = '',
  ['exs'] = '',
  ['eex'] = '',
  ['leex'] = '',
  ['vim'] = '',
  ['ai'] = '',
  ['psd'] = '',
  ['psb'] = '',
  ['ts'] = '',
  ['tsx'] = '',
  ['jl'] = '',
  ['pp'] = '',
  ['vue'] = '󰡄',
  ['elm'] = '',
  ['swift'] = '',
  ['xcplayground'] = '',
}, {
  __index = function(table, key)
    local ext = key:match '%.(.+)$'

    return ext and table[ext] or '󰈔'
  end,
})

return M
