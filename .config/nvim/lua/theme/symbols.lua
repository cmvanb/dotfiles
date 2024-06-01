--------------------------------------------------------------------------------
-- Symbols lookup
--------------------------------------------------------------------------------

local default_terminal_symbols = {
    borderchars = {
        '─', '│', '─', '│', '╭', '╮', '╯', '╰',
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
        tab_page = '  ',
    },
    packer = {
        working = '',
        error = '⨯',
        done = '',
        removed = '-',
        moved = '󰁔',
        header = '─',
    },
    telescope = {
        prompt_char = '❱',
        select_char = '●',
    },
    indent_char = '▏',
}

local linux_vt_symbols = {
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
        tab_page = '@',
    },
    packer = {
        working = '?',
        error = 'x',
        done = 'O',
        removed = '-',
        moved = '→',
        header = '-',
    },
    telescope = {
        prompt_char = '>',
        select_char = '·',
    },
    indent_char = '│',
}

return is_linux_virtual_terminal()
    and linux_vt_symbols
    or default_terminal_symbols
