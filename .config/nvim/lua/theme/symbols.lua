--------------------------------------------------------------------------------
-- Symbols lookup

-- TODO: Consider adding a shortcut to toggle the EOL character.
--------------------------------------------------------------------------------

local Symbols =
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
            lead = '⋅',
            tab = '―',
            -- eol = '',
            trail = '⋅',
        },
        prompt_char = '❱',
        indent_char = '▏',
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
            lead = '.',
            tab = '>-',
            -- eol = '↓',
            trail = '.',
        },
        prompt_char = '>',
        indent_char = '│',
    }

return Symbols
