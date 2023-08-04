--------------------------------------------------------------------------------
-- Path utilities
--------------------------------------------------------------------------------

local TableUtils = require('utils.table')

local PathUtils = {}

PathUtils.path_separator =
    (function ()
        -- TODO: Make platform agnostic.
        return '/'
    end)()

function PathUtils.get_package_paths()
    return vim.split(package.path, ';')
end

function PathUtils.append_to_package_path(path)
    local paths = PathUtils.get_package_paths()

    if TableUtils.contains(paths, path) then
        return
    end

    package.path = package.path .. path
end

function PathUtils.prepend_to_package_path(path)
    local paths = PathUtils.get_package_paths()

    if TableUtils.contains(paths, path) then
        return
    end

    package.path = path .. package.path
end

return PathUtils

