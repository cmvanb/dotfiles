--------------------------------------------------------------------------------
-- Telescope configuration
--------------------------------------------------------------------------------

local telescope = require('telescope')
local actions = require('telescope.actions')

local Symbols = require('theme.symbols')

telescope.setup({
    defaults = {
        layout_strategy = 'horizontal',
        layout_config = {
            preview_width = 0.5,
        },
        prompt_prefix = Symbols.prompt_char .. ' ',
        selection_caret = ' ',
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
