--------------------------------------------------------------------------------
-- Plugin configuration
--------------------------------------------------------------------------------

return {

    -- General
    ----------------------------------------------------------------------------

    -- Sugar for UNIX shell commands.
    { 'tpope/vim-eunuch' },

    -- Mini plugins collection.
    {
        'echasnovski/mini.nvim',
        config = function()
            do_load('plugins/mini/comment')
            do_load('plugins/mini/pairs')
        end
    },

    -- Keymap helper
    {
        'folke/which-key.nvim',
        config = function()
            require('which-key').setup({
                icons = {
                    mappings = false,
                },
            })
        end
    },


    -- Session management
    ----------------------------------------------------------------------------

    {
        'Shatur/neovim-session-manager',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            do_load('plugins/session')
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
            local ThemeConfig = reload('theme.config')

            reload('mason').setup({
                ui = {
                    border = ThemeConfig.border,
                },
            })
        end,
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            'mason.nvim',
        },
    },

    -- LSP configuration. Also configure mason-lspconfig.
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'saghen/blink.cmp',
            'mason-lspconfig.nvim',
        },
        config = function()
            do_load('plugins/lsp')
        end,
    },


    -- Completion
    ----------------------------------------------------------------------------

    -- Snippet engine.
    {
        'L3MON4D3/LuaSnip',
        config = function()
            reload('luasnip').setup({
                history = true,
                update_events = 'TextChanged,TextChangedI',
            })
        end,
    },

    -- Various snippets.
    {
        'rafamadriz/friendly-snippets',
        dependencies = { 'L3MON4D3/LuaSnip' },
        config = function()
            reload('luasnip.loaders.from_vscode').lazy_load()
        end,
    },

    -- Blink
    {
        'saghen/blink.cmp',
        version = not vim.g.lazyvim_blink_main and '*',
        build = vim.g.lazyvim_blink_main and 'cargo build --release',
        opts_extend = {
            'sources.completion.enabled_providers',
            'sources.compat',
            'sources.default',
        },
        dependencies = {
            'rafamadriz/friendly-snippets',
            -- add blink.compat to dependencies
            {
                'saghen/blink.compat',
                optional = true, -- make optional so it's only enabled if any extras need it
                opts = {},
                version = not vim.g.lazyvim_blink_main and '*',
            },
        },
        event = 'InsertEnter',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- snippets = {
            --     expand = function(snippet, _)
            --         return LazyVim.cmp.expand(snippet)
            --     end,
            -- },
            appearance = {
                -- sets the fallback highlight groups to nvim-cmp's highlight groups
                -- useful for when your theme doesn't support blink.cmp
                -- will be removed in a future release, assuming themes add support
                use_nvim_cmp_as_default = false,
                -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono',
            },
            completion = {
                accept = {
                    -- experimental auto-brackets support
                    auto_brackets = {
                        enabled = true,
                    },
                },
                menu = {
                    draw = {
                        treesitter = { 'lsp' },
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                },
                ghost_text = {
                    enabled = vim.g.ai_cmp,
                },
            },

            -- experimental signature help support
            -- signature = { enabled = true },

            sources = {
                -- adding any nvim-cmp sources here will enable them
                -- with blink.compat
                compat = {},
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },

            cmdline = {
                enabled = false,
            },

            keymap = {
                preset = 'enter',
                ['<Right>'] = { 'select_and_accept' },
            },
        },
        ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
        config = function(_, opts)
            -- setup compat sources
            local enabled = opts.sources.default
            for _, source in ipairs(opts.sources.compat or {}) do
                opts.sources.providers[source] = vim.tbl_deep_extend(
                    'force',
                    { name = source, module = 'blink.compat.source' },
                    opts.sources.providers[source] or {}
                )
                if type(enabled) == 'table' and not vim.tbl_contains(enabled, source) then
                    table.insert(enabled, source)
                end
            end

            -- add ai_accept to <Tab> key
            -- if not opts.keymap['<Tab>'] then
            --     if opts.keymap.preset == 'super-tab' then -- super-tab
            --         opts.keymap['<Tab>'] = {
            --             require('blink.cmp.keymap.presets')['super-tab']['<Tab>'][1],
            --             LazyVim.cmp.map({ 'snippet_forward', 'ai_accept' }),
            --             'fallback',
            --         }
            --     else -- other presets
            --         opts.keymap['<Tab>'] = {
            --             LazyVim.cmp.map({ 'snippet_forward', 'ai_accept' }),
            --             'fallback',
            --         }
            --     end
            -- end

            -- Unset custom prop to pass blink.cmp validation
            opts.sources.compat = nil

            -- check if we need to override symbol kinds
            -- for _, provider in pairs(opts.sources.providers or {}) do
            --     ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
            --     if provider.kind then
            --         local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
            --         local kind_idx = #CompletionItemKind + 1
            --
            --         CompletionItemKind[kind_idx] = provider.kind
            --         ---@diagnostic disable-next-line: no-unknown
            --         CompletionItemKind[provider.kind] = kind_idx
            --
            --         ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
            --         local transform_items = provider.transform_items
            --         ---@param ctx blink.cmp.Context
            --         ---@param items blink.cmp.CompletionItem[]
            --         provider.transform_items = function(ctx, items)
            --             items = transform_items and transform_items(ctx, items) or items
            --             for _, item in ipairs(items) do
            --                 item.kind = kind_idx or item.kind
            --                 item.kind_icon = LazyVim.config.icons.kinds[item.kind_name] or item.kind_icon or nil
            --             end
            --             return items
            --         end
            --
            --         -- Unset custom prop to pass blink.cmp validation
            --         provider.kind = nil
            --     end
            -- end

            require('blink.cmp').setup(opts)
        end,
    },

    -- -- Completion tooling.
    -- {
    --     'hrsh7th/nvim-cmp',
    --     dependencies = { 'L3MON4D3/LuaSnip' },
    --     config = function()
    --         do_load('plugins/completion')
    --     end
    -- },
    --
    -- -- Completion sources.
    -- { 'hrsh7th/cmp-buffer' },
    -- { 'hrsh7th/cmp-nvim-lua' },
    -- { 'hrsh7th/cmp-nvim-lsp' },
    -- { 'hrsh7th/cmp-nvim-lsp-signature-help' },
    -- { 'saadparwaiz1/cmp_luasnip' },
    -- { 'f3fora/cmp-spell' },

    -- AI
    ----------------------------------------------------------------------------

    -- Github Copilot
    {
        'github/copilot.vim',
    },

    -- CodeCompanion
    -- {
    --     'olimorris/codecompanion.nvim',
    --     config = true,
    --     dependencies = {
    --         'nvim-lua/plenary.nvim',
    --         'nvim-treesitter/nvim-treesitter',
    --     },
    -- },

    -- Syntax highlighting
    ----------------------------------------------------------------------------

    -- Treesitter.
    {
        'nvim-treesitter/nvim-treesitter',
        build = function()
            local ts_update = reload('nvim-treesitter.install').update({ with_sync = true })
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
    { 'imsnif/kdl.vim' },

    -- Cursor highlight
    { 'RRethy/vim-illuminate' },

    -- Formatting
    ----------------------------------------------------------------------------

    {
        'Wansmer/treesj',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            reload('treesj').setup({
                use_default_keymaps = false,
            })
        end,
    },

    -- {
    --     'stevearc/conform.nvim',
    --     config = function()
    --         require('conform').setup({
    --             formatters_by_ft = {
    --                 css = { 'prettierd' },
    --                 -- javascript = { 'prettierd' },
    --                 -- javascriptreact = { 'prettierd' },
    --                 -- markdown = { 'prettierd' },
    --                 -- python = { 'black' },
    --                 -- rust = { 'rustfmt' },
    --                 -- yaml = { 'prettierd' },
    --             },
    --             format_on_save = {
    --                 timeout_ms = 500,
    --                 lsp_format = 'fallback',
    --             },
    --         })
    --     end,
    -- },


    -- Folding
    ----------------------------------------------------------------------------

    -- {
    --     'kevinhwang91/nvim-ufo',
    --     dependencies = { 'kevinhwang91/promise-async' },
    --     config = function()
    --         do_load('plugins/ufo')
    --     end,
    -- },
    -- {
    --     'chrisgrieser/nvim-origami',
    --     config = function()
    --         reload('origami').setup({
    --             setupFoldKeymaps = false,
    --         })
    --     end,
    -- },


    -- Search
    ----------------------------------------------------------------------------

    -- Snacks
    {
        'folke/snacks.nvim',
        priority = 1000,
        lazy = false,
        opts = {
            picker = {
                enabled = true,
                win = {
                    -- input window
                    input = {
                        keys = {
                            ["<Esc>"] = { "close", mode = { "n", "i" } },
                        },
                    },
                },
            },
        }
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
            local ThemeSymbols = reload('theme.symbols')

            reload('ibl').setup({
                indent = {
                    char = ThemeSymbols.indent_char,
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
            reload('leap').setup({
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
            local ThemeSymbols = reload('theme.symbols')

            reload('gitsigns').setup({
                -- Enable cursor line highlights (fixes missing background color
                -- in sign column)
                culhl = true,
                signs = {
                    add          = { text = ThemeSymbols.git_signs.add },
                    change       = { text = ThemeSymbols.git_signs.change },
                    delete       = { text = ThemeSymbols.git_signs.delete },
                    topdelete    = { text = ThemeSymbols.git_signs.topdelete },
                    changedelete = { text = ThemeSymbols.git_signs.changedelete },
                    untracked    = { text = ThemeSymbols.git_signs.untracked },
                },
            })
        end
    },


    -- Status line
    ----------------------------------------------------------------------------

    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'kyazdani42/nvim-web-devicons',
            'nvimdev/guard-collection',
        },
        config = function()
            do_load('plugins/lualine')
        end,
    },
}
