--------------------------------------------------------------------------------
-- Symbols lookup
--
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
        git_signs = {
            add          = '┃',
            change       = '┃',
            delete       = '_',
            topdelete    = '‾',
            changedelete = '~',
            untracked    = '┆',
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
        git_signs = {
            add          = '+',
            change       = '~',
            delete       = '-',
            topdelete    = '-',
            changedelete = '~',
            untracked    = 'u',
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
