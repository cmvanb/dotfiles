--------------------------------------------------------------------------------
-- Telescope configuration
--------------------------------------------------------------------------------

local telescope = require('telescope')
local actions = require('telescope.actions')

local ThemeSymbols = require('theme.symbols')

telescope.setup({
    defaults = {
        border = true,
        borderchars = ThemeSymbols.borderchars,
        dynamic_preview_title = true,
        layout_strategy = 'flex',
        layout_config = {
            flip_columns = 133,
        },
        prompt_prefix = ThemeSymbols.telescope.prompt_char .. ' ',
        selection_caret = ThemeSymbols.telescope.select_char .. ' ',
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
            '--ignore',
        },
        mappings = {
            i = {
                ['<C-q>'] = actions.delete_buffer,
                ['<C-n>'] = actions.select_vertical,
                ['<C-p>'] = actions.select_horizontal,
                ['<C-j>'] = actions.move_selection_next,
                ['<C-k>'] = actions.move_selection_previous,
                ['<Esc>'] = actions.close,
            },
        },
    },
})
