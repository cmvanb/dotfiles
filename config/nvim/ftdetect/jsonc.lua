vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = "*.json",
    callback = function(args)
        -- Get the filename without the path
        local filename = vim.fn.fnamemodify(args.file, ':t')

        -- NOTE: This is a hack for VSCode settings.json and keybindings.json.
        -- Would be nice to have a better detection mechanism to avoid false
        -- positives.
        if filename == "settings.json" or filename == "keybindings.json" then
            vim.bo.filetype = 'jsonc'
        else
            vim.bo.filetype = 'json'
        end
    end
})
