--------------------------------------------------------------------------------
-- Neovim configuration
--------------------------------------------------------------------------------

-- Packer's compile target is in `.local/share/nvim`, so we need to include this
-- in the runtimepath to ensure NVIM can autoload Packer.
vim.opt.runtimepath:append(vim.fn.stdpath('data'))

-- Improve startup performance.
require('utils.disable_builtins')

-- Global utils.
require('utils.debug')
require('utils.do_load')
require('utils.reload')
require('utils.reload_config')
require('utils.terminal')

-- Load editor config.
require('editor.gui')
require('editor.options')
require('editor.highlights')

-- Load plugins. Will bootstrap Lazy.nvim if necessary.
require('plugins.manager')

-- Load autocommands.
require('autocommands')

-- Load key mappings last.
require('editor.keymaps')
