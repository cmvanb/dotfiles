--------------------------------------------------------------------------------
-- Completion config
--------------------------------------------------------------------------------

local function has_words_before()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local cmp = require('cmp')
local luasnip = require('luasnip')

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        -- ['<C-k>'] = cmp.mapping.scroll_docs(-4),
        -- ['<C-j>'] = cmp.mapping.scroll_docs(4),
        -- ['<C-Space>'] = cmp.mapping.complete(),
        -- ['<C-x>'] = cmp.mapping.abort(),

        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { 'i', 's' }),

        -- TODO: Fix the shift-tab mapping not working.
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<CR>'] = cmp.mapping.confirm({ select = false }),

        -- NOTE: Inlcuded for consistency with fish shell. Ideally we want to change fish shell completion bindings.
        ['<Right>'] = cmp.mapping.confirm({ select = true }),
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
        { name = 'nvim_lua', keyword_length = 3 },
        { name = 'nvim_lsp', keyword_length = 3 },
        { name = 'nvim_lsp_signature_help', keyword_length = 3 },
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
        completion = {
            border = 'none',
            winhighlight = 'Normal:CmpMenuBackground,CursorLine:CmpMenuSelect',
        },
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

