--------------------------------------------------------------------------------
-- Equalize splits when window size changes.
--------------------------------------------------------------------------------

local augroup = vim.api.nvim_create_augroup("EqualizeSplits", { clear = true })

vim.api.nvim_create_autocmd('VimResized', {
    group = augroup,
    callback = function()
        vim.cmd('wincmd =')
    end,
})

vim.api.nvim_create_autocmd('BufWipeout', {
    group = augroup,
    callback = function()
        vim.cmd('wincmd =')
    end,
})

