--------------------------------------------------------------------------------
-- Load (dofile) lua module
--------------------------------------------------------------------------------

local FileUtils = require('utils.file')

function _G.do_load(module_name)
    local path_prefix = vim.fn.stdpath('config') .. '/lua/'

    local resolutions = {}

    local has_file_ext = #module_name > 4 and string.sub(module_name, -4) == '.lua'

    if has_file_ext then
        table.insert(resolutions, path_prefix .. module_name)
        table.insert(resolutions, path_prefix .. module_name .. '/init.lua')
    else
        table.insert(resolutions, path_prefix .. module_name .. '.lua')
        table.insert(resolutions, path_prefix .. module_name .. '/init.lua')
    end

    local load_path = nil

    for _, res in ipairs(resolutions) do
        if FileUtils.is_file(res) then
            load_path = res
            break
        end
    end

    if not load_path then
        local error_message =
            'Could not find lua file at: \n' ..
            '`' .. resolutions[1] .. '` \n' ..
            '`' .. resolutions[2] .. '`'

        error(error_message)
    end

    return dofile(load_path)
end
