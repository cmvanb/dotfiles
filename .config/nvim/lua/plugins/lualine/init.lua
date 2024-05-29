--------------------------------------------------------------------------------
-- Lualine configuration
--------------------------------------------------------------------------------

local theme = reload('plugins.lualine.theme')

local Symbols = reload('theme.symbols')

require('lualine').setup({
    options = {
        theme = theme,
        component_separators = ' ',
        section_separators = {
            left = Symbols.lualine.section_separator_left,
            right = Symbols.lualine.section_separator_right,
        },
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = {
            {
                'branch',
                icon = Symbols.lualine.git_branch,
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
                    added = Symbols.diff_signs.added,
                    modified = Symbols.diff_signs.changed,
                    removed = Symbols.diff_signs.removed,
                },
            },
        },
        lualine_c =
        {
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
                    error = Symbols.diagnostic_signs.error,
                    warn = Symbols.diagnostic_signs.warn,
                    hint = Symbols.diagnostic_signs.hint,
                    info = Symbols.diagnostic_signs.info,
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
                    right = Symbols.lualine.section_separator_left
                },
                padding = { left = 1, right = 1 },
                symbols = {
                    modified = Symbols.lualine.file_modified,
                    readonly = Symbols.lualine.file_readonly,
                    unnamed = '[No Name]',
                    newfile = '',
                }
            },
            -- {
            --     'buffers',
            --
            --     icons_enabled = true,
            --     padding = { left = 1, right = 1 },
            --     -- separator = { left = '', right = '' },
            --     separator = { left = '', right = '' },
            --
            --     show_filename_only = true,
            --     hide_filename_extension = false,
            --     show_modified_status = true,
            --
            --     mode = 0,
            --
            --     -- Don't limit length.
            --     max_length = vim.o.columns / 16,
            --
            --     filetype_names = {
            --         TelescopePrompt = 'Telescope',
            --         packer = 'Packer',
            --         mason = 'Mason',
            --     },
            --
            --     buffers_color = {
            --         active = 'lualine_z_normal',
            --         inactive = 'lualine_y_normal',
            --     },
            --
            --     symbols = {
            --         modified = ' ●',
            --         alternate_file = '',
            --         directory =  '',
            --     },
            -- },
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
                    return Symbols.lualine.tab_page .. context.tabnr
                end,
                show_modified_status = false,
                separator = {
                    left = Symbols.lualine.section_separator_right,
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
