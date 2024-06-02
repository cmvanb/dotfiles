--------------------------------------------------------------------------------
-- Layout help windows dynamically (based on the terminal size).
--------------------------------------------------------------------------------

local augroup = vim.api.nvim_create_augroup("OpenHelpVertically", { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    group = augroup,
    callback = function()
        if vim.bo.buftype ~= 'help' then
            return
        end

        local columns = vim.api.nvim_get_option_value('columns', {})
        local lines = vim.api.nvim_get_option_value('lines', {})

        if columns >= lines * 3 then
            vim.cmd("wincmd L")
        else
            vim.cmd("wincmd K")
        end
    end,
})
