--------------------------------------------------------------------------------
-- Show/hide command line when entering command mode
--------------------------------------------------------------------------------

local augroup = vim.api.nvim_create_augroup("CommandLine", { clear = true })

vim.api.nvim_create_autocmd('CmdlineEnter', {
    group = augroup,
    callback = function()
        vim.cmd('set cmdheight=1')
    end,
})

vim.api.nvim_create_autocmd('CmdlineLeave', {
    group = augroup,
    callback = function()
        vim.cmd('set cmdheight=0')
    end,
})
