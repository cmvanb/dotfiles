--------------------------------------------------------------------------------
-- Editor key mappings
--------------------------------------------------------------------------------

-- TODO: Clear existing key mappings when reloading.

-- Imports
--------------------------------------------------------------------------------

local KeyMapUtils = reload('utils.keymaps')

-- Shortcuts
--------------------------------------------------------------------------------

local map, nmap, xmap, imap =
    KeyMapUtils.map,
    KeyMapUtils.nmap,
    KeyMapUtils.xmap,
    KeyMapUtils.imap

local noremap, nnoremap, vnoremap, xnoremap, inoremap, onoremap =
    KeyMapUtils.noremap,
    KeyMapUtils.nnoremap,
    KeyMapUtils.vnoremap,
    KeyMapUtils.xnoremap,
    KeyMapUtils.inoremap,
    KeyMapUtils.onoremap

-- Remove some default mappings
--------------------------------------------------------------------------------

map('q', '<nop>')
map('Q', '<nop>')

map('H', '<nop>')
map('J', '<nop>')
map('K', '<nop>')
map('L', '<nop>')

map('<C-o>', '<nop>')

map('<C-h>', '<nop>')
map('<C-j>', '<nop>')
map('<C-k>', '<nop>')
map('<C-l>', '<nop>')

map('<C-n>', '<nop>')
map('<C-p>', '<nop>')
imap('<C-n>', '<nop>')
imap('<C-p>', '<nop>')

map('<CR>', '<nop>')

map('ga', '<nop>')
map('gd', '<nop>')
map('ge', '<nop>')
map('gD', '<nop>')
map('gh', '<nop>')
map('gH', '<nop>')
map('gi', '<nop>')
map('go', '<nop>')
map('gr', '<nop>')

-- Leader key
--------------------------------------------------------------------------------

nnoremap(' ', '')
xnoremap(' ', '')
vim.g.mapleader = ' '

-- Windows-like key bindings
--------------------------------------------------------------------------------

-- Copy, paste
-- NOTE: These are only working because the terminal (Wezterm) is configured for it.
if not is_linux_terminal() then
    vnoremap('<C-c>', '"+y')
    noremap('<C-v>', '"+p')
end

-- Cut
noremap('<C-x>', 'x')

-- Select all
noremap('<C-a>', 'gg0vG$')

-- Undo
noremap('<C-z>', 'u')

-- Selection
--------------------------------------------------------------------------------

nmap('+', '<nop>')
xmap('+', '<nop>')
nmap('-', '<nop>')
xmap('-', '<nop>')

-- Visual selection expansion powered by nvim-treesitter.
-- NOTE: These mappings don't work nicely.
-- nnoremap('+', '<cmd>lua require"nvim-treesitter.incremental_selection".init_selection()<cr>')
-- xnoremap('+', '<cmd>lua require"nvim-treesitter.incremental_selection".node_incremental()<cr>')
-- nnoremap('-', '<cmd>lua require"nvim-treesitter.incremental_selection".node_decremental()<cr>')
-- xnoremap('-', '<cmd>lua require"nvim-treesitter.incremental_selection".node_decremental()<cr>')

-- Visual block select
noremap('<leader>v', '<C-v>')

-- Navigation
--------------------------------------------------------------------------------

-- Start/end of line
nnoremap('H', '0')
nnoremap('L', '$')
xnoremap('H', '0')
xnoremap('L', '$')
onoremap('H', '0')
onoremap('L', '$')

-- Leap
noremap('<leader>j', function() require('leap').leap({}) end)
noremap('<leader>k', function() require('leap').leap({ backward = true }) end)

-- Line up/down
noremap('<C-j>', '<C-e>')
noremap('<C-k>', '<C-y>')

-- Toggle mini map
noremap('<C-g>m', require('mini.map').toggle)

-- Editing
--------------------------------------------------------------------------------

-- Swap lines
nnoremap('J', '<esc>:m .+1<cr>==', { silent = true })
nnoremap('K', '<esc>:m .-2<cr>==', { silent = true })

-- Formatting
noremap(';', '=')
noremap('<leader>;', 'gg=G')

-- Reading
--------------------------------------------------------------------------------

-- Toggle linebreaks
noremap('<C-g>w', '<cmd>set wrap!<cr>:set linebreak!<cr>')

-- Folds
--------------------------------------------------------------------------------

local ufo = require('ufo')

noremap('zR', ufo.openAllFolds)
noremap('zM', ufo.closeAllFolds)

-- Search
--------------------------------------------------------------------------------

-- Clear search highlight, clear command line and clear search pattern.
noremap('<leader>l', ':noh<cr>:let @/=""<cr>:echo ""<cr>')

local telescope_builtin = require('telescope.builtin')

-- Fuzzy finder
noremap('<leader>a', function() telescope_builtin.find_files({ hidden = true, no_ignore = true }) end)
noremap('<leader>f', require('plugins.telescope.project_files'))
noremap('<leader>b', telescope_builtin.buffers)
noremap('<leader>g', telescope_builtin.live_grep)
noremap('<leader>i', telescope_builtin.symbols)

-- LSP & diagnostics
--------------------------------------------------------------------------------

noremap('gd', telescope_builtin.lsp_definitions)
noremap('ge', function() telescope_builtin.diagnostics({ bufnr = 0 }) end)
noremap('gi', telescope_builtin.lsp_implementations)
noremap('gt', telescope_builtin.lsp_type_definitions)
noremap('gr', telescope_builtin.lsp_references)
nnoremap('gp', vim.diagnostic.open_float)
nnoremap('gj', vim.diagnostic.goto_next)
nnoremap('gk', vim.diagnostic.goto_prev)

-- Window management
--------------------------------------------------------------------------------

-- Change window focus
noremap('<C-h>', '<C-w>h')
noremap('<C-l>', '<C-w>l')

-- Cycle windows
noremap('<C-z>', '<C-w>r')

-- Split windows
nnoremap('<C-n>', '<esc>:belowright vnew<cr>', { silent = true })
nnoremap('<C-p>', '<esc>:belowright new<cr>', { silent = true })

-- Close window
noremap('<C-w>', ':close<cr>', { silent = true })

-- Buffer management
--------------------------------------------------------------------------------

-- Change buffer
-- NOTE: Wezterm translates <C-BS> to <F15> to get around NVIM's limitation.
noremap('<F15>', ':bprev<cr>', { silent = true })
noremap('<C-Tab>', ':bnext<cr>', { silent = true })

-- Save all buffers
nnoremap('<C-s>', ':wa!<cr>')
xnoremap('<C-s>', '<esc>:wa!<cr>')
inoremap('<C-s>', '<esc>:wa!<cr>')

-- Close buffer
nnoremap('<C-q>', ':Bdelete<cr>', { silent = true })

-- Close NVIM without saving
noremap('<leader>q', ':qa!<cr>')

-- Git
--------------------------------------------------------------------------------

noremap('<C-g>b', '<cmd>GitBlameToggle<cr>')

-- Plugin management
--------------------------------------------------------------------------------

-- Reload config and plugins.
noremap('<leader>r', _G.reload_config, { silent = true })
