--------------------------------------------------------------------------------
-- Telescope project files picker
-- see: https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#falling-back-to-find_files-if-git_files-cant-find-a-git-directory
--------------------------------------------------------------------------------

return function()
    local opts = {}

    vim.fn.system('git rev-parse --is-inside-work-tree')

    if vim.v.shell_error == 0 then
        require('telescope.builtin').git_files(opts)
    else
        require('telescope.builtin').find_files(opts)
    end
end
