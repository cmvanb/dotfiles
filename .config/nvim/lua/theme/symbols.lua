--------------------------------------------------------------------------------
-- Symbols lookup
--
-- TODO: Consider adding a shortcut to toggle the EOL character.
--------------------------------------------------------------------------------

local Symbols =
    not is_linux_virtual_terminal() and {
        borderchars = {
            "─", "│", "─", "│", "╭", "╮", "╯", "╰",
        },
        diagnostic_signs = {
            error = '󰅜 ',
            warn  = ' ',
            hint  = '󰌵 ',
            info  = 'ℹ ',
        },
        diff_signs = {
            added = '+',
            changed = '~',
            removed = '-',
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
        lualine = {
            section_separator_left = '',
            section_separator_right = '',
            file_modified = '●',
            file_readonly = '󰌾',
        },
        prompt_char = '❱',
        select_char = '',
        indent_char = '▏',
    } or {
        borderchars = {
            '─', '│', '─', '│', '┌', '┐', '┘', '└',
        },
        diagnostic_signs = {
            error = 'x ',
            warn  = '! ',
            hint  = '? ',
            info  = 'i ',
        },
        diff_signs = {
            added = '+',
            changed = '~',
            removed = '-',
        },
        git_signs = {
            add          = '│',
            change       = '│',
            delete       = '_',
            topdelete    = '─',
            changedelete = '~',
            untracked    = '░',
        },
        fillchars = {
            eob = '~',
            foldopen = '▼',
            foldclose = '▶',
            fold = ' ',
        },
        listchars = {
            lead = '·',
            tab = '>-',
            -- eol = '↓',
            trail = '·',
        },
        lualine = {
            section_separator_left = '▒',
            section_separator_right = '▒',
            file_modified = '*',
            file_readonly = '!',
        },
        prompt_char = '>',
        select_char = '·',
        indent_char = '│',
    }

return Symbols
