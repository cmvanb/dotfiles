--------------------------------------------------------------------------------
-- Path utilities
--------------------------------------------------------------------------------

local TableUtils = require('utils.table')

local PathUtils = {}

-- Private functions
--------------------------------------------------------------------------------

local function _get_package_paths()
    return vim.split(package.path, ';')
end

-- Append a path to package.path
--------------------------------------------------------------------------------

function PathUtils.append_to_package_path(path)
    local paths = _get_package_paths()

    if TableUtils.contains(paths, path) then
        return
    end

    package.path = package.path .. ';'.. path
end

-- Prepend a path to package.path
--------------------------------------------------------------------------------

function PathUtils.prepend_to_package_path(path)
    local paths = _get_package_paths()

    if TableUtils.contains(paths, path) then
        return
    end

    package.path = path .. ';' .. package.path
end

return PathUtils
