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
            file_modified = '●',
            file_readonly = '󰌾',
            git_branch = '',
            section_separator_left = '',
            section_separator_right = '',
            tab = ' ',
        },
        prompt_char = '❱',
        select_char = '●',
        indent_char = '▏',
    } or {
        borderchars = {
            '─', '│', '─', '│', '┌', '┐', '┘', '└',
        },
        diagnostic_signs = {
            error = 'x',
            warn  = '!',
            hint  = '?',
            info  = 'i',
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
            file_modified = '*',
            file_readonly = '[ro]',
            git_branch = '├',
            section_separator_left = '>',
            section_separator_right = '<',
            tab = '@',
        },
        prompt_char = '>',
        select_char = '·',
        indent_char = '│',
    }

return Symbols
