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

return TableUtils

