--------------------------------------------------------------------------------
-- Mini comment plugin
--------------------------------------------------------------------------------

require('mini.comment').setup({
    mappings = {
        -- Toggle comment on current line (NORMAL)
        comment_line = '<C-/>',
        -- Toggle comment on selection (VISUAL)
        comment_visual = '<C-/>',
        -- Define 'comment' textobject (like `dgc` - delete whole comment block)
        textobject = 'gc',
    },
})

