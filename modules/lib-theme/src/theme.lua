--------------------------------------------------------------------------------
-- System theme Lua API
--
-- Loads the pre-generated theme dict from $XDG_CACHE_HOME/theme/theme.lua
-- and exposes a typed API mirroring theme.py.
--------------------------------------------------------------------------------

local cache_dir = os.getenv('XDG_CACHE_HOME') .. '/theme'

-- Load the pre-generated dict.
local _prev_path = package.path
package.path = cache_dir .. '/?.lua;' .. package.path
local _dict = require('theme-data')
package.path = _prev_path

assert(_dict ~= nil, '[theme.lua] Could not load theme dict from ' .. cache_dir .. '/theme-data.lua')

-- Private helpers
--------------------------------------------------------------------------------

local function _color(name)
    local v = _dict.colors[name]
    if v == nil then
        error('[theme.lua] Color `' .. name .. '` not found.', 3)
    end
    return v
end

local function _font(name)
    local v = _dict.fonts[name]
    if v == nil then
        error('[theme.lua] Font `' .. name .. '` not found.', 3)
    end
    return v
end

local function _cursor(name)
    local v = _dict.cursor[name]
    if v == nil then
        error('[theme.lua] Cursor `' .. name .. '` not found.', 3)
    end
    return v
end

-- ANSI index lookup
local _ansi_index = {
    ['black']     = 0,
    ['red']       = 1,
    ['green']     = 2,
    ['yellow']    = 3,
    ['blue']      = 4,
    ['magenta']   = 5,
    ['cyan']      = 6,
    ['white']     = 7,
    ['brblack']   = 8,
    ['brred']     = 9,
    ['brgreen']   = 10,
    ['bryellow']  = 11,
    ['brblue']    = 12,
    ['brmagenta'] = 13,
    ['brcyan']    = 14,
    ['brwhite']   = 15,
}

-- API
--------------------------------------------------------------------------------

local Theme = {}

-- Returns bare hex:  "RRGGBB"
function Theme.color_named(name)
    return _color(name)
end

-- Returns hash hex:  "#RRGGBB"
function Theme.color_hash(name)
    return '#' .. _color(name)
end

-- Returns 0x hex:   "0xRRGGBB"
function Theme.color_zerox(name)
    return '0x' .. _color(name)
end

-- Returns ANSI 24-bit fg escape sequence
function Theme.color_ansi_fg(name)
    local hex = _color(name)
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    return string.format('\x1b[38:2:%d:%d:%dm', r, g, b)
end

-- Returns ANSI 24-bit bg escape sequence
function Theme.color_ansi_bg(name)
    local hex = _color(name)
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    return string.format('\x1b[48:2:%d:%d:%dm', r, g, b)
end

-- Returns ANSI reset sequence
function Theme.color_ansi_reset()
    return '\x1b[0m'
end

-- Returns the ANSI 0-15 index for an `ansi_*` color name
function Theme.color_name_to_ansi_index(name)
    local suffix = name:match('^ansi_(.+)$')
    if suffix == nil then
        error('[theme.lua] color_name_to_ansi_index expects `ansi_{name}`, received: `' .. name .. '`', 2)
    end
    local index = _ansi_index[suffix]
    if index == nil then
        error('[theme.lua] color_name_to_ansi_index: unknown ANSI name `' .. suffix .. '`', 2)
    end
    return index
end

-- Returns the hex color for an i0-i15 index
function Theme.color_index_to_name(index)
    if index < 0 or index > 15 then
        error('[theme.lua] color_index_to_name expects 0-15, received: ' .. index, 2)
    end
    return _dict.colors['i' .. index]
end

-- Returns a font value by key
function Theme.font(name)
    return _font(name)
end

-- Returns a cursor value by key
function Theme.cursor(name)
    return _cursor(name)
end

return Theme
