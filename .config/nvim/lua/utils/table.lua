--------------------------------------------------------------------------------
-- Table utilities
--------------------------------------------------------------------------------

local TableUtils = {}

function TableUtils.contains(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end

    return false
end

function TableUtils.count(table)
    local count = 0

    for _ in pairs(table) do
        count = count + 1
    end

    return count
end

return TableUtils

