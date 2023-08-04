--------------------------------------------------------------------------------
-- String utilities
--------------------------------------------------------------------------------

local StringUtils = {}

function StringUtils.contains(string, substring)
    return string.match(string, substring) ~= nil
end

function StringUtils.split(string, separator)
    if separator == nil then
        separator = "%s"
    end

    local result = {}

    for s in string.gmatch(string, "([^" .. separator .. "]+)") do
        table.insert(result, s)
    end

    return result
end

return StringUtils
