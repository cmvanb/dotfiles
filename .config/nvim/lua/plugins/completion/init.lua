--------------------------------------------------------------------------------
-- Completion config
--------------------------------------------------------------------------------

local cmp = require('cmp')
local luasnip = require('luasnip')

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),

        ['<Right>'] = cmp.mapping(function(fallback)
            -- NOTE: Try this for copilot:
            -- vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](vim.api.nvim_replace_termcodes('<Tab>', true, true, true)), 'n', true)

            if cmp.visible() then
                -- NOTE: `select = false` prevents inferring a selection when
                -- no item is highlighted.
                cmp.confirm({ select = false })
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({ select = true })
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<Esc>'] = cmp.mapping(function(fallback)
            vim.cmd.stopinsert()

            if cmp.visible() then
                cmp.abort()
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),

    completion = {
        completeopt = 'menu,menuone,noinsert'
    },

    formatting = {
        fields = { 'abbr', 'menu', 'kind' },
        format = function(entry, item)
            local short_name = {
                nvim_lsp = 'LSP',
                nvim_lua = 'nvim'
            }

            local menu_name = short_name[entry.source.name] or entry.source.name

            item.menu = string.format('[%s]', menu_name)
            return item
        end,
    },
    matching = {
        disallow_fuzzy_matching = true,
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },

    sources = {
        { name = 'buffer', keyword_length = 2 },
        { name = 'nvim_lua', keyword_length = 2 },
        { name = 'nvim_lsp', keyword_length = 2 },
        { name = 'nvim_lsp_signature_help', keyword_length = 2 },
        { name = 'luasnip', keyword_length = 2 },
        {
            name = 'spell',
            option = {
                keep_all_entries = false,
                enable_in_context = function()
                    return true
                end,
            },
        },
    },

    window = {
        completion = cmp.config.window.bordered(),
        documentation = vim.tbl_deep_extend(
            'force',
            cmp.config.window.bordered(),
            {
                max_height = 15,
                max_width = 60,
            }
        ),
    },
})

