--------------------------------------------------------------------------------
-- Plugin manager
--------------------------------------------------------------------------------

-- Bootstrap lazy.nvim.
local lazy_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazy_path) then
    local repo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', repo, lazy_path })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
            { out, 'WarningMsg' },
            { '\nPress any key to exit...' },
        }, true, {})

        vim.fn.getchar()
        os.exit(1)
    end
end

-- Add lazy.nvim to the runtimepath.
vim.opt.rtp:prepend(lazy_path)

-- Setup leader key early for lazy.nvim.
vim.g.mapleader = ' '

-- Load plugins.
local plugin_config = require('plugins.config')

require('lazy').setup(plugin_config)
