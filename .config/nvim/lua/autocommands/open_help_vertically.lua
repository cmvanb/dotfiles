--------------------------------------------------------------------------------
-- Open help windows vertically
--------------------------------------------------------------------------------

local augroup = vim.api.nvim_create_augroup("OpenHelpVertically", { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    group = augroup,
    callback = function()
        vim.cmd("if &buftype == 'help' | wincmd L | endif")
    end,
})
