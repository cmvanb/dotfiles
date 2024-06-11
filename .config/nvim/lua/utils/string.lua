--------------------------------------------------------------------------------
-- String utilities
--------------------------------------------------------------------------------

local StringUtils = {}

-- Test whether a string contains a given substring
--------------------------------------------------------------------------------

function StringUtils.contains(string, substring)
    return string.match(string, substring) ~= nil
end

-- Split a string on a given separator
--------------------------------------------------------------------------------

function StringUtils.split(string, separator)
    if separator == nil then
        separator = '%s'
    end

    local result = {}

    for s in string.gmatch(string, '([^' .. separator .. ']+)') do
        table.insert(result, s)
    end

    return result
end

return StringUtils
