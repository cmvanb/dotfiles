--------------------------------------------------------------------------------
-- Treesitter configuration
--------------------------------------------------------------------------------

local parser_config = require('nvim-treesitter.parsers').get_parser_configs()

-- Hyprland parser
parser_config.hypr = {
    install_info = {
        url = 'https://github.com/luckasRanarison/tree-sitter-hypr',
        files = { 'src/parser.c' },
        branch = 'master',
    },
    filetype = 'hypr',
}

require('nvim-treesitter.configs').setup({
    auto_install = true,
    highlight = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = 'gnn',    -- gnn
            node_incremental = 'grn',  -- grn
            node_decremental = 'grm',  -- grm
            scope_incremental = 'grc', -- grc
        },
    },
    indent = {
        enable = true
    },
    playground = {
        enable = true,
    }
})

