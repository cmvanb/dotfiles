--------------------------------------------------------------------------------
-- Symbols lookup
--------------------------------------------------------------------------------

local symbols =
    not is_linux_virtual_terminal() and {
        diagnostic_signs = {
            error = '󰅜 ',
            warn  = ' ',
            hint  = '󰌵 ',
            info  = 'ℹ ',
        },
        fillchars = {
            eob = '.',
            foldopen = '󰅀',
            foldclose = '󰅂',
            fold = ' ',
        },
        listchars = {
            tab = '-->',
            eol = '',
            trail = '⋅'
        },
    } or {
        diagnostic_signs = {
            error = 'x ',
            warn  = '! ',
            hint  = '? ',
            info  = 'i ',
        },
        fillchars = {
            eob = '~',
            foldopen = '▼',
            foldclose = '▶',
            fold = ' ',
        },
        listchars = {
            tab = '-->',
            eol = '↓',
            trail = '.'
        },
    }

return symbols
