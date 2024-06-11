--------------------------------------------------------------------------------
-- File utilities
--------------------------------------------------------------------------------

local FileUtils = {}

-- Test whether path is a file
--------------------------------------------------------------------------------

function FileUtils.is_file(path)
    local stat = vim.loop.fs_stat(path)

    return stat and stat.type == 'file' or false
end

-- Test whether path is a directory
--------------------------------------------------------------------------------

function FileUtils.is_directory(path)
    local stat = vim.loop.fs_stat(path)

    return stat and stat.type == 'directory' or false
end

return FileUtils
