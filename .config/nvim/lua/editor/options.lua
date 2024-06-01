--------------------------------------------------------------------------------
-- Editor options
--------------------------------------------------------------------------------

local ThemeSymbols = reload('theme.symbols')

local opt = vim.opt

-- Use terminal title
opt.title = true

-- Use per-window statusbar
opt.laststatus = 2

-- Show column and line info
opt.ruler = true

-- Show line numbers
opt.number = true

-- Show signs in number column.
opt.signcolumn = 'yes'

-- Highlight current line
opt.cursorline = true
opt.cursorcolumn = false

-- Whitespace visuals
opt.listchars = ThemeSymbols.listchars
opt.list = true

-- End-of-buffer and folds visuals
opt.fillchars = ThemeSymbols.fillchars

-- Tabs should be 4 spaces
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- Don't wrap lines
opt.wrap = false

-- File encoding
opt.fileencoding = 'utf-8'

-- Highlight search results
opt.hlsearch = true

-- Don't autoinsert comment leaders in normal mode
opt.formatoptions = opt.formatoptions - { 'o' }

-- Treat dash separated words as a whole word
opt.iskeyword = opt.iskeyword + { '-' }

-- Save swap file faster
opt.updatetime = 100

-- Set clipboard
opt.clipboard = 'unnamedplus'

-- Start scrolling before cursor reaches edge of window
opt.scrolloff = 4

-- Enable mouse in all modes
opt.mouse = 'a'

-- Sessions
opt.sessionoptions = 'buffers,curdir,folds,help,tabpages,winsize,winpos,terminal'

-- Folds
opt.foldmethod = 'manual'
opt.foldcolumn = '1'
opt.foldlevel = 99 -- NOTE: UFO provider needs a large value, feel free to decrease
opt.foldlevelstart = 99
opt.foldenable = true

-- Current mode is already visible in status line (lualine)
opt.showmode = false

-- Enable spell checking
opt.spell = false
opt.spelllang = { 'en_us' }
opt.spellsuggest = 'best,10'

-- Always navigate to the first non-whitespace character (e.g. C-u, C-d)
opt.startofline = true
