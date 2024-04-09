--------------------------------------------------------------------------------
-- Highlights utilities
--------------------------------------------------------------------------------

local HighlightsUtils = {}

-- Imports
--------------------------------------------------------------------------------

local theme = reload('system.theme')

-- Private functions
--------------------------------------------------------------------------------

local function _get_24bit_theme_color(color_name)
    return theme.color_hash(color_name)
end

local function _get_ansi_theme_color(color_name)
    return theme.color_name_to_ansi_index(color_name)
end

local function _construct_gui_options(foreground_color, background_color, special_color, attributes)
    foreground_color = foreground_color or 'NONE'
    if foreground_color ~= 'NONE' then
        foreground_color = _get_24bit_theme_color(foreground_color)
    end

    background_color = background_color or 'NONE'
    if background_color ~= 'NONE' then
        background_color = _get_24bit_theme_color(background_color)
    end

    special_color = special_color or 'NONE'
    if special_color ~= 'NONE' then
        special_color = _get_24bit_theme_color(special_color)
    end

    attributes = attributes or 'NONE'

    return {
        guifg = foreground_color,
        guibg = background_color,
        guisp = special_color,
        gui = attributes,
    }
end

local function _construct_terminal_options(foreground_color, background_color, attributes)
    foreground_color = foreground_color or 'NONE'
    if foreground_color ~= 'NONE' then
        foreground_color = _get_ansi_theme_color(foreground_color)
    end

    background_color = background_color or 'NONE'
    if background_color ~= 'NONE' then
        background_color = _get_ansi_theme_color(background_color)
    end

    attributes = attributes or 'NONE'

    return {
        ctermfg = foreground_color,
        ctermbg = background_color,
        cterm = attributes,
    }
end

-- Create a highlight group
--------------------------------------------------------------------------------

function HighlightsUtils.highlight(group, gui_options, terminal_options)
    gui_options = gui_options or {}
    gui_options = _construct_gui_options(
        gui_options.fg,
        gui_options.bg,
        gui_options.sp,
        gui_options.attrs
    )

    terminal_options = terminal_options or {}
    terminal_options = _construct_terminal_options(
        terminal_options.fg,
        terminal_options.bg,
        terminal_options.attrs
    )

    local command =
        'hi! ' .. group
        .. ' guifg=' .. gui_options.guifg
        .. ' guibg=' .. gui_options.guibg
        .. ' guisp=' .. gui_options.guisp
        .. ' gui=' .. gui_options.gui
        .. ' ctermfg=' .. terminal_options.ctermfg
        .. ' ctermbg=' .. terminal_options.ctermbg
        .. ' cterm=' .. terminal_options.cterm

    vim.cmd(command)
end

-- Link a highlight group
--------------------------------------------------------------------------------

function HighlightsUtils.link(group, target)
    vim.cmd('hi! link ' .. group .. ' ' .. target)
end

return HighlightsUtils
