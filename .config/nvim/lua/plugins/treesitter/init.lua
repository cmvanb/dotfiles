--------------------------------------------------------------------------------
-- Treesitter configuration
--------------------------------------------------------------------------------

require('nvim-treesitter.configs').setup({
    ensure_installed = {
        'bash',
        'c',
        'c_sharp',
        'cpp',
        'css',
        'dockerfile',
        'fish',
        'go',
        'html',
        'javascript',
        'json',
        'lua',
        'make',
        'markdown',
        'nix',
        'python',
        'rust',
        'toml',
        'typescript',
        'vim',
        'yaml',
        'zig',
    },
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
