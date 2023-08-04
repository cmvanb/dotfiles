--------------------------------------------------------------------------------
-- Colorizer configuration
--------------------------------------------------------------------------------

local colorizer = require('colorizer')
colorizer.setup({
    user_default_options = {
        -- Don't highlight CSS names.
        names = false,
    },
})

vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
        colorizer.attach_to_buffer(0)
    end,
})

