--------------------------------------------------------------------------------
-- Mini indentscope plugin
--
-- Show scope of current indent.
--------------------------------------------------------------------------------

local function get_scope_symbol()
    if is_linux_terminal() then return '|' else return '╎' end
end

local indentscope = require('mini.indentscope')

indentscope.setup({
    draw = {
        delay = 10,
        animation = indentscope.gen_animation.cubic({ easing = 'in', duration = 200, unit = 'total' }),
    },

    mappings = {
        object_scope = 'ii',
        object_scope_with_border = 'ai',
        goto_top = '[i',
        goto_bottom = ']i',
    },

    options = {
        border = 'both',
        indent_at_cursor = true,
        try_as_border = false,
    },

    symbol = get_scope_symbol(),
})
