--------------------------------------------------------------------------------
-- Wezterm configuration file
--------------------------------------------------------------------------------

local wezterm = require('wezterm')

-- Retrieve system theme
--------------------------------------------------------------------------------

package.path = os.getenv('XDG_OPT_HOME') .. '/theme' .. [[/?.lua]]
local theme = require('theme')

-- Helpers
--------------------------------------------------------------------------------

-- Create alternate mappings to `alt-screen` applications such as terminal NVIM.
local function alt_action(window, pane, alt_screen_action, terminal_action)
    return wezterm.action_callback(function(window, pane)
        if pane:is_alt_screen_active() then
            window:perform_action(alt_screen_action, pane)
        else
            window:perform_action(terminal_action, pane)
        end
    end)
end

return {

-- General settings
--------------------------------------------------------------------------------

    -- Disable warnings
    warn_about_missing_glyphs = false,

    -- NOTE: Enabling this causes problems with vim-sandwich in NVIM.
    -- Keyboard input settings
    enable_kitty_keyboard = false,

    -- Disable tab bar
    enable_tab_bar = false,
    use_fancy_tab_bar = false,

-- Appearance
--------------------------------------------------------------------------------

    -- Don't render bold as bright.
    bold_brightens_ansi_colors = false,

    -- Cursor
    default_cursor_style = 'SteadyBlock',

    -- Font
    font = wezterm.font({
        family = theme.font('font_mono'),
        weight = 'Regular',
    }),
    font_size = 16.0,

    -- Window
    adjust_window_size_when_changing_font_size = false,
    window_padding = {
        left   = 0,
        right  = 0,
        top    = 0,
        bottom = 0,
    },

    -- Terminal bell
    audible_bell = 'Disabled',
    visual_bell = {
        fade_in_function = 'Linear',
        fade_in_duration_ms = 0,
        fade_out_function = 'EaseOut',
        fade_out_duration_ms = 200,
    },

    -- Transparency
    window_background_opacity = 1.00,

-- Key bindings
--------------------------------------------------------------------------------

    -- NOTE: We don't need any of the defaults.
    -- see: https://wezfurlong.org/wezterm/config/default-keys.html
    disable_default_key_bindings = true,

    keys = {
        -- Reload wezterm config.
        {
            key = 'r',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.ReloadConfiguration,
        },
        -- Search scrollback buffer
        {
            key = 'f',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.Search { CaseInSensitiveString = ""},
        },
        -- Spawn new terminal in current directory
        {
            key = 't',
            mods = 'CTRL',
            action = wezterm.action.SpawnWindow,
        },
        -- Copy
        {
            key = 'c',
            mods = 'CTRL',
            action = alt_action(
                window, pane,
                wezterm.action.SendKey { key = 'c', mods = 'CTRL' },
                wezterm.action { CopyTo = 'ClipboardAndPrimarySelection' }
            ),
        },
        -- Paste
        {
            key = 'v',
            mods = 'CTRL',
            action = wezterm.action { PasteFrom = 'Clipboard' },
        },
        -- STTY interrupt passthrough
        {
            key = 'x',
            mods = 'CTRL',
            action = wezterm.action.SendKey { key = 'c', mods = 'CTRL' },
        },
        -- STTY EOF passthrough
        {
            key = '.',
            mods = 'CTRL',
            action = wezterm.action.SendKey { key = 'd', mods = 'CTRL' },
        },
        -- Scroll down half-page
        {
            key = 'd',
            mods = 'CTRL',
            action = alt_action(
                window, pane,
                wezterm.action.SendKey { key = 'd', mods = 'CTRL' },
                wezterm.action.ScrollByPage(0.5)
            ),
        },
        -- Scroll up half-page
        {
            key = 'u',
            mods = 'CTRL',
            action = alt_action(
                window, pane,
                wezterm.action.SendKey { key = 'u', mods = 'CTRL' },
                wezterm.action.ScrollByPage(-0.5)
            ),
        },
        -- Scroll down one line
        {
            key = 'j',
            mods = 'CTRL',
            action = alt_action(
                window, pane,
                wezterm.action.SendKey { key = 'j', mods = 'CTRL' },
                wezterm.action.ScrollByLine(1)
            ),
        },
        -- Scroll up one line
        {
            key = 'k',
            mods = 'CTRL',
            action = alt_action(
                window, pane,
                wezterm.action.SendKey { key = 'k', mods = 'CTRL' },
                wezterm.action.ScrollByLine(-1)
            ),
        },
        -- Key passthrough
        -- It's not possible for NVIM to distinguish <C-i> from <Tab>, or
        -- <C-m> from <CR>, or <C-BS> from <C-H>. Best we can do is pass escape  
        -- codes for unused function keys. Use `showkeys -a` to find codes for 
        -- specific keys.
        --  see: https://www.reddit.com/r/neovim/comments/mbj8m5/how_to_setup_ctrlshiftkey_mappings_in_neovim_and/
        --  see: https://en.wikipedia.org/wiki/List_of_Unicode_characters#Basic_Latin
        {
            key = 'i',
            mods = 'CTRL',
            action = wezterm.action { SendString = '\x1b[1;2P' },
        },
        {
            key = 'm',
            mods = 'CTRL',
            action = alt_action(
                window, pane,
                wezterm.action { SendString = '\x1b[1;2Q' },
                wezterm.action.Nop
            ),
        },
        {
            key = 'Backspace',
            mods = 'CTRL',
            action = alt_action(
                window, pane,
                wezterm.action { SendString = '\x1b[1;2R' },
                wezterm.action.Nop
            ),
        },
        {
            key = 'Tab',
            mods = 'CTRL',
            action = alt_action(
                window, pane,
                wezterm.action { SendString = '\x1b[9;5u' },
                wezterm.action.Nop
            ),
        },
        {
            key = 'q',
            mods = 'CTRL|SHIFT',
            action = alt_action(
                window, pane,
                wezterm.action { SendString = '\x1b[81;5u' },
                wezterm.action.Nop
            ),
        },
    },

-- Mouse input
--------------------------------------------------------------------------------

    -- Mouse bindings
    bypass_mouse_reporting_modifiers = 'SHIFT',

-- Colors
--------------------------------------------------------------------------------

    -- Color theme mapping
    colors = {
        background = theme.color_hash('terminal_bg'),
        foreground = theme.color_hash('terminal_text'),

        cursor_bg = theme.color_hash('primary_15'),
        cursor_fg = theme.color_hash('terminal_bg'),
        cursor_border = theme.color_hash('primary_12'),

        selection_bg = theme.color_hash('primary_15'),
        selection_fg = theme.color_hash('gray_0'),

        visual_bell = theme.color_hash('primary_1'),

        tab_bar = {
            background = theme.color_hash('gray_0'),

            active_tab = {
                bg_color = theme.color_hash('gray_0'),
                fg_color = theme.color_hash('gray_15'),

                intensity = 'Bold',
            },

            inactive_tab = {
                bg_color = theme.color_hash('gray_0'),
                fg_color = theme.color_hash('gray_5'),

                intensity = 'Normal',
            },

            inactive_tab_hover = {
                bg_color = theme.color_hash('gray_2'),
                fg_color = theme.color_hash('gray_4'),
            },

            new_tab = {
                bg_color = theme.color_hash('gray_0'),
                fg_color = theme.color_hash('gray_5'),
            },

            new_tab_hover = {
                bg_color = theme.color_hash('gray_2'),
                fg_color = theme.color_hash('gray_4'),
            },
        },

        ansi = {
            theme.color_hash('ansi_black'),
            theme.color_hash('ansi_red'),
            theme.color_hash('ansi_green'),
            theme.color_hash('ansi_yellow'),
            theme.color_hash('ansi_blue'),
            theme.color_hash('ansi_magenta'),
            theme.color_hash('ansi_cyan'),
            theme.color_hash('ansi_white'),
        },

        brights = {
            theme.color_hash('ansi_brblack'),
            theme.color_hash('ansi_brred'),
            theme.color_hash('ansi_brgreen'),
            theme.color_hash('ansi_bryellow'),
            theme.color_hash('ansi_brblue'),
            theme.color_hash('ansi_brmagenta'),
            theme.color_hash('ansi_brcyan'),
            theme.color_hash('ansi_brwhite'),
        },

        indexed = {
            [16] = theme.color_hash('primary_0'),
            [17] = theme.color_hash('primary_1'),
            [18] = theme.color_hash('primary_2'),
            [19] = theme.color_hash('primary_3'),
            [20] = theme.color_hash('primary_4'),
            [21] = theme.color_hash('primary_5'),
            [22] = theme.color_hash('primary_6'),
            [23] = theme.color_hash('primary_7'),
            [24] = theme.color_hash('primary_8'),
            [25] = theme.color_hash('primary_9'),
            [26] = theme.color_hash('primary_10'),
            [27] = theme.color_hash('primary_11'),
            [28] = theme.color_hash('primary_12'),
            [29] = theme.color_hash('primary_13'),
            [30] = theme.color_hash('primary_14'),
            [31] = theme.color_hash('primary_15'),

            [32] = theme.color_hash('secondary_0'),
            [33] = theme.color_hash('secondary_1'),
            [34] = theme.color_hash('secondary_2'),
            [35] = theme.color_hash('secondary_3'),
            [36] = theme.color_hash('secondary_4'),
            [37] = theme.color_hash('secondary_5'),
            [38] = theme.color_hash('secondary_6'),
            [39] = theme.color_hash('secondary_7'),
            [40] = theme.color_hash('secondary_8'),
            [41] = theme.color_hash('secondary_9'),
            [42] = theme.color_hash('secondary_10'),
            [43] = theme.color_hash('secondary_11'),
            [44] = theme.color_hash('secondary_12'),
            [45] = theme.color_hash('secondary_13'),
            [46] = theme.color_hash('secondary_14'),
            [47] = theme.color_hash('secondary_15'),

            [48] = theme.color_hash('text_0'),
            [49] = theme.color_hash('text_1'),
            [50] = theme.color_hash('text_2'),
            [51] = theme.color_hash('text_3'),
            [52] = theme.color_hash('text_4'),
            [53] = theme.color_hash('text_5'),
            [54] = theme.color_hash('text_6'),
            [55] = theme.color_hash('text_7'),
            [56] = theme.color_hash('text_8'),
            [57] = theme.color_hash('text_9'),
            [58] = theme.color_hash('text_10'),
            [59] = theme.color_hash('text_11'),
            [60] = theme.color_hash('text_12'),
            [61] = theme.color_hash('text_13'),
            [62] = theme.color_hash('text_14'),
            [63] = theme.color_hash('text_15'),

            [64] = theme.color_hash('gray_0'),
            [65] = theme.color_hash('gray_1'),
            [66] = theme.color_hash('gray_2'),
            [67] = theme.color_hash('gray_3'),
            [68] = theme.color_hash('gray_4'),
            [69] = theme.color_hash('gray_5'),
            [70] = theme.color_hash('gray_6'),
            [71] = theme.color_hash('gray_7'),
            [72] = theme.color_hash('gray_8'),
            [73] = theme.color_hash('gray_9'),
            [74] = theme.color_hash('gray_10'),
            [75] = theme.color_hash('gray_11'),
            [76] = theme.color_hash('gray_12'),
            [77] = theme.color_hash('gray_13'),
            [78] = theme.color_hash('gray_14'),
            [79] = theme.color_hash('gray_15'),

            [80] = theme.color_hash('red_0'),
            [81] = theme.color_hash('red_1'),
            [82] = theme.color_hash('red_2'),
            [83] = theme.color_hash('red_3'),
            [84] = theme.color_hash('red_4'),
            [85] = theme.color_hash('red_5'),
            [86] = theme.color_hash('red_6'),
            [87] = theme.color_hash('red_7'),
            [88] = theme.color_hash('red_8'),
            [89] = theme.color_hash('red_9'),

            [90] = theme.color_hash('orange_0'),
            [91] = theme.color_hash('orange_1'),
            [92] = theme.color_hash('orange_2'),
            [93] = theme.color_hash('orange_3'),
            [94] = theme.color_hash('orange_4'),
            [95] = theme.color_hash('orange_5'),
            [96] = theme.color_hash('orange_6'),
            [97] = theme.color_hash('orange_7'),
            [98] = theme.color_hash('orange_8'),
            [99] = theme.color_hash('orange_9'),

            [100] = theme.color_hash('yellow_0'),
            [101] = theme.color_hash('yellow_1'),
            [102] = theme.color_hash('yellow_2'),
            [103] = theme.color_hash('yellow_3'),
            [104] = theme.color_hash('yellow_4'),
            [105] = theme.color_hash('yellow_5'),
            [106] = theme.color_hash('yellow_6'),
            [107] = theme.color_hash('yellow_7'),
            [108] = theme.color_hash('yellow_8'),
            [109] = theme.color_hash('yellow_9'),

            [110] = theme.color_hash('green_0'),
            [111] = theme.color_hash('green_1'),
            [112] = theme.color_hash('green_2'),
            [113] = theme.color_hash('green_3'),
            [114] = theme.color_hash('green_4'),
            [115] = theme.color_hash('green_5'),
            [116] = theme.color_hash('green_6'),
            [117] = theme.color_hash('green_7'),
            [118] = theme.color_hash('green_8'),
            [119] = theme.color_hash('green_9'),

            [120] = theme.color_hash('cyan_0'),
            [121] = theme.color_hash('cyan_1'),
            [122] = theme.color_hash('cyan_2'),
            [123] = theme.color_hash('cyan_3'),
            [124] = theme.color_hash('cyan_4'),
            [125] = theme.color_hash('cyan_5'),
            [126] = theme.color_hash('cyan_6'),
            [127] = theme.color_hash('cyan_7'),
            [128] = theme.color_hash('cyan_8'),
            [129] = theme.color_hash('cyan_9'),

            [130] = theme.color_hash('blue_0'),
            [131] = theme.color_hash('blue_1'),
            [132] = theme.color_hash('blue_2'),
            [133] = theme.color_hash('blue_3'),
            [134] = theme.color_hash('blue_4'),
            [135] = theme.color_hash('blue_5'),
            [136] = theme.color_hash('blue_6'),
            [137] = theme.color_hash('blue_7'),
            [138] = theme.color_hash('blue_8'),
            [139] = theme.color_hash('blue_9'),

            [140] = theme.color_hash('purple_0'),
            [141] = theme.color_hash('purple_1'),
            [142] = theme.color_hash('purple_2'),
            [143] = theme.color_hash('purple_3'),
            [144] = theme.color_hash('purple_4'),
            [145] = theme.color_hash('purple_5'),
            [146] = theme.color_hash('purple_6'),
            [147] = theme.color_hash('purple_7'),
            [148] = theme.color_hash('purple_8'),
            [149] = theme.color_hash('purple_9'),

            [150] = theme.color_hash('magenta_0'),
            [151] = theme.color_hash('magenta_1'),
            [152] = theme.color_hash('magenta_2'),
            [153] = theme.color_hash('magenta_3'),
            [154] = theme.color_hash('magenta_4'),
            [155] = theme.color_hash('magenta_5'),
            [156] = theme.color_hash('magenta_6'),
            [157] = theme.color_hash('magenta_7'),
            [158] = theme.color_hash('magenta_8'),
            [159] = theme.color_hash('magenta_9'),
        },
    },
}
