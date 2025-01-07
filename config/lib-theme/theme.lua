--------------------------------------------------------------------------------
-- System theme Lua API
--------------------------------------------------------------------------------

local theme = {}

-- Utilities
--------------------------------------------------------------------------------

function file_exists(name)
    local f = io.open(name, 'r')
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

function raise_error(message)
    error('[theme.lua] ERROR: ' .. message)
end

-- Parsing
--------------------------------------------------------------------------------

local function parse_error(line, column, message)
    raise_error('Unable to continue parsing at line ' .. line.. ', column ' .. column .. ': ' .. message)
end

local function parse_vars(filePath)
    local file = io.open(filePath, 'r')
    if file == nil then
        raise_error('Could not open file: ' .. filePath)
    end

    local lines = io.lines(filePath)
    io.close(file)

    local vars = {}
    local line_count = 0

    for line in lines do
        local key = nil
        local value = nil
        local assignment = false
        local lookup = false

        line_count = line_count + 1

        for i = 1, #line do
            local char = line:byte(i)

            -- Space after assignment, append to value.
            -- Space before assignment, keep reading.
            if char == string.byte(' ') then
                if assignment == true then
                    if value == nil then
                        value = ''
                    end
                    value = value .. string.char(char)
                else
                    goto continue
                end

            -- Hash after assignment, char is ignored, but continue parsing value.
            -- Hash before assignment, line is skipped.
            elseif char == string.byte('#') then
                if assignment == true then
                    goto continue
                else
                    key = nil
                    value = nil
                    break
                end

            -- Quote, char is ignored, only allowed after assignment
            elseif char == string.byte('\'') then
                if assignment == true then
                    goto continue
                else
                    parse_error(line_count, i, 'Expected character [' .. char .. '] only after assignment.')
                end

            -- Dollar, indicates variable lookup, only allowed after assignment
            elseif char == string.byte('$') then
                if assignment == true then
                    lookup = true
                    goto continue
                else
                    parse_error(line_count, i, 'Expected character [' .. char .. '] only after assignment.')
                end

            -- Alphanumeric or underscore, append to either key or value
            elseif string.match(string.char(char), '[%w_]') ~= nil then
                if assignment == false then
                    if key == nil then
                        key = ''
                    end
                    key = key .. string.char(char)
                else
                    if value == nil then
                        value = ''
                    end
                    value = value .. string.char(char)
                end

            -- Decimal point, append to value, only allowed after assignment
            elseif char == string.byte('.') then
                if assignment == true then
                    if value == nil then
                        value = ''
                    end
                    value = value .. string.char(char)
                    goto continue
                else
                    parse_error(line_count, i, 'Expected character [' .. char .. '] only after assignment.')
                end

            -- Assignment operator reached, keep reading for value
            elseif char == string.byte('=') then
                if assignment == false then
                    assignment = true
                    goto continue
                end
            else
                parse_error(line_count, i, 'Unknown character [' .. char .. '].')
            end

            -- Lua doesn't have the typical continue operator, so we use `goto`.
            ::continue::
        end

        -- Assign value
        if key ~= nil and value ~= nil then
            if lookup == true then
                vars[key] = vars[value]
            else
                vars[key] = value
            end
        end
    end

    return vars
end

-- Entry point
--------------------------------------------------------------------------------

local colors_path = os.getenv('XDG_CONFIG_HOME') .. '/theme/colors'
local colors = {}
if file_exists(colors_path) then
    colors = parse_vars(colors_path)
else
    raise_error('Theme color file is not readable.')
end

local fonts_path = os.getenv('XDG_CONFIG_HOME') .. '/theme/fonts'
local fonts = {}
if file_exists(fonts_path) then
    fonts = parse_vars(fonts_path)
end

local cursor_path = os.getenv('XDG_CONFIG_HOME') .. '/theme/cursor'
local cursor = {}
if file_exists(cursor_path) then
    cursor = parse_vars(cursor_path)
end

-- Lookup
--------------------------------------------------------------------------------

local ansi_lookup = {
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
    ['brwhite']   = 15
}

function theme.color_name_to_ansi_index(name)
    if string.sub(name, 1, 5) == 'ansi_' then
        name = string.sub(name, 6, -1)
    else
        error('theme.name_to_ansi_index expects string with format: `ansi_{name}`, received: `' .. name .. '`', 2)
    end

    if string.len(name) <= 0 then
        error('theme.name_to_ansi_index expects string with format: `ansi_{name}`, received empty string.', 2)
    end

    local result = ansi_lookup[name]

    if result == nil then
        error('theme.name_to_ansi_index did not find `' .. name .. '`, expected format is: `ansi_{name}`.', 2)
    end

    return result
end

function theme.color_index_to_name(index)
    if index < 0 or index > 15 then
        error('theme.index_to_name expects integer 0 -> 15, received: ' .. index, 2)
    end
    return colors['i' .. index]
end

function theme.color_named(name)
    local result = colors[name]

    if result == nil then
        error('theme.color_named did not find `' .. name .. '`.', 2)
    end

    return result
end

function theme.color_hash(name)
    local result = colors[name]

    if result == nil then
        error('theme.color_hash did not find `' .. name .. '`.', 2)
    end

    return '#' .. result
end

function theme.color_zerox(name)
    local result = colors[name]

    if result == nil then
        error('theme.color_zerox did not find `' .. name .. '`.', 2)
    end

    return '0x' .. result
end

function theme.font(name)
    return fonts[name]
end

function theme.cursor(name)
    return cursor[name]
end

-- Debugging
--------------------------------------------------------------------------------

-- TODO: Use terminal escape codes to colorize output
function theme.print_colors()
    for k, v in pairs(colors) do
        print(k .. ": " .. v)
    end
end

return theme
