--------------------------------------------------------------------------------
-- Plugin configuration
--------------------------------------------------------------------------------

return {

    -- General
    ----------------------------------------------------------------------------

    -- Packer can manage itself.
    { 'wbthomason/packer.nvim' },

    -- Sugar for UNIX shell commands.
    { 'tpope/vim-eunuch' },

    -- Mini plugins collection.
    {
        'echasnovski/mini.nvim',
        config = function()
            do_load('plugins/mini/comment')
            do_load('plugins/mini/map')
            do_load('plugins/mini/pairs')
        end
    },

    -- Session management
    ----------------------------------------------------------------------------

    {
        'rmagatti/auto-session',
        config = function()
            require('auto-session').setup()
        end
    },

    -- Buffer management
    ----------------------------------------------------------------------------

    -- Better buffer deletion
    { 'famiu/bufdelete.nvim' },

    -- Redirect command output to new buffer.
    { 'sbulav/nredir.nvim' },

    -- Git integration
    ----------------------------------------------------------------------------

    -- Git messenger
    {
        'rhysd/git-messenger.vim',
        config = function()
            vim.g.git_messenger_no_default_mappings = true
        end,
    },

    -- LSP
    ----------------------------------------------------------------------------

    -- Package management for LSP tooling such as language servers, debuggers,
    -- linters and formatters.
    {
        'williamboman/mason.nvim',
        config = function()
            require('mason').setup({
                ui = {
                    border = 'rounded',
                },
            })
        end,
    },
    {
        'williamboman/mason-lspconfig.nvim',
        after = {
            'mason.nvim',
        },
    },

    -- LSP configuration. Also configure mason-lspconfig.
    {
        'neovim/nvim-lspconfig',
        after = {
            'mason-lspconfig.nvim',
        },
        config = function()
            do_load('plugins/lsp')
        end,
    },

    -- Completion
    ----------------------------------------------------------------------------

    -- Github Copilot
    {
        'github/copilot.vim',
    },

    -- Snippet engine.
    {
        'L3MON4D3/LuaSnip',
        config = function()
            require('luasnip').setup({
                history = true,
                update_events = 'TextChanged,TextChangedI',
            })
        end,
    },

    -- Various snippets.
    {
        'rafamadriz/friendly-snippets',
        requires = { 'L3MON4D3/LuaSnip' },
        config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
        end,
    },

    -- Completion tooling.
    {
        'hrsh7th/nvim-cmp',
        requires = { 'L3MON4D3/LuaSnip' },
        config = function()
            do_load('plugins/completion')
        end
    },

    -- Completion sources.
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-nvim-lua' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-nvim-lsp-signature-help' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'f3fora/cmp-spell' },

    -- Syntax highlighting
    ----------------------------------------------------------------------------

    -- Treesitter.
    {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
        config = function()
            do_load('plugins/treesitter')
        end
    },
    { 'nvim-treesitter/playground' },

    -- Syntax rules.
    { 'khaveesh/vim-fish-syntax' },
    { 'camnw/lf-vim' },
    { 'LnL7/vim-nix' },
    { 'ziglang/zig.vim' },

    -- Cursor highlight
    { 'RRethy/vim-illuminate' },

    -- Folding
    ----------------------------------------------------------------------------

    {
        'kevinhwang91/nvim-ufo',
        requires = { 'kevinhwang91/promise-async' },
        config = function()
            do_load('plugins/ufo')
        end,
    },
    {
        'chrisgrieser/nvim-origami',
        config = function()
            require('origami').setup({})
        end,
    },

    -- Search
    ----------------------------------------------------------------------------

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            do_load('plugins/telescope')
        end
    },
    {
        'nvim-telescope/telescope-symbols.nvim',
    },

    -- Viewing
    ----------------------------------------------------------------------------

    -- See color values in editor.
    {
        'NvChad/nvim-colorizer.lua',
        config = function()
            do_load('plugins/colorizer')
        end
    },

    -- Indentation
    {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            local Symbols = require('theme.symbols')

            require('ibl').setup({
                indent = {
                    char = Symbols.indent_char,
                },
                scope = {
                    enabled = true,
                }
            })
        end
    },

    -- Navigation
    ----------------------------------------------------------------------------

    -- Jump movement.
    {
        'ggandor/leap.nvim',
        config = function()
            require('leap').setup({
                case_sensitive = true,
            })
        end
    },

    -- Editing
    ----------------------------------------------------------------------------

    -- Surround.
    -- sa: add, sd: delete, sr: replace
    -- ib: inner select, ab: outer select (VISUAL mode)
    { 'machakann/vim-sandwich' },

    -- easier digraphs
    -- :UnicodeName
    -- :UnicodeSearch
    -- :UnicodeTable
    -- :Digraphs
    {
        'chrisbra/unicode.vim',
        config = function()
            vim.g.Unicode_no_default_mappings = true
        end,
    },

    -- Formatting
    ----------------------------------------------------------------------------

    {
        'nvimdev/guard.nvim',
        config = function()
            do_load('plugins/guard')
        end
    },

    -- Status column
    ----------------------------------------------------------------------------

    {
        'luukvbaal/statuscol.nvim',
        config = function()
            do_load('plugins/statuscol')
        end
    },

    -- Sign column
    ----------------------------------------------------------------------------

    {
        'lewis6991/gitsigns.nvim',
        config = function()
            local Symbols = require('theme.symbols')

            require('gitsigns').setup({
                signs = {
                    add          = { text = Symbols.git_signs.add },
                    change       = { text = Symbols.git_signs.change },
                    delete       = { text = Symbols.git_signs.delete },
                    topdelete    = { text = Symbols.git_signs.topdelete },
                    changedelete = { text = Symbols.git_signs.changedelete },
                    untracked    = { text = Symbols.git_signs.untracked },
                },
            })
        end
    },

    -- Status line
    ----------------------------------------------------------------------------

    {
        'nvim-lualine/lualine.nvim',
        requires = {
            'kyazdani42/nvim-web-devicons',
            'nvimdev/guard-collection',
        },
        config = function()
            do_load('plugins/lualine')
        end,
    },
}
