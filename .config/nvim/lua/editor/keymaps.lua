--------------------------------------------------------------------------------
-- Editor key mappings
--------------------------------------------------------------------------------

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

local noremap, nnoremap, xnoremap, inoremap, onoremap, vnoremap =
    KeyMapUtils.noremap,
    KeyMapUtils.nnoremap,
    KeyMapUtils.xnoremap,
    KeyMapUtils.inoremap,
    KeyMapUtils.onoremap,
    KeyMapUtils.vnoremap

-- Remove some default mappings
--------------------------------------------------------------------------------

map('q', '<nop>')
map('Q', '<nop>')

map('H', '<nop>')
map('J', '<nop>')
map('K', '<nop>')
map('L', '<nop>')

map('<C-h>', '<nop>')
map('<C-j>', '<nop>')
map('<C-k>', '<nop>')
map('<C-l>', '<nop>')

map('<C-o>', '<nop>')

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

-- Viewing
--------------------------------------------------------------------------------

-- -- Folds
-- local ufo = require('ufo')
-- nnoremap('zR', ufo.openAllFolds)
-- nnoremap('zM', ufo.closeAllFolds)

-- Toggle indent guides & whitespace
-- TODO: Consider cycling through an option to toggle the EOL character.
nnoremap('<leader>n',
    function()
        if vim.wo.list then
            vim.cmd('IBLDisable')
            vim.cmd('tabdo windo set nolist')
        else
            vim.cmd('IBLEnable')
            vim.cmd('tabdo windo set list')
        end
    end,
    { silent = true, desc = 'Toggle indentation guides' })

-- Toggle linebreaks
nnoremap('<leader>w',
    function()
        if vim.wo.linebreak then
            vim.cmd('tabdo windo set nowrap')
            vim.cmd('tabdo windo set nolinebreak')
        else
            vim.cmd('tabdo windo set wrap')
            vim.cmd('tabdo windo set linebreak')
        end
    end,
    { desc = 'Toggle linebreaks' })

-- Navigation
--------------------------------------------------------------------------------

-- Half page up/down
noremap(
    '<C-j>',
    '<C-d>',
    { desc = 'Scroll half page down' })
noremap(
    '<C-k>',
    '<C-u>',
    { desc = 'Scroll half page up' })

-- Start/end of line
-- nnoremap('H', '0')
-- xnoremap('H', '0')
-- onoremap('H', '0')
-- nnoremap('L', '$')
-- xnoremap('L', '$')
-- onoremap('L', '$')

-- Leap
noremap(
    '<leader>j',
    function() require('leap').leap({}) end,
    { desc = 'Leap forward' })
noremap(
    '<leader>k',
    function() require('leap').leap({ backward = true }) end,
    { desc = 'Leap backward' })

-- Selection
--------------------------------------------------------------------------------

-- Select all
noremap('<C-a>', 'gg0vG$', { desc = 'Select all' })

-- Visual block select
noremap('<A-v>', '<C-v>', { desc = 'Visual block select' })

-- Editing
-------------------------------------------------------------------------------

-- Copy, paste
-- NOTE: These are only working because the terminal (Alacritty) is configured for it.
if not is_linux_virtual_terminal() then
    noremap('<C-c>', '"+y', { desc = 'Copy' })
    noremap('<C-v>', '"+p', { desc = 'Paste' })
end

-- Cut
noremap('<C-x>', 'x', { desc = 'Cut' })

-- Undo
nnoremap('<C-z>', 'u', { desc = 'Undo' })

-- Swap lines
nnoremap('J', '<esc>:m .+1<cr>==', { silent = true }, { desc = 'Move line down' })
nnoremap('K', '<esc>:m .-2<cr>==', { silent = true }, { desc = 'Move line up' })

-- Indentation
nnoremap('H', '<<', { desc = 'Indent left' })
nnoremap('L', '>>', { desc = 'Indent right' })
vnoremap('H', '<gv', { desc = 'Indent left' })
vnoremap('L', '>gv', { desc = 'Indent right' })

-- Formatting
nnoremap(';', '=', { desc = 'Format selected' })
xnoremap(';', '=', { desc = 'Format selected' })
nnoremap('<leader>;', 'gg=G', { desc = 'Format buffer' })

-- Insert line break
nnoremap('<Enter>', 'i<CR><esc>`^', { desc = 'Insert line break' })

-- Search
--------------------------------------------------------------------------------

-- Clear search highlight, clear command line and clear search pattern.
nnoremap('<leader>l', ':noh<cr>:let @/=""<cr>:echo ""<cr>', { desc = 'Clear search' })

-- Fuzzy finder
local telescope_builtin = require('telescope.builtin')
nnoremap(
    '<leader>a',
    function() telescope_builtin.find_files({ hidden = true, no_ignore = false }) end,
    { desc = 'Search all files' })
nnoremap(
    '<leader>f',
    require('plugins.telescope.project_files'),
    { desc = 'Search project files' })
nnoremap(
    '<leader>b', telescope_builtin.buffers,
    { desc = 'Search buffers' })
nnoremap(
    '<leader>g', telescope_builtin.live_grep,
    { desc = 'Interactive grep' })
nnoremap(
    '<leader>i',
    telescope_builtin.symbols,
    { desc = 'Insert symbols' })
nnoremap(
    '<leader>h',
    telescope_builtin.help_tags,
    { desc = 'Search help' })

-- LSP & diagnostics
--------------------------------------------------------------------------------

nnoremap(
    'gd',
    telescope_builtin.lsp_definitions,
    { desc = 'LSP: Go to definition' })
nnoremap(
    'ge',
    function() telescope_builtin.diagnostics({ bufnr = 0 }) end,
    { desc = 'LSP: Show diagnostics' })
nnoremap(
    'gi',
    telescope_builtin.lsp_implementations,
    { desc = 'LSP: Go to implementation' })
nnoremap(
    'gt',
    telescope_builtin.lsp_type_definitions,
    { desc = 'LSP: Go to type definition' })
nnoremap(
    'gr',
    telescope_builtin.lsp_references,
    { desc = 'LSP: Find references' })
nnoremap(
    'gp',
    vim.diagnostic.open_float,
    { desc = 'LSP: Show diagnostic' })
nnoremap(
    'gj',
    vim.diagnostic.goto_next,
    { desc = 'LSP: Next diagnostic' })
nnoremap(
    'gk',
    vim.diagnostic.goto_prev,
    { desc = 'LSP: Previous diagnostic' })

-- Buffer management
--------------------------------------------------------------------------------

-- Save all buffers
nnoremap('<leader>s', ':wa!<cr>', { desc = 'Save all buffers' })
nnoremap('<C-s>', ':wa!<cr>', { desc = 'Save all buffers' })
xnoremap('<C-s>', '<esc>:wa!<cr>', { desc = 'Save all buffers' })
inoremap('<C-s>', '<esc>:wa!<cr>', { desc = 'Save all buffers' })

-- Cycle buffers
-- NOTE: Alacritty translates <C-BS> to <F15> to get around NVIM's limitation.
nnoremap('<C-h>', ':bprev<cr>', { silent = true, desc = 'Previous buffer' })
nnoremap('<C-l>', ':bnext<cr>', { silent = true, desc = 'Next buffer' })

-- Close buffer
nnoremap('<C-q>', ':Bdelete<cr>', { silent = true, desc = 'Close buffer' })

-- Quit NVIM without saving
noremap('<leader>q', ':qa!<cr>', { desc = 'Quit NVIM without saving' })

-- Window management
--------------------------------------------------------------------------------

-- Change window focus
nnoremap('<C-A-h>', '<C-w>h', { desc = 'Focus window left' })
nnoremap('<C-A-j>', '<C-w>j', { desc = 'Focus window down' })
nnoremap('<C-A-k>', '<C-w>k', { desc = 'Focus window up' })
nnoremap('<C-A-l>', '<C-w>l', { desc = 'Focus window right' })

-- Cycle windows
nnoremap('<C-A-s>', '<C-w>R<C-w>l', { desc = 'Cycle windows left' })
nnoremap('<C-A-g>', '<C-w>r<C-w>h', { desc = 'Rotate windows right' })

-- Split windows
nnoremap(
    '<C-A-n>',
    ':belowright vnew<cr>',
    { silent = true, desc = 'Split window vertically' })
nnoremap(
    '<C-A-p>',
    ':belowright new<cr>',
    { silent = true, desc = 'Split window horizontally' })

-- Close window
nnoremap('<C-A-q>', ':close<cr>', { silent = true, desc = 'Close window' })

-- Change window size
nnoremap(
    '<C-A-a>',
    ':wincmd =<cr>',
    { silent = true, desc = 'Equalize window width' })
nnoremap(
    '<C-A-d>',
    ':100wincmd |<cr>',
    { silent = true, desc = 'Enlarge window width' })
nnoremap(
    '<C-A-f>',
    ':wincmd |<cr>',
    { silent = true, desc = 'Maximize window width' })

-- Open new tab with current buffer
noremap('<C-A-t>', ':tab split<cr>', { silent = true, desc = 'Tab split' })

-- Git
--------------------------------------------------------------------------------

nnoremap('gm', ':GitMessenger<cr>', { desc = 'Show git log for line' })

-- Package management
--------------------------------------------------------------------------------

nnoremap('<leader>p', ':Lazy<cr>', { desc = 'Plugin manager' })
nnoremap('<leader>m', ':Mason<cr>', { desc = 'Tooling manager' })

-- Plugin management
--------------------------------------------------------------------------------

-- Reload config and plugins.
nnoremap('<leader>r', _G.reload_config, { silent = true, desc = 'Reload config' })
