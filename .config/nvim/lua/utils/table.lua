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

function TableUtils.destructive_merge(base_table, overlay_table)
    for k,v in pairs(overlay_table) do base_table[k] = v end
    return base_table
end

return TableUtils

