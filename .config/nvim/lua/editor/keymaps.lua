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

local noremap, nnoremap, xnoremap, inoremap, onoremap =
    KeyMapUtils.noremap,
    KeyMapUtils.nnoremap,
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

-- Copy, paste
-- NOTE: These are only working because the terminal (Alacritty) is configured for it.
if not is_linux_virtual_terminal() then
    noremap('<C-c>', '"+y')
    noremap('<C-v>', '"+p')
end

-- Cut
noremap('<C-x>', 'x')

-- Select all
noremap('<C-a>', 'gg0vG$')

-- Undo
nnoremap('<C-z>', 'u')

-- Find
nnoremap('<C-f>', '/')

-- Save all buffers
nnoremap('<C-s>', ':wa!<cr>')
xnoremap('<C-s>', '<esc>:wa!<cr>')
inoremap('<C-s>', '<esc>:wa!<cr>')

-- Viewing
--------------------------------------------------------------------------------

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
    { silent = true })

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
    end)

-- Selection
--------------------------------------------------------------------------------

-- Visual block select
noremap('<A-v>', '<C-v>')

-- Navigation
--------------------------------------------------------------------------------

-- Half page up/down
noremap('<C-j>', '<C-d>')
noremap('<C-k>', '<C-u>')

-- Start/end of line
-- nnoremap('H', '0')
-- xnoremap('H', '0')
-- onoremap('H', '0')
-- nnoremap('L', '$')
-- xnoremap('L', '$')
-- onoremap('L', '$')

-- Leap
noremap('<leader>j', function() require('leap').leap({}) end)
noremap('<leader>k', function() require('leap').leap({ backward = true }) end)

-- Editing
-------------------------------------------------------------------------------

-- Swap lines
nnoremap('J', '<esc>:m .+1<cr>==', { silent = true })
nnoremap('K', '<esc>:m .-2<cr>==', { silent = true })

-- Indentation
nnoremap('H', '<<')
nnoremap('L', '>>')

-- Formatting
nnoremap(';', '=')
xnoremap(';', '=')
nnoremap('<leader>;', 'gg=G')

-- Insert line break
nnoremap('<Enter>', 'i<CR><esc>`^')

-- Folds
--------------------------------------------------------------------------------

local ufo = require('ufo')

nnoremap('zR', ufo.openAllFolds)
nnoremap('zM', ufo.closeAllFolds)

-- Search
--------------------------------------------------------------------------------

-- Clear search highlight, clear command line and clear search pattern.
nnoremap('<leader>l', ':noh<cr>:let @/=""<cr>:echo ""<cr>')

local telescope_builtin = require('telescope.builtin')

-- Fuzzy finder
nnoremap('<leader>a', function() telescope_builtin.find_files({ hidden = true, no_ignore = false }) end)
nnoremap('<leader>f', require('plugins.telescope.project_files'))
nnoremap('<leader>b', telescope_builtin.buffers)
nnoremap('<leader>g', telescope_builtin.live_grep)
nnoremap('<leader>i', telescope_builtin.symbols)
nnoremap('<leader>h', telescope_builtin.help_tags)

-- LSP & diagnostics
--------------------------------------------------------------------------------

nnoremap('gd', telescope_builtin.lsp_definitions)
nnoremap('ge', function() telescope_builtin.diagnostics({ bufnr = 0 }) end)
nnoremap('gi', telescope_builtin.lsp_implementations)
nnoremap('gt', telescope_builtin.lsp_type_definitions)
nnoremap('gr', telescope_builtin.lsp_references)
nnoremap('gp', vim.diagnostic.open_float)
nnoremap('gj', vim.diagnostic.goto_next)
nnoremap('gk', vim.diagnostic.goto_prev)

-- Window management
--------------------------------------------------------------------------------

-- Change window focus
nnoremap('<C-A-h>', '<C-w>h')
nnoremap('<C-A-j>', '<C-w>j')
nnoremap('<C-A-k>', '<C-w>k')
nnoremap('<C-A-l>', '<C-w>l')

-- Cycle windows
nnoremap('<C-A-s>', '<C-w>R')
nnoremap('<C-A-g>', '<C-w>r')

-- Split windows
nnoremap('<C-A-n>', ':belowright vnew<cr>', { silent = true })
nnoremap('<C-A-p>', ':belowright new<cr>', { silent = true })

-- Close window
nnoremap('<C-A-q>', ':close<cr>', { silent = true })

-- Change window size
nnoremap('<C-A-PageUp>', ':wincmd ><cr>', { silent = true })
nnoremap('<C-A-PageDown>', ':wincmd <<cr>', { silent = true })

-- Buffer management
--------------------------------------------------------------------------------

-- Cycle buffers
-- NOTE: Alacritty translates <C-BS> to <F15> to get around NVIM's limitation.
nnoremap('<C-S-Tab>', ':bprev<cr>', { silent = true })
nnoremap('<C-Tab>', ':bnext<cr>', { silent = true })
nnoremap('<C-h>', ':bprev<cr>', { silent = true })
nnoremap('<C-l>', ':bnext<cr>', { silent = true })

-- Close buffer
nnoremap('<C-q>', ':Bdelete<cr>', { silent = true })

-- Close NVIM without saving
noremap('<leader>q', ':qa!<cr>')

-- Git
--------------------------------------------------------------------------------

nnoremap('gm', ':GitMessenger<cr>')

-- Package management
--------------------------------------------------------------------------------

nnoremap('<leader>p', ':Lazy<cr>')
nnoremap('<leader>m', ':Mason<cr>')

-- Plugin management
--------------------------------------------------------------------------------

-- Reload config and plugins.
nnoremap('<leader>r', _G.reload_config, { silent = true })
