--------------------------------------------------------------------------------
-- Lualine theme
--------------------------------------------------------------------------------

local theme = reload('theme.system')

local colors = {
    theme_1_bg  = theme.color_hash('primary_6'),
    theme_1_fg  = theme.color_hash('text_15'),
    theme_2_bg  = theme.color_hash('primary_3'),
    theme_2_fg  = theme.color_hash('text_8'),
    theme_3_bg  = theme.color_hash('editor_bg'),
    theme_3_fg  = theme.color_hash('text_6'),
    inactive_bg = theme.color_hash('editor_bg'),
    inactive_fg = theme.color_hash('text_4'),

    normal_bg   = theme.color_hash('primary_6'),
    normal_fg   = theme.color_hash('text_15'),
    insert_bg   = theme.color_hash('green_2'),
    insert_fg   = theme.color_hash('green_5'),
    visual_bg   = theme.color_hash('magenta_4'),
    visual_fg   = theme.color_hash('magenta_9'),
    command_bg  = theme.color_hash('orange_3'),
    command_fg  = theme.color_hash('yellow_6'),
    replace_bg  = theme.color_hash('purple_3'),
    replace_fg  = theme.color_hash('purple_8'),
}

-- Construct theme
--------------------------------------------------------------------------------

return {
    normal = {
        a = { bg = colors.normal_bg, fg = colors.normal_fg, gui = 'bold' },
        b = { bg = colors.theme_2_bg, fg = colors.theme_2_fg },
        c = { bg = colors.theme_3_bg, fg = colors.theme_3_fg },
        x = { bg = colors.theme_3_bg, fg = colors.theme_3_fg },
        y = { bg = colors.theme_2_bg, fg = colors.theme_2_fg },
        z = { bg = colors.theme_1_bg, fg = colors.theme_1_fg },
    },
    insert = {
        a = { bg = colors.insert_bg, fg = colors.insert_fg, gui = 'bold' },
        b = { bg = colors.theme_2_bg, fg = colors.theme_2_fg },
        c = { bg = colors.theme_3_bg, fg = colors.theme_3_fg },
        x = { bg = colors.theme_3_bg, fg = colors.theme_3_fg },
        y = { bg = colors.theme_2_bg, fg = colors.theme_2_fg },
        z = { bg = colors.theme_1_bg, fg = colors.theme_1_fg },
    },
    visual = {
        a = { bg = colors.visual_bg, fg = colors.visual_fg, gui = 'bold' },
        b = { bg = colors.theme_2_bg, fg = colors.theme_2_fg },
        c = { bg = colors.theme_3_bg, fg = colors.theme_3_fg },
        x = { bg = colors.theme_3_bg, fg = colors.theme_3_fg },
        y = { bg = colors.theme_2_bg, fg = colors.theme_2_fg },
        z = { bg = colors.theme_1_bg, fg = colors.theme_1_fg },
    },
    replace = {
        a = { bg = colors.replace_bg, fg = colors.replace_fg, gui = 'bold' },
        b = { bg = colors.theme_2_bg, fg = colors.theme_2_fg },
        c = { bg = colors.theme_3_bg, fg = colors.theme_3_fg },
        x = { bg = colors.theme_3_bg, fg = colors.theme_3_fg },
        y = { bg = colors.theme_2_bg, fg = colors.theme_2_fg },
        z = { bg = colors.theme_1_bg, fg = colors.theme_1_fg },
    },
    command = {
        a = { bg = colors.command_bg, fg = colors.command_fg, gui = 'bold' },
        b = { bg = colors.theme_2_bg, fg = colors.theme_2_fg },
        c = { bg = colors.theme_3_bg, fg = colors.theme_3_fg },
        x = { bg = colors.theme_3_bg, fg = colors.theme_3_fg },
        y = { bg = colors.theme_2_bg, fg = colors.theme_2_fg },
        z = { bg = colors.theme_1_bg, fg = colors.theme_1_fg },
    },
    inactive = {
        a = { bg = colors.inactive_bg, fg = colors.inactive_fg, gui = 'bold' },
        b = { bg = colors.inactive_bg, fg = colors.inactive_fg },
        c = { bg = colors.inactive_bg, fg = colors.inactive_fg },
        x = { bg = colors.inactive_bg, fg = colors.inactive_fg },
        y = { bg = colors.inactive_bg, fg = colors.inactive_fg },
        z = { bg = colors.inactive_bg, fg = colors.inactive_fg },
    }
}
