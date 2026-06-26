--------------------------------------------------------------------------------
-- Wezterm configuration file
--------------------------------------------------------------------------------

local wezterm = require('wezterm')

-- Retrieve system theme
--------------------------------------------------------------------------------

package.path = os.getenv('XDG_OPT_HOME') .. '/theme/?.lua;' .. package.path
local theme = require('theme')

-- Helpers
--------------------------------------------------------------------------------

-- Create alternate mappings for `alt-screen` applications such as terminal NVIM.
local function alt_action(alt_screen_action, terminal_action)
    return wezterm.action_callback(function(window, pane)
        if pane:is_alt_screen_active() then
            window:perform_action(alt_screen_action, pane)
        else
            window:perform_action(terminal_action, pane)
        end
    end)
end

local function indexed_palette()
    local palettes = {
        { 'primary', 16 }, { 'secondary', 16 }, { 'text', 16 }, { 'gray', 16 },
        { 'red', 10 }, { 'orange', 10 }, { 'yellow', 10 }, { 'green', 10 },
        { 'cyan', 10 }, { 'blue', 10 }, { 'purple', 10 }, { 'magenta', 10 },
    }
    local result = {}
    local idx = 16
    for _, palette in ipairs(palettes) do
        for i = 0, palette[2] - 1 do
            result[idx] = theme.color_hash(palette[1] .. '_' .. i)
            idx = idx + 1
        end
    end
    return result
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

    -- Bigger scrollback buffer
    scrollback_lines = 10000,

    -- Don't prompt when closing window
    window_close_confirmation = 'NeverPrompt',

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
    -- NOTE: Wezterm's font size doesn't match other terminals (e.g. Alacritty).
    font_size = tonumber(theme.font('font_size_msmall')),

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
        fade_out_duration_ms = 150,
    },

    -- Opacity
    -- NOTE: Transparency has a noticeable performance impact.
    window_background_opacity = 0.80,

-- Key bindings
--------------------------------------------------------------------------------

    -- NOTE: We don't need any of the defaults.
    -- see: https://wezfurlong.org/wezterm/config/default-keys.html
    disable_default_key_bindings = true,

    keys = {
        -- Spawn new terminal in current directory
        {
            key = 't',
            mods = 'CTRL',
            action = wezterm.action.SpawnWindow,
        },
        -- Clipboard
        {
            key = 'c',
            mods = 'CTRL',
            action = alt_action(
                wezterm.action.SendKey { key = 'c', mods = 'CTRL' },
                wezterm.action { CopyTo = 'ClipboardAndPrimarySelection' }
            ),
        },
        {
            key = 'v',
            mods = 'CTRL',
            action = wezterm.action { PasteFrom = 'Clipboard' },
        },
        -- Scrolling
        {
            key = 'PageDown',
            action = alt_action(
                wezterm.action.SendKey { key = 'PageDown' },
                wezterm.action.ScrollByPage(0.5)
            ),
        },
        {
            key = 'PageUp',
            action = alt_action(
                wezterm.action.SendKey { key = 'PageUp' },
                wezterm.action.ScrollByPage(-0.5)
            ),
        },
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
        -- STTY signals
        {
            key = 'x',
            mods = 'CTRL',
            action = wezterm.action.SendKey { key = 'c', mods = 'CTRL' },
        },
        {
            key = '.',
            mods = 'CTRL',
            action = wezterm.action.SendKey { key = 'd', mods = 'CTRL' },
        },
        -- Passthrough
        -- It's not possible for NVIM to distinguish <C-i> from <Tab>, or
        -- <C-m> from <CR>, or <C-BS> from <C-H>. Best we can do is pass escape  
        -- codes for unused function keys. Use `showkey -a` to find codes for 
        -- specific keys.
        --  see: https://www.reddit.com/r/neovim/comments/mbj8m5/how_to_setup_ctrlshiftkey_mappings_in_neovim_and/
        --  see: https://en.wikipedia.org/wiki/List_of_Unicode_characters#Basic_Latin
        {
            key = 'i',
            mods = 'CTRL',
            action = wezterm.action { SendString = '\x1b[1;2S' },
        },
        {
            key = 'm',
            mods = 'CTRL',
            action = wezterm.action { SendString = '\x1b[15;2~' },
        },
        {
            key = 'Backspace',
            mods = 'CTRL',
            action = wezterm.action { SendString = '\x1b[17;2~' },
        },
        {
            key = 'Period',
            mods = 'CTRL',
            action = wezterm.action { SendString = '\x1b[18;2~' },
        },
        {
            key = 'Tab',
            mods = 'CTRL',
            action = wezterm.action { SendString = '\x1b[9;5u' },
        },
        {
            key = 'Semicolon',
            mods = 'CTRL',
            action = wezterm.action { SendString = '\x1b[19;2~' },
        },
        -- Font size
        {
            key = 'j',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.IncreaseFontSize,
        },
        {
            key = 'k',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.DecreaseFontSize,
        },
        {
            key = 'l',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.ResetFontSize,
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

        cursor_bg = theme.color_hash('terminal_text'),
        cursor_fg = theme.color_hash('terminal_bg'),
        cursor_border = theme.color_hash('text_12'),

        selection_bg = theme.color_hash('selection_bg'),
        selection_fg = theme.color_hash('selection_fg'),

        visual_bell = theme.color_hash('black'),

        tab_bar = {
            background = theme.color_hash('system_bg'),

            active_tab = {
                bg_color = theme.color_hash('primary_8'),
                fg_color = theme.color_hash('text_15'),

                intensity = 'Bold',
            },

            inactive_tab = {
                bg_color = theme.color_hash('gray_2'),
                fg_color = theme.color_hash('gray_10'),

                intensity = 'Normal',
            },

            inactive_tab_hover = {
                bg_color = theme.color_hash('gray_3'),
                fg_color = theme.color_hash('gray_10'),
            },

            new_tab = {
                bg_color = theme.color_hash('gray_2'),
                fg_color = theme.color_hash('gray_10'),
            },

            new_tab_hover = {
                bg_color = theme.color_hash('gray_3'),
                fg_color = theme.color_hash('gray_10'),
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

        indexed = indexed_palette(),
    },
}
