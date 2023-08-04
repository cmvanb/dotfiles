--------------------------------------------------------------------------------
-- Mini comment plugin
--------------------------------------------------------------------------------

require('mini.comment').setup({
    mappings = {
        -- Toggle comment on selection (VISUAL) or current line (NORMAL)
        comment = '<C-/>',
        -- Toggle comment on current line
        comment_line = '<C-/>',
    },
})

