--------------------------------------------------------------------------------
-- Plugin configuration
--------------------------------------------------------------------------------

return {
    -- Packer can manage itself.
    { 'wbthomason/packer.nvim' },

    -- Sugar for UNIX shell commands.
    { 'tpope/vim-eunuch' },

    -- Mini plugins collection.
    {
        'echasnovski/mini.nvim',
        config = function()
            do_load('plugins/mini/comment')
            do_load('plugins/mini/cursorword')
            do_load('plugins/mini/indentscope')
            do_load('plugins/mini/pairs')
        end
    },

    -- Session management
    {
        'natecraddock/sessions.nvim',
        config = function()
            do_load('plugins/session')
        end,
    },

    -- Git blame
    {
        'f-person/git-blame.nvim',
        config = function()
            vim.g.gitblame_enabled = 0
        end,
    },

    -- Better buffer deletion
    { 'famiu/bufdelete.nvim' },

    -- Redirect output to scratch buffer.
    { 'sbulav/nredir.nvim' },

    -- Auto formatting.
    {
        'nvimdev/guard.nvim',
        config = function()
            do_load('plugins/guard')
        end
    },

    -- Mason is a package manager for LSP tooling such as language servers,
    -- debug servers, linters and formatters.
    {
        'williamboman/mason.nvim',
    },
    {
        'williamboman/mason-lspconfig.nvim',
        after = {
            'mason.nvim',
        },
    },

    -- Default language server configurations
    {
        'neovim/nvim-lspconfig',
        after = {
            'mason-lspconfig.nvim',
        },
        config = function()
            do_load('plugins/lsp')
        end,
    },

    -- Treesitter (syntax highlighting).
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

    -- Snippet engine.
    {
        'L3MON4D3/LuaSnip',
        config = function()
            local luasnip = require('luasnip')

            luasnip.setup({
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

    -- Completion.
    {
        'hrsh7th/nvim-cmp',
        requires = { 'L3MON4D3/LuaSnip' },
        config = function()
            do_load('plugins/completion')
        end
    },

    -- various completions
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-nvim-lua' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'f3fora/cmp-spell' },

    -- Fuzzy finder.
    {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            do_load('plugins/telescope')
        end
    },

    -- Status line.
    {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons' },
        config = function()
            do_load('plugins/lualine')
        end,
    },

    -- Symbols. 🔥
    {
        'nvim-telescope/telescope-symbols.nvim',
    },

    -- Jump movement.
    {
        'ggandor/leap.nvim',
        config = function()
            do_load('plugins/leap')
        end
    },

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

    -- View colors in editor.
    {
        'NvChad/nvim-colorizer.lua',
        config = function()
            do_load('plugins/colorizer')
        end
    },

    -- Fish syntax highlighting.
    { 'khaveesh/vim-fish-syntax' },

    -- Nix syntax highlighting.
    { 'LnL7/vim-nix' },

    -- Zig syntax highlighting.
    { 'ziglang/zig.vim' },
}

