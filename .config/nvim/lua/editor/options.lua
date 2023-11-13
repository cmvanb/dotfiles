--------------------------------------------------------------------------------
-- Editor options
--------------------------------------------------------------------------------

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
opt.signcolumn = 'number'

-- Highlight current line
opt.cursorline = true
opt.cursorcolumn = false

-- Whitespace visualization
opt.listchars = { tab = '-->', eol = '', trail = '' }
opt.list = false

-- End-of-buffer visualization
opt.fillchars = { eob = '.' }

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

-- Folding
opt.foldmethod = 'syntax'
opt.foldenable = false

-- Current mode is already visible in status line (lualine)
opt.showmode = false

-- Enable spell checking
opt.spell = false
opt.spelllang = { 'en_us' }

