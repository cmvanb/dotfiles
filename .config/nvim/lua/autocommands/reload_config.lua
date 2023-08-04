--------------------------------------------------------------------------------
-- Reload configuration changes.
--------------------------------------------------------------------------------

-- local StringUtils = require('utils/string')

local config_path = vim.fn.stdpath('config')
local augroup = vim.api.nvim_create_augroup('ReloadConfig', { clear = true })

vim.api.nvim_create_autocmd('BufWritePost', {
    group = augroup,
    pattern = config_path .. '/*.lua',
    callback = function()
        reload_config()
    end,
})


