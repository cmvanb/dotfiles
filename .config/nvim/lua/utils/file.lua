--------------------------------------------------------------------------------
-- File utilities
--------------------------------------------------------------------------------

local PathUtils = require('utils.path')
local StringUtils = require('utils.string')

local FileUtils = {}

function FileUtils.is_file(path)
    local stat = vim.loop.fs_stat(path)

    return stat and stat.type == "file" or false
end

function FileUtils.is_directory(path)
    local stat = vim.loop.fs_stat(path)

    return stat and stat.type == "directory" or false
end

-- NOTE: Untested.
function FileUtils.get_file_dir(path)
    assert(string.len(path) > 0, 'Cannot get directory from empty path.')

    -- Split
    local components = StringUtils.split(path, PathUtils.path_separator)
    assert(#components > 1, '`' .. path .. '` contains no separators.')

    -- Drop last component
    components[#components] = nil

    -- Join
    return table.concat(components, PathUtils.path_separator)
end

return FileUtils


