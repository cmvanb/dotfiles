--------------------------------------------------------------------------------
-- Completion config
--------------------------------------------------------------------------------

local TableUtils = reload('utils.table')

local function has_words_before()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local cmp = require('cmp')
local luasnip = require('luasnip')

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),

        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({ select = false })
                -- local count = TableUtils.count(cmp.get_entries())
                -- if count == 1 then
                --     cmp.confirm({ select = false })
                -- else
                --     cmp.select_next_item()
                -- end
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<CR>'] = cmp.mapping(function(fallback)
            -- local entry = cmp.get_selected_entry()
            -- dump_table(entry)
            if cmp.visible() then
                cmp.confirm({ select = false })
                -- TODO: Figure out how to exit insert mode without leaving
                -- garbage chars.
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<Right>'] = cmp.mapping.confirm({ select = false }),

        ['<Esc>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.abort()
                vim.cmd.stopinsert()
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

