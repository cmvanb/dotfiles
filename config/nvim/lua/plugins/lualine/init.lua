--------------------------------------------------------------------------------
-- Lualine configuration
--------------------------------------------------------------------------------

local theme = reload('plugins.lualine.theme')

local ThemeSymbols = reload('theme.symbols')

reload('lualine').setup({
    options = {
        theme = theme,
        component_separators = ' ',
        section_separators = {
            left = ThemeSymbols.lualine.section_separator_left,
            right = ThemeSymbols.lualine.section_separator_right,
        },
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = {
            {
                'branch',
                icon = ThemeSymbols.lualine.git_branch,
            },
            {
                'diff',
                colored = true,
                diff_color = {
                    added    = 'LualineDiffAdd',
                    modified = 'LualineDiffChange',
                    removed  = 'LualineDiffDelete',
                },
                symbols = {
                    added = ThemeSymbols.diff_signs.added,
                    modified = ThemeSymbols.diff_signs.changed,
                    removed = ThemeSymbols.diff_signs.removed,
                },
            },
        },
        lualine_c = {
        },
        lualine_x = {
        },
        lualine_y = {
            {
                'diagnostics',
                colored = true,
                diagnostics_color = {
                    error = 'LualineDiagError',
                    warn  = 'LualineDiagWarn',
                    info  = 'LualineDiagInfo',
                    hint  = 'LualineDiagHint',
                },
                symbols = {
                    error = ThemeSymbols.diagnostic_signs.error,
                    warn = ThemeSymbols.diagnostic_signs.warn,
                    hint = ThemeSymbols.diagnostic_signs.hint,
                    info = ThemeSymbols.diagnostic_signs.info,
                },
            },
            {
                'filetype',
                icons_enabled = false,
            },
        },
        lualine_z = {
            {
                'location',
                padding = { left = 1, right = 1 },
            },
        }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {
        lualine_a = {
            {
                'filename',
                color = 'lualine_z_normal',
                path = 3,
                shorting_target = 0,
                separator = {
                    left = '',
                    right = ThemeSymbols.lualine.section_separator_left
                },
                padding = { left = 1, right = 1 },
                symbols = {
                    modified = ThemeSymbols.lualine.file_modified,
                    readonly = ThemeSymbols.lualine.file_readonly,
                    unnamed = '[No Name]',
                    newfile = '',
                }
            },
        },
        lualine_b = {
        },
        lualine_c = {
        },
        lualine_x = {
        },
        lualine_y = {
        },
        lualine_z = {
            {
                'tabs',
                mode = 1,
                fmt = function(_, context)
                    return ThemeSymbols.lualine.tab_page .. context.tabnr
                end,
                show_modified_status = false,
                separator = {
                    left = ThemeSymbols.lualine.section_separator_right,
                    right = ''
                },
                padding = { left = 1, right = 1 },
                tabs_color = {
                    active = 'lualine_z_normal',
                    inactive = 'lualine_y_normal',
                },
            },
        }
    },
})
