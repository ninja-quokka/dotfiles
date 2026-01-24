-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Better UX
vim.opt.autowriteall = true
vim.o.cmdheight = 0

-- Set spell opts
vim.opt.spell = false
vim.opt.spelllang = "en_au"

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.swapfile = false
-- Save undo history to disk for persistance
vim.opt.undofile = true
vim.opt.clipboard = "unnamedplus"
if vim.env.SSH_TTY then
  vim.g.clipboard = "osc52"
end

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Indents settings
--
-- Make tabs take up the space of four spaces
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- UI
vim.opt.showcmd = false
vim.o.winborder = "rounded"
vim.opt.number = true
vim.opt.showtabline = 1

-- Minimal number of columns for the line number
-- Default: 4
vim.opt.numberwidth = 2

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Preview substitutions live, as you type! (split|nosplit)
vim.opt.inccommand = "split"

-- Sets how Neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- wrapped part of the line is visually indented to match the original line's indentation
vim.opt.breakindent = true
vim.g.termguicolors = true

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.showmode = true -- Set to false once status bar
vim.opt.laststatus = 3
vim.opt.fillchars = { eob = " " }
vim.go.guicursor = "n-v-sm:block,i-t-ci-ve-c:ver25,r-cr-o:hor20"

-- Search
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Program to use for the :grep command
vim.opt.grepprg = "rg --vimgrep"

vim.diagnostic.config({
  virtual_text = true,
  float = { border = "rounded" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
})

-- https://www.reddit.com/r/neovim/comments/1jmqd7t/sorry_ufo_these_7_lines_replaced_you/
-- Nice and simple folding:
vim.o.foldenable = true
vim.o.foldlevelstart = 99
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext = ""
vim.opt.foldcolumn = "0"
vim.opt.fillchars:append({ fold = " " })

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Enables loading .nvimrc files for per project configuration
vim.opt.exrc = true

-- Enable experimental Lua module loader that reduces
-- startup time by caching byte-compiled Lua files.
vim.loader.enable()
