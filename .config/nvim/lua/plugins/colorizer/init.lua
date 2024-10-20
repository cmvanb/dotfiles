--------------------------------------------------------------------------------
-- Colorizer configuration
--------------------------------------------------------------------------------

local colorizer = reload('colorizer')

colorizer.setup({
    filetypes = {
        '*',
    },
    user_default_options = {
        -- Don't highlight CSS names.
        names = false,
        always_update = true,
        mode = 'background',
    },
})

vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
        -- NOTE: Ugly timer hack because Colorizer is buggy.
        vim.fn.timer_start(300, function()
            colorizer.attach_to_buffer(0)
        end)
    end,
})
