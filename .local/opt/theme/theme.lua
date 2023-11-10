--------------------------------------------------------------------------------
-- System theme Lua API
--------------------------------------------------------------------------------

local theme = {}

-- Parsing
--------------------------------------------------------------------------------

local function parse_vars(filePath)
    local file = io.open(filePath, 'r')
    if file == nil then
        error('Could not open file: ' .. filePath)
    end

    local lines = io.lines(filePath) 
    io.close(file)

    local vars = {}

    for line in lines do
        local key = nil
        local value = nil
        local assignment = false
        local lookup = false

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
                    error('Unable to continue parsing, expected character [' .. c .. '] only after assignment.')
                end

            -- Dollar, indicates variable lookup, only allowed after assignment
            elseif char == string.byte('$') then
                if assignment == true then
                    lookup = true
                    goto continue
                else
                    error('Unable to continue parsing, expected character [' .. c .. '] only after assignment.')
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

            -- Assignment operator reached, keep reading for value
            elseif char == string.byte('=') then
                if assignment == false then
                    assignment = true
                    goto continue
                end
            else
                error('Unable to continue parsing, unexpected character [' .. c .. '].')
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

local colors = parse_vars(os.getenv('XDG_CONFIG_HOME') .. '/theme/colors')
local fonts = parse_vars(os.getenv('XDG_CONFIG_HOME') .. '/theme/fonts')

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

-- Debugging
--------------------------------------------------------------------------------

-- TODO: Use terminal escape codes to colorize output
function theme.print_colors()
    for k, v in pairs(colors) do
        print(k .. ": " .. v)
    end
end

return theme
