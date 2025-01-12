--------------------------------------------------------------------------------
-- Key mapping utilities
--------------------------------------------------------------------------------

local KeyMapUtils = {}

-- Imports
--------------------------------------------------------------------------------

local TableUtils = require('utils.table')

-- Private functions
--------------------------------------------------------------------------------

local function _map(mode, keys, command, options)
    options = TableUtils.merge(options or {}, { noremap = false })
    vim.keymap.set(mode, keys, command, options)
end

local function _noremap(mode, keys, command, options)
    options = TableUtils.merge(options or {}, { noremap = true })
    vim.keymap.set(mode, keys, command, options)
end

-- Map functions
--------------------------------------------------------------------------------

function KeyMapUtils.unmap(keys, options)
    options = options or {}
    vim.keymap.del('', keys, options)
end

function KeyMapUtils.map(keys, command, options)
    _map('', keys, command, options)
end

function KeyMapUtils.nmap(keys, command, options)
    _map('n', keys, command, options)
end

function KeyMapUtils.vmap(keys, command, options)
    _map('v', keys, command, options)
end

function KeyMapUtils.xmap(keys, command, options)
    _map('x', keys, command, options)
end

function KeyMapUtils.imap(keys, command, options)
    _map('i', keys, command, options)
end

-- Noremap functions
--------------------------------------------------------------------------------

function KeyMapUtils.noremap(keys, command, options)
    _noremap('', keys, command, options)
end

function KeyMapUtils.nnoremap(keys, command, options)
    _noremap('n', keys, command, options)
end

function KeyMapUtils.vnoremap(keys, command, options)
    _noremap('v', keys, command, options)
end

function KeyMapUtils.xnoremap(keys, command, options)
    _noremap('x', keys, command, options)
end

function KeyMapUtils.inoremap(keys, command, options)
    _noremap('i', keys, command, options)
end

function KeyMapUtils.onoremap(keys, command, options)
    _noremap('o', keys, command, options)
end

return KeyMapUtils
