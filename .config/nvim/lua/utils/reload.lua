--------------------------------------------------------------------------------
-- Reload lua module
--------------------------------------------------------------------------------

function _G.reload(m)
    -- Clear package from loaded and global tables.
    package.loaded[m] = nil
    _G[m] = nil

    return require(m)
end

