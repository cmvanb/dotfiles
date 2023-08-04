--------------------------------------------------------------------------------
-- Lualine configuration
--------------------------------------------------------------------------------

local theme = reload('plugins.lualine.theme')

require('lualine').setup({
    options = {
        theme = theme,
        component_separators = ' ',
        -- section_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = {
            'branch',
            {
                'diff',
                colored = true,
                diff_color = {
                    added    = 'LualineDiffAdd',
                    modified = 'LualineDiffChange',
                    removed  = 'LualineDiffDelete',
                },
                symbols = {
                    added = '+',
                    modified = '~',
                    removed = '-',
                },
            },
        },
        lualine_c =
        {
        },
        lualine_x = {},
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
                    error = '✘ ',
                    warn = '⚠ ',
                    hint = ' ',
                    info = 'ℹ ',
                },
            },
            {
                'filetype',
                icons_enabled = false,
            },
        },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {
        lualine_a = {
            {
                'buffers',

                icons_enabled = false,
                padding = { left = 2, right = 2 },
                separator = { left = '', right = '' },

                show_filename_only = true,
                hide_filename_extension = false,
                show_modified_status = true,

                mode = 0,

                -- Don't limit length.
                max_length = 0,

                filetype_names = {
                    TelescopePrompt = 'Telescope',
                    packer = 'Packer',
                },

                buffers_color = {
                    active = 'lualine_z_normal',
                    inactive = 'lualine_y_normal',
                },

                symbols = {
                    modified = ' ●',
                    alternate_file = '',
                    directory =  '',
                },
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
                'filename',
                path = 3,
                shorting_target = 0,
                separator = { left = '', right = '' },
                padding = { left = 2, right = 2 },
                symbols = {
                    modified = '',
                    readonly = '',
                    unnamed = '',
                    newfile = '',
                }
            },
            {
                'tabs',
                separator = { left = '', right = '' },
                padding = { left = 2, right = 2 },
                tabs_color = {
                    active = 'lualine_z_normal',
                    inactive = 'lualine_y_normal',
                },
            },
        }
    },
})

