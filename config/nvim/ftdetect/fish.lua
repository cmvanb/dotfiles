vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = "*.fish~esh",
    callback = function()
        vim.bo.filetype = 'fish'
    end
})
